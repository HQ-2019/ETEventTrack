//
//  ETJsonUtils.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETJsonUtils.h"

@implementation ETJsonUtils

+ (id)fromJSONData:(NSData *)data {
    if (data != nil) {
        NSError *error = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
        
        if (obj != nil && error == nil){
            return obj;
        } else {
            // 解析错误
            return nil;
        }
    } else {
        return nil;
    }
}

+ (id)fromJSONString:(NSString *)string {
    return [ETJsonUtils fromJSONData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSData *)toJSONData:(id)obj {
    NSData *ret = nil;
    if ( [NSJSONSerialization isValidJSONObject:obj] ) {
        NSError *error = nil;
        ret = [NSJSONSerialization dataWithJSONObject:obj
                                              options:NSJSONWritingPrettyPrinted
                                                error:&error];
        if ( error ) {
            ret = nil;
        }
    }
    return ret;
}

+ (NSString *)toJSONString:(id)obj {
    return [[NSString alloc] initWithData:[ETJsonUtils toJSONData:obj] encoding:NSUTF8StringEncoding];
}


@end
