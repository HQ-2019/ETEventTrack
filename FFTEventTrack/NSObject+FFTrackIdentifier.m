//
//  NSObject+FFTrackIdentifier.m
//  FFTwoBaboons
//
//  Created by huangqun on 2018/3/27.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "NSObject+FFTrackIdentifier.h"

static void *const KEventId = (void *) &KEventId;
static void *const KViewAppearTime = (void *) &KViewAppearTime;
static void *const KExpendData = (void *) &KExpendData;

@implementation NSObject (FFTrackIdentifier)

- (void)setEventId:(NSString *)eventId {
    objc_setAssociatedObject(self, KEventId, eventId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)eventId {
    return objc_getAssociatedObject(self, KEventId);
}

- (void)setViewAppearTime:(NSString *)viewAppearTime {
    objc_setAssociatedObject(self, KViewAppearTime, viewAppearTime, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)viewAppearTime {
    return objc_getAssociatedObject(self, KViewAppearTime);
}

- (void)setExpendData:(NSDictionary *)expendData {
    objc_setAssociatedObject(self, KExpendData, expendData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)expendData {
    return objc_getAssociatedObject(self, KExpendData);
}

- (void)configInfoData:(id)obj {
    if (nil == obj) {
        return;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        self.expendData = obj;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        if (count == 0) {
            [dict setObject:obj forKey:@"object_key"];
            if (dict) {
                self.expendData = dict;
            }
            return;
        }
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            if (key.length > 0 &&
                [obj valueForKey:key]) {
                [dict setObject:[obj valueForKey:key] forKey:key];
            }
        }
        free(properties);
        if (dict) {
            self.expendData = dict;
        }
    }
}


@end
