//
//  OPVideoPlayer.h
//  ViewMoviewPlayer
//
//  Created by lanou on 15/11/6.
//  Copyright © 2015年 RockyFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OPVideoPlayerDelegate <NSObject>
@optional
- (void)dismissVc;
- (void)currentPLayPath:(NSString *)path;
@end

@interface OPVideoPlayer : UIView

@property (nonatomic, weak) id<OPVideoPlayerDelegate>delegate;
/**
 *  根据传入的页好分组播放
 *
 *  @param array 当前页需要播放文件数组
 *  @param page  当前页
 */
- (void)setupVideoByArray:(NSMutableArray *)array page:(NSInteger)page;
/**
 *  根据传入的全路径播放
 *
 *  @param fullPath 全路径
 */
- (void)setupVideoByfullPath:(NSString *)fullPath;
/**
 *  退出的时候停止播放, 清空数据
 */
- (void)stopAction;
@end
