//
//  OPAVPlayer.h
//  MediaPlayer
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    playStatusUnKnowError,
    playStatusFileError,
} playStatus;

@class VideoPlayer;
@protocol OPAVPlayerDelegate <NSObject>
- (void)oplayerCurrent:(NSString *)path;
- (void)oplayerEndAll;
@optional
- (void)oplayerEnd:(NSString *)path;
- (void)oplayerStart;
- (void)audioStatus:(playStatus)status;
@end

@interface OPAVPlayer : NSObject

@property (nonatomic, weak) id<OPAVPlayerDelegate>delegate;
+ (instancetype)sharePlayer;
- (void)setupAudioByArray:(NSMutableArray *)array;
- (void)stopPlay;
@end
