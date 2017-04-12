//
//  ColorPickerViewController.m
//  ColorPicker
//
//  Created by Fabián Cañas
//  Based on work by Gilly Dekel on 23/3/09
//  Copyright 2010-2014. All rights reserved.
//

#import "OPColorPickerView.h"
#import "OPColorSwatchView.h"
#import "OPBrightDarkGradView.h"
#import "JMGestureButton.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HMRandomColor HMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface OPColorPickerView () {
    
    CGFloat currentBrightness;
    CGFloat currentHue;
    CGFloat currentSaturation;
    CGFloat _width;
    CGPoint _point;
}

@property (readwrite, nonatomic, strong) UIView *brightnessBar;
@property (readwrite, nonatomic, strong) OPBrightDarkGradView *gradientView;

// 照片按钮
@property (readwrite, nonatomic, weak) UIImageView *hueSatImage;

// 选择颜色按钮
@property (readwrite, nonatomic, strong) UIView *crossHairs;

// 展示画笔宽度
@property (nonatomic, weak) UIView *sizeView;

// 颜色变化量
@property (readwrite, nonatomic, strong) OPColorSwatchView *swatch;

// 设置初始选中颜色位置
@property (readwrite, nonatomic, copy, nullable) UIColor *color;

// 选择按钮
@property (nonatomic, strong) UIButton *choose;

// 取消
@property (nonatomic, strong) UIButton *cancle;

// 透明度
@property (nonatomic, weak) UILabel *optionLabel;

// 宽度
@property (nonatomic, weak) UILabel *optionWhidth;

@end

static CGFloat _textWidth;
static CGFloat _widthValue;
static CGFloat _brigthValue;
static CGFloat _blackColor;
static UIColor *_lastColor;

//static BOOL _isFrst;

@implementation OPColorPickerView

+(void)fristColor:(UIColor *)color
{
    _lastColor = color;
    _textWidth = 3.0;
    _widthValue = 0.000000;
    _brigthValue = 1.0;
    _blackColor = 0.000000;
}

+ (instancetype)colorPickerWithColor:(UIColor *)color view:(UIView *)view delegate:(id<OPColorPickerViewDelegate>) delegate {
    
    JMGestureButton *gesture = [JMGestureButton creatGestureButton];
    OPColorPickerView *picker = [[OPColorPickerView alloc] init];
    picker.delegate = delegate;
    picker.layer.cornerRadius = 10;
    picker.layer.masksToBounds = YES;
    [gesture addSubview:picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (isPad) {
            
            make.centerX.centerY.equalTo(gesture);
            make.width.mas_equalTo(606);
            make.height.mas_equalTo(460);
            
        }else{
            
            make.width.equalTo(gesture.mas_width);
            make.height.equalTo(gesture.mas_height).multipliedBy(0.4);
            make.center.equalTo(gesture);
        }
    }];
    
    // 判断UIColor是否有值
    if (_lastColor != nil) {
        
        picker.color = _lastColor;
    }else{
        picker.color = [UIColor redColor];
    }
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = JMColor(215, 215, 215);
        
        // 添加子控件
        [self addsubViews];
        
        // 图片颜色深浅按钮
        [self addSubview:self.swatch];
        [self setColor:_color];
        [self updateGradientColor];
        [self updateCrosshairPosition];
        _swatch.color = _color;
    }
    return self;
}

