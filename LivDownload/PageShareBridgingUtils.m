//
//  PageShareBridgingUtils.m
//  PageShare
//
//  Created by Q.S Wang on 16/06/2016.
//  Copyright © 2016 Oneplus Smartware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageShareBridgingUtils.h"

@implementation PageShareBridgingUtils

+ (NSString*) getEmojiName : (int) index
{
    return Constants.EMOJI[index];
}

//Trac #896 liv文件名展示有四种: defined/roomname/time-roomname/time-defined
+ (NSString*)getShouldShowedLivName:(NSString *)livFullPath
{
    NSString *newFullPath=[livFullPath stringByDeletingPathExtension];
    NSArray * arr = [newFullPath componentsSeparatedByString:@"_"];
    NSString * livstr;
    if ([newFullPath containsString:@":"]) {
     
        if (arr.count == 1) {
             NSArray * contentarr = [newFullPath componentsSeparatedByString:@"-"];
            NSString * name = contentarr[0];
            NSArray * timedetailArr = [contentarr.lastObject componentsSeparatedByString:@":"];
            NSString * time = [NSString stringWithFormat:@"%@:%@",timedetailArr[0],timedetailArr[1]];
            livstr = [NSString stringWithFormat:@"%@-%@",time,name];
            
        }else if (arr.count == 2){
        
            NSArray * timeArr = [arr.lastObject componentsSeparatedByString:@"-"];
            NSString * name = timeArr[0];
            NSArray * timedetailArr = [timeArr.lastObject componentsSeparatedByString:@":"];
            NSString * time = [NSString stringWithFormat:@"%@:%@",timedetailArr[0],timedetailArr[1]];
            livstr = [NSString stringWithFormat:@"%@-%@",time,name];
            
        }else if (arr.count == 3){
 
            NSArray * timeArr = [arr.lastObject componentsSeparatedByString:@"-"];
            NSArray * timedetailArr = [timeArr.lastObject componentsSeparatedByString:@":"];
            NSString * name;
            if ([timeArr[0] isEqualToString:@""]) {
                name = arr[1];
            }else{
                name = timeArr[0];
            }
            NSString * time = [NSString stringWithFormat:@"%@:%@",timedetailArr[0],timedetailArr[1]];
            livstr = [NSString stringWithFormat:@"%@-%@",time,name];

        }else if (arr.count == 4){
            
            NSString * name;
            if ([arr[0] isEqualToString:arr[2]]) {
                name = arr[1];
            }else{
                name = arr[2];
            }
            NSArray * timeArr = [arr.lastObject componentsSeparatedByString:@"-"];
            NSArray * timedetailArr = [timeArr.lastObject componentsSeparatedByString:@":"];
            NSString * time = [NSString stringWithFormat:@"%@:%@",timedetailArr[0],timedetailArr[1]];
            livstr = [NSString stringWithFormat:@"%@-%@",time,name];
  
        }else{
            livstr = newFullPath;
        }
    }else{

        if (arr.count == 1) {
            livstr = arr.firstObject;
        }else if (arr.count == 2){
            livstr = arr[1];
        }else if (arr.count == 3){
            livstr = arr[1];
        }else if (arr.count == 4){
            if ([arr[0] isEqualToString:arr[2]]) {
                livstr = arr[1];
            }else{
                livstr = arr[2];
            }
        }else{
            livstr = arr[0];
        }
    }
    return livstr;
}

//返回毫秒
+ (CGFloat)getVideoDuration:(NSURL*)videoUrl {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
//    CGFloat second = urlAsset.duration.value / urlAsset.duration.timescale;
    CGFloat videoDurationSeconds = CMTimeGetSeconds(urlAsset.duration);  // 获取视频总时长,单位秒
    return floorf(videoDurationSeconds*1000);
}

//返回毫秒
+ (CGFloat)getMusicDuration:(NSURL *)musicUrl {
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:musicUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    CGFloat audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return floorf(audioDurationSeconds*1000);
}

//按时间戳排序
+ (NSArray *)sortArray:(NSArray *)arr{
    
    NSMutableArray *timeMuArr = [NSMutableArray array];
    NSString *time = @"2017-01-21-22:05:09";
    for (NSString *string in arr) {
        //看是否有时间戳
        if ([string length]>[time length]) {
            NSString *subString = [string substringFromIndex:[string length]-[time length]];
    
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
            NSDate* date = [formatter dateFromString:subString];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
            if ([timeSp integerValue]>0) {
                [timeMuArr addObject:timeSp];
            }
        }
    }
    
    //时间排序
    NSComparator timeSort = ^(id stringA,id stringB){
        if ([stringA integerValue] > [stringB integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([stringA integerValue] < [stringB integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray * timedataArr = [timeMuArr sortedArrayUsingComparator:timeSort];
 
    NSMutableArray *timeRelArr = [NSMutableArray array];
    for (NSString *string in timedataArr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
        NSDate * timedata = [NSDate dateWithTimeIntervalSince1970:[string integerValue]];
        NSString * timeStr = [formatter stringFromDate:timedata];
        [timeRelArr addObject:timeStr];
    }
    
    NSMutableArray *  risMuArr = [NSMutableArray array];
    for (int i=0; i<timeRelArr.count; i++) {
        for (int j=0; j<arr.count; j++) {
            if([arr[j] rangeOfString:[NSString stringWithFormat:@"%@",timeRelArr[i]]].location !=NSNotFound) {
                [risMuArr insertObject:arr[j] atIndex:0];
            }
        }
    }
    
    for (NSString *string in arr) {
        //若不包含时间戳放在最后
        BOOL isExist = [risMuArr containsObject:string];
        if (isExist==NO) {
            [risMuArr addObject:string];
        }
    }
    
    return risMuArr;
}

@end
