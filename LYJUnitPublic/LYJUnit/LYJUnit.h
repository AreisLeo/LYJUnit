//
//  LYJUnit.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "LYJUnitMacro.h"
@class LYJUnitAttributedData;

@interface LYJUnit : NSObject

#pragma mark SystemSettingMethod
/**
 是否大于ios <Index> 系统版本
 */
+ (BOOL)_ISIOSWithIndex:(CGFloat)index;

/**
 是否大于ios10
 */
+ (BOOL)_ISIOS10;

/**
 注册本地通知
 */
+ (void)_registerLocalNotification;

#pragma mark NSArrayMethod
/**
 快速排序
 第一个方法 从左向右 第一个数组排序 按数字排序
 第二个方法 从左向右 model value值进行排序
 */
+ (void)_quickSortArray:(NSMutableArray *)array;

+ (void)_quickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath;

#pragma mark NSDateMethod
/**
 求出下一天 一月 一年 或者 上一天  上一月 上一年
 year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
 返回的是 修改后的时间
 */
+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index;

+ (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType andTargetDate:(NSDate *)targetDate;

#pragma mark UILocalNotificationMethod
/**
 本地通知
 key 可以用于取消对应的localNotification alertBody 用于显示正文
 第一种方法 立即发送本地通知 没有时间设置的
 第二种方法 按设置好的时间发送本地通知
 第三种方法 完整方法
 第四种方法 取消localNotification 需要之前创建添加的key
 第五种方法 取消全部localNotification
 第六种方法 系统版本10.0后可使用新的本地推送方法
 */
+ (void)_localNotificationWithAlertBody:(NSString *)alertBody;

+ (void)_localNotificationWithDate:(NSDate *)date andAlertBody:(NSString *)alertBody;

+ (void)_localNotificationWithDate:(NSDate *)date alertBody:(NSString *)alertBody key:(NSString *)key andIsNow:(BOOL)isNow;

+ (void)_cancelLocalNotificationWithKey:(NSString *)key;

+ (void)_cancelAllLocalNotifications;

/**
 10.0后才能使用的本地推送方法
 */
//item 对应为 TimeInterval 最少为60秒  NSDateComponents CLRegion
+ (UNNotificationTrigger *)_UNNotificationTriggerWithType:(LYJUnitNotificationTriggerType)type item:(id)item andRepeats:(BOOL)repeats;

+ (void)_UNUserNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body identifier:(NSString *)identifier badge:(NSNumber *)badge trigger:(UNNotificationTrigger *)trigger;



#pragma mark NSMutableAttributedStringMethod
/**
 添加富文本
 fullText 必需填写完整的文本
 attributedData 使用链式编程的书写方法
 */
+ (NSMutableAttributedString *)_attributedStringWithFullText:(NSString *)fullText andAttributedData:(void(^)(LYJUnitAttributedData *attributedData))attributedData;

@end
