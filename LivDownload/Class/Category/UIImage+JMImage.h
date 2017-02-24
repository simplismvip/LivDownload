//
//  UIImage+JMImage.h
//  Sina-微博
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JMImage)

/**
 *  旋转
 *
 *  @param degrees 需要旋转的视图
 *
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/**
 *  创建一个内容可拉伸，而边角不拉伸的图片
 *
 *  @param imageName 需要拉伸的视图
 *
 */
+ (UIImage *)imageWithStretchableName:(NSString *)imageName;
/**
 *  无渲染模式
 *
 *  @param name 原始模式渲染
 *
 */
+ (UIImage *)imageWithRenderingName:(NSString *)name;
/**
 * 忽略图片颜色, 使用tint渲染
 *
 *  @param name 原始模式渲染
 *
 */
+ (UIImage *)imageWithTemplateName:(NSString *)name;
/**
 *  生成一个带圆环的图片
 *
 *  @param name   图片的名称
 *  @param border 圆环的宽度
 *  @param color  圆环的颜色
 *
 */
+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)border borderColor:(UIColor *)color;

/**
 *  截屏
 *
 *  @param view 需要截屏的视图
 *
 */
+ (UIImage *)imageWithCaptureView:(UIView *)view;

#pragma mark -- 拷贝的代码, 需要修改
/**
 *  整个窗口截屏
 *
 *  @param destSize 需要截屏的视图
 *
 */
- (UIImage *)scaleAndClipToFillSize:(CGSize)destSize;

/* Crop image in the rectangle*/
/**
 *  整个窗口截屏
 *
 *  @param rect 需要截屏的视图
 *
 */
- (UIImage *)cropImageInRect:(CGRect)rect;

/**
 *  整个窗口截屏
 *
 *  @param size 需要截屏的视图
 *
 */
- (UIImage *)scaleImageToSize:(CGSize)size;
/**
 *  整个窗口截屏
 *
 *  @param radius 需要截屏的视图
 *
 */
- (UIImage *)gaussianBlurWithRadius:(CGFloat)radius;

/**
 *  生成一个带圆环的图片
 *
 *  @param image   图片的名称
 *  @param inset 圆环的宽度
 *  @param width 圆环的宽度
 *  @param color  圆环的颜色
 *
 */
+ (UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset borderWidth:(CGFloat)width borderColor:(UIColor *)color;
/**
 *  图片拉伸
 *
 *  @param name 需要拉伸的名字
 *
 */
+ (UIImage *)resizeImageWithName:(NSString *)name;
@end
