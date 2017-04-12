//
//  NSTimer+JMAddition.m
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "NSTimer+JMAddition.h"

@implementation NSTimer (JMAddition)
- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}
@end
