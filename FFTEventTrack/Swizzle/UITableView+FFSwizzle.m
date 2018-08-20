//
//  UITableView+FFSwizzle.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/28.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UITableView+FFSwizzle.h"

@implementation UITableView (FFSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置UITableView的delegate时进行swizzle
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(swizzled_setDelegate:);
        [FFSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
      });
}

- (void)swizzled_setDelegate:(id <UITableViewDelegate>)delegate {
    [self swizzled_setDelegate:delegate];
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        Class aClass = [delegate class];
        NSError *error = NULL;
        // 对UITableViewDelegate进行swizzle
        SEL originalSelector1 = @selector(tableView:didSelectRowAtIndexPath:);
        SEL swizzledSelector1 = @selector(swizzled_tableView:didSelectRowAtIndexPath:);
        [FFSwizzleUtils swizzlingWithOriginClass:aClass
                                       originSel:originalSelector1
                                    swizzleClass:[self class]
                                 swizzleSelector:swizzledSelector1
                                           error:&error];
    }
}

- (void)swizzled_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self swizzled_tableView:tableView didSelectRowAtIndexPath:indexPath];
    // 由于swizzle的是tableView的delegate，因此在该函数域中self指向的是delegate(通常是controller)
    // 整理埋点数据
    NSString *eventId = @"";
    NSString *pageId = @"";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SEL action = @selector(tableView:didSelectRowAtIndexPath:);
    UIViewController *controller = [tableView getViewController:tableView];
    NSString *controllerName = @"";
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

    // 当设置了eventId时直接使用，不从配置文件读取
    if ([NSString isNotEmpty:cell.eventId]) {
        eventId = cell.eventId;
        
        NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", NSStringFromClass([[tableView getViewController:tableView] class]), eventId, NSStringFromSelector(action));
    } else {
        //从用户埋点配置文件中查找点击事件id
        NSString *actionString = NSStringFromSelector(action);
        if ([NSString isNotEmpty:controllerName] && [NSString isNotEmpty:actionString]) {
            eventId = [FFEventTrackConfig eventControlIdByClassName:controllerName eventName:actionString];
            NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", NSStringFromClass([controller class]), eventId, actionString);
        }
    }
    if ([NSString isNotEmpty:eventId]) {
        //加入埋点信息
        NSDictionary *eventDic = @{}.mutableCopy;
        [eventDic setValue:pageId forKey:KEventKeyPageId];
        [eventDic setValue:eventId forKey:KElementID];
        [eventDic setValue:KBuryPointTypeClick forKey:KEventKeyEventType];
        [eventDic setValue:KEventTypeClick forKey:KEventType];
        
        NSString *index = @"";
        if ([pageId isEqualToString:@"1012"]) {
            index = [NSString stringWithFormat:@"%ld", indexPath.row + 2];
        } else {
            index = [NSString stringWithFormat:@"%ld", indexPath.row];
        }
        
        if (cell.expendData.allKeys.count > 0) {
            NSMutableDictionary *expendData = cell.expendData.mutableCopy;
            [expendData setValue:index forKey:@"index"];
            [eventDic setValue:KEventTypeClick forKey:KEventType];
            [eventDic setValue:expendData forKey:KEventKeyContent];
       } else if (self.expendData.allKeys.count > 0) {
            [eventDic setValue:KEventTypeView forKey:KEventType];
            [eventDic setValue:self.expendData forKey:KEventKeyContent];
        }
        NSDictionary *event = eventDic.copy;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [FFTrackDataManager addEventTrackData:[FFTrackDataUtil eventTrackData:event]];
        });

        if ([cell.expendData.allKeys containsObject:@"id"]) {
            [eventDic setValue:cell.expendData[@"id"] forKey:KEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [FFAnalyticsManager sensorAnalyticTrackEvent:KBuryPointTypeClick withProperties:[FFTrackDataUtil eventTrackData:sEvent]];
            });
            return;
        } else if ([self.expendData.allKeys containsObject:@"id"]) {
            [eventDic setValue:self.expendData[@"id"] forKey:KEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [FFAnalyticsManager sensorAnalyticTrackEvent:KBuryPointTypeClick withProperties:[FFTrackDataUtil eventTrackData:sEvent]];
            });
            return;
        }
       else {
            [eventDic setValue:nil forKey:KEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [FFAnalyticsManager sensorAnalyticTrackEvent:KBuryPointTypeClick withProperties:[FFTrackDataUtil eventTrackData:sEvent]];
            });
            return;
        }
    }
}

#pragma mark -
#pragma mark - 获取控件所属的ViewController
- (UIViewController *)getViewController:(UITableView *)tableView {
    for (UIView *next = [tableView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}

@end
