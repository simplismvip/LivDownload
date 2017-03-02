//
//  OPAudioMangerTool.m
//  AudioPlayer
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPAudioMangerTool.h"
#import "OPAVPlayer.h"

@interface OPAudioMangerTool ()<OPAVPlayerDelegate, AVAudioRecorderDelegate>
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIViewController *superVC;
@end

@implementation OPAudioMangerTool

// 开始播放
- (void)playBySource:(NSMutableArray *)array
{
    OPAVPlayer *opPlayer = [OPAVPlayer sharePlayer];
    opPlayer.delegate = self;
    [opPlayer setupAudioByArray:array];
}

- (void)stop
{
    [[OPAVPlayer sharePlayer] stopPlay];
}

#pragma mark--OPAVPlayerDelegate
- (void)oplayerCurrent:(NSString *)path
{
    [self currentAudioUrl:path];
}

- (void)oplayerEndAll
{
    if ([self.delegate respondsToSelector:@selector(playEnd)]) {[self.delegate playEnd];}
}

- (void)audioStatus:(playStatus)status
{
    if (status==playStatusUnKnowError || status==playStatusFileError) {
        
        if ([self.delegate respondsToSelector:@selector(playFail)]) {[self.delegate playFail];}
    }
}

#pragma mark--OPAudioMangerToolDelegate
- (void)currentAudioUrl:(NSString *)url
{
    if ([self.delegate respondsToSelector:@selector(currentAudioPath:)]) {[self.delegate currentAudioPath:url];}
}
@end
