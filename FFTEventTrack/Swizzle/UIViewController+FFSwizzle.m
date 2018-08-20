//
//  UIViewController+FFSwizzle.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/26.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UIViewController+FFSwizzle.h"
#import "FFCarouselView.h"
#import "UIView+FFViewHelper.h"
#import "FFBaseNavigationController.h"

@implementation UIViewController (FFSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(swizzled_viewDidAppear:);
        [FFSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];

        SEL originalSelector1 = @selector(viewDidDisappear:);
        SEL swizzledSelector1 = @selector(swizzled_viewWillDisappear:);
        [FFSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
    });
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    NSLog(@"swizzled_viewDidAppear: %@   eventId: %@", NSStringFromClass([self class]), self.eventId);
    [self swizzled_viewDidAppear:animated];
    [self enterView];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    NSLog(@"swizzled_viewWillDisappear: %@   eventId: %@", NSStringFromClass([self class]), self.eventId);
    [self swizzled_viewWillDisappear:animated];
    [self leaveView];
}

#pragma mark -
#pragma mark - 页面进入和离开
- (void)enterView {
    // 记录进入页面的时间
    self.viewAppearTime = [FFTrackDataUtil nowTimestamp];
    NSString *pageId = [self getViewPageId];

    if ([NSString isNotEmpty:pageId]) {
        // 添加页面进入时的埋点统计
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *enterDic = @{KEventKeyEventType: KEventTypeEnter, KEventKeyPageId: pageId};
            [FFTrackDataManager addEventTrackData:[FFTrackDataUtil eventTrackData:enterDic]];
            [FFAnalyticsManager sensorAnalyticTrackEvent:KEventTypeEnter withProperties:[FFTrackDataUtil eventTrackData:enterDic]];
        });
    }
}

- (void)leaveView {
    NSString *pageId = [self getViewPageId];
    if ([NSString isNotEmpty:pageId]) {
        // 添加页面离开时的埋点统计
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *Interval = [NSString stringWithFormat:@"%lld", [FFTrackDataUtil nowTimeIntervalSince:self.viewAppearTime]];
            NSDictionary *eventDic = [FFTrackDataUtil eventTrackData:@{KEventKeyEventType: KEventTypePage, KEventTypeDuration: Interval, KEventKeyPageId: pageId}];
            [FFTrackDataManager addEventTrackData:eventDic.copy];
            [FFAnalyticsManager sensorAnalyticTrackEvent:KEventTypePage withProperties:eventDic.copy];
        });
    }
}

#pragma mark -
#pragma mark - 获取页面的统计id
- (NSString *)getViewPageId {
    NSString *str = nil;
    if ([NSString isNotEmpty:self.eventId]) {
        str = self.eventId;
    } else {
        // 从用户埋点配置文件中查找页面id
         str = [FFEventTrackConfig eventPageItem:NSStringFromClass([self class])];
        if (str) {
            self.eventId = str;
        }
    }
    return str;
}

@end
