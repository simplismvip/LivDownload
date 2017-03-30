//
//  JMGestureButton.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/19.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMGestureButton.h"
#import "UIView+Extension.h"

@implementation JMGestureButton

+ (JMGestureButton *)creatGestureButton
{
    JMGestureButton *gesture = [self buttonWithType:(UIButtonTypeSystem)];
    gesture.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    gesture.backgroundColor = [UIColor clearColor];
    [gesture addTarget:gesture action:@selector(rem_GestureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:gesture];
    return gesture;
}

- (void)rem_GestureBtn:(JMGestureButton *)sender
{
    for (UIView *v in self.subviews) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            v.frame = CGRectMake(v.x, self.height, v.width, v.height);
            
        } completion:^(BOOL finished) {
            
            [sender removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(didRemove)]) {[self.delegate didRemove];}
        }];
    }
}

@end
