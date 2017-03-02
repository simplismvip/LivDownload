//
//  UIImage+MetaImage.h
//  LivDownload
//
//  Created by JM Zhao on 2017/2/24.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MetaImage)
- (NSDictionary *)getJPEGimageInfo;
- (NSDictionary *)getPNGimageInfo;
- (UIImage *)creatThumbnailFromImageSource:(int)imageSize;
- (UIImage *)getThumbnailFromImage;
+ (UIImage *)getImageFromWindow;
@end
