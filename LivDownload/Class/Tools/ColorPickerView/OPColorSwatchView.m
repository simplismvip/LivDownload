//
//  OPColorSwatchView.m
//  ColorPicker
//
//  Created by JM Zhao on 16/6/24.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPColorSwatchView.h"
#import <QuartzCore/QuartzCore.h>

@implementation OPColorSwatchView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayers];
    }
    return self;
}

-(void)setupLayers {
    CALayer *layer = self.layer;
    UIColor *edgeColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [layer setBackgroundColor:self.color.CGColor];
    [layer setCornerRadius:7];
    [layer setBorderWidth:2.0f];
    [layer setBorderColor:edgeColor.CGColor];
}

-(void)setColor:(UIColor *)swatchColor {
    if (_color != swatchColor) {
        _color = [swatchColor copy];
        [self.layer setBackgroundColor:_color.CGColor];
    }
}
@end
