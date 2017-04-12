//
//  ColorPickerViewController.m
//  ColorPicker
//
//  Created by Fabián Cañas
//  Based on work by Gilly Dekel on 23/3/09
//  Copyright 2010-2014. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OPColorPickerView, FCColorSwatchView;
@protocol OPColorPickerViewDelegate <NSObject>
/**
 *  初始化颜色控制器
 *
 *  @param colorPicker 颜色控制器
 *  @param color       返回选择好的颜色颜色
 *  @param width       返回画笔的宽度
 */
- (void)colorPickerViewController:(OPColorPickerView *)colorPicker didSelectColor:(UIColor *)color selectWidth:(CGFloat)width;
/**
 *  取消颜色选择
 *
 *  @param colorPicker 颜色选择控制器
 */
@optional
- (void)colorPickerViewControllerDidCancel:(OPColorPickerView *)colorPicker;

@end

@interface OPColorPickerView : UIView
/**
 *  初始化颜色控制器并且添加代理
 *
 *  @param color  设置初始颜色
 *  @param delegate 设置代理
 *
 *  @return 返回初始化的颜色控制器
 */
+ (instancetype)colorPickerWithColor:(UIColor *)color view:(UIView *)view delegate:(id<OPColorPickerViewDelegate>) delegate;

@property (nonatomic, weak, nullable) id<OPColorPickerViewDelegate> delegate;

+ (void)fristColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

