//
//  OPMediaManger.m
//  ViewMoviewPlayer
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPMediaManger.h"
#import "OPVideoVC.h"
#import "OPVideoPlayer.h"

@interface OPMediaManger()

@end

static NSArray *_videoArr;
@implementation OPMediaManger

// 过滤视频文件
+ (OPVideoVC *)viewByPath:(NSString *)path page:(NSInteger)page addDelegate:(id)delegate
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *muArr = [NSMutableArray array];
    NSMutableArray *local = [NSMutableArray array];
    NSMutableArray *url = [NSMutableArray array];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    // 1> 首先过滤出 M_ 开头的文件
    for (NSString *fileName in contents) {
        
        NSArray *array;
        if ([fileName pathExtension].length > 0) {
            
            array = [fileName componentsSeparatedByString:@"_"];
        }
        
        if (array.count >= 2) {
            
            if ([array[1] isEqualToString:[NSString stringWithFormat:@"%ld", (long)page]]) {
                
                NSRange range = NSMakeRange(0, 2);
                NSString *m_ = [fileName substringWithRange:range];
                if ([m_ isEqualToString:@"M_"]) {
                    
                    [muArr addObject:fileName];
                }
            }
        }
    }
    
    for (NSString *name in muArr) {
        
        NSString *extension = [[name pathExtension] lowercaseString];
        
        // 本地 local
        if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"] || [extension isEqualToString:@"3gp"] || [extension isEqualToString:@"mpv"]) {
            
            // 首先要对文件进行一次筛查, page页
            NSString *key = [name componentsSeparatedByString:@"_"][1];
            if ([key isEqualToString:[NSString stringWithFormat:@"%ld", (long)page]]) {
                
                [local addObject:[path stringByAppendingPathComponent:name]];
            }
            
        }else {// 网络 URL
            
            // 首先要对文件进行一次筛查, page页
            NSString *key = [name componentsSeparatedByString:@"_"][1];
            if ([key isEqualToString:[NSString stringWithFormat:@"%ld", page]]) {
                
                // 去掉换行符和空格等不合法格式
                NSString *pathString = [path stringByAppendingPathComponent:name];
                NSString *pathStr = [[[FileManager alloc] init] readMediaUrlFromUrlFile:pathString];
                pathStr = [pathStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *newString = [pathStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *ext = [[newString pathExtension] lowercaseString];
                
                if ([ext isEqualToString:@"mp4"] || [ext isEqualToString:@"mov"] || [ext isEqualToString:@"3gp"] || [ext isEqualToString:@"mpv"]) {
                    
                    [url addObject:newString];
                }
            }
        }
    }
    if (url.count > 0) {
        
        OPVideoVC *vc = [[OPVideoVC alloc] init];
        vc.delegate = delegate;
        [vc setupVCByArray:url page:page];
        _videoArr = url.copy;
        return vc;
        
    } else if (local.count > 0){
        
        OPVideoVC *vc = [[OPVideoVC alloc] init];
        vc.delegate = delegate;
        [vc setupVCByArray:local page:page];
        _videoArr = local.copy;
        return vc;
    }else{
        
        return nil;
    }
}

+ (NSArray *)returnVideoArr
{
    return _videoArr;
}

+ (OPVideoVC *)getViewByVideoPath:(NSString *)videoPath
{
    OPVideoVC *vc = [[OPVideoVC alloc] init];
    [vc setupVCByFullPath:videoPath];
    return vc;
}


@end
