//
//  JMTextView.m
//  LivDownload
//
//  Created by JM Zhao on 2017/4/10.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "JMTextView.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMTextView()
@property (nonatomic, weak) UIButton *btn;
@end

@implementation JMTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [JMColor(100, 100, 100) colorWithAlphaComponent:0];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setImage:[UIImage imageNamed:@"more_32"] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(voiceNotePlay:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        self.btn = btn;
        
        // UIPanGestureRecognizer
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGerture:)];
        [self addGestureRecognizer:panGesture];
        
    }
    return self;
}

# pragma -- 平移手势
- (void)handlePanGerture:(UIPanGestureRecognizer *)pangGerture{
    
    CGPoint point = [pangGerture translationInView:pangGerture.view];
    pangGerture.view.transform = CGAffineTransformTranslate(pangGerture.view.transform, point.x, point.y);
    [pangGerture setTranslation:CGPointZero inView:pangGerture.view];
}

- (void)voiceNotePlay:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(playVoiceNote:)]) {
        
        [self.delegate playVoiceNote:0];
    }
}

- (void)layoutSubviews
{
    _btn.frame = self.bounds;
}


@end
