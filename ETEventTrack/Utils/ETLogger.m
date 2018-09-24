//
//  ETLogger.m
//  ETEventTrackDemo
//
//  Created by huangqun on 2018/9/24.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETLogger.h"

@interface ETLogger ()

@property (nonatomic, assign) BOOL enableLog;

@end

@implementation ETLogger

dET_SINGLETON_FOR_CLASS(ETLogger)

/**
 开启日志打印功能(Release模式不打印)
 
 @param enableLog 默认NO：不开启日志
 */
+ (void)enableLog:(BOOL)enableLog {
    [[self class] sharedInstance].enableLog = enableLog;
}

/**
 获取日志开启状态
 
 @return YES：开启
 */
+ (BOOL)isLoggerEnabled {
    return [[self class] sharedInstance].enableLog;
}

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
             message:(NSString *)format, ... {
    @try {
        if ([ETLogger isLoggerEnabled]) {
            va_list args;
            va_start(args, format);
            NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
            NSString *log = [NSString stringWithFormat:@"%s【第%lu行】%@\n", function, (unsigned long)line, message];
            NSLog(@"%@", log);
        }
    } @catch (NSException *exception) {
    }
}

@end
