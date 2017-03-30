//
//  UIAlertController+JMAlertController.h
//  PageShare
//
//  Created by JM Zhao on 16/7/1.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (JMAlertController)
/**
 *  带输入框弹窗
 *
 *  @param title       输入标题
 *  @param message     输入消息
 *  @param actionTitles    action的title
 *  @param preferredStyle  弹框样式
 *  @param placeholders   textField placeholders, 数组形式输入
 *  @param confirmHandel  确定回调方法
 *  @param canelHander    取消回调方法
 *
 *  @return 返回一个弹窗控制器, 使用时推出就好
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSArray<NSString *> *)actionTitles preferredStyle:(UIAlertControllerStyle)preferredStyle textFilfPlaceHolders:(NSArray<NSString *> *) placeholders  confirmHandel:(void(^)(NSArray <NSString *>* alterTextFs)) confirmHandel cancelHandel:(void(^)()) canelHander;

/**
 *  不带输入框弹窗
 *
 *  @param title       输入标题
 *  @param message     输入消息
 *  @param actionTitles    action的title
 *  @param preferredStyle  弹框样式
 *  @param confirmHandel  确定回调方法
 *  @param canelHander    取消回调方法
 *
 *  @return 返回一个弹窗控制器, 使用时推出就好
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSArray<NSString *> *)actionTitles preferredStyle:(UIAlertControllerStyle)preferredStyle cloudcenter:(void(^)())cloudcenter friendshare:(void(^)())friendshare emailshare:(void(^)())emailshare;

/**
 *  只弹出一个提醒框
 *
 *  @param title          弹出提醒文字
 *  @param preferredStyle     弹出样式
 *  @param confirmHandel  点击回调
 *
 *  @return 返回控制器
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title preferredStyle:(UIAlertControllerStyle)preferredStyle confirmHandel:(void(^)()) confirmHandel;
@end
