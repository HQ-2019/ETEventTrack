//
//  NSObject+FFTrackIdentifier.h
//  ETEventTrack
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ETIdentifier)

/**
 事件标志  对同一个事件函数有不同的业务统计需求时，需在事件函数中区分设置控件的eventId，埋点时不再从配置文件去读取eventId值
 */
@property(nonatomic, copy) NSString *et_eventId;

/**
 页面打开的时间
 */
@property(nonatomic, copy) NSString *et_viewAppearTime;

/**
 扩展参数
 */
@property(nonatomic, strong) NSDictionary *et_expendData;

/**
 统计数据业务结合

 @param obj 业务数据
 */
- (void)configInfoData:(id)obj;

@end
