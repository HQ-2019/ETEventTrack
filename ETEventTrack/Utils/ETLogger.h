//
//  ETLogger.h
//  ETEventTrackDemo
//
//  Created by huangqun on 2018/9/24.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETMacro.h"

NS_ASSUME_NONNULL_BEGIN

// release状态下不打印日志, debug模式下根据用户的设置来判断是否打印日志
#ifdef DEBUG
#define ETLog(format, ...) [ETLogger logWtihTime:__TIME__ function:__FUNCTION__ line:__LINE__ message:(format), ## __VA_ARGS__];
#else
#define NSLog(...)
#endif

@interface ETLogger : NSObject

dET_SINGLETON_FOR_CLASS_HEADER(ETLogger)

/**
 开启日志打印功能(Release模式不打印)

 @param enableLog 默认NO：不开启日志
 */
+ (void)enableLog:(BOOL)enableLog;

/**
 获取日志开启状态

 @return YES：开启
 */
+ (BOOL)isLoggerEnabled;

/**
 输出日志
 
 @param time 时间
 @param function 函数名
 @param line 行数
 @param format 内容
 */
+ (void)logWtihTime:(const char *)time
           function:(const char *)function
               line:(NSUInteger)line
             message:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
