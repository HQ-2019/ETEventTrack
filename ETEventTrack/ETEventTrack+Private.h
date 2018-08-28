//
//  ETEventTrack+Private.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/22.
//  Copyright © 2018年 freedom. All rights reserved.
//
//  内部使用
//

#import "ETEventTrack.h"

@interface ETEventTrack ()

/**
 自有埋点的服务器地址
 */
@property (nonatomic, strong) NSString *serverUrl;

/**
 神策SDK埋点的服务器地址
 */
@property (nonatomic, strong) NSString *shenceServerUrl;

/**
 埋点信息配置文件的名称
 */
@property (nonatomic, strong) NSString *configFileName;

/**
 获取埋点信息中公参的block
 埋点信息中需要宿主APP的参数可在这个block中回调
 */
@property (nonatomic, copy) ETCommonParamsBloack commonParamsbloack;

@end
