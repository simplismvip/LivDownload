//
//  NSTimer+JMAddition.h
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JMAddition)
- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;
@end
