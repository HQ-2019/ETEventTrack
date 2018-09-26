//
//  FFTrackDataManager.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETEventTrackManager.h"

#import "ETEventTrack+Private.h"
#import "ETDataManamer.h"
#import "ETNetworkManager.h"
#import "ETUtilsHeader.h"

#import "ETConstants.h"
#import "ETLogger.h"

#define FFFilePath @"JAStatistics/Cancel" // 沙河存储目录
#define FFFileName @"TrackInfo"           // 沙河Json文件名称

@interface ETEventTrackManager ()

@property (nonatomic, strong) dispatch_queue_t dataQueue;   // 数据操作队列
@property (nonatomic, strong) NSMutableArray *dataArray;    // 埋点数据数组
@property (nonatomic, assign) BOOL uploading;               // 是否正在提交数据 YES:正在执行提交
@property (nonatomic, strong) dispatch_source_t timer;      // GCD定时器

@end

@implementation ETEventTrackManager

dET_SINGLETON_FOR_CLASS(ETEventTrackManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploading = NO;
        
        // 设置队列
        NSString *uuid = [NSString stringWithFormat:@"com.et.array_%p", self];
        self.dataQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);

        // 开启定时器
        [self openTimer];
    }
    return self;
}

#pragma mark -
#pragma mark - data handle
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)addObject:(id)anObject {
    dispatch_barrier_async(self.dataQueue, ^{
        if (anObject) {
            [self.dataArray addObject:anObject];
        }
    });
}

- (void)removeObjectsInArray:(NSArray *)array{
    dispatch_barrier_async(self.dataQueue, ^{
        if (array.count > 0) {
            [self.dataArray removeObjectsInArray:array];
        }
    });
}

- (NSArray *)getArray {
    __block NSEnumerator *enu;
    dispatch_sync(self.dataQueue, ^{
        enu = [self.dataArray objectEnumerator];
    });
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSObject *object in enu) {
        [array addObject:object];
    }
    
    return array.copy;
}

#pragma mark -
#pragma mark Timer
/**
 开启定时器
 */
- (void)openTimer {
    if (self.timer == nil) {
        // 获取全局子线程队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 创建定时器并添加到队列
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        // 设置定时器开始时间
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
        // 设置定时器执行间隔
        dispatch_source_set_timer(self.timer, start, (int64_t)([ETConfigFileUtils timeInterval] * NSEC_PER_SEC), 0);
        
        // 处理定时器事件
        dispatch_source_set_event_handler(self.timer, ^{
            [self timerActions];
        });

        // 激活timer(CGD Timer默认为关闭状态)
        dispatch_resume(self.timer);
    }
}

/**
 定时器关闭
 */
- (void)closeTimer {
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

/**
 定时器事件
 */
- (void)timerActions {
    [self uploadEventTrackData:nil];
}

#pragma mark -
#pragma mark - 新增加一个埋点数据
+ (void)addEventTrackData:(NSDictionary *)trackData {
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[self class] sharedInstance] addEventTrackData:trackData];
        });
    }
}

- (void)addEventTrackData:(NSDictionary *)trackData {
    @try {
        NSAssert(trackData, @"new add event track data cannot be nil");
        // 获取完整的埋点信息
        NSDictionary *data = [ETDataManamer eventTrackData:trackData];
        // 将埋点数据添加到数组
//            [self.dataArray addObject:data];
        [self addObject:data];
        
        ETLog(@"\n ############# new add event track data ############### \n %@", data);
    } @catch (NSException *exception) {
        ETLog(@"t添加信息异常: %@", exception);
    }
}

#pragma mark -
#pragma mark - 上传统计数据
/**
 上传统计数据
 
 @param callback callback
 */
+ (void)uploadEventTrackData:(KResponeAlertCallBack)callback {
    [[[self class] sharedInstance] uploadEventTrackData:callback];
}

