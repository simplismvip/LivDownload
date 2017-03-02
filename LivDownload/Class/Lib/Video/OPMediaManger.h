//
//  OPMediaManger.h
//  ViewMoviewPlayer
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPVideoVC;
@interface OPMediaManger : NSObject
/**
 *  返回正在播放的一组视频
 */
+ (NSArray *)returnVideoArr;
+ (OPVideoVC *)viewByPath:(NSString *)path page:(NSInteger)page addDelegate:(id)delegate;
+ (OPVideoVC *)getViewByVideoPath:(NSString *)videoPath;

@end
