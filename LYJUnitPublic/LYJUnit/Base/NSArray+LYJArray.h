//
//  NSArray+LYJArray.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJUnitMacro.h"
#import <UIKit/UIKit.h>
@interface NSArray (LYJArray)

+ (NSArray *)arrayWithPlistData:(NSData *)plist;

+ (NSArray *)arrayWithPlistString:(NSString *)plist;

- (NSData *)plistData;

- (NSString *)plistString;

/**
 返回数组内随机对象

 @return 随机对象
 */
- (id)randomObject;

- (id)objectOrNilAtIndex:(NSUInteger)index;

/**
 把自身转化为jsonString

 @return jsonString
 */
- (NSString *)jsonPrettyStringEncoded;

/**
 快速排序
 第一个方法 升序
 第二个方法 降序
 第三个方法 升序 model keyPath值进行排序
 第四个方法 降序 model keyPath值进行排序
 */
- (NSArray *)_ascendQuickSort;

- (NSArray *)_descendQuickSort;

- (NSArray *)_ascendQuickSortWithKeyPath:(NSString *)keyPath;

- (NSArray *)_descendQuickSortWithKeyPath:(NSString *)keyPath;

/**
 数据转换 mapBlock 返回需要的转换 model
 */
- (NSArray *)_mapWithMapBlock:(arrayMapBlock)mapBlock;

/**
 累加计算 当 keyPath 为 nil 时 直接取出 floatValue
 */
- (CGFloat)_accumulateWithKeyPath:(NSString *)keyPath;

/**
 计算当前数组是否全部满足条件 当其它一个不满足时返回 NO
 */
- (BOOL)_allMatchingWithKeyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue;

/**
 计算当前数组是否全部不满足条件 当其它一个满足时返回 NO
 */
- (BOOL)_allNoneMatchingWithKeyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue;

/**
 求和 integer
 */
- (NSInteger)_reduceEachInteger;

/**
 求和 float
 */
- (CGFloat)_reduceEachFloat;

/**
 取出当前数组需要的 count,count 后面的直接放弃 从前到后
 */
- (NSArray *)_takeWithCount:(NSInteger)count;

/**
 取出当前数组需要的 count,count 前面的直接放弃 从后到前
 */
- (NSArray *)_takeLastWithCount:(NSInteger)count;

/**
 取出当前数组中符合条件的值 当不条件符合后 后面不再进行条件判断 直接返回
 */
- (NSArray *)_takeUntilWithBlock:(valuePredicateBlock)block;

/**
 取出当前数组中不符合条件的值 当条件符合后 后面不再进行条件判断 直接返回
 */
- (NSArray *)_takeWhileWithBlock:(valuePredicateBlock)block;

/**
 取出当前数组跳过的 count 后的值 取后值
 */
- (NSArray *)_skipWithSkipCount:(NSInteger)skipCount;
/**
 取出当前数组中符合条件的值 当条件符合后 后面不再进行条件判断
 */
- (NSArray *)_skipUntilWithBlock:(valuePredicateBlock)block;

/**
 取出当前数组中不符合条件的值 当条件符合后 后面不再进行条件判断
 */
- (NSArray *)_skipWhileWithBlock:(valuePredicateBlock)block;

/**
 判断数组是否为空

 @return yes 为空
 */
- (BOOL)noValue;
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
