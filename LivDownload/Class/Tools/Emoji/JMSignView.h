//
//  JMSignView.h
//  SignDemo
//
//  Created by JM Zhao on 2017/4/5.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^signImageBlock)(UIImage *signImage);
@interface JMSignView : UIView
@property (nonatomic, copy) signImageBlock signImage;
@property (nonatomic, strong) UIColor *paintColor;
@end
