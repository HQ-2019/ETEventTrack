//
//  ETSubViewController.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/28.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETSubViewController.h"

@interface ETSubViewController ()

@end

@implementation ETSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 手动设置页面埋点id
    self.et_eventId = @"10003";
    
    // 设置导航栏
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(goback)];
    leftItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
