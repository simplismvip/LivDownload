//
//  JMSignView.m
//  SignDemo
//
//  Created by JM Zhao on 2017/4/5.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMSignView.h"
#import "JMWriteView.h"
#import "JMGestureButton.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMSignView()
@property (nonatomic, weak) JMWriteView *view;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIView *backViewBtn;
@property (nonatomic, weak) UIButton *resign;
@property (nonatomic, weak) UIButton *save;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JMSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paintBoard_2"]];
//        [self addSubview:imageView];
//        self.imageView = imageView;
        
        self.backgroundColor = JMColor(207, 207, 207);
        
        JMWriteView *view = [[JMWriteView alloc] init];
        [self addSubview:view];
        self.view = view;
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = JMColor(90, 171, 225);
        [self addSubview:backView];
        self.backView = backView;
        
        UIView *backViewBtn = [[UIView alloc] init];
        backViewBtn.backgroundColor = JMColor(70, 70, 70);
        [self addSubview:backViewBtn];
        self.backViewBtn = backViewBtn;
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        button.backgroundColor = JMColor(167, 167, 167);
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [JMColor(167, 167, 167) CGColor];
        
        [button setTitle:NSLocalizedString(@"net.pictoshare.pageshare.urlhistoryview.button.download.cancel", "") forState:(UIControlStateNormal)];
        [button setTintColor:JMColor(167, 167, 167)];
        [button addTarget:self action:@selector(reSign:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        self.resign = button;
        
        UIButton *save = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [save setTitle:NSLocalizedString(@"net.pictoshare.pageshare.alert.determine.text", "") forState:(UIControlStateNormal)];
        [save setTintColor:JMColor(167, 167, 167)];
        save.layer.cornerRadius = 10;
        save.layer.masksToBounds = YES;
        save.layer.borderWidth = 0.5;
        save.layer.borderColor = [JMColor(167, 167, 167) CGColor];
//        save.backgroundColor = JMColor(167, 167, 167);
        [save addTarget:self action:@selector(save:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:save];
        self.save = save;
    }
    return self;
}

- (void)setPaintColor:(UIColor *)paintColor
{
    _paintColor = paintColor;
    self.view.linesColor = self.paintColor;
}

- (void)reSign:(UIButton *)sender
{
    [_view clear];
}

- (void)save:(UIButton *)sender
{
    if (self.signImage) {
        
        self.signImage([self compressOriginalImage:self.view.paintImage toSize:CGSizeMake(self.view.paintImage.size.width/2, self.view.paintImage.size.height/2)]);
        JMGestureButton *btn = (JMGestureButton *)self.superview;
        [btn rem_GestureBtn:btn];
    }
}

- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, 164, 104)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-38);
    _backView.frame = CGRectMake(0, CGRectGetMaxY(_view.frame), self.bounds.size.width, 3);
    _imageView.frame = self.bounds;
    _backViewBtn.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame), self.bounds.size.width, 40);
    _resign.frame = CGRectMake(self.bounds.size.width/2-80, CGRectGetMaxY(_backView.frame)+5, 60, 30);
    _save.frame = CGRectMake(self.bounds.size.width/2+20, CGRectGetMaxY(_backView.frame)+5, 60, 30);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
