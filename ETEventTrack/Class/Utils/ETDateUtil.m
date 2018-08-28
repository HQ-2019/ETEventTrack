//
//  FFTrackDataUtil.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETDateUtil.h"

#import "ETEventTrack+Private.h"

@implementation ETDateUtil

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