- (void)uploadEventTrackData:(KResponeAlertCallBack)callback {
    @try {
        if (![self isUploadData] || [ETEventTrack sharedInstance].serverUrl.length <= 0 || self.dataArray.count <= 0) {
            return;
        }
        
        // 设置埋点数据
        NSMutableDictionary *params = [NSMutableDictionary new];
        NSArray *array = [self getArray];
        [params setValue:array forKey:@"body"];
        
        self.uploading = YES;
        
        __weak typeof(self) weakSelf = self;
        [[ETNetworkManager sharedInstance] POST:[ETEventTrack sharedInstance].serverUrl
                                     parameters:params
                                       callBack:^(id JSONResponse, NSError *error) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           strongSelf.uploading = NO;
                                           NSString *status = JSONResponse[ @"code" ];
                                           NSString *msg = JSONResponse[ @"message" ];
                                           BOOL success = NO;
                                           if ([status isEqualToString:@"0000"] && error == nil) {
                                               //清除数据
                                               [strongSelf removeObjectsInArray:array];
                                               [strongSelf clearLoactionData];
                                               success = YES;
                                           }
                                           if (callback) {
                                               callback(success, msg);
                                           }
                                       }];
    } @catch (NSException *exception) {
        ETLog(@"上传埋点信息异常: %@", exception);
    }
}

/**
 上传本地保存的埋点数据
 */
+ (void)uploadLocalEventTrackData {
    [[[self class] sharedInstance] uploadLocalEventTrackData];
}

- (void)uploadLocalEventTrackData {
    @try {
        NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:YES];
        NSString *jsonString = [NSString stringWithContentsOfFile:loactionDataPath encoding:NSUTF8StringEncoding error:NULL];
        NSArray *loactionArray = [ETJsonUtils fromJSONString:jsonString];
        if (loactionArray.count > 0) {
            [self.dataArray insertObjects:loactionArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, loactionArray.count)]];
            ETLog(@"上传本地埋点数据 : %@", self.dataArray);
            [self uploadEventTrackData:nil];
        }
    } @catch (NSException *exception) {
        ETLog(@"上传本地埋点信息异常: %@", exception);
    }
}

/**
 是否上传埋点数据

 @return 是否上传 YES：上传
 */
- (BOOL)isUploadData {
    if (self.dataArray.count > 0 && !self.uploading) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - 保存统计数据到地化
+ (void)saveLocalEventTrackData {
    [[[self class] sharedInstance] saveLocalEventTrackData];
}

- (void)saveLocalEventTrackData {
    @try {
        [self clearLoactionData];
        NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:YES];
        NSArray *array = [self getArray];
        NSString *loactionString = [ETJsonUtils toJSONString:array];
        BOOL saveBool = [loactionString writeToFile:loactionDataPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        //存储成功后删除内存数组
        if (saveBool) {
            [self removeObjectsInArray:array];
            ETLog(@"统计数据保存到本地 成功");
        } else {
            ETLog(@"统计数据保存到本地 失败");
        }
    } @catch (NSException *exception) {
        ETLog(@"埋点信息持久化失败： %@", exception);
    }
}

#pragma mark -
#pragma mark - 获取本地数据路径
- (NSString *)getLoactionJsonPathWithDataNameBool:(BOOL)nameBool {
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *loactionPath = [rootPath stringByAppendingPathComponent:FFFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:loactionPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:loactionPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    if (nameBool) {
        //文件目录带文件名
        return [loactionPath stringByAppendingPathComponent:FFFileName];
    } else {
        //文件上一级目录
        return loactionPath;
    }
}

#pragma mark -
#pragma mark - 清除缓存数据
- (void)clearLoactionData {
    @try {
        NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:NO];
        [[NSFileManager defaultManager] removeItemAtPath:loactionDataPath error:NULL];
    } @catch (NSException *exception) {
        ETLog(@"清除本地数据异常: %@", exception);
    }
}

@end
