//
//  ETJsonUtils.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETJsonUtils : NSObject

+ (id)fromJSONData:(NSData *)data;

+ (id)fromJSONString:(NSString *)string;

+ (NSData *)toJSONData:(id)obj;

+ (NSString *)toJSONString:(id)obj;

@end
