//
//  JMSearchView.m
//  LivDownload
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMSearchView.h"
#import "UIView+Extension.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMSearchView()
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *midBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@end

@implementation JMSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"最近搜索";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
        
//        UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [leftBtn setTitle:@"课号" forState:(UIControlStateNormal)];
//        [leftBtn setTintColor:JMColor(90, 200, 93)];
//        [self addSubview:leftBtn];
//        
//        UIButton *midBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [midBtn setTitle:@"房间" forState:(UIControlStateNormal)];
//        [midBtn setTintColor:JMColor(90, 200, 93)];
//        [self addSubview:midBtn];
//        
//        UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [rightBtn setTitle:@"历史" forState:(UIControlStateNormal)];
//        [rightBtn setTintColor:JMColor(90, 200, 93)];
//        [self addSubview:rightBtn];
//        
        self.label = label;
//        self.leftBtn = leftBtn;
//        self.midBtn = midBtn;
//        self.rightBtn = rightBtn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 0, self.width, self.height);
    
//    _leftBtn.frame = CGRectMake(0, CGRectGetMaxY(_label.frame), self.width/3, self.height*0.6);
//    _midBtn.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame), CGRectGetMaxY(_label.frame), self.width/3, self.height*0.6);
//    _rightBtn.frame = CGRectMake(CGRectGetMaxX(_midBtn.frame), CGRectGetMaxY(_label.frame), self.width/3, self.height*0.6);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
