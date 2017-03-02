//
//  Header.h
//  PageShare
//
//  Created by Q.S Wang on 16/06/2016.
//  Copyright © 2016 Oneplus Smartware. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <Foundation/Foundation.h>

@interface PageShareBridgingUtils : NSObject

+ (NSString*) getEmojiName : (int) index;
+ (CGFloat)getVideoDuration:(NSURL*)videoUrl;
+ (CGFloat)getMusicDuration:(NSURL *)musicUrl;
+ (NSString*)getShouldShowedLivName:(NSString *)livFullPath;
+ (NSArray *)sortArray:(NSArray *)arr;
@end

#endif /* Header_h */
