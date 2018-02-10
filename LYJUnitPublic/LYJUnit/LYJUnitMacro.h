//
//  LYJUnitMacro.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#ifndef LYJUnitMacro_h
#define LYJUnitMacro_h


#define KeyWindow [UIApplication sharedApplication].keyWindow
#define kWeakSelf __weak typeof(self) weakSelf = self;

#define IS_IOSX(a) @available(ios a,*)

#define IS_IOS7 IS_IOSX(7.0)

#define IS_IOS8 IS_IOSX(8.0)

#define IS_IOS9 IS_IOSX(9.0)

#define IS_IOS10 IS_IOSX(10.0)

#define IS_IOS11 IS_IOSX(11.0)

#define IS_IOS12 IS_IOSX(12.0)

#define IS_IOS13 IS_IOSX(13.0)

#define IS_IOS14 IS_IOSX(14.0)

#define IS_IOS15 IS_IOSX(15.0)

#pragma mark ------ENUM------
typedef enum : NSUInteger {
    LYJUnitDateNextTypeMinute,
    LYJUnitDateNextTypeHour,
    LYJUnitDateNextTypeDay,
    LYJUnitDateNextTypeMonth,
    LYJUnitDateNextTypeYear,
} LYJUnitDateNextType;

typedef enum : NSUInteger {
    LYJUnitDateTypeHH,
    LYJUnitDateTypeHHMM,
    LYJUnitDateTypeHHMMSS,
    LYJUnitDateTypeDD,
    LYJUnitDateTypeMMDD,
    LYJUnitDateTypeYYYYMMDD,
    LYJUnitDateTypeYYYYMMDDHH,
    LYJUnitDateTypeYYYYMMDDHHMM,
    LYJUnitDateTypeYYYYMMDDHHMMSS,
} LYJUnitDateType;

typedef enum : NSUInteger {
    /**多少时间后激活*/
    LYJUnitNotificationTriggerTypeTimeInterval,
    /**指定时间激活*/
    LYJUnitNotificationTriggerTypeCalendar,
    /**到达指定位置激活*/
    LYJUnitNotificationTriggerTypeLocation,
} LYJUnitNotificationTriggerType;

typedef enum : NSUInteger {
    /** 比较字符串头部是否包含对应字符*/
    LYJUnitMatchTypePrefix,
    /** 比较字符串尾部是否包含对应字符*/
    LYJUnitMatchTypeSuffix,
    /** 比较字符串是否包含对应字符*/
    LYJUnitMatchTypeContainsString,
    /** 比较值是否一致*/
    LYJUnitMatchTypeContains,
} LYJUnitMatchType;


#pragma mark ------Block-------
typedef void (^valueChangeBlock)(id newValue ,id oldValue ,id object ,NSString *keyPath);
typedef id (^arrayMapBlock)(id value);
typedef BOOL (^valuePredicateBlock)(id value);
typedef void(^removeBlock)(void);
#endif /* LYJUnitMacro_h */
