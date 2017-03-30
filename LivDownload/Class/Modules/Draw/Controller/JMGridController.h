//
//  JMGridController.h
//  LivDownload
//
//  Created by JM Zhao on 2017/3/30.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMGridController : UIViewController
- (void)switchGrid;
- (void)reloadData;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