// 添加子控件
- (void)addsubViews
{
    // 设置选择按钮
    UIButton *choose = [UIButton buttonWithType:(UIButtonTypeSystem)];
    choose.layer.cornerRadius = 5;
    choose.tintColor = [UIColor whiteColor];
    [choose setTitle:NSLocalizedString(@"net.pictoshare.pageshare.opcolorpickerview.choose","") forState:(UIControlStateNormal)];
    choose.backgroundColor = JMColor(130, 182, 227);
    [choose addTarget:self action:@selector(chooseSelectedColor) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:choose];
    self.choose = choose;
    
    // 设置取消按钮
    UIButton *cancle = [UIButton buttonWithType:(UIButtonTypeSystem)];
    cancle.layer.cornerRadius = 5;
    cancle.tintColor = [UIColor whiteColor];
    cancle.backgroundColor = JMColor(130, 182, 227);
    [cancle setTitle:NSLocalizedString(@"net.pictoshare.pageshare.document.navgationbar.button.alert.cancel", "")  forState:(UIControlStateNormal)];
    [cancle addTarget:self action:@selector(cancelColorSelection) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:cancle];
    self.cancle =cancle;
    
    // 图片image
    UIImage *image = [UIImage imageNamed:@"colormap"];
    UIImageView *hueSatImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:hueSatImage];
    self.hueSatImage = hueSatImage;
    
    // 选择颜色按钮
    UIView *crossHairs = [[UIView alloc] init];
    crossHairs.layer.cornerRadius = 19;
    crossHairs.layer.borderWidth = 2;
    crossHairs.layer.shadowColor = [UIColor blackColor].CGColor;
    crossHairs.layer.shadowOffset = CGSizeZero;
    crossHairs.layer.shadowRadius = 1;
    crossHairs.layer.shadowOpacity = 0.5;
    [self addSubview:crossHairs];
    self.crossHairs = crossHairs;
    
    NSArray *labelArr = @[@"宽度", @"透明度"];

#pragma amrk -- UIlabel
    // 透明度
    UILabel *optionLabel = [[UILabel alloc] init];
    optionLabel.backgroundColor = [UIColor redColor];
    optionLabel.font = [UIFont systemFontOfSize:14];
    optionLabel.textColor = [UIColor whiteColor];
    optionLabel.layer.cornerRadius = 5;
    optionLabel.layer.masksToBounds = YES;
    optionLabel.textAlignment = NSTextAlignmentCenter;
    optionLabel.backgroundColor = JMColor(130, 182, 227);
    optionLabel.text = labelArr[1];
    [self addSubview:optionLabel];
    self.optionLabel = optionLabel;
    
    //宽度
    UILabel *optionWhidth = [[UILabel alloc] init];
    optionWhidth.backgroundColor = [UIColor redColor];
    optionWhidth.font = [UIFont systemFontOfSize:14];
    optionWhidth.textColor = [UIColor whiteColor];
    optionWhidth.layer.cornerRadius = 5;
    optionWhidth.layer.masksToBounds = YES;
    optionWhidth.textAlignment = NSTextAlignmentCenter;
    optionWhidth.backgroundColor = JMColor(130, 182, 227);
    optionWhidth.text = labelArr[0];
    [self addSubview:optionWhidth];
    self.optionWhidth = optionWhidth;
    
