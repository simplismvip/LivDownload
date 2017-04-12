//
//  EmojiCollectionView.h
//  EmojiViewTest
//
//  Created by Mac on 16/6/15.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiCollectionViewDelegate <NSObject>

// 选中item相应事件
- (void)emojiSelected:(NSInteger)index;
@end

@interface EmojiCollectionView : UIView

@property (nonatomic, weak) id <EmojiCollectionViewDelegate>delegate;
/**
 *  初始化View设置代理并且添加到当前控制器, EmojiCollectionView的位置默认位于superView中央
 *
 *  @param delegate 遵循代理
 */
+ (void)initWithViewWithDelegate:(id)delegate;

@end
