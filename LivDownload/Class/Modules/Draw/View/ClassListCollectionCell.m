//
//  ClassListCollectionCell.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ClassListCollectionCell.h"
#import "ClassModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ClassListCollectionCell ()

@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UILabel *className;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation ClassListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        _classImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _classImage.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_classImage];
        
        _className = [[UILabel alloc] initWithFrame:CGRectZero];
        _className.numberOfLines = 0;
        _className.textColor = JMColor(55, 55, 55);
        // _className.backgroundColor = [UIColor grayColor];
        _className.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_className];
        
        _countBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_countBtn addTarget:self action:@selector(showRoomNumber:event:) forControlEvents:(UIControlEventTouchUpInside)];
        _countBtn.frame = CGRectZero;
        [self.contentView addSubview:_countBtn];
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteByIndexPath:event:) forControlEvents:(UIControlEventTouchUpInside)];
        _deleteBtn.frame = CGRectZero;
        [_deleteBtn setImage:[UIImage imageNamed:@"collectionDelete"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_deleteBtn];
    }
    
    return self;
}

- (void)showRoomNumber:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(showRoomMembers:currentPoint:)]) {
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        [self.delegate showRoomMembers:indexpath currentPoint:currentTouchPosition];
    }
}

- (void)deleteByIndexPath:(UIButton *)sender event:(id)event
{
    if ([self.delegate respondsToSelector:@selector(deleteByIndexPath:)]) {
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:_collection];
        NSIndexPath *indexpath = [_collection indexPathForItemAtPoint:currentTouchPosition];
        [self.delegate deleteByIndexPath:indexpath];
    }
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        
        _classImage.frame = CGRectMake(0, 0, self.width, self.height*0.8);
        _deleteBtn.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMinY(_classImage.frame), 30, 30);
        _className.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_classImage.frame), CGRectGetWidth(_classImage.frame), self.height*0.2);
        _countBtn.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_classImage.frame), CGRectGetWidth(_classImage.frame), self.height*0.2);
        _className.font = [UIFont boldSystemFontOfSize:11.0];
        _className.textAlignment = NSTextAlignmentCenter;
        
    } else {
        
        _classImage.frame = CGRectMake(0, 0, self.height, self.height);
        _deleteBtn.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMinY(_classImage.frame), 30, 30);
        _className.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, CGRectGetMinY(_classImage.frame), self.width-self.height-10, self.height);
        _countBtn.frame = CGRectMake(0, 0, 0, 0);
        _className.font = [UIFont boldSystemFontOfSize:14.0];
        _className.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setModel:(ClassModel *)model
{
    _model = model;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.classImage] placeholderImage:[UIImage imageNamed:model.classImage]];
    _className.text = [NSString stringWithFormat:@"%@", model.className];
}

#pragma mark - 是否处于编辑状态

- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        _deleteBtn.hidden = NO;
        
    } else {
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
        _deleteBtn.hidden = YES;
    }
}


@end