#pragma amrk -- UISlider
    // 左右轨的图片
    UIImage *stetchLeftTrack= [UIImage imageNamed:@"prgbar_unread"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"prgbar_read"];
    UIImage *thumbImage = [UIImage imageNamed:@"prgbar_icon_changesize"];
    
    for (int i = 0; i < 2; i ++) {
        
        UISlider *textSlider=[[UISlider alloc] init];
        textSlider.tag = i*10;
        textSlider.backgroundColor = [UIColor clearColor];
        [textSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [textSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        [textSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [textSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        
        // 滑块拖动时的事件
        [textSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:textSlider];
    }
    
    // 显示颜色View
    self.swatch = [[OPColorSwatchView alloc] init];
    
    if (_textWidth == 0.000000) {
        _width = 2.0;
    }else{
       _width = _textWidth;
    }
    self.swatch.layer.cornerRadius = 10;
    
    // 灰度
    self.gradientView = [[OPBrightDarkGradView alloc] init];
    [self addSubview:self.gradientView];
    
    self.brightnessBar = [[UIView alloc] init];
    self.brightnessBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.brightnessBar];
    
    // 展示画笔宽度
    UIView *sizeView = [[UIView alloc] init];
    [self addSubview:sizeView];
    self.sizeView = sizeView;
    self.sizeView.backgroundColor = JMColor(130, 182, 227);
}

// 布局子View Frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 10.0f;
    CGFloat y = 10.0f;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat edge = 5.0;
    CGFloat btnH = (0.6*h-edge*5-2*y)/4;
    CGFloat btnW = 60;
    
    _choose.frame = CGRectMake(x, y, w*0.25, 1.5*btnH);
    _cancle.frame = CGRectMake(CGRectGetMaxX(_choose.frame)+edge, y, w*0.25, 1.5*btnH);
    _hueSatImage.frame = CGRectMake(x, CGRectGetMaxY(_cancle.frame)+edge, w*0.9, h*0.4+0.6*btnH);
    _crossHairs.frame = CGRectMake(150, 150, 15, 15);
    _gradientView.frame = CGRectMake(x, CGRectGetMaxY(_hueSatImage.frame)+edge, w*0.9, btnH*0.7);
    _brightnessBar.frame = CGRectMake(x, CGRectGetMaxY(_hueSatImage.frame)+edge, 10, btnH*0.7);
    _optionWhidth.frame = CGRectMake(x, CGRectGetMaxY(_brightnessBar.frame)+edge, btnW*1.08, btnH*0.7);
    _optionLabel.frame = CGRectMake(x, CGRectGetMaxY(_optionWhidth.frame)+edge, btnW*1.08, btnH*0.7);
    
    int i = 0;
    for (UIView *view1 in self.subviews) {
        
        if ([view1 isMemberOfClass:[UISlider class]]) {
         
            UISlider *view = (UISlider *)view1;
            
            if (i == 0) {
                
                view.frame = CGRectMake(CGRectGetMaxX(_optionWhidth.frame) +edge, _optionWhidth.center.y-10, w*0.9-btnW, 20);
                view.value = _widthValue;
                
            }else if (i == 1){
            
                view.frame = CGRectMake(CGRectGetMaxX(_optionLabel.frame) +edge, _optionLabel.center.y-10, w*0.9-btnW, 20);
                if (_brigthValue==0.000000) {view.value = 1.0;}else{view.value = _brigthValue;}
                
            }
            
            i ++;
        }
    }
    
    self.swatch.frame = CGRectMake(CGRectGetMaxX(_cancle.frame)+edge, CGRectGetMinY(_choose.frame), CGRectGetMaxX(_hueSatImage.frame)-CGRectGetMaxX(_cancle.frame)-edge, 1.5*btnH);
    
    self.sizeView.frame = CGRectMake(CGRectGetMaxX(_hueSatImage.frame)+20, CGRectGetMinY(_choose.frame), _width, CGRectGetMaxY(_hueSatImage.frame) - CGRectGetMinY(_choose.frame));
}

- (void)viewWillLayoutSubviews {
    [self updateCrosshairPosition];
}

#pragma mark - Color Manipulation
- (void)_setColor:(UIColor *)newColor {
    if (![_color isEqual:newColor]) {
        
        CGFloat brightness;
        [newColor getHue:NULL saturation:NULL brightness:&brightness alpha:NULL];
        CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(newColor.CGColor));
        
        if (colorSpaceModel==kCGColorSpaceModelMonochrome) {
            
            const CGFloat *c = CGColorGetComponents(newColor.CGColor);
            _color = [UIColor colorWithHue:0 saturation:0 brightness:c[0] alpha:1.0];
            
        } else {
            _color = [newColor copy];
        }
        
        _swatch.color = _color;
        // self.sizeView.backgroundColor = _color;
    }
}

- (void)setColor:(UIColor *)newColor {
    
    CGFloat hue, saturation;
    [newColor getHue:&hue saturation:&saturation brightness:NULL alpha:NULL];
    
    currentHue = hue;
    currentSaturation = saturation;
    [self _setColor:newColor];
    [self updateGradientColor];
    [self updateBrightnessPosition];
    [self updateCrosshairPosition];
}

- (void)updateBrightnessPosition {
    [_color getHue:NULL saturation:NULL brightness:&currentBrightness alpha:NULL];
    
    CGPoint brightnessPosition;
    brightnessPosition.x = (1.0-currentBrightness)*_gradientView.frame.size.width + _gradientView.frame.origin.x;
    brightnessPosition.y = _gradientView.center.y;
    _brightnessBar.center = brightnessPosition;
}

// 更新位置
- (void)updateCrosshairPosition {
    CGPoint hueSatPosition;
    
#pragma mark -- updateBrightnessPosition 移动到这里
    [_color getHue:NULL saturation:NULL brightness:&currentBrightness alpha:NULL];
    
    hueSatPosition.x = (currentHue*_hueSatImage.frame.size.width)+_hueSatImage.frame.origin.x;
    hueSatPosition.y = (1.0-currentSaturation)*_hueSatImage.frame.size.height+_hueSatImage.frame.origin.y;
    
    _crossHairs.center = hueSatPosition;
    [self updateGradientColor];
  
}

