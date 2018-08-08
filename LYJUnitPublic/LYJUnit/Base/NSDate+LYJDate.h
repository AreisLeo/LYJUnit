//
//  NSDate+LYJDate.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJUnitMacro.h"
@interface NSDate (LYJDate)

/**
 求出下一天 一月 一年 或者 上一天  上一月 上一年
 year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
 返回的是 修改后的时间
 */

- (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType andIndex:(NSInteger)index;

+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index;


/**
 快速返回日期字符串属性

 @param dateType 对应的日期样式
 @return dateString
 */
- (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType;
@end
