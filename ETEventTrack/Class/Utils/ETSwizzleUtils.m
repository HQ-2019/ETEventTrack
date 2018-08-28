//
//  FFSwizzleUtils.m
//  ETEventTrack
//
//  Created by huangqun on 2018/3/26.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "ETSwizzleUtils.h"
#import <objc/runtime.h>

@implementation ETSwizzleUtils

/**
 指定类和指定函数进行swizzle
 
 @param objClass 操作类对象
 @param originalSelector 原函数
 @param swizzledSelector 进行swizzle的函数
 */
+ (void)swizzlingInClass:(Class)objClass originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(objClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(objClass, swizzledSelector);
    
    BOOL addMethod = class_addMethod(objClass,
                                     originalSelector,
                                     method_getImplementation(swizzledMethod),
                                     method_getTypeEncoding(swizzledMethod));
    
    if (addMethod) {
        class_replaceMethod(objClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 指定类和指定函数进行swizzle
 
 @param originalClass 操作类对象
 @param originSelector 原函数
 @param swizzledClass 交换的操作对象原函数
 @param swizzledSelector 进行swizzle的函数
 @param error error
 */
+ (void)swizzlingWithOriginClass:(Class)originalClass originSel:(SEL)originSelector swizzleClass:(Class)swizzledClass swizzleSelector:(SEL)swizzledSelector error:(NSError **)error {
    Method originalMethod = class_getInstanceMethod(originalClass, originSelector);
    if (!originalMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(originSelector), NSStringFromClass([self class]));
    }
    
    Method swizzleMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    if (!swizzleMethod) {
        NSLog(@"swizzleMethod method %@ not found for class %@", NSStringFromSelector(swizzledSelector), NSStringFromClass([self class]));
        
    }
    
    IMP replacedMethodIMP = method_getImplementation(swizzleMethod);
    
    BOOL addMethod = class_addMethod(originalClass, swizzledSelector, replacedMethodIMP, "v@:@@");
    
    //    BOOL addMethod = class_addMethod(originalClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (addMethod) {
        Method newMethod = class_getInstanceMethod(originalClass, swizzledSelector);
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

/**
 类里是否包含对应的sel
 
 @param sel Sel
 @param class 类名
 @return 是否包含
 */
+ (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

@end
