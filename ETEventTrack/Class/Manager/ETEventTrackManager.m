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

#define FFFilePath @"JAStatistics/Cancel"      // 沙河存储目录
#define FFFileName @"TrackInfo"                // 沙河Json文件名称

#define dUPLOAD_INTERVAL 10.0                    // 上传埋点信息的时间间隔 (采用定时上传方式)

@interface ETEventTrackManager ()

@property(nonatomic, strong) NSMutableArray *currentArray;

@property(nonatomic, assign) BOOL uploading;                    /**< 是否正在提交数据 YES:正在执行提交 */
@property (nonatomic, strong) dispatch_source_t timer;          /**< 定时器 */

@end

@implementation ETEventTrackManager

dET_SINGLETON_FOR_CLASS(ETEventTrackManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentArray = @[].mutableCopy;
        _uploading = NO;
        
        // 开启定时器
        [self openTimer];
    }
    return self;
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
        dispatch_source_set_timer(self.timer, start, (int64_t)(dUPLOAD_INTERVAL * NSEC_PER_SEC), 0);
        
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
    NSLog(@"定时上传埋点数据: %@", [NSThread currentThread]);
    [self uploadEventTrackData:nil];
}

#pragma mark -
#pragma mark - 新增加一个埋点数据
+ (void)addEventTrackData:(NSDictionary *)trackData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[self class] sharedInstance] addEventTrackData:trackData];
    });
}

- (void)addEventTrackData:(NSDictionary *)trackData {
    NSAssert(trackData, @"new add event track data cannot be nil");
    // 获取完整的埋点信息
    NSDictionary *data = [ETDataManamer eventTrackData:trackData];
    // 将埋点数据添加到数组
    [self.currentArray addObject:data];
    
    NSLog(@"\n ############# new add event track data ############### \n %@", data);
}

#pragma mark -
#pragma mark - 上传统计数据 忽略kMaxCounts条数的限制
/**
 上传统计数据 忽略kMaxCounts条数的限制
 
 @param callback callback
 */
+ (void)uploadEventTrackData:(KResponeAlertCallBack)callback {
    [[[self class] sharedInstance] uploadEventTrackData:callback];
}

- (void)uploadEventTrackData:(KResponeAlertCallBack)callback {
    [self uploadEventTrackDataWithCount:self.currentArray.count callback:^(BOOL success, NSString *msg) {
        if (callback) {
            callback(success, msg);
        }
    }];
}

/**
 上传本地保存的埋点数据
 */
+ (void)uploadLocalEventTrackData {
    [[[self class] sharedInstance] uploadLocalEventTrackData];
}

- (void)uploadLocalEventTrackData {
    NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:YES];
    NSString *jsonString = [NSString stringWithContentsOfFile:loactionDataPath encoding:NSUTF8StringEncoding error:NULL];

    NSArray *loactionArray = [ETJsonUtils fromJSONString:jsonString];
    if (loactionArray.count > 0) {
        [self.currentArray insertObjects:loactionArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, loactionArray.count)]];
        [self uploadEventTrackDataWithCount:self.currentArray.count callback:nil];
    }
    NSLog(@"上传本地埋点数据 : %@", self.currentArray);
}

/**
 上传统计数据

 @param count 上传的埋点数据条数
 @param callback 回调
 */
- (void)uploadEventTrackDataWithCount:(NSUInteger)count callback:(KResponeAlertCallBack)callback {
    if (![self isUploadData] || [ETEventTrack sharedInstance].serverUrl.length <= 0) {
        return;
    }

    if (count > self.currentArray.count) {
        count = self.currentArray.count;
    }
    NSArray *uploadArray = [self.currentArray subarrayWithRange:NSMakeRange(0, count)];
//    NSMutableArray *uploadMutableArray = [NSMutableArray array];
//    for (NSDictionary *dic in uploadArray) {
//        NSMutableDictionary *params = dic.mutableCopy;
//        [params addEntriesFromDictionary:[FFTrackDataUtil commonData]];
//        [uploadMutableArray addObject:params];
//    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    // 设置埋点数据
    [params setValue:uploadArray forKey:@"body"];

    self.uploading = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [[ETNetworkManager sharedInstance] POST:[ETEventTrack sharedInstance].serverUrl parameters:params callBack:^(id JSONResponse, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        self.uploading = NO;
        NSString *status = JSONResponse[@"code"];
        NSString *msg = JSONResponse[@"message"];
        BOOL success = NO;
        if ([status isEqualToString:@"0000"] && error == nil) {
            //统计满kMaxCounts条上传后删除本地数据
            if (strongSelf.currentArray.count > 0) {
                //进入后台时为保存数据并清除currentArray 在此需要做count处理防止越界
                if (count >= strongSelf.currentArray.count) {
                    [self.currentArray removeAllObjects];
                } else {
                    if (count < strongSelf.currentArray.count) {
                        [strongSelf.currentArray removeObjectsInRange:NSMakeRange(0, count)];
                    }
                }
            }
            //清除数据
            [strongSelf clearLoactionData];
            success = YES;
        }
        if (callback) {
            callback(success, msg);
        }
    }];
}

/**
 是否上传埋点数据

 @return 是否上传 YES：上传
 */
- (BOOL)isUploadData {
    if (self.currentArray.count > 0 && !self.uploading) {
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
    [self clearLoactionData];
    NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:YES];

    NSString *loactionString = [ETJsonUtils toJSONString:self.currentArray];
    BOOL saveBool = [loactionString writeToFile:loactionDataPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    //存储成功后删除内存数组
    if (saveBool) {
        [self.currentArray removeAllObjects];
        NSLog(@"统计数据保存到本地 成功");
    } else {
        NSLog(@"统计数据保存到本地 失败");
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
    NSString *loactionDataPath = [self getLoactionJsonPathWithDataNameBool:NO];
    [[NSFileManager defaultManager] removeItemAtPath:loactionDataPath error:NULL];
}

@end
