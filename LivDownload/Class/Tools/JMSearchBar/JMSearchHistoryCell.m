//
//  JMSearchHistoryCell.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMSearchHistoryCell.h"
#import "UIView+Extension.h"

@interface JMSearchHistoryCell()
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UIButton *deleteB;
@property (nonatomic, weak) UILabel *contentL;
@end

@implementation JMSearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        [self addSubview:leftImage];
        self.imageV = leftImage;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn addTarget:self action:@selector(deleteHistory:event:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        self.deleteB = btn;
        
        UILabel *content = [[UILabel alloc] init];
        content.textColor = [UIColor grayColor];
        content.font = [UIFont systemFontOfSize:14];
        [self addSubview:content];
        self.contentL = content;
    }
    
    return self;
}

- (void)deleteHistory:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
        
        [self.delegate deleteCell:[self getIndexPathEvent:event]];
    }
}

- (NSIndexPath *)getIndexPathEvent:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    UITableView *table = [self myTableView];
    CGPoint currentTouchPosition = [touch locationInView:table];
    return [table indexPathForRowAtPoint:currentTouchPosition];
}

- (UITableView*)myTableView
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            
            return (UITableView*)nextResponder;
        }
    }
    return nil;
}

- (void)setImage:(NSString *)image btnImage:(NSString *)btnImage content:(NSString *)content
{
    _imageV.image = [UIImage imageNamed:image];
    _contentL.text = content;
    [_deleteB setImage:[UIImage imageNamed:btnImage] forState:(UIControlStateNormal)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageV.frame = CGRectMake(10, 12, 20, 20);
    _contentL.frame = CGRectMake(CGRectGetMaxX(_imageV.frame)+10, 5, self.width-78, 34);
    _deleteB.frame = CGRectMake(self.width-44, 5, 34, 34);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