// 更新颜色
- (void)updateGradientColor {
    
    UIColor *gradientColor = [UIColor colorWithHue: currentHue saturation: currentSaturation brightness: 1.0 alpha:1.0];
    _crossHairs.layer.backgroundColor = gradientColor.CGColor;
    [_gradientView setColor:gradientColor];
}

// 更新颜色位置
- (void)updateHueSatWithMovement:(CGPoint) position {
    
    currentHue = (position.x-_hueSatImage.frame.origin.x)/_hueSatImage.frame.size.width;
    currentSaturation = 1.0 -  (position.y-_hueSatImage.frame.origin.y)/_hueSatImage.frame.size.height;
    
    UIColor *_tcolor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1.0];
    UIColor *gradientColor = [UIColor colorWithHue: currentHue saturation: currentSaturation brightness: 1.0 alpha:1.0];
    
    _crossHairs.layer.backgroundColor = gradientColor.CGColor;
    [self updateGradientColor];
    [self _setColor:_tcolor];
    _swatch.color = _color;
    
    if (_brigthValue==0.000000) {_brigthValue = 1.0;}
    [self changeSaturation:_brigthValue];
    // self.sizeView.backgroundColor = _color;
}

- (void)updateBrightnessWithMovement:(CGPoint) position {
    
    currentBrightness = 1.0 - ((position.x - _gradientView.frame.origin.x)/_gradientView.frame.size.width);
    
    UIColor *_tcolor = [UIColor colorWithHue:currentHue
                                  saturation:currentSaturation
                                  brightness:currentBrightness
                                       alpha:1.0];
    [self _setColor:_tcolor];
    _swatch.color = _color;
}

#pragma mark - Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        [self dispatchTouchEvent:[touch locationInView:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches){
        [self dispatchTouchEvent:[touch locationInView:self]];
    }
}

- (void)dispatchTouchEvent:(CGPoint)position {
    if (CGRectContainsPoint(_hueSatImage.frame,position)) {
        
        _crossHairs.center = position;
        [self updateHueSatWithMovement:position];
        
    }else if (CGRectContainsPoint(_gradientView.frame, position)) {
        _brightnessBar.center = CGPointMake(position.x, _gradientView.center.y);
        [self updateBrightnessWithMovement:position];
    }
}

#pragma mark - 选择颜色回调
- (void)chooseSelectedColor {
    
    if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didSelectColor:selectWidth:)]) {
        
        [_delegate colorPickerViewController:self didSelectColor:self.color selectWidth:_width];
        _lastColor = self.color;
    }
}

// 取消颜色回调
- (void)cancelColorSelection {
    
    // 移除自身
    if ([self.delegate respondsToSelector:@selector(colorPickerViewControllerDidCancel:)]) {
        
        [_delegate colorPickerViewControllerDidCancel:self];  
    }
}

// 颜色 : hue 色调 saturation 饱和度 brightness 亮度
- (void)sliderAction:(UISlider *)sender
{
    switch (sender.tag) {
        case 0:
            
            _width = sender.value*27 +3;
            _textWidth = _width;
            _widthValue = sender.value;
            self.sizeView.bounds = CGRectMake(self.sizeView.bounds.origin.x, self.sizeView.bounds.origin.y, _width, self.sizeView.bounds.size.height);
            // [self layoutIfNeeded];
            break;
            
        case 10:
            
            _brigthValue = sender.value+0.0001;
            [self changeSaturation:sender.value];
            break;
            
        default:
            break;
    }
}

// 透明度
- (void)changeSaturation:(CGFloat)value {
    
//    currentSaturation = 1-value;
    UIColor *_tcolor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:value];
    _crossHairs.layer.backgroundColor = _tcolor.CGColor;
    [self _setColor:_tcolor];
    _swatch.color = _color;
}

// 亮度
- (void)changeBrightness:(CGFloat)value {
    
    currentBrightness = 1-value;
    UIColor *_tcolor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1.0];
    _crossHairs.layer.backgroundColor = _tcolor.CGColor;
    [self _setColor:_tcolor];
    _swatch.color = _color;
}

/*
// 饱和度
- (void)changeHue:(CGFloat)value {
    
    currentHue = 1-value;
    UIColor *_tcolor = [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1.0];
    _crossHairs.layer.backgroundColor = _tcolor.CGColor;
    [self _setColor:_tcolor];
    _swatch.color = _color;
}
*/
@end
