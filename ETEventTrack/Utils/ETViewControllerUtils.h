//
//  ETViewControllerUtils.h
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/27.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ETViewControllerUtils : NSObject

/**
 通过target事件查询子视图所在的ViewController
 
 @param target target
 @return UIViewController
 */
+ (UIViewController *)getViewControllerWithTarget:(id)target;

/**
 通过subView查询 子视图所在的ViewController
 
 @param subView subView
 @return UIViewController
 */
+ (UIViewController *)getViewControllerWithSubView:(UIView *)subView;

@end
