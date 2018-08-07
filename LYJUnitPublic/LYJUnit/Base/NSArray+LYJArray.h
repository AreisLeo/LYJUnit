//
//  NSArray+LYJArray.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LYJArray)

+ (NSArray *)arrayWithPlistData:(NSData *)plist;

+ (NSArray *)arrayWithPlistString:(NSString *)plist;

- (NSData *)plistData;

- (NSString *)plistString;

- (id)randomObject;

- (id)objectOrNilAtIndex:(NSUInteger)index;

- (NSString *)jsonPrettyStringEncoded;

@end


@interface NSMutableArray(LYJArray)

/**
 解释plistData转换成数组

 @param plist 目标对象
 @return 数组
 */
+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist;

/**
 解释plist字符串转换成数组

 @param plist 目标对象
 @return 数组
 */
+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist;

/**
 移除数组第一个对象
 */
- (void)removeFirstObject;


/**
 返回数组第一个对象，并且从数组中移除

 @return 目标对象
 */
- (id)popFirstObject;

/**
 返回数组最后一个对象，并且从数组中移除

 @return 目标对象
 */
- (id)popLastObject;


/**
 插入目标对象到数组开始位置

 @param object 目标对象
 */
- (void)prependObject:(id)object;

/**
 插入数组到开始位置

 @param objects 目标数组
 */
- (void)prependObjects:(NSArray *)objects;

/**
 插入目标数组到数组指定位置

 @param objects 目标数组
 @param index 位置
 */
- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 反序排列
 */
- (void)reverse;

/**
 随机生成排序
 */
- (void)shuffle;

@end
