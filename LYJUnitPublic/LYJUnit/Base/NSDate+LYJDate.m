//
//  NSDate+LYJDate.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NSDate+LYJDate.h"

@implementation NSDate (LYJDate)

- (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType andIndex:(NSInteger)index
{
    return [NSDate _dateNextType:dateType targetDate:self andIndex:index];
}

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



- (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType
{
    NSString *dateTypeStr = @"yyyy-MM-dd HH:mm:ss";
    switch (dateType) {
        case LYJUnitDateTypeHH:
            dateTypeStr = @"HH";
            break;
        case LYJUnitDateTypeHHMM:
            dateTypeStr = @"HH:mm";
            break;
        case LYJUnitDateTypeHHMMSS:
            dateTypeStr = @"HH:mm:ss";
            break;
        case LYJUnitDateTypeDD:
            dateTypeStr = @"dd";
            break;
        case LYJUnitDateTypeMMDD:
            dateTypeStr = @"MM-dd";
            break;
        case LYJUnitDateTypeYYYYMMDD:
            dateTypeStr = @"yyyy-MM-dd";
            break;
        case LYJUnitDateTypeYYYYMMDDHH:
            dateTypeStr = @"yyyy-MM-dd HH";
            break;
        case LYJUnitDateTypeYYYYMMDDHHMM:
            dateTypeStr = @"yyyy-MM-dd HH:mm";
            break;
        case LYJUnitDateTypeYYYYMMDDHHMMSS:
            dateTypeStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateTypeStr];
    return [dateFormatter stringFromDate:self];
}


@end
