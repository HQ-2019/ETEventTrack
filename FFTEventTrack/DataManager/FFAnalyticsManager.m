//  FFAnalyticsManager.m
//  FFTwoBaboons
//
//  Created by 衡松 on 2018/5/15.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "FFAnalyticsManager.h"
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#import "FFTrackDataUtil.h"

#ifdef dUSE_DEBUG_URL
    // 测试环境
    static NSString *const serverURL = @"http://123.59.154.79:8106/sa?project=default";
#else
    // 发布环境
    static NSString *const serverURL = @"http://sensors.finupfriends.com:8106/sa?project=production";
#endif

@implementation FFAnalyticsManager

/**
 启动神策统计功能
 */
+ (void)sensorAnalyticsStart {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //确保只执行一次代码
        [SensorsAnalyticsSDK sharedInstanceWithServerURL:serverURL andDebugMode: SensorsAnalyticsDebugOff];
        [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
         SensorsAnalyticsEventTypeAppEnd |
         SensorsAnalyticsEventTypeAppViewScreen |
         SensorsAnalyticsEventTypeAppClick];
        [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag];
        [[SensorsAnalyticsSDK sharedInstance] setFlushNetworkPolicy:SensorsAnalyticsNetworkTypeALL];
        [[SensorsAnalyticsSDK sharedInstance] enableLog:NO];
    });
}

/**
 追踪用户行为事件
 
 @param event 事件
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event {
    [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:[FFTrackDataUtil commonData]];
}

/**
 追踪用户行为事件，并为事件添加自定义属性
 
 @param event 事件
 @param propertyDic 自定义属性
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event withProperties:(NSDictionary *)propertyDic {
    NSMutableDictionary *dic = propertyDic.mutableCopy;
    [dic addEntriesFromDictionary:[FFTrackDataUtil commonData]];
    [[SensorsAnalyticsSDK sharedInstance] track:event
                                 withProperties:dic];
}

@end
