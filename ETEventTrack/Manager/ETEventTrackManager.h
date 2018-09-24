//
//  FFTrackDataManager.h
//  ETEventTrack
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMacro.h"

/**
 UI提示回调
 
 @param success success or fail
 @param msg 需要提示的文案
 */
typedef void (^KResponeAlertCallBack)(BOOL success, NSString *msg);

@interface ETEventTrackManager : NSObject

dET_SINGLETON_FOR_CLASS_HEADER(ETEventTrackManager)

/**
 添加一个埋点信息

 @param trackData 埋点信息
 */
+ (void)addEventTrackData:(NSDictionary *)trackData;

/**
 上传统计数据 忽略kMaxCounts条数的限制

 @param callback callback
 */
+ (void)uploadEventTrackData:(KResponeAlertCallBack)callback;

/**
 上传本地缓存的埋点数据数据
 */
+ (void)uploadLocalEventTrackData;

/**
 保存埋点数据到本地
 */
+ (void)saveLocalEventTrackData;

@end
