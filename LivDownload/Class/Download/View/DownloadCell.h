//
//  DownloadCell.h
//  DownloadTest
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DownloadModel;
@protocol DownloadCellDelegate <NSObject>

- (void)editerCell;
- (void)startDownload:(NSIndexPath *)index isStart:(BOOL)isStart;
// - (void)deleteCell:(NSIndexPath *)indexPath;
@end

@interface DownloadCell : UITableViewCell

@property (nonatomic, weak) UILabel *precent;
@property (nonatomic, weak) UILabel *netSpeed;
@property (nonatomic, weak) id<DownloadCellDelegate> delegate;
+ (instancetype)initWithCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(DownloadModel *)model;
- (void)reloadCellData:(DownloadModel *)datas;


/*
 self.deleteBtn.frame = CGRectMake(self.width-self.height*2, CGRectGetMinY(_header.frame), self.height-10, self.height-10);
 self.playAndPause.frame = CGRectMake(CGRectGetMaxX(_deleteBtn.frame)+10, CGRectGetMinY(_header.frame), self.height-10, self.height-10);
 */
@end
