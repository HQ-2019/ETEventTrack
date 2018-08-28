//
//  EventTrackManager.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/24.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventTrackManager : NSObject

+ (EventTrackManager *)sharedInstance;

/**
 启动埋点库
 */
+ (void)start;

/**
 添加埋点信息(自有埋点)
 
 @param trackData 埋点信息
 */
+ (void)addEventTrackData:(NSDictionary *)trackData;

/**
 添加埋点信息(神策SDK埋点)
 
 @param event 事件
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event;

/**
 添加埋点信息(神策SDK埋点)，并使用自定埋点信息
 
 @param event 事件
 @param propertieDic 自定义信息
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event properties:(NSDictionary *)propertieDic;

@end
