//
//  FFTEventTrackDemoTests.m
//  FFTEventTrackDemoTests
//
//  Created by huangqun on 2018/8/21.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FFTEventTrackDemoTests : XCTestCase

@property (nonatomic, strong) NSMutableArray *customerArray;

@end

@implementation FFTEventTrackDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.customerArray = @[@"11", @"222"].mutableCopy;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testArray {
    for (int i = 0; i <= 5 ; i ++) {
        NSLog(@"-------111  00 %d  %@", i, self.customerArray);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self.customerArray) {
                [self.customerArray addObject:[NSString stringWithFormat:@"lll - %d", i]];
                NSLog(@"-------111  11 %d  %@", i, self.customerArray);
            }
        });
        
        if (i == 2) {
            NSArray *array = [NSArray arrayWithArray:self.customerArray];
            NSLog(@"-------111  22 %d  %@", i, array);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"-------111  33 %d  %@", i, array);
                    [self.customerArray removeObjectsInArray:array];
                    NSLog(@"-------111  44 %d  %@", i, self.customerArray);
            });
        }
        
        if (i == 4) {
            NSArray *array = [NSArray arrayWithArray:self.customerArray];
            NSLog(@"-------111  22 %d  %@", i, array);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"-------111  33 %d  %@", i, array);
                [self.customerArray removeObjectsInArray:array];
                NSLog(@"-------111  44 %d  %@", i, self.customerArray);
            });
        }
    }
    
}

@end
