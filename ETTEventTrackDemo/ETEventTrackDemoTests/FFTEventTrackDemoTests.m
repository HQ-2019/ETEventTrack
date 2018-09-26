//
//  FFTEventTrackDemoTests.m
//  FFTEventTrackDemoTests
//
//  Created by huangqun on 2018/8/21.
//  Copyright © 2018年 freedom. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FFTEventTrackDemoTests : XCTestCase

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FFTEventTrackDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString* uuid = [NSString stringWithFormat:@"com.jzp.array_%p", self];
    self.syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (void)addObject:(id)anObject {
    dispatch_barrier_async(self.syncQueue, ^{
        if (anObject) {
            [self.dataArray addObject:anObject];
        }
    });
}

- (void)removeObjectAtIndex:(NSArray *)array{
    dispatch_barrier_async(self.syncQueue, ^{
        if (array.count > 0) {
            [self.dataArray removeObjectsInArray:array];
            NSLog(@"------  removeArray:%d  dataArray:%d", array.count, self.dataArray.count);
        }
    });
}

- (NSArray *)objectEnumerator {
    __block NSEnumerator *enu;
    dispatch_sync(self.syncQueue, ^{
        enu = [self.dataArray objectEnumerator];
    });

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSObject *object in enu) {
        [array addObject:object];
    }

    return array.copy;
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

- (void)testArraySyncHandle {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 1; i <= 1000 ; i ++) {
        
        dispatch_async(queue, ^{
            [self addObject:[NSString stringWithFormat:@"lll - %d", i]];
        });
        
        if (i == 600) {
            NSArray * array = [self objectEnumerator];
            NSLog(@"---- 11  %lu", (unsigned long)array.count);
            dispatch_async(queue, ^{
                [self removeObjectAtIndex:array];
            });
        }
        
        if (i == 800) {
            NSArray * array = [self objectEnumerator];
            NSLog(@"---- 22 %lu", (unsigned long)array.count);
            dispatch_async(queue, ^{
                [self removeObjectAtIndex:array];
            });
        }

        if (i == 900) {
            NSArray * array = [self objectEnumerator];
            NSLog(@"---- 33 %lu", (unsigned long)array.count);
            dispatch_async(queue, ^{
                [self removeObjectAtIndex:array];
            });
        }

        if (i == 950) {
            NSArray * array = [self objectEnumerator];
            NSLog(@"---- 44  %lu", (unsigned long)array.count);
            dispatch_async(queue, ^{
                [self removeObjectAtIndex:array];
            });
        }
    }
    
    sleep(1);
    NSArray * array = [self objectEnumerator];
    NSLog(@"----  %lu  %@", (unsigned long)array.count, array);
}

@end
