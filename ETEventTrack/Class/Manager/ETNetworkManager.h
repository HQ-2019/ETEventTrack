//
//  ETNetworkManager.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETConstants.h"

typedef void(^ETNetworkResponeCallBack)(id JSONResponse, NSError *error);

@interface ETNetworkManager : NSObject

dET_SINGLETON_FOR_CLASS_HEADER(ETNetworkManager)

/**
 POST请求
 
 @param interface 完整的接口地址
 @param params 完整的参数
 @param callBack 回调
 */
- (void)POST:(NSString *)interface
  parameters:(NSDictionary *)params
    callBack:(ETNetworkResponeCallBack)callBack;

/**
 POST请求
 
 @param interface 完整的接口地址
 @param timeout 定义超时时间
 @param params 完整的参数
 @param callBack 回调
 */
- (void)POST:(NSString *)interface
     timeout:(double)timeout
  parameters:(NSDictionary *)params
    callBack:(ETNetworkResponeCallBack)callBack;

@end
