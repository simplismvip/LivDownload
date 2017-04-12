//
//  JMBaseWebViewController.h
//  LivDownload
//
//  Created by JM Zhao on 2017/4/12.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseWebViewController : UIViewController
@property (nonatomic, copy) NSString *urlString;

// 重新加载数据
- (void)reload;

// 停止加载数据
- (void)stopLoading;

// 返回上一级
- (void)goBack;

// 跳转下一级
- (void)goForward;
@end
