//
//  ClassController.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ClassController.h"

#import "ClassModel.h"
#import "ClassListCollectionCell.h"
#import "NSObject+JMProperty.h"
#import "ClassCollectionViewFlowLayout.h"
#import "ClassCollectionReusableView.h"
#import "UIView+Extension.h"

#import "UIAlertController+JMAlertController.h"
#import "JMGestureButton.h"

#import "UserDefaultTools.h"

@interface ClassController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ClassListCollectionCellDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) ClassCollectionViewFlowLayout *collectionLayout;
@end

@implementation ClassController
static NSString *const collectionID = @"cell";

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collection];
}

- (void)switchGrid
{
    BOOL _isGrid = ![UserDefaultTools readBoolByKey:self.key];
    if ([UserDefaultTools setBool:_isGrid forKey:self.key]) {
        
        [self.collection reloadData];
    }
}

- (void)reloadData
{
    [self.collection reloadData];
}

- (UICollectionView *)collection
{
    if (!_collection)
    {
        self.collectionLayout = [[ClassCollectionViewFlowLayout alloc] init];
        self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-94) collectionViewLayout:_collectionLayout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.alwaysBounceVertical = NO;
        [self.view addSubview:_collection];
        
        // 注册
        [_collection registerClass:[ClassListCollectionCell class] forCellWithReuseIdentifier:collectionID];
    }
    return _collection;
}


#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.isGrid = [UserDefaultTools readBoolByKey:self.key];
    cell.model = self.dataSource[indexPath.row];
    cell.collection = collectionView;
    cell.delegate = self;
    return cell;
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//// 点击高亮
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        
        [_collection performBatchUpdates:^{
            
            [_dataSource removeObjectAtIndex:indexPath.row];
            [_collection deleteItemsAtIndexPaths:@[indexPath]];
            
        } completion:nil];
        
    }else if([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

// 动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserDefaultTools readBoolByKey:self.key]) {
        
        NSInteger rows = (self.view.width-10*4)/3;
        return CGSizeMake(rows, rows+40);
        
    } else {
        return CGSizeMake(self.view.width-20, (self.view.width-6)/4+20);
    }
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
