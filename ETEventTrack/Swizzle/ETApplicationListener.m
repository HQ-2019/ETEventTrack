//
//  ETApplicationListener.m
//  ETEventTrackDemo
//
//  Created by huangqun on 2018/8/28.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETApplicationListener.h"
#import <UIKit/UIApplication.h>

#import "ETEventTrack.h"
#import "ETEventTrack+Private.h"

#import "ETEventTrackManager.h"
#import "ETAnalyticsManager.h"

#import "ETUtilsHeader.h"
#import "ETConstants.h"
#import "ETLogger.h"

@interface ETApplicationListener ()

@property (nonatomic, strong) NSDate *appLaunchTime;                                          /**< APP启动时的时间 */
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier; /**< 后台任务标记 */

@end

@implementation ETApplicationListener

+ (ETApplicationListener *)sharedInstance {
    static dispatch_once_t onceToken;
    static ETApplicationListener *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ETApplicationListener alloc] init];

    });
    return sharedInstance;
}

/**
 启动应用程序生命周期事件的监听
 */
+ (void)startApplicationListeners {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationDidFinishLaunchingNotification:)
                               name:UIApplicationDidFinishLaunchingNotification
                             object:nil];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationWillEnterForeground:)
                               name:UIApplicationWillEnterForegroundNotification
                             object:nil];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];

    [notificationCenter addObserver:[ETApplicationListener sharedInstance]
                           selector:@selector(applicationWillTerminateNotification:)
                               name:UIApplicationWillTerminateNotification
                             object:nil];
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification {
    ETLog(@"ET  applicationDidFinishLaunchingNotification");
    // 程序切入前台 数据打点
    [self applicationStartOrEnterForeground];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    ETLog(@"ET  applicationWillEnterForeground");
    // 程序切入前台 数据打点
    [self applicationStartOrEnterForeground];
    
    // 结束后台任务
    [self endBackgroundTask];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    ETLog(@"ET  applicationDidBecomeActive");
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    ETLog(@"ET  applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    ETLog(@"ET  applicationDidEnterBackground");
    // 标记一个后台任务开始 默认600S
    [self startBackgroundTask];

    // 上传所以埋点日志
    [self submitAllLogsWhenEnterBackground];
}

- (void)applicationWillTerminateNotification:(NSNotification *)notification {
    ETLog(@"ET  applicationWillTerminateNotification");
    // 应用被kill时保存埋点日志到本地
    [self addEnterBackgroundEventTrackInfo:@"0"];
    [ETEventTrackManager saveLocalEventTrackData];
}

#pragma mark -
#pragma mark - 应用程序启动或者进入前台时添加埋点
- (void)applicationStartOrEnterForeground {
    @try {
        self.appLaunchTime = [NSDate date];
        if (![self hasLaunched]) {
            // 第一次安装
            [ETAnalyticsManager sensorAnalyticTrackEvent:ETEventTypeAppFisrtLaunch];
            [ETEventTrackManager addEventTrackData:@{ETEventKeyEventType: ETEventTypeAppFisrtLaunch}];
        }
        
        // 添加进入前台的埋点
        [ETAnalyticsManager sensorAnalyticTrackEvent:ETEventTypeAppEnterForeground];
        [ETEventTrackManager addEventTrackData:@{ETEventKeyEventType: ETEventTypeAppEnterForeground}];

        //进入前台 上传本地和已有埋点数据
        [ETEventTrackManager uploadLocalEventTrackData];
    } @catch (NSException *exception) {
        ETLog(@"应用启动上传埋点信息异常: %@", exception);
    }
}

#pragma mark -
#pragma mark - 程序进入后台时上传埋点所有日志
- (void)submitAllLogsWhenEnterBackground {
    @try {
        // 添加进入后台时的埋点
        [self addEnterBackgroundEventTrackInfo:@"1"];

        // 上传已有的埋点数据
        __weak typeof(self) weakSelf = self;
        [ETEventTrackManager uploadEventTrackData:^(BOOL success, NSString *msg) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!success) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 进入后台时存储本地统计数据 （上传失败时将数据缓存到本地）
                    [ETEventTrackManager saveLocalEventTrackData];
                });
            }
            // 结束后台任务
            [strongSelf endBackgroundTask];
        }];
    } @catch (NSException *exception) {
        ETLog(@"应用进入后台上传埋点信息异常: %@", exception);
    }
}

- (void)addEnterBackgroundEventTrackInfo:(NSString *)type {
    @try {
        // 添加应用挂起或杀掉时的埋点
        double timeInterval = [[NSDate date] timeIntervalSinceDate:self.appLaunchTime];
        NSString *timeIntervalString = [NSString stringWithFormat:@"%0.0f", timeInterval * 1000];
        NSDictionary *dic = @{ ETEventKeyEventType: ETEventTypeAppEnterBackground,
                               @"exitType": type,
                               @"length": timeIntervalString
        };
        [ETAnalyticsManager sensorAnalyticTrackEvent:ETEventTypeAppEnterBackground properties:dic];
        [ETEventTrackManager addEventTrackData:dic];
    } @catch (NSException *exception) {
        ETLog(@"应用进入后台增加埋点异常: %@", exception);
    }
}

#pragma mark -
#pragma mark - 后台任务
- (void)startBackgroundTask {
    __weak typeof(self) weakSelf = self;
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在此Block块中执行一些清理工作。
        // 如果清理工作失败了，那么将导致程序挂掉

        // 清理工作需要在主线程中用同步的方式来进行
        [strongSelf endBackgroundTask];
    }];
}

- (void)endBackgroundTask {
    // 判断任务标记是否为未结束 如果有后台任务则将其结束
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //标记指定的后台任务完成
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            //将后台任务设置为结束(销毁后台任务)
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        });
    }
}

#pragma mark -
#pragma mark - 是否第一次安装
- (BOOL)hasLaunched {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:@"CFBundleShortVersion"] isEqualToString:version]) {
        [userDefaults setObject:version forKey:@"CFBundleShortVersion"];
        [userDefaults synchronize];
        return NO;
    } else {
        return YES;
    }
    
    return YES;
}

@end
