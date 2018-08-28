//
//  UIViewController+ETSwizzle.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/26.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UIViewController+ETSwizzle.h"

#import "ETEventTrackManager.h"
#import "ETAnalyticsManager.h"

#import "ETUtilsHeader.h"
#import "ETConstants.h"
#import "NSObject+ETIdentifier.h"

@implementation UIViewController (ETSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(swizzled_viewDidAppear:);
        [ETSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];

        SEL originalSelector1 = @selector(viewDidDisappear:);
        SEL swizzledSelector1 = @selector(swizzled_viewWillDisappear:);
        [ETSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
    });
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    NSLog(@"swizzled_viewDidAppear: %@   eventId: %@", NSStringFromClass([self class]), self.et_eventId);
    [self swizzled_viewDidAppear:animated];
    [self enterView];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    NSLog(@"swizzled_viewWillDisappear: %@   eventId: %@", NSStringFromClass([self class]), self.et_eventId);
    [self swizzled_viewWillDisappear:animated];
    [self leaveView];
}

#pragma mark -
#pragma mark - 页面进入和离开
- (void)enterView {
    // 记录进入页面的时间
    self.et_viewAppearTime = [ETDateUtil nowTimestamp];
    NSString *pageId = [self getViewPageId];
    if (pageId.length >0) {
        // 添加页面进入时的埋点统计
        NSDictionary *enterDic = @{ETEventKeyEventType: ETEventTypeEnter, ETEventKeyPageId: pageId};
        [ETEventTrackManager addEventTrackData:enterDic];
        [ETAnalyticsManager sensorAnalyticTrackEvent:ETEventTypeEnter properties:enterDic];
    }
}

- (void)leaveView {
    NSString *pageId = [self getViewPageId];
    if (pageId.length > 0) {
        // 添加页面离开时的埋点统计
        NSString *Interval = [NSString stringWithFormat:@"%lld", [ETDateUtil nowTimeIntervalSince:self.et_viewAppearTime]];
        NSDictionary *eventDic = @{ETEventKeyEventType: ETEventTypePage, ETEventTypeDuration: Interval, ETEventKeyPageId: pageId};
        [ETEventTrackManager addEventTrackData:eventDic.copy];
        [ETAnalyticsManager sensorAnalyticTrackEvent:ETEventTypePage properties:eventDic.copy];
    }
}

#pragma mark -
#pragma mark - 获取页面的统计id
- (NSString *)getViewPageId {
    NSString *str = nil;
    if (self.et_eventId.length > 0) {
        str = self.et_eventId;
    } else {
        // 从用户埋点配置文件中查找页面id
         str = [ETConfigFileUtils eventPageItem:NSStringFromClass([self class])];
        if (str) {
            self.et_eventId = str;
        }
    }
    return str;
}

@end
