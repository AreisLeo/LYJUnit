//
//  NSTimer+LYJTimer.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/6.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LYJTimer)

+ (NSTimer *)LYJ_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                          block:(void(^)(NSTimer *timer))block
                                        repeats:(BOOL)repeats;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                             block:(void(^)(NSTimer *timer))block
                           repeats:(BOOL)repeats;

@end
