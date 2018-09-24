//
//  ETDataManamer.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/28.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETDataManamer : NSObject

/**
 获取一个完整埋点的数据
 
 @param params 埋点参数
 @return 埋点数据
 */
+ (NSMutableDictionary *)eventTrackData:(NSDictionary *)params;

/**
 获取宿主APP注入的公共参数

 @return NSDictionary
 */
+ (NSDictionary *)commonParams;

@end
