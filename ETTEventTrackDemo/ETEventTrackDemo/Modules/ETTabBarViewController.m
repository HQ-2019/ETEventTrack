//
//  ETTabBarViewController.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/28.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETTabBarViewController.h"

@interface ETTabBarViewController ()

@end

@implementation ETTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabBar背景色
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self initTabBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 初始化tabBarItem
- (void)initTabBarItems {
    NSArray *viewControllerName = @[@"ETHomeViewController", @"ETSecondViewController"];
    NSArray *normalImages = @[@"ico_my_def", @"ico_rcmd_def"];
    NSArray *selectImages = @[@"ico_my_slc", @"ico_rcmd_slc"];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    [viewControllerName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        
        UIViewController *controller = [[NSClassFromString(obj) alloc] init];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
        // 设置UIImage的渲染方式为总是显示原始图片
        UIImage *normalImage = [[UIImage imageNamed:normalImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [[UIImage imageNamed:selectImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置tabBarItem
        controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                              image:normalImage
                                                      selectedImage:selectImage];
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        controller.tabBarItem.tag = index;
        // 将默认title偏移出tabBar的显示范围
        controller.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
        
        [viewControllers addObject:naviController];
    }];
    
    self.viewControllers = viewControllers;
}

@end
