//
//  FFEventTrackConfig.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "FFEventTrackConfig.h"

@interface FFEventTrackConfig ()

@property(nonatomic, strong) NSString *eventTrackVersion;      /**< 埋点配置的版本 */
@property(nonatomic, strong) NSDictionary *eventItems;         /**< 所有的埋点配置信息(不包含手动埋点信息) */

@end

@implementation FFEventTrackConfig

/**
 埋点版本
 
 @return 版本号
 */
+ (NSString *)eventTrackVersion {
    return @"";
}

/**
 通过类名获取事件埋点配置信息
 
 @param className 控制器类名
 @return dic
 */
+ (NSDictionary *)eventItem:(NSString *)className {
    return nil;
}

/**
 通过类名获取页面id
 
 @param className 控制器类名
 @return pageId
 */
+ (NSString *)eventPageItem:(NSString *)className {
    return nil;
}

/**
 获取事件id
 
 @param className 控制器类名
 @param eventName 事件名称
 @return 事件id
 */
+ (NSString *)eventControlIdByClassName:(NSString *)className eventName:(NSString *)eventName {
    return nil;
}

- (NSDictionary *)eventTrackConfig {
    return nil;
}

@end
