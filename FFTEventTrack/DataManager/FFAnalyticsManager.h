//
//  FFAnalyticsManager.h
//  FFTwoBaboons
//
//  Created by 衡松 on 2018/5/15.
//  Copyright © 2018年 finupgroup. All rights reserved.
//
//  神策SDK埋点
//

#import <Foundation/Foundation.h>

@interface FFAnalyticsManager : NSObject

/**
  启动神策统计功能
 */
+ (void)sensorAnalyticsStart;

/**
 追踪用户行为事件
 
 @param event 事件
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event;

/**
 追踪用户行为事件，并为事件添加自定义属性

 @param event 事件
 @param propertyDic 自定义属性
 */
+ (void)sensorAnalyticTrackEvent:(NSString *)event withProperties:(NSDictionary *)propertyDic;

@end
