//
//  JMSearchHistoryCell.h
//  YaoYao
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMSearchHistoryCellDelegate <NSObject>
- (void)deleteCell:(NSIndexPath *)indexPath;
@end

@interface JMSearchHistoryCell : UITableViewCell
@property (nonatomic, weak) id <JMSearchHistoryCellDelegate>delegate;
- (void)setImage:(NSString *)image btnImage:(NSString *)btnImage content:(NSString *)content;
@end
