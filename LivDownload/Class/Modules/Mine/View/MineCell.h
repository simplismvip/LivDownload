//
//  MineCell.h
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineModel;
@interface MineCell : UITableViewCell
+ (instancetype)setCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath model:(MineModel *)model;
@end
