//
//  ETViewControllerUtils.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETViewControllerUtils.h"

@implementation ETViewControllerUtils

/**
 通过target事件查询子视图所在的ViewController

 @param target target
 @return UIViewController
 */
+ (UIViewController *)getViewControllerWithTarget:(id)target {
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

/**
 通过subView查询 子视图所在的ViewController

 @param subView subView
 @return UIViewController
 */
+ (UIViewController *)getViewControllerWithSubView:(UIView *)subView {
    for (UIView *next = [subView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    
    return nil;
}

@end
