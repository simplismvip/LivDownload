//
//  ToolBarStatusDelegate.h
//  LivDownload
//
//  Created by cheny on 2017/3/1.
//  Copyright © 2017年 yijia. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef ToolBarStatusDelegate_h
#define ToolBarStatusDelegate_h

@protocol ToolBarStatusDelegate <NSObject>
- (BOOL) isDrawingEnabled;
- (BOOL) isEraseEnabled;

@end

#endif /* ToolBarStatusDelegate_h */
