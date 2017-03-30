//
//  ClassController.h
//  ClassItem
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassController : UIViewController
@property (nonatomic, copy) NSString *key;
- (void)switchGrid;
- (void)reloadData;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
