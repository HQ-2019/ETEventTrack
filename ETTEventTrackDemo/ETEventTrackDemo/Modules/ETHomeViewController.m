//
//  ViewController.m
//  FFTEventTrackDemo
//
//  Created by huangqun on 2018/8/21.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import "ETHomeViewController.h"
#import "ETSubViewController.h"

@interface ETHomeViewController ()

@end

@implementation ETHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 250)/2, 150, 250, 50);
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"配置文件中配置按钮埋点ID" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 250)/2, 250, 250, 50);
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"代码设置按钮埋点ID" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    // 手动设置埋点id
    button2.et_eventId = @"1003";
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 250)/2, 350, 250, 50);
    button3.backgroundColor = [UIColor redColor];
    [button3 setTitle:@"添加一个登录埋点" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonAction3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonAction1 {
    NSLog(@"button click: %@", NSStringFromSelector(_cmd));
    
    ETSubViewController *controller = [ETSubViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)buttonAction2 {
    NSLog(@"button click: %@", NSStringFromSelector(_cmd));
}

- (void)buttonAction3 {
    // 添加一个登录的埋点信息
    [EventTrackManager addEventTrackData:@{ETEventKeyEventType: ETEventTypeAppLogin}];
    [EventTrackManager addShenceEventTrackWithEvent:ETEventTypeAppLogin properties:@{@"sucess": @"1"}];
}

@end
