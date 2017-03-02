//
//  OPAVPlayer.m
//  MediaPlayer
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface OPAVPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *videoItems;

@end

@implementation OPAVPlayer

+ (instancetype)sharePlayer
{
    static OPAVPlayer *avPlayer = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avPlayer = [[self alloc] init];
    });
    return avPlayer;
}

- (id)init{
    
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

- (AVPlayer *)player
{
    if (!_player) {
        
        self.player = [[AVPlayer alloc] init];
    }
    
    return _player;
}

- (AVPlayerItem *)getPlayItem:(int)index
{
    NSString *sourceStr = self.videoItems[index];
    sourceStr = [sourceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newString = [sourceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange range = NSMakeRange(0, 4);
    NSString *httpStr = [sourceStr substringWithRange:range];
    
    NSURL *url;
    if ([httpStr isEqualToString:@"http"]) {url = [NSURL URLWithString:newString];
    }else{url = [NSURL fileURLWithPath:newString];}
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    return item;
}

- (void)setupAudioByArray:(NSMutableArray *)array
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.videoItems removeAllObjects];
    self.videoItems = array;
    self.index = 0;
    [self musicPareparePlay];
    [self addNotification];
}

// 播放完成后会通知对象调用这个方法
- (void)playbackFinished:(NSNotification *)noti
{
    if ([self.delegate respondsToSelector:@selector(oplayerEnd:)]) {[self.delegate oplayerEnd:_videoItems[self.index]];}
    [self next];
}

// 播放
- (void)musicPlay
{
    if ([self.delegate respondsToSelector:@selector(oplayerCurrent:)]&&self.videoItems != nil && self.videoItems.count != 0) {
        
        NSString *str = self.videoItems[self.index];
        [self.delegate oplayerCurrent:str];
    }
    
    [self.player play];
}

- (void)musicPareparePlay
{
    if (_player.currentItem) {
        
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    
    }
    
    AVPlayerItem *playItem = [self getPlayItem:(int)self.index];
    if (playItem) {
        
        [playItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
        [self.player replaceCurrentItemWithPlayerItem:playItem];
    }
}

- (void)stopPlay
{
    if (self.player) {
        
        [self.player pause];
        [self removeNotifation];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        self.player = nil;
    }
}

- (void)next
{
    self.index++;
    if (self.index<self.videoItems.count) {
        
        [self removeNotifation];
        [self musicPareparePlay];
        [self addNotification];
        
    }else{
        self.index = 0;
        [self stopPlay];
        if ([self.delegate respondsToSelector:@selector(oplayerEndAll)]) {[self.delegate oplayerEndAll];}
    }
}

- (void)removeNotifation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusUnknown:
                
                [self.delegate audioStatus:playStatusUnKnowError];
                break;
                
            case AVPlayerStatusReadyToPlay:
                
                [self musicPlay];
                break;
                
            case AVPlayerStatusFailed:
                
                [self.delegate audioStatus:playStatusFileError];
                [self next];
                
                break;
                
            default:
                break;
        }
    }
}

@end
