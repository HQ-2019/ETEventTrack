//
//  FFTrackDataUtil.h
//  ETEventTrack
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETDateUtil : NSObject

/**
 获取某个时间到现在的间隔
 
 @param startTime 开始时间
 @return 时间间隔
 */
+ (long long)nowTimeIntervalSince:(NSString *)startTime;

/**
 获取当前时间
 @return 时间戳
 */
+ (NSString *)nowTimestamp;

@end
