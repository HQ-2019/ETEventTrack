//
//  ETEventTrack.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/22.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETEventTrack.h"

#import "ETEventTrack+Private.h"

#import "ETEventTrackManager.h"
#import "ETDateUtil.h"
#import "ETAnalyticsManager.h"

#import "ETApplicationListener.h"

#import "ETLogger.h"

@implementation ETEventTrack

dET_SINGLETON_FOR_CLASS(ETEventTrack)

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
        commonParamsBloack:(ETCommonParamsBloack)commonParamsBloack {
    [[ETEventTrack sharedInstance] startWithServerUrl:serverUrl
                                       configFileName:configFileName
                                            enableLog:enableLog
                                   commonParamsBloack:commonParamsBloack];
}

- (void)startWithServerUrl:(NSString *)serverUrl
            configFileName:(NSString *)configFileName
                 enableLog:(BOOL)enableLog
        commonParamsBloack:(ETCommonParamsBloack)commonParamsBloack {
    NSAssert(serverUrl.length > 0, @"服务器地址不能为空");
    if (serverUrl.length > 0) {
        self.serverUrl = serverUrl;
    }

    if (configFileName.length > 0) {
        self.configFileName = configFileName;
    }

    if (commonParamsBloack) {
        self.commonParamsbloack = commonParamsBloack;
    }

    // 启动应用程序生命周期事件的监听
    [ETApplicationListener startApplicationListeners];

    // 设置日志输出
    [ETLogger enableLog:enableLog];
}

/**
 配置神策SDK
 
 @param serverUrl 神策SDK服务器地址
 @param enableLog 是否输出log日志 默认:NO 不输出
 */
+ (void)configShenceSdkWithServerUrl:(NSString *)serverUrl
                           enableLog:(BOOL)enableLog {
    [[ETEventTrack sharedInstance] configShenceSdkWithServerUrl:serverUrl enableLog:enableLog];
}

- (void)configShenceSdkWithServerUrl:(NSString *)serverUrl
                           enableLog:(BOOL)enableLog {
    // 启动神策埋点
    [ETAnalyticsManager startSensorAnalyticsWithEnableLog:enableLog];
}

/**
 添加埋点信息(自有埋点)
 
 @param trackData 埋点信息
 */
+ (void)addEventTrackData:(NSDictionary *)trackData {
    [ETEventTrackManager addEventTrackData:trackData];
}

/**
 添加埋点信息(神策SDK埋点)
 
 @param event 事件
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event {
    [ETAnalyticsManager sensorAnalyticTrackEvent:event];
}

/**
 添加埋点信息(神策SDK埋点)，并使用自定埋点信息
 
 @param event 事件
 @param propertieDic 自定义信息
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event properties:(NSDictionary *)propertieDic {
    [ETAnalyticsManager sensorAnalyticTrackEvent:event properties:propertieDic];
}

@end
