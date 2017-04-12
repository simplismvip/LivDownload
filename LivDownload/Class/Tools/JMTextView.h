//
//  JMTextView.h
//  LivDownload
//
//  Created by JM Zhao on 2017/4/10.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMTextVieweDelegate <NSObject>
- (void)playVoiceNote:(BOOL)isPlay;
@end
@interface JMTextView : UIView
@property (nonatomic, weak) id<JMTextVieweDelegate>delegate;
@end
