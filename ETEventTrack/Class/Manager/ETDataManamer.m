//
//  ETDataManamer.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/28.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETDataManamer.h"
#import "ETEventTrack+Private.h"
#import "ETDateUtil.h"

@implementation ETDataManamer

/**
 获取一个完整埋点的数据
 
 @param params 埋点参数
 @return 埋点数据
 */
+ (NSMutableDictionary *)eventTrackData:(NSDictionary *)params {
    NSMutableDictionary *trackData = [NSMutableDictionary new];
    // 埋点时间
    [trackData setValue:[ETDateUtil nowTimestamp] forKey:@"operateTime"];
    
    //追加参数
    if (params) {
        [trackData addEntriesFromDictionary:params];
    }
    
    // 添加公参
    [trackData addEntriesFromDictionary:[ETDataManamer commonParams]];
    
    return trackData;
}

/**
 获取宿主APP注入的公共参数
 
 @return NSDictionary
 */
+ (NSDictionary *)commonParams {
    if ([ETEventTrack sharedInstance].commonParamsbloack) {
        id commonParams = [ETEventTrack sharedInstance].commonParamsbloack();
        if ([commonParams isKindOfClass:[NSDictionary class]]) {
            return commonParams;
        }
    }
    
    return nil;
}

@end
