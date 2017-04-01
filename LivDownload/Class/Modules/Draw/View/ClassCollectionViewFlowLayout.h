//
//  ClassCollectionViewFlowLayout.h
//  ClassItem
//
//  Created by JM Zhao on 2017/3/3.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassCollectionViewFlowLayoutDelegate <NSObject>

/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

@end

@interface ClassCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, assign) id<ClassCollectionViewFlowLayoutDelegate> delegate;
@end
