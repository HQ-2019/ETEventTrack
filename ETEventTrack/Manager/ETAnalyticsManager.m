//  FFAnalyticsManager.m
//  ETEventTrack
//
//  Created by 衡松 on 2018/5/15.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETAnalyticsManager.h"
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>

#import "ETDataManamer.h"
#import "ETDateUtil.h"
#import "ETEventTrack+Private.h"

@implementation ETAnalyticsManager

/**
 启动神策统计功能
 
 @param enableLog 是否输出日志
 */
+ (void)startSensorAnalyticsWithEnableLog:(BOOL)enableLog {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //确保只执行一次代码
        [SensorsAnalyticsSDK sharedInstanceWithServerURL:[ETEventTrack sharedInstance].shenceServerUrl
                                            andDebugMode:SensorsAnalyticsDebugOff];
        [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd |
         SensorsAnalyticsEventTypeAppViewScreen | SensorsAnalyticsEventTypeAppClick];
        [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag];
        [[SensorsAnalyticsSDK sharedInstance] setFlushNetworkPolicy:SensorsAnalyticsNetworkTypeALL];
        [[SensorsAnalyticsSDK sharedInstance] enableLog:enableLog];
    });
}

/**
 追踪用户行为事件
 
 @param event 事件
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event {
    NSDictionary *dic = [ETDataManamer commonParams];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:dic];
    });
}

/**
 追踪用户行为事件，并为事件添加自定义属性
 
 @param event 事件
 @param propertyDic 自定义属性
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event properties:(NSDictionary *)propertyDic {
    NSMutableDictionary *dic = propertyDic.mutableCopy;
    [dic addEntriesFromDictionary:[ETDataManamer commonParams]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SensorsAnalyticsSDK sharedInstance] track:event
                                     withProperties:dic];
    });
}

@end
