//
//  FFTrackDataUtil.h
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/29.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFTrackDataUtil : NSObject

/**
 获取一个完整埋点的数据

 @param params 埋点参数
 @return 埋点数据
 */
+ (NSMutableDictionary *)eventTrackData:(NSDictionary *)params;

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

/**
 上传埋点接口中的公参部分
 
 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)commonData;

@end
