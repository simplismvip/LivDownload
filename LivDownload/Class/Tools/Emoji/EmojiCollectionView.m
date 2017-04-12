//
//  EmojiCollectionView.m
//  EmojiViewTest
//
//  Created by Mac on 16/6/15.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "EmojiCollectionView.h"
#import "JMGestureButton.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface EmojiCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _edgeLeft;
    CGFloat _edgeRight;
    CGFloat _edgeMid;
    CGFloat _widthImage;
    CGFloat _heightImage;
}
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UILabel *headLabel;
@end

@implementation EmojiCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [self getEmojiArrayByString:nil];
        
        UIView *view     = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        [self addSubview:view];
        self.view = view;

        UILabel *headLabel   = [[UILabel alloc] init];
        headLabel.text       = NSLocalizedString(@"net.pictoshare.pageshare.emojicollectionview.icon.title", "");
        headLabel.textColor  = [UIColor whiteColor];
        headLabel.font       = [UIFont systemFontOfSize:18];
        [view addSubview:headLabel];
        self.headLabel = headLabel;
        
        self.backgroundColor = JMColor(242, 243, 245);
    }
    return self;
}

// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell   = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            [imageView removeFromSuperview];
        }
    }
    
    NSMutableDictionary *dic = self.dataArr[indexPath.row];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dic.allKeys.lastObject]];
    [cell.contentView addSubview:imageView];
    return cell;
}

// 选中cell触发方法
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.dataArr[indexPath.row];
    NSNumber *index = dic.allValues.lastObject;
    
    if ([self.delegate respondsToSelector:@selector(emojiSelected:)]) {
        
        // 移除自身
        [self.delegate emojiSelected:index.integerValue];
    }
    
    return YES;
}

#pragma mark -- 初始化CollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = JMColor(242, 243, 245);
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = (44.0/736.0)*[UIScreen mainScreen].bounds.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    self.flowLayout.itemSize = CGSizeMake(w*0.14, w*0.14);
    self.collectionView.frame = CGRectMake(15, h+8, w-30, hei - h-8);
    self.view.frame = CGRectMake(0, 0, w, h);
    self.headLabel.frame = CGRectMake(10, 0, w*0.5, h);
}

#pragma mark -- 返回过滤过的数组
- (NSArray *)getEmojiArrayByString:(NSString *)String
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i< Constants.EMOJI.count;i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ( ![Constants.EMOJI[i] isEqualToString:@""] ) {
            NSNumber *num = [NSNumber numberWithInteger:i];
            [dic setValue: num forKey:Constants.EMOJI[i]];
            [arr addObject:dic];
        }
    }
    return [arr copy];
}

#pragma mark -- 初始化View
+ (void)initWithViewWithDelegate:(id)delegate
{
    EmojiCollectionView *viewC = [[EmojiCollectionView alloc] init];
    [viewC createCollectionView];
    viewC.delegate = delegate;
    
    JMGestureButton *gesture = [JMGestureButton creatGestureButton];
    [gesture addSubview:viewC];
    
    [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (isPad) {
            
            make.centerX.centerY.equalTo(gesture);
            make.width.mas_equalTo(606);
            make.height.mas_equalTo(460);
            
        }else{
            
            make.left.right.equalTo(@0);
            make.centerX.centerY.equalTo(gesture);
            make.height.mas_equalTo(gesture).multipliedBy(0.42);
        }
    }];
}
@end
