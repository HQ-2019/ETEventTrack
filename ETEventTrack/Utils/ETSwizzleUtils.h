//
//  FFSwizzleUtils.h
//  ETEventTrack
//
//  Created by huangqun on 2018/3/26.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETSwizzleUtils : NSObject


/**
 指定类和指定函数进行swizzle

 @param objClass 操作类对象
 @param originalSelector 原函数
 @param swizzledSelector 进行swizzle的函数
 */
+ (void)swizzlingInClass:(Class)objClass originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

/**
 指定类和指定函数进行swizzle
 
 @param originalClass 操作类对象
 @param originSelector 原函数
 @param swizzledClass 交换的操作对象原函数
 @param swizzledSelector 进行swizzle的函数
 @param error error
 */
+ (void)swizzlingWithOriginClass:(Class)originalClass originSel:(SEL)originSelector swizzleClass:(Class)swizzledClass swizzleSelector:(SEL)swizzledSelector error:(NSError **)error;

/**
 类里是否包含对应的sel

 @param sel Sel
 @param class 类名
 @return 是否包含
 */
+ (BOOL)isContainSel:(SEL)sel inClass:(Class)class;


@end
