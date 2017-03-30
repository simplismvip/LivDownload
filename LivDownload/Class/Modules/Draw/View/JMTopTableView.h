//
//  JMTopTableView.h
//  TopBarFrame
//
//  Created by JM Zhao on 2017/3/28.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JMColorType=0,
    JMClearType,
    JMLayerType,
    JMEllipseType,
    JMEraserType,
    JMSaveType,
    JMMediaType,
    JMDismissType,
    JMMoreType
} JMBottomType;

@protocol JMTopTableViewDelegate <NSObject>
- (void)topTableView:(JMBottomType)bottomType didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)topTableViewDisSelectSection:(NSInteger)section;
@end
@interface JMTopTableView : UIView
@property (nonatomic, weak) id <JMTopTableViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
