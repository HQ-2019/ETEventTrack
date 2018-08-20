//
//  UIControl+FFSwizzle.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UIControl+FFSwizzle.h"
#import "FFTabBarViewController.h"
#import "FFBaseNavigationController.h"

@implementation UIControl (FFSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swizzled_sendAction:to:forEvent:);
        [FFSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    //执行原函数
    [self swizzled_sendAction:action to:target forEvent:event];
    //设置埋点数据
    [self stastisticsAction:action to:target forEvent:event];
}

#pragma mark -
#pragma mark - 事件埋点统计

- (void)stastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([target isKindOfClass:[UITabBar class]]) {
        return;
    }
    NSString *eventId = @"";
    NSString *pageId = @"";
    NSString *controllerName = @"";
    UIViewController *controller = [self getViewControllerWithTarget:target];
    // 获取控件所在页面的配置id
    if (controller) {
        controllerName = NSStringFromClass([controller class]);
        if ([NSString isNotEmpty:controller.eventId]) {
            pageId = controller.eventId;
        } else {
            NSString *str = [FFEventTrackConfig eventPageItem:controllerName];
            pageId = [NSString isNotEmpty:str] ? str : @"";
        }
    }

    //当设置了eventId时直接使用，不从配置文件读取
    if ([NSString isNotEmpty:self.eventId]) {
        eventId = self.eventId;
        NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", controllerName, eventId, NSStringFromSelector(action));
    } else {
        //只统计触摸结束时
        if (event != nil && [[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
            //从用户埋点配置文件中查找点击事件id
            NSString *actionString = NSStringFromSelector(action);
            if ([NSString isNotEmpty:controllerName]) {
                eventId = [FFEventTrackConfig eventControlIdByClassName:controllerName eventName:actionString];
                NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", controllerName, eventId, actionString);
            }
        }
    }

    if ([NSString isNotEmpty:eventId]) {
        //加入埋点信息
        NSDictionary *eventDic = @{}.mutableCopy;
        NSDictionary *contenDic = @{}.mutableCopy;
        [eventDic setValue:pageId forKey:KEventKeyPageId];
        [eventDic setValue:eventId forKey:KElementID];
        [eventDic setValue:KBuryPointTypeClick forKey:KEventKeyEventType];
        [eventDic setValue:KEventTypeClick forKey:KEventType];
        if (self.expendData.allKeys > 0) {
             contenDic = [self expendData];
          } else if ([controller expendData].allKeys > 0) {
             contenDic = [controller expendData];
        }
        
        if (contenDic.allKeys > 0) {
            [eventDic setValue:contenDic.copy forKey:KEventKeyContent];
        } else {
            [eventDic setValue:nil forKey:KEventKeyContent];
        }
        
        NSDictionary *event = eventDic.copy;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [FFTrackDataManager addEventTrackData:[FFTrackDataUtil eventTrackData:event]];
        });

        if (contenDic.allKeys.count > 0 && [contenDic.allKeys containsObject:@"id"]) {
            [eventDic setValue:contenDic[@"id"] forKey:KEventKeyContent];
        } else {
            [eventDic setValue:nil forKey:KEventKeyContent];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [FFAnalyticsManager sensorAnalyticTrackEvent:KBuryPointTypeClick withProperties:eventDic.copy];
        });
    }

}

#pragma mark -
#pragma mark - 获取触发事件的控件所属的ViewController

- (UIViewController *)getViewControllerWithTarget:(id)target {
    //如果target是ViewController 则直接返回
    if ([target isKindOfClass:[UIViewController class]]) {
        return (UIViewController *) target;
    }
    //如果target是继承UIView 则查询其所属的ViewController
    if ([target isKindOfClass:[UIView class]]) {
        for (UIView *next = (UIView *) target; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (UIViewController *) nextResponder;
            }
        }
    }
    return nil;

}

@end
