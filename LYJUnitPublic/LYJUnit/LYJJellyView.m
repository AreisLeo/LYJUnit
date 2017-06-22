//
//  LYJJellyView.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/22.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJJellyView.h"

@interface LYJJellyView ()

@property (assign ,nonatomic) CGFloat from;
@property (assign ,nonatomic) CGFloat to;
@property (assign ,nonatomic) BOOL animating;
@property (strong ,nonatomic) CAShapeLayer *animationLayer;
@end

@implementation LYJJellyView

- (void)beginAnimation
{
    if (!self.displayLinkLayer)
    {
        self.displayLinkLayer = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDisplayLinkLayer:)];
        [self.displayLinkLayer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.animating = YES;
        self.animationLayer = [CAShapeLayer layer];
        self.animationLayer.bounds = self.bounds;
        [self.layer addSublayer:self.animationLayer];
    }
}

- (void)endAnimation
{
    [self.animationLayer removeFromSuperlayer];
    self.animating = NO;
    [self.displayLinkLayer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLinkLayer invalidate];
    self.displayLinkLayer = nil;
}

- (void)refreshDisplayLinkLayer:(CADisplayLink *)displayLinkLayer
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = self.layer.presentationLayer;
    
    CGFloat progress = 1;
    if (!self.animating) {
        progress = 1;
    } else {
        progress = 1 - (layer.position.x - 100) / (-100 - 100);
    }
    NSLog(@"progress:%f", progress);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat deltaWidth = width / 2 * (0.5 - fabs(progress - 0.5));
    NSLog(@"delta:%f", deltaWidth);
//
    
    CGPoint topLeft = CGPointMake(0, 0);
    CGPoint topRight = CGPointMake(CGRectGetWidth(rect), 0);
    CGPoint bottomLeft = CGPointMake(0, CGRectGetHeight(rect));
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(rect) , CGRectGetHeight(rect));

    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:topRight];
    [path addQuadCurveToPoint:bottomRight controlPoint:CGPointMake(CGRectGetWidth(rect) + 50 , CGRectGetMidY(rect))];
    [path addLineToPoint:bottomLeft];
    [path addQuadCurveToPoint:topLeft controlPoint:CGPointMake(0 + deltaWidth,  CGRectGetMidY(rect))];
    self.animationLayer.path = path.CGPath;
    [self.animationLayer setFillColor:[UIColor redColor].CGColor];
    [path closePath];
    
}

@end
