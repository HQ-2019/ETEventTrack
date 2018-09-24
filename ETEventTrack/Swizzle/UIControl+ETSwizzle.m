//
//  UIControl+ETSwizzle.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UIControl+ETSwizzle.h"

#import "ETEventTrackManager.h"
#import "ETAnalyticsManager.h"

#import "ETUtilsHeader.h"
#import "ETConstants.h"
#import "NSObject+ETIdentifier.h"
#import "ETLogger.h"

@implementation UIControl (ETSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swizzled_sendAction:to:forEvent:);
        [ETSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    //执行原函数
    [self swizzled_sendAction:action to:target forEvent:event];
    //设置埋点数据
    [self stastisticsAction:action to:target forEvent:event];
    
    ETLog(@"点击事件 action:%@   target:%@  UIEvent:%@", NSStringFromSelector(action), target, event);
}

#pragma mark -
#pragma mark - 事件埋点统计

- (void)stastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([target isKindOfClass:[UITabBar class]]) {
        return;
    }
    
    @try {
        NSString *eventId = @"";
        NSString *pageId = @"";
        NSString *controllerName = @"";
        UIViewController *controller = [ETViewControllerUtils getViewControllerWithTarget:target];
        // 获取控件所在页面的配置id
        if (controller) {
            controllerName = NSStringFromClass([controller class]);
            if (controller.et_eventId.length > 0) {
                pageId = controller.et_eventId;
            } else {
                NSString *str = [ETConfigFileUtils eventPageItem:controllerName];
                pageId = str.length > 0 ? str : @"";
            }
        }

        //当设置了eventId时直接使用，不从配置文件读取
        if (self.et_eventId.length > 0) {
            eventId = self.et_eventId;
            ETLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", controllerName, eventId, NSStringFromSelector(action));
        } else {
            //只统计触摸结束时
            if (event != nil && [[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
                //从用户埋点配置文件中查找点击事件id
                NSString *actionString = NSStringFromSelector(action);
                if (controllerName.length > 0) {
                    eventId = [ETConfigFileUtils eventControlIdByClassName:controllerName eventName:actionString];
                    ETLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", controllerName, eventId, actionString);
                }
            }
        }

        if (eventId.length > 0) {
            //加入埋点信息
            NSDictionary *eventDic = @{}.mutableCopy;
            NSDictionary *contenDic = @{}.mutableCopy;
            [eventDic setValue:pageId forKey:ETEventKeyPageId];
            [eventDic setValue:eventId forKey:ETElementID];
            [eventDic setValue:ETBuryPointTypeClick forKey:ETEventKeyEventType];
            [eventDic setValue:ETEventTypeClick forKey:ETEventType];
            if (self.et_expendData.allKeys > 0) {
                contenDic = [self et_expendData];
            } else if ([controller et_expendData].allKeys > 0) {
                contenDic = [controller et_expendData];
            }

            if (contenDic.allKeys > 0) {
                [eventDic setValue:contenDic.copy forKey:ETEventKeyContent];
            } else {
                [eventDic setValue:nil forKey:ETEventKeyContent];
            }

            NSDictionary *event = eventDic.copy;
            [ETEventTrackManager addEventTrackData:event];

            if (contenDic.allKeys.count > 0 && [contenDic.allKeys containsObject:@"id"]) {
                [eventDic setValue:contenDic[ @"id" ] forKey:ETEventKeyContent];
            } else {
                [eventDic setValue:nil forKey:ETEventKeyContent];
            }

            [ETAnalyticsManager sensorAnalyticTrackEvent:ETBuryPointTypeClick properties:eventDic.copy];
        }
    } @catch (NSException *exception) {
        ETLog(@"点击事件埋点异常: %@", exception);
    }
}

@end
