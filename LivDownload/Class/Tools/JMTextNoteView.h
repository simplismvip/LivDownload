//
//  JMTextNoteView.h
//  LivDownload
//
//  Created by JM Zhao on 2017/4/10.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMTextNoteViewDelegate <NSObject>
- (void)playVoiceNote:(BOOL)isPlay;
@end
@interface JMTextNoteView : UITextView
@property (nonatomic, weak) id<JMTextNoteViewDelegate>noteDelegate;
@end
