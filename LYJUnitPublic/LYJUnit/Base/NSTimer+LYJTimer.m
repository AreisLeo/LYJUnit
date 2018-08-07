//
//  NSTimer+LYJTimer.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/6.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NSTimer+LYJTimer.h"

@implementation NSTimer (LYJTimer)

+ (void)LYJ_timerBlock:(NSTimer *)timer
{
    if ([timer userInfo])
    {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }

}

+ (NSTimer *)LYJ_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds  block:(void(^)(NSTimer *timer))block repeats:(BOOL)repeats
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(LYJ_timerBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void(^)(NSTimer *timer))block repeats:(BOOL)repeats
{
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(LYJ_timerBlock:) userInfo:[block copy] repeats:repeats];
}



@end
