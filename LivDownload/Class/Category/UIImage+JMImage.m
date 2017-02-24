//
//  UIImage+JMImage.m
//  Sina-微博
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "UIImage+JMImage.h"

@implementation UIImage (JMImage)

+ (UIImage *)imageWithRenderingName:(NSString *)name{
    
    UIImage *selImage = [UIImage imageNamed:name];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return selImage;
}

+ (UIImage *)imageWithTemplateName:(NSString *)name{
    
    UIImage *selImage = [UIImage imageNamed:name];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return selImage;
}

+ (UIImage *)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)imageWithCaptureView:(UIView *)view
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 图层只能用渲染不能用draw, 渲染控制器view的图层到上下文
    [view.layer renderInContext:ctx];
    
    // 获取截屏图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)border borderColor:(UIColor *)color
{
    // 圆环的宽度
    CGFloat borderW = border;
    
    // 加载旧的图片
    UIImage *oldImage =  [UIImage imageNamed:name];
    
    // 新的图片尺寸
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    
    // 设置新的图片尺寸
    CGFloat circirW = imageW > imageH ? imageH : imageW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), NO, 0.0);
    
    // 画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circirW, circirW)];
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    // 设置颜色
    [color set];
    
    // 渲染
    CGContextFillPath(ctx);
    
    CGRect clipR = CGRectMake(borderW, borderW, oldImage.size.width, oldImage.size.height);
    
    // 画圆：正切于旧图片的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    
    // 设置裁剪区域
    [clipPath addClip];
    
    // 画图片
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, image.size.width-inset*2.0f, image.size.height-inset*2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset+width/2, inset+width/2, image.size.width-width-inset*2.0f,image.size.height-width-inset*2.0f));
        CGContextStrokePath(context);
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 图片拉伸
+ (UIImage *)resizeImageWithName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width*0.5f - 1;
    CGFloat h = normal.size.height*0.5f - 1;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}


#pragma mark -- 对象方法
- (UIImage *)scaleAndClipToFillSize:(CGSize)destSize
{
    CGFloat showWidth = destSize.width;
    CGFloat showHeight = destSize.height;
    CGFloat scaleWidth = showWidth;
    CGFloat scaleHeight = showHeight;
    
    scaleWidth = ceilf(scaleHeight/self.size.height*self.size.width);
    if (scaleWidth < destSize.width) {
        scaleWidth = destSize.width;
        scaleHeight = ceilf(scaleWidth/self.size.width*self.size.height);
    }
    
    // scale
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaleWidth, scaleHeight), NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // clip
    CGFloat originX = ceilf((scaleWidth-showWidth)/2);
    CGFloat originY = ceilf((scaleHeight-showHeight)/2);
    
    CGRect cropRect = CGRectMake(ceilf(originX*scaledImage.scale), ceilf(originY*scaledImage.scale), ceilf(showWidth*scaledImage.scale), ceilf(showHeight*scaledImage.scale));
    return [scaledImage cropImageInRect:cropRect];
}

- (UIImage *)cropImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropImage;
}

- (UIImage *)scaleImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)gaussianBlurWithRadius:(CGFloat)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:cgImage];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
