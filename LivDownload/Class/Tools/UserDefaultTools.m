//
//  UserDefaultTools.m
//  PageShare
//
//  Created by JM Zhao on 16/8/29.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import "UserDefaultTools.h"

@implementation UserDefaultTools

+ (BOOL)setUrl:(NSURL *)url forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setURL:url forKey:defaultName];
    return [defaults synchronize];
}

+ (NSURL *)readUrlByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults URLForKey:key];
}

+ (NSString *)readIPByKey:(NSString *)key
{
    return [[self readUrlByKey:key] absoluteString];
}

+ (void)removeObjectByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

#pragma mark -- 存储和读取 NSString 值
+ (BOOL)setString:(NSString *)string forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:defaultName];
    return [defaults synchronize];
}

+ (NSString *)readStringByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *anser = [defaults objectForKey:key];
//    if (anser==nil) {
//       anser = @"nil";
//    }
    return anser;
}

#pragma mark -- 存储和读取 BOOL 值
+ (BOOL)setBool:(BOOL)Bool forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:Bool forKey:defaultName];
    return [defaults synchronize];
}

+ (BOOL)readBoolByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}


@end
