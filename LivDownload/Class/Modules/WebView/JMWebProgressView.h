//
//  JMWebProgressView.h
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface JMWebProgressView : CAShapeLayer
- (void)finishedLoad;
- (void)startLoad;
- (void)closeTimer;
@end
