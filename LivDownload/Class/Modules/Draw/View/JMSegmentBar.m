//
//  JMSegmentBar.m
//  ContainerView
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMSegmentBar.h"
#import "UIView+Extension.h"

#define baseTag 200
#define kadge 50
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMSegmentBar()
@property (nonatomic, strong) UIView *IineView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation JMSegmentBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = JMColor(247, 247, 247);
        scrollView.autoresizesSubviews = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 1)];
        backView.backgroundColor = JMColor(227, 227, 227);
        [self addSubview:backView];
        
        [backView addSubview:self.IineView];
        
    }
    return self;
}

#pragma mark -- setter
- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    for (int i = 0; i < _items.count; i ++) {
        
        UIViewController *vc = _items[i];
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.tag = baseTag+i;
        [button setTitle:vc.title forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(senmentControllerAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        [self.btnArray addObject:button];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if ([self.delegate respondsToSelector:@selector(changeController:)]) {
        
        [self.delegate changeController:selectIndex];
        [self didSelectItem:selectIndex];
    }
}

#pragma mark -- JMSegmentBarDelegate
- (void)senmentControllerAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(changeController:)]) {
        
        NSInteger index = sender.tag - baseTag;
        [self.delegate changeController:index];
        [self didSelectItem:index];
        self.selectIndex = index;
    }
}

- (void)didSelectItem:(NSInteger)selectIndex
{
    for (int i = 0; i < _btnArray.count; i ++) {
        
        if (selectIndex == i) {
            
            UIButton *btn = _btnArray[i];
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            [btn setTitleColor:JMColor(100, 163, 226) forState:(UIControlStateNormal)];
        }else{
            
            UIButton *btn = _btnArray[i];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
    }
}

- (void)scrollToRate:(CGFloat)rate
{
    UIButton *btn = _btnArray.firstObject;
    float x = rate*(CGRectGetWidth(btn.frame) / self.width)+kadge*(_selectIndex+1);
    [self.IineView setFrame:CGRectMake(x, self.IineView.y, self.IineView.width, self.IineView.height)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.btnArray.count;
    CGFloat width = (self.width-(count+1)*kadge)/count;
    CGFloat height = self.height;
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(kadge+(width+kadge)*i, 0, width, height-1);
    }
    
    _scrollView.frame = self.bounds;
    _IineView.frame = CGRectMake(kadge, -1, width, 2);
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {self.btnArray = [NSMutableArray array];}
    return _btnArray;
}

- (UIView *)IineView
{
    if (!_IineView) {
    
        self.IineView = [[UIView alloc] init];
        _IineView.backgroundColor = JMColor(100, 163, 226);
        [self addSubview:_IineView];
    }
    
    return _IineView;
}
@end
