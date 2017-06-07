//
//  LYJUnit.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnit.h"
#import "LYJUnitAttributedData.h"

@implementation LYJUnit

#pragma mark -----SystemSetting------
+ (void)_registerLocalNotification
{
    if ([self _ISIOS10])
    {
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    }
    else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

+ (BOOL)_ISIOS10
{
    return [self _ISIOSWithIndex:10];
}

+ (BOOL)_ISIOSWithIndex:(NSInteger)index
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if ([[[phoneVersion componentsSeparatedByString:@"."]firstObject]integerValue] >= index)
    {
        return YES;
    }
    return NO;
}

#pragma mark -----NSArray------

+ (void)_quickSortArray:(NSMutableArray *)array
{
    [self _quickSortArray:array leftIndex:0 andRightIndex:array.count - 1];
}
//排序
+ (void)_quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] floatValue];
    
    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] floatValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] floatValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    //将基准数放到正确位置
    array[i] = @(key);
    
    /**** 递归排序 ***/
    //排序基准数左边的
    [self _quickSortArray:array leftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self _quickSortArray:array leftIndex:i + 1 andRightIndex:rightIndex];
}

+ (void)_quickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath
{
    
}
+ (void)_quickSortArray:(NSMutableArray *)array keyPath:(NSString *)keyPath leftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    id item = array[i] ;
    CGFloat keyPathValue = [[item valueForKey:keyPath] floatValue];
    while (i < j) {
        while (i < j && [self _getValueWithKeyPath:keyPath index:j andSortArray:array] >= keyPathValue) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [self _getValueWithKeyPath:keyPath index:i andSortArray:array] <= keyPathValue) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = item;
    [self _quickSortArray:array keyPath:keyPath leftIndex:leftIndex andRightIndex:i - 1];
    [self _quickSortArray:array keyPath:keyPath leftIndex:i + 1 andRightIndex:rightIndex];
}

+ (CGFloat)_getValueWithKeyPath:(NSString *)keyPath index:(NSInteger)index andSortArray:(NSArray *)array
{
    id item = array[index] ;
    return [[item valueForKey:keyPath] floatValue];
}


#pragma mark -----NSDate------

+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    switch (dateType)
    {
        case LYJUnitDateNextTypeMinute:
            [lastMonthComps setMinute: -index];
            break;
        case LYJUnitDateNextTypeHour:
            [lastMonthComps setHour: -index];
            break;
        case LYJUnitDateNextTypeDay:
            [lastMonthComps setDay: -index];
            break;
        case LYJUnitDateNextTypeMonth:
            [lastMonthComps setMonth: -index];
            break;
        case LYJUnitDateNextTypeYear:
            [lastMonthComps setYear: -index];
            break;
        default:
            break;
    }
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:targetDate options:0];
    return newdate;
}


#pragma mark -----UILocalNotification------

+ (void)_localNotificationWithAlertBody:(NSString *)alertBody
{
    [self _localNotificationWithDate:[NSDate new] alertBody:alertBody key:nil andIsNow:YES];
}

+ (void)_localNotificationWithDate:(NSDate *)date andAlertBody:(NSString *)alertBody
{
    [self _localNotificationWithDate:date alertBody:alertBody key:nil andIsNow:NO];
}

+ (void)_localNotificationWithDate:(NSDate *)date alertBody:(NSString *)alertBody key:(NSString *)key andIsNow:(BOOL)isNow
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    if (key)
    {
        localNotification.userInfo = @{@"key":key};
    }
    localNotification.alertBody = alertBody;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    if (isNow)
    {
        [[UIApplication sharedApplication]presentLocalNotificationNow:localNotification];
    }
    else
    {

    
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    }
}

+ (void)_cancelLocalNotificationWithKey:(NSString *)key
{
    UILocalNotification *targetLocalNotification = nil;
    NSArray *localNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *localNotification in localNotifications)
    {
        
        if ([key isEqualToString:localNotification.userInfo[@"key"]])
        {
            targetLocalNotification = localNotification;
            break;
        }
    }
    if (targetLocalNotification)
    {
        NSLog(@"取消目标的key:%@",key);
        [[UIApplication sharedApplication]cancelLocalNotification:targetLocalNotification];
    }
}

+ (void)_cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (UNNotificationTrigger *)_triggerWithType:(LYJUnitNotificationTriggerType)type item:(id)item andRepeats:(BOOL)repeats
{
    UNNotificationTrigger *trigger = nil;
    switch (type) {
        case LYJUnitNotificationTriggerTypeTimeInterval:
        {
            trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:[item floatValue] repeats:repeats];
        }
            break;
        case LYJUnitNotificationTriggerTypeCalendar:
        {
            trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:item repeats:repeats];
        }
            break;
        case LYJUnitNotificationTriggerTypeLocation:
        {
            trigger = [UNLocationNotificationTrigger triggerWithRegion:item repeats:repeats];
        }
            break;
        default:
            break;
    }
    return trigger;
}

+ (void)_UNUserNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body identifier:(NSString *)identifier badge:(NSNumber *)badge trigger:(UNNotificationTrigger *)trigger
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //        UNMutableNotificationContent *mutableContent = [UNMutableNotificationContent new];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body;
    content.badge = badge;
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark -----NSMutableAttributedString------
+ (NSMutableAttributedString *)_attributedStringWithFullText:(NSString *)fullText andAttributedData:(void (^)(LYJUnitAttributedData *))attributedData
{
    LYJUnitAttributedData *data = [LYJUnitAttributedData dataWithFullText:fullText];
    if (attributedData) attributedData(data);
    return [data attributedString];
}
@end
