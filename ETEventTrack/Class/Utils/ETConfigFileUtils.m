//
//  FFEventTrackConfig.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETConfigFileUtils.h"
#import "ETEventTrack+Private.h"

@interface ETConfigFileUtils ()

@property(nonatomic, strong) NSString *eventTrackVersion;      /**< 埋点配置的版本 */
@property(nonatomic, strong) NSDictionary *eventItems;         /**< 所有的埋点配置信息(不包含手动埋点信息) */

@end

@implementation ETConfigFileUtils

dET_SINGLETON_FOR_CLASS(ETConfigFileUtils)

/**
 埋点版本
 
 @return 版本号
 */
+ (NSString *)eventTrackVersion {
    ETConfigFileUtils *config = [[self class] sharedInstance];
    if (config.eventTrackVersion.length > 0) {
        [config eventTrackConfig];
    }
    return config.eventTrackVersion.length > 0 ? config.eventTrackVersion : @"";
}

/**
 通过类名获取事件埋点配置信息
 
 @param className 控制器类名
 @return dic
 */
+ (NSDictionary *)eventItem:(NSString *)className {
    ETConfigFileUtils *config = [[self class] sharedInstance];
    if (config.eventItems == nil) {
        [config eventTrackConfig];
    }
    NSDictionary *item = config.eventItems[className];
    return item;
}

/**
 通过类名获取页面id
 
 @param className 控制器类名
 @return pageId
 */
+ (NSString *)eventPageItem:(NSString *)className {
    ETConfigFileUtils *config = [[self class] sharedInstance];
    if (config.eventItems == nil) {
        [config eventTrackConfig];
    }
    NSDictionary *item = config.eventItems[className];
    NSString *eventId = item[ETConfigKeyPageId];
    return eventId;
}

/**
 获取事件id
 
 @param className 控制器类名
 @param eventName 事件名称
 @return 事件id
 */
+ (NSString *)eventControlIdByClassName:(NSString *)className eventName:(NSString *)eventName {
    ETConfigFileUtils *config = [[self class] sharedInstance];
    if (config.eventItems == nil) {
        [config eventTrackConfig];
    }
    NSDictionary *item = config.eventItems[className];
    NSDictionary *controlEvents = item[ETConfigKeyControlId];
    NSString *eventId = controlEvents[eventName];
    return eventId;
}

- (NSDictionary *)eventTrackConfig {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[ETEventTrack sharedInstance].configFileName
                                                         ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.eventTrackVersion = dic[ETConfigKeyVersion];
    self.eventItems =dic[ETConfigKeyAllEvents];
    return dic;
}

@end
