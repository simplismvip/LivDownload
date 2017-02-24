//
//  MineModel.h
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MineModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger accessoryType;
@property (nonatomic, strong) UISwitch *switchAction;
@end
