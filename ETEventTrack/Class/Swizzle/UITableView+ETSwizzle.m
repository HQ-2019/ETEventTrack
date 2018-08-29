//
//  UITableView+ETSwizzle.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/28.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "UITableView+ETSwizzle.h"

#import "ETEventTrackManager.h"
#import "ETAnalyticsManager.h"

#import "ETUtilsHeader.h"
#import "ETConstants.h"
#import "NSObject+ETIdentifier.h"

@implementation UITableView (ETSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置UITableView的delegate时进行swizzle
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(swizzled_setDelegate:);
        [ETSwizzleUtils swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
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
        [ETSwizzleUtils swizzlingWithOriginClass:aClass
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
    UIViewController *controller = [ETViewControllerUtils getViewControllerWithSubView:tableView];;
    NSString *controllerName = @"";
    
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
    
    // 当设置了eventId时直接使用，不从配置文件读取
    if (cell.et_eventId.length > 0) {
        eventId = cell.et_eventId;
        NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", NSStringFromClass([[ETViewControllerUtils getViewControllerWithSubView:tableView] class]), eventId, NSStringFromSelector(action));
    } else {
        //从用户埋点配置文件中查找点击事件id
        NSString *actionString = NSStringFromSelector(action);
        if (controllerName.length > 0 && actionString.length > 0) {
            eventId = [ETConfigFileUtils eventControlIdByClassName:controllerName eventName:actionString];
            NSLog(@"点击事件控制所属控制器:%@   事件ID:%@  事件名称:%@", NSStringFromClass([controller class]), eventId, actionString);
        }
    }
    
    //加入埋点信息
    if (eventId.length > 0) {
        NSDictionary *eventDic = @{}.mutableCopy;
        [eventDic setValue:pageId forKey:ETEventKeyPageId];
        [eventDic setValue:eventId forKey:ETElementID];
        [eventDic setValue:ETBuryPointTypeClick forKey:ETEventKeyEventType];
        [eventDic setValue:ETEventTypeClick forKey:ETEventType];
        
        NSString *index = @"";
        if ([pageId isEqualToString:@"1012"]) {
            index = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 2];
        } else {
            index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        }
        
        if (cell.et_expendData.allKeys.count > 0) {
            NSMutableDictionary *expendData = cell.et_expendData.mutableCopy;
            [expendData setValue:index forKey:@"index"];
            [eventDic setValue:ETEventTypeClick forKey:ETEventType];
            [eventDic setValue:expendData forKey:ETEventKeyContent];
        } else if (self.et_expendData.allKeys.count > 0) {
            [eventDic setValue:ETEventTypeView forKey:ETEventType];
            [eventDic setValue:self.et_expendData forKey:ETEventKeyContent];
        }
        NSDictionary *event = eventDic.copy;
        [ETEventTrackManager addEventTrackData:event];
        
        if ([cell.et_expendData.allKeys containsObject:@"id"]) {
            [eventDic setValue:cell.et_expendData[@"id"] forKey:ETEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            [ETAnalyticsManager sensorAnalyticTrackEvent:ETBuryPointTypeClick properties:sEvent];
            return;
        } else if ([self.et_expendData.allKeys containsObject:@"id"]) {
            [eventDic setValue:self.et_expendData[@"id"] forKey:ETEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            [ETAnalyticsManager sensorAnalyticTrackEvent:ETBuryPointTypeClick properties:sEvent];
            return;
        } else {
            [eventDic setValue:nil forKey:ETEventKeyContent];
            NSDictionary *sEvent = eventDic.copy;
            [ETAnalyticsManager sensorAnalyticTrackEvent:ETBuryPointTypeClick properties:sEvent];
            return;
        }
    }
}


@end
