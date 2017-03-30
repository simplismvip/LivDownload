//
//  DownloadCompleteCell.h
//  LivDownload
//
//  Created by JM Zhao on 2017/2/23.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownloadModel;
@interface DownloadCompleteCell : UITableViewCell
+ (instancetype)initWithDownloadCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(DownloadModel *)model;
@end
