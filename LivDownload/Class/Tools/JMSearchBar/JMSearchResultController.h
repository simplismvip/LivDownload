//
//  JMSearchResultController.h
//  LivDownload
//
//  Created by JM Zhao on 2017/3/31.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSearchResultController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, weak) UIViewController *mainSearchController;
@end
