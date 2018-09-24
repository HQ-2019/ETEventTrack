//
//  ETEventTrack.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/22.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETMacro.h"
#import "ETConstants.h"
#import "NSObject+ETIdentifier.h"

typedef id(^ETCommonParamsBloack)(void);

@interface ETEventTrack : NSObject

dET_SINGLETON_FOR_CLASS_HEADER(ETEventTrack)

/**
 开启埋点

 @param serverUrl 自有埋点的服务器地址
 @param configFileName 埋点信息的配置文件名称 plist格式
 @param enableLog 是否输出log日志 默认:NO 不输出
 @param commonParamsBloack 获取宿主APP的公共参数
 */
+ (void)startWithServerUrl:(NSString *)serverUrl
            configFileName:(NSString *)configFileName
                 enableLog:(BOOL)enableLog
        commonParamsBloack:(ETCommonParamsBloack)commonParamsBloack;

/**
 配置神策SDK

 @param serverUrl 神策SDK服务器地址
 @param enableLog 是否输出log日志 默认:NO 不输出
 */
+ (void)configShenceSdkWithServerUrl:(NSString *)serverUrl
                           enableLog:(BOOL)enableLog;


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
