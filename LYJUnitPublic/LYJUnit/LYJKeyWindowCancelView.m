//
//  LYJKeyWindowCancelView.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "LYJKeyWindowCancelView.h"

@interface LYJKeyWindowCancelView ()
;


@end

@implementation LYJKeyWindowCancelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat topViewMargin = 30;
        CGFloat midViewMargin = 10;
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(topViewMargin, topViewMargin, self.bounds.size.width - topViewMargin, self.bounds.size.height - topViewMargin)];
        self.topView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.topView];

        self.midView = [[UIView alloc]initWithFrame:CGRectMake(midViewMargin, midViewMargin, self.bounds.size.width - midViewMargin, self.bounds.size.height - midViewMargin)];
        self.midView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.midView];

        [self bringSubviewToFront:self.topView];

    }
    return self;
}

@end
