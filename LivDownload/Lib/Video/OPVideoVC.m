//
//  OPVideoVC.m
//  ViewMoviewPlayer
//
//  Created by Mac on 16/6/8.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPVideoVC.h"
#import "OPVideoPlayer.h"
#import "OPMediaManger.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface OPVideoVC ()<OPVideoPlayerDelegate>
@property (nonatomic, weak) OPVideoPlayer *videoView;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation OPVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupVCByArray:(NSMutableArray *)array page:(NSInteger)page
{
    OPVideoPlayer *view = [[OPVideoPlayer alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIImage *image = [UIImage imageNamed:@"navbar_close2"];
    [backBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
    backBtn.frame = CGRectMake(10, 20, 60, 50);
    [backBtn addTarget:self action:@selector(backSuperView:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view setupVideoByArray:array page:page];
    [self.view addSubview:view];
    [self.view addSubview:backBtn];
    self.videoView = view;
}


- (void)setupVCByFullPath:(NSString *)fullPath
{
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    UIImage *image = [UIImage imageNamed:@"navbar_close2"];
    [backBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
    backBtn.frame = CGRectMake(10, 20, 60, 50);
    [backBtn addTarget:self action:@selector(backSuperView:) forControlEvents:(UIControlEventTouchUpInside)];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 初始化视频播放器类
    NSURL *url;
    if ([fullPath hasPrefix:@"http"]) {

        url = [NSURL URLWithString:fullPath];

    }else{
        url = [NSURL fileURLWithPath:fullPath];
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
    [self.player play];
    [self.view addSubview:backBtn];
    [self addNotification];
}

// 添加通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

// 移除通知
- (void)removeNotifation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 播放完成后会通知对象调用这个方法
- (void)playbackFinished:(NSNotification *)noti
{
    [self dismiss];
}


//// 传入全路径
//- (void)setupVCByFullPath:(NSString *)fullPath
//{
//    OPVideoPlayer *view = [[OPVideoPlayer alloc] initWithFrame:self.view.bounds];
//    view.delegate = self;
//    
//    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    UIImage *image = [UIImage imageNamed:@"navbar_close2"];
//    [backBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
//    backBtn.frame = CGRectMake(0, 0, 60, 50);
//    [backBtn addTarget:self action:@selector(backSuperView:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    [view setupVideoByfullPath:fullPath];
//    [self.view addSubview:view];
//    [self.view addSubview:backBtn];
//
//    self.videoView = view;
//}

// 播放完成后自动返回代理
- (void)dismissVc{
    
    [self dismiss];
    
}

- (void)dismiss
{
    if ([self.delegate respondsToSelector:@selector(closeVideoPlayer)]) {
        
        [self.delegate closeVideoPlayer];
    }
    
    [self.player pause];
    [self removeNotifation];
    [self.videoView stopAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)currentPLayPath:(NSString *)path
{
    if ([self.delegate respondsToSelector:@selector(currentPath:)]) {
        
        [self.delegate currentPath:path];
    }
}

// 返回
- (void)backSuperView:(UIButton *)btn
{
    [self dismiss];
}

@end
