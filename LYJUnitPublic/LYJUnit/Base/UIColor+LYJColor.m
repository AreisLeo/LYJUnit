//
//  UIColor+LYJColor.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "UIColor+LYJColor.h"

@implementation UIColor (LYJColor)

+ (UIColor *)LYJ_randomColor
{
    CGFloat r = arc4random()% 256;
    CGFloat g = arc4random()% 256;
    CGFloat b = arc4random()% 256;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1];
}

@end
