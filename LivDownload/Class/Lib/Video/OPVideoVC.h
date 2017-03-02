//
//  OPVideoVC.h
//  ViewMoviewPlayer
//
//  Created by Mac on 16/6/8.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OPVideoVCDelegate <NSObject>
- (void)currentPath:(NSString *)string;
- (void)closeVideoPlayer;
@end

@interface OPVideoVC : UIViewController

@property (nonatomic, weak) id<OPVideoVCDelegate>delegate;

/**
 *  根据当前页号初始化播放器
 *
 *  @param array 当前页视频资源数组
 *  @param page  需要播放的当前页
 */
- (void)setupVCByArray:(NSMutableArray *)array page:(NSInteger)page;
/**
 *  根据传入全路径初始化播放器
 *
 *  @param fullPath 全路径
 */
- (void)setupVCByFullPath:(NSString *)fullPath;

- (void)dismiss;
@end
