//
//  OPAudioMangerTool.h
//  AudioPlayer
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol OPAudioMangerToolDelegate <NSObject>

@optional
- (void)currentAudioPath:(NSString *)string;

// 音频播放结束的时候回调
- (void)playEnd;
- (void)playFail;
@end

@interface OPAudioMangerTool : NSObject
@property (nonatomic, weak) id <OPAudioMangerToolDelegate>delegate;

- (void)playBySource:(NSMutableArray *)array;
- (void)stop;
@end
