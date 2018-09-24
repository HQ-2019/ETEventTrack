//
//  FFEventTrackConfig.h
//  ETEventTrack
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETConstants.h"

@interface ETConfigFileUtils : NSObject
dET_SINGLETON_FOR_CLASS_HEADER(ETConfigFileUtils)

/**
 埋点版本

 @return 版本号
 */
+ (NSString *)eventTrackVersion;

/**
 上传埋点信息的时间间隔

 @return 如果文件中没有配置时间，则默认为30s
 */
+ (NSUInteger)timeInterval;

/**
 通过类名获取事件埋点配置信息

 @param className 控制器类名
 @return dic
 */
+ (NSDictionary *)eventItem:(NSString *)className;

/**
 通过类名获取页面id
 
 @param className 控制器类名
 @return pageId
 */
+ (NSString *)eventPageItem:(NSString *)className;

/**
 获取事件id

 @param className 控制器类名
 @param eventName 事件名称
 @return 事件id
 */
+ (NSString *)eventControlIdByClassName:(NSString *)className eventName:(NSString *)eventName;

@end
