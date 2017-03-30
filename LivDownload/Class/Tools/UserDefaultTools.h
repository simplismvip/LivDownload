//
//  UserDefaultTools.h
//  PageShare
//
//  Created by JM Zhao on 16/8/29.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultTools : NSObject
/**
 *  设置URL根据输入key值
 *
 *  @param url         需要存入的URL数据
 *  @param defaultName key值
 *
 *  @return 返回存储是否成功
 */
+ (BOOL)setUrl:(NSURL *)url forKey:(NSString *)defaultName;
/**
 *  根据key值删除value值
 *
 *  @param key key值
 */
+ (void)removeObjectByKey:(NSString *)key;
/**
 *  根据key值读取对应value值
 *
 *  @param key key值
 *
 *  @return 返回读取的value值
 */
+ (NSURL *)readUrlByKey:(NSString *)key;
/**
 *  根据key值返回对应字符串
 *
 *  @param key 输入key值
 *
 *  @return 返回字符串的值
 */
+ (NSString *)readIPByKey:(NSString *)key;

// 存储和读取 NSString 值
+ (BOOL)setString:(NSString *)string forKey:(NSString *)defaultName;
+ (NSString *)readStringByKey:(NSString *)key;

+ (BOOL)setBool:(BOOL)Bool forKey:(NSString *)defaultName;
+ (BOOL)readBoolByKey:(NSString *)key;
@end
