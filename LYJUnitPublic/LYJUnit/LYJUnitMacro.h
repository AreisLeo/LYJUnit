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



#endif /* LYJUnitMacro_h */
