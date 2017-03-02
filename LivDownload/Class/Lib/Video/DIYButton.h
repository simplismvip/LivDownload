//
//  DIYButton.h
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYButton : UIButton

// 添加readonly使外界只能改变它的属性，不能替换
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
// 点击button改变图片
@property (nonatomic, strong, readonly) UIImageView *selectIconImageView;

@end
