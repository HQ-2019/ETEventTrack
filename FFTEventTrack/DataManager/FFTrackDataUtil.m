//
//  FFTrackDataUtil.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "FFTrackDataUtil.h"
#import "UIDevice+FFNetStatus.h"
#import "FFLocationManager.h"
#import "FFSessionManager.h"

@implementation FFTrackDataUtil

/**
 获取一个完整埋点的数据
 
 @param params 埋点参数
 @return 埋点数据
 */
+ (NSMutableDictionary *)eventTrackData:(NSDictionary *)params {
    NSMutableDictionary *trackData = [NSMutableDictionary new];
    // 埋点时间
    [trackData setValue:[[self class] nowTimestamp] forKey:@"operateTime"];
    CGFloat latitude = [FFLocationManager sharedInstance].lastLocation.coordinate.latitude;
    CGFloat longitude = [FFLocationManager sharedInstance].lastLocation.coordinate.longitude;
    if (longitude && latitude) {
        NSString *lat = [NSString stringWithFormat:@"%f", latitude];
        NSString *lon = [NSString stringWithFormat:@"%f", longitude];
        NSDictionary *location = @{@"latitude": lat,
            @"longitude": lon};
        [trackData addEntriesFromDictionary:location];
    }
   //追加参数
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [trackData setValue:obj forKey:key];
        }];
    }
    return trackData;
}

/**
 上传埋点接口中的公参部分

 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)commonData {

    NSString *uniqueId = [UIDevice IDFA] ?: [[UIDevice currentDevice] deviceIdentifierID];
    NSString *appSessionId = [NSString stringWithFormat:@"%@", [FFSessionManager shareSessionManager].appSessionId ?: [UIDevice appSessionId]];
    NSString *channelId = [NSString stringWithFormat:@"%d", dCHANNEL_CODE];
    NSString *userId = [NSString stringWithFormat:@"%@", [FFUserManager userId] ?: @"0"];

    NSMutableDictionary *common = @{
                                    @"userId": userId,                                             // 用户id
                                    @"channelId": channelId,                                       // 下载APP的渠道号
                                    @"appVersion": dVERSION_NAME,                                  // app版本号
                                    @"appSessionId": appSessionId,
                                    @"networkType": [UIDevice networkStatus],                      //网络类型
                                    @"carrier": [UIDevice carrier] ?: @"",                         //运营商名称
                                    @"os": @"ios",
                                    @"osVersion": [[UIDevice currentDevice] systemVersion],
                                    @"uniqueId": uniqueId,
                                    @"deviceNum": [UIDevice IDFA] ?: @"",
                                    @"model": [UIDevice getDeviceModel] ?: @"",
                                    @"manufacturer": @"Apple",
                                    @"pageType": @"native",                                         // 区分是原生埋点还是H5埋点
                                    @"packageType": dPACKAGE_TYPE                                   // 区分不同的包
                                    }.mutableCopy;
    return common;
}


/**
 获取某个时间到现在的间隔

 @param startTime 开始时间
 @return 时间间隔
 */
+ (long long)nowTimeIntervalSince:(NSString *)startTime {
    NSString *nowTime = [self nowTimestamp];
    long long reserveTime = 0;

    //开始时间不能为空 并且当前时间大于当前时间
    if ([startTime longLongValue] > 0 && [nowTime longLongValue] > [startTime longLongValue]) {
        reserveTime = [nowTime longLongValue] - [startTime longLongValue];
    }

    return reserveTime;
}

/**
 获取当前时间
 @return 时间戳
 */
+ (NSString *)nowTimestamp {
    NSDate *nowTime = [NSDate date];
    NSTimeInterval time = [nowTime timeIntervalSince1970];
    //    return [FFDateUtil getPointYYYYMMDDHHMMSSString:time];
    return [NSString stringWithFormat:@"%0.0f", time * 1000];
}

@end
