//
//  LYJKeyWindowCancelView.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "LYJKeyWindowCancelView.h"
#import "LYJUnitHeader.h"
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
//        self.topView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.topView];

        self.midView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width, self.bounds.size.width, self.bounds.size.width - midViewMargin, self.bounds.size.height - midViewMargin)];
//        self.midView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.midView];

        [self bringSubviewToFront:self.topView];

        CAShapeLayer *topShapeLayer = [LYJUnit _drawArcWithCenter:CGPointMake(self.topView.bounds.size.width, self.topView.bounds.size.height) radius:self.topView.bounds.size.width startAngle:0.5 endAngle:-0.5 clockwise:YES layerLineWidth:0 layerStrokeColor:[UIColor redColor] layerFillColor:[UIColor redColor] layerLineCap:kCALineCapButt animations:^(CAShapeLayer *shapeLayer) {

        }];
        [self.topView.layer insertSublayer:topShapeLayer atIndex:0];

        CAShapeLayer *midShapeLayer = [LYJUnit _drawArcWithCenter:CGPointMake(self.midView.bounds.size.width, self.midView.bounds.size.height) radius:self.midView.bounds.size.width startAngle:0.5 endAngle:-0.5 clockwise:YES layerLineWidth:0 layerStrokeColor:[UIColor redColor] layerFillColor:[UIColor redColor] layerLineCap:kCALineCapButt animations:^(CAShapeLayer *shapeLayer) {

        }];
        [self.midView.layer insertSublayer:midShapeLayer atIndex:0];

    }
    return self;
}

- (void)animations
{
    [UIView animateWithDuration:0.2f animations:^{
        self.midView.frame = ({
            CGRect frame  = self.midView.frame;
            frame.origin = CGPointMake(10, 10);
            frame;
        });
    }];
}

- (void)setupMidView
{
    self.midView.frame = ({
        CGRect frame  = self.midView.frame;
        frame.origin = CGPointMake(self.frame.size.width, self.frame.size.width);
        frame;
    });
}

- (CGRect)containsRect
{
    return CGRectMake(self.frame.origin.x + self.topView.frame.origin.x,self.frame.origin.y + self.topView.frame.origin.y, self.topView.frame.size.width, self.topView.frame.size.height);
}


@end
