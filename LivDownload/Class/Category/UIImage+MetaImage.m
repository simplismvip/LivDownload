//
//  UIImage+MetaImage.m
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import "UIImage+MetaImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

// @"/Users/mac/Desktop/14577546764Screenshot_2014-11-13-12-16-454.jpg.png"
@implementation UIImage (MetaImage)

#pragma mark -- 获取照片内置信息
- (NSDictionary *)getJPEGimageInfo
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    NSDictionary *metaDataInfo    = CFBridgingRelease(imageMetaData);
    CFRelease(imageSource);
    return metaDataInfo;
}

- (NSDictionary *)getPNGimageInfo
{
    NSData *data = UIImagePNGRepresentation(self);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    NSDictionary *metaDataInfo    = CFBridgingRelease(imageMetaData);
    CFRelease(imageSource);
    return metaDataInfo;
}

#pragma mark -- 生成缩略图
- (UIImage *)getThumbnailFromImage
{
    CGSize size = self.size;
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    float ratio = MAX(newRect.size.width/size.width, newRect.size.height/size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = size.width *ratio;
    projectRect.size.height = size.height *ratio;
    projectRect.origin.x = (newRect.size.width-projectRect.size.width)/2;
    projectRect.origin.y = (newRect.size.height-projectRect.size.height)/2;
    [self drawInRect:projectRect];
    
    UIImage *smallimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return smallimg;
    
}

- (UIImage *)creatThumbnailFromImageSource:(int)imageSize
{
    CGImageRef thumbnailImage;
    CFDictionaryRef imageOptions;
    CFStringRef imageKeys[3];
    CFTypeRef imageValues[3];
    CFNumberRef thumbnailSize;
    
    NSData *imagedata = UIImagePNGRepresentation(self);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imagedata, NULL);
    if (imageSource == NULL) {
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }
    //创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    imageKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    imageValues[0] = (CFTypeRef)kCFBooleanTrue;
    imageKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    imageValues[1] = (CFTypeRef)kCFBooleanTrue;
    
    //缩放键值对
    imageKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    imageValues[2] = (CFTypeRef)thumbnailSize;
    imageOptions = CFDictionaryCreate(NULL, (const void **) imageKeys,
                                      (const void **) imageValues, 3,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    //获取缩略图
    thumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, imageOptions);
    CFRelease(imageOptions);
    CFRelease(thumbnailSize);
    CFRelease(imageSource);
    if (thumbnailImage == NULL) {
        return NULL;
    }else{
        
        return [UIImage imageWithCGImage:thumbnailImage];
    }
}

#pragma mark -- 设置渲染模式
- (UIImage *)imageWithRendering{
    
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)imageWithTemplate{
    
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark -- 屏幕截图
+ (UIImage *)imageWithCaptureView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 全屏幕截图
+ (UIImage *)getImageFromWindow
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0); // no ritina
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        if(window == screenWindow)
        {
            break;
        }else{
            [window.layer renderInContext:context];
        }
    }
    
    if ([screenWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [screenWindow drawViewHierarchyInRect:screenWindow.bounds afterScreenUpdates:YES];
    } else {
        [screenWindow.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    screenWindow.layer.contents = nil;
    UIGraphicsEndImageContext();
    
    float iOSVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if(iOSVersion < 8.0)
    {
        image = [self rotateUIInterfaceOrientationImage:image];
    }
    
    return image;
}

+ (UIImage *)rotateUIInterfaceOrientationImage:(UIImage *)image{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:
        {
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationDown];
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
        }
            break;
        case UIInterfaceOrientationUnknown:
        {
        }
            break;
            
        default:
            break;
    }
    
    return image;
}

@end
