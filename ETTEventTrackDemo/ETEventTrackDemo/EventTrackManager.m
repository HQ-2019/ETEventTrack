//
//  EventTrackManager.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/24.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "EventTrackManager.h"
#import "ETEventTrack.h"

@implementation EventTrackManager

+ (EventTrackManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static EventTrackManager *sharedEventTrackManager = nil;
    dispatch_once(&onceToken, ^{
        sharedEventTrackManager = [[EventTrackManager alloc] init];
        
    });
    return sharedEventTrackManager;
}

/**
 启动埋点库
 */
+ (void)start {
    [[self sharedInstance] start];
}

- (void)start {
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", @"http://feifei-app-h5.feifei.test", @"/api/burypoint/bury"];
    NSString *shenceServerURL = @"http://123.59.154.79:8106/sa?project=default";
    NSString *configFileName = @"FFEventTrackConfig";
    [ETEventTrack configShenceSdkWithServerUrl:shenceServerURL enableLog:NO];
    [ETEventTrack startWithServerUrl:serverURL configFileName:configFileName commonParamsBloack:[self commonParamsBloack]];
}


/**
 给埋点库注入获取公共参数的Block

 @return ETCommonParamsBloack
 */
- (ETCommonParamsBloack)commonParamsBloack {
    ETCommonParamsBloack commonParamsBloack = ^id{
        NSMutableDictionary *common = @{
                                        @"userId": @"",                 // 用户id
                                        @"channelId": @"",              // 下载APP的渠道号
                                        @"appVersion": @"",             // app版本号
                                        @"appSessionId": @"",
                                        @"networkType": @"",            //网络类型
                                        @"carrier": @"",                //运营商名称
                                        @"os": @"ios",
                                        @"osVersion": @"",
                                        @"uniqueId": @"",
                                        @"deviceNum": @"",
                                        @"model": @"",
                                        @"manufacturer": @"",
                                        @"pageType": @"",               // 区分是原生埋点还是H5埋点
                                        @"packageType": @""             // 区分不同的包
                                        }.mutableCopy;
        return common;
    };
    
    return commonParamsBloack;
}

/**
 添加埋点信息(自有埋点)
 
 @param trackData 埋点信息
 */
+ (void)addEventTrackData:(NSDictionary *)trackData {
    [ETEventTrack addEventTrackData:trackData];
}

/**
 添加埋点信息(神策SDK埋点)
 
 @param event 事件
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event {
    [ETEventTrack addShenceEventTrackWithEvent:event];
}

/**
 添加埋点信息(神策SDK埋点)，并使用自定埋点信息
 
 @param event 事件
 @param propertieDic 自定义信息
 */
+ (void)addShenceEventTrackWithEvent:(NSString *)event properties:(NSDictionary *)propertieDic {
    [ETEventTrack addShenceEventTrackWithEvent:event properties:propertieDic];
}

@end
