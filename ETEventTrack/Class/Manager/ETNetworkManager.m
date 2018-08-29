//
//  ETNetworkManager.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETNetworkManager.h"
#import <AFNetworking/AFNetworking.h>

double const ETRequstTimeOut = 30.0;      /**< 网络请求默认的超时时间 */

@interface ETNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;
@property (nonatomic, strong) NSMutableDictionary *taskList;            /**< 执行的任务列表 */

@end

@implementation ETNetworkManager

dET_SINGLETON_FOR_CLASS(ETNetworkManager)

- (AFHTTPSessionManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 连接超时时间设置为30秒
        _requestManager.requestSerializer.timeoutInterval = ETRequstTimeOut;
        
//        if ([[ETEventTrack sharedInstance].serverUrl hasPrefix:@"https:"]) {
//            _requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//            _requestManager.securityPolicy.allowInvalidCertificates = YES;
//            _requestManager.securityPolicy.validatesDomainName = NO;
//        }
//        
//        // 监控网络状态变化
//        NSOperationQueue *operationQueue = _requestManager.operationQueue;
//        [_requestManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            NSLog(@"当前网络类型变更： %ld", (long)status);
//            switch (status) {
//                case AFNetworkReachabilityStatusReachableViaWWAN:
//                case AFNetworkReachabilityStatusReachableViaWiFi:
//                    [operationQueue setSuspended:NO];
//                    break;
//                case AFNetworkReachabilityStatusNotReachable:
//                default:
//                    [operationQueue setSuspended:YES];
//                    break;
//            }
//        }];
//        NSLog(@"当前网络类型 ： %ld", (long)_requestManager.reachabilityManager.networkReachabilityStatus);
//        [_requestManager.reachabilityManager startMonitoring];
    }
    return _requestManager;
}

- (void)setSecurityPolicyWithUrl:(NSString *)url {
    if ([url hasPrefix:@"https:"]) {
        _requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _requestManager.securityPolicy.allowInvalidCertificates = YES;
        _requestManager.securityPolicy.validatesDomainName = NO;
    } else {
        _requestManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
}

- (NSMutableDictionary *)taskList {
    if (!_taskList) {
        _taskList = @{}.mutableCopy;
    }
    return _taskList;
}

#pragma mark -
#pragma mark - POST 请求
/**
 POST请求
 
 @param interface 接口名称
 @param params body参数
 @param callBack 回调
 */
- (void)POST:(NSString *)interface
  parameters:(NSDictionary *)params
    callBack:(ETNetworkResponeCallBack)callBack {
    [self POST:interface timeout:ETRequstTimeOut parameters:params callBack:callBack];
}

/**
 POST请求
 
 @param interface 接口名称
 @param timeout 定义超时时间
 @param params body参数
 @param callBack 回调
 */
- (void)POST:(NSString *)interface
     timeout:(double)timeout
  parameters:(NSDictionary *)params
    callBack:(ETNetworkResponeCallBack)callBack {
    
    [self setSecurityPolicyWithUrl:interface];
    self.requestManager.requestSerializer.timeoutInterval = timeout;
    
    if (self.requestManager.operationQueue.suspended && callBack) {
        NSError *error = [NSError errorWithDomain:@"服务异常" code:9999 userInfo:nil];
        callBack(nil, error);
    }
    
    @synchronized(self.taskList) {
        NSURLSessionDataTask *requestTask;
        
        // 取消队列中重复的任务
        if (self.taskList) {
            requestTask = self.taskList[interface];
            if (requestTask) {
                [requestTask cancel];
            }
        }
        
        // 使用AFN发起POST请求
        requestTask = [self.requestManager POST:interface parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successWithTask:task responseObject:responseObject interface:interface parameters:params callBack:callBack];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failureWithTask:task error:error interface:interface parameters:params callBack:callBack];
        }];
        
        // 保存本次任务
        if (requestTask) {
            self.taskList[interface] = requestTask;
        }
    }
}


#pragma mark -
#pragma mark - 处理网路请求
- (void)successWithTask:(NSURLSessionDataTask * _Nonnull)task
         responseObject:(id _Nullable)responseObject
              interface:(NSString *)interface
             parameters:(NSDictionary *)params
               callBack:(ETNetworkResponeCallBack)callBack {
    NSLog(@"\n ********** 发送信令 (成功) ********* \n服务器接口: %@ \n请求参数: %@ \n服务器响应: %@ \n ************* 信令结束 (成功) ********** ", task.originalRequest.URL, params, responseObject);
    // 需要时统一处理状态值
    
    //回调请求结果
    if (callBack) {
        callBack(responseObject, nil);
    }
    
    [self clearTaskWithUrl:interface];
}

- (void)failureWithTask:(NSURLSessionDataTask * _Nonnull)task
                  error:(NSError * _Nonnull)error
              interface:(NSString *)interface
             parameters:(NSDictionary *)params
               callBack:(ETNetworkResponeCallBack)callBack {
    NSLog(@"\n ********** 发送信令 (失败) ********* \n服务器接口: %@ \n请求参数: %@ \n错误信息: %@ \n ************* 信令结束 (失败) ********** ", task.originalRequest.URL, params, error);
    if (error.code != NSURLErrorCancelled && callBack) {
        callBack(nil, error);
    }
    
    [self clearTaskWithUrl:interface];
}

#pragma mark -
#pragma mark - 清楚缓存中的任务
- (void)clearTaskWithUrl:(NSString * _Nonnull)url {
    if (!url || self.taskList.allKeys.count == 0) {
        return;
    }
    [self.taskList removeObjectForKey:url];
}

@end
