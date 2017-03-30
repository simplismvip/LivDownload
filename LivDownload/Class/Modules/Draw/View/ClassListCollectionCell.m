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
@property (nonatomic, strong) UILabel *classTime;
@property (nonatomic, strong) UILabel *memberCount;
@property (nonatomic, strong) UIButton *countBtn;

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
        _className.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_className];
        
        _classTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _classTime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_classTime];
        
        _memberCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _memberCount.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_memberCount];
        
        _countBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_countBtn addTarget:self action:@selector(showRoomNumber:event:) forControlEvents:(UIControlEventTouchUpInside)];
        _countBtn.frame = CGRectZero;
        [self.contentView addSubview:_countBtn];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPress];
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

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        
        _classImage.frame = CGRectMake(10, 5, self.width-20, self.height-57);
        _className.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_classImage.frame), CGRectGetWidth(_classImage.frame), 16);
        _classTime.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_className.frame), CGRectGetWidth(_classImage.frame), 16);
        _countBtn.frame = CGRectMake(CGRectGetMinX(_classTime.frame), CGRectGetMaxY(_classTime.frame), CGRectGetWidth(_classTime.frame), 20);
        _memberCount.frame = CGRectMake(CGRectGetMinX(_classTime.frame), CGRectGetMaxY(_classTime.frame), CGRectGetWidth(_classTime.frame), 20);
        _className.font = [UIFont boldSystemFontOfSize:11.0];
        _classTime.font = [UIFont systemFontOfSize:11.0];
        _memberCount.font = [UIFont systemFontOfSize:11.0];
        
    } else {
        _classImage.frame = CGRectMake(5, 5, self.height-10, self.height-10);
        _className.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, self.height*0.2, self.width-self.height, self.height*0.2);
        _classTime.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, CGRectGetMaxY(_className.frame), self.width-self.height, self.height*0.2);
        _countBtn.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, CGRectGetMaxY(_classTime.frame), self.width-self.height, self.height*0.3);
        _memberCount.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, CGRectGetMaxY(_classTime.frame), self.width-self.height, self.height*0.3);
        _className.font = [UIFont boldSystemFontOfSize:14.0];
        _classTime.font = [UIFont systemFontOfSize:14.0];
        _memberCount.font = [UIFont systemFontOfSize:14.0];
    }
}

- (void)setModel:(ClassModel *)model
{
    _model = model;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.classImage] placeholderImage:[UIImage imageNamed:model.classImage]];
    _className.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"net.pictoshare.pageshare.classviewcontroller.classMember.text", ""), model.className];
    _classTime.text = model.classTime;
    _memberCount.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"net.pictoshare.pageshare.classviewcontroller.classCount.text", ""), model.classCount];
}

@end
