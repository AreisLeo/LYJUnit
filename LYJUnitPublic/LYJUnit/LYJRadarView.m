//
//  LYJRadarView.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/20.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJRadarView.h"
#import <QuartzCore/QuartzCore.h>

@interface LYJRadarView () <CAAnimationDelegate>
{
    NSInteger _count ;
}
/** 点生成的view */
@property (strong ,nonatomic) UIView *pointsView;

@property (strong ,nonatomic) CAShapeLayer *calculateLayer;

@end

@implementation LYJRadarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.indicatorView = [[LYJRadarIndicatorView alloc] initWithFrame:self.bounds];
    [self addSubview:self.indicatorView];
    UIColor *defaultColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    self.indicatorStartColor = defaultColor;
    self.roundBorderColor = defaultColor;
    self.indicatorEndColor = [UIColor clearColor];
    self.indicatorClockwise = YES;
    self.indicatorAngle = 50.0f;
    self.radius = 100.0f;
    self.sectionsNum = 3;
    self.isRandomPoint = YES;
    self.maxPointCount = 4;
    self.minPointCount = 2;
    self.pointsView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.pointsView];
    self.pointViewImageName = @"椭圆-2";
    self.pointsArray = [NSMutableArray array];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.indicatorView)
    {
        self.indicatorView.frame = self.bounds;
        self.indicatorView.backgroundColor = [UIColor clearColor];
        self.indicatorView.radius = self.radius;
        self.indicatorView.angle = self.indicatorAngle;
        self.indicatorView.clockwise = self.indicatorClockwise;
        self.indicatorView.startColor = self.indicatorStartColor;
        self.indicatorView.endColor = self.indicatorEndColor;
    }
    if (self.pointsView)
    {
        self.pointsView.frame = self.bounds;
    }
}
- (void)calculatePointsLayer:(CGPoint)centerPoint withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withRadius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle  clockwise:YES];
    self.calculateLayer = [CAShapeLayer layer];
    self.calculateLayer.path = path.CGPath;
    //arcLayer.strokeColor可设置画笔颜色
    self.calculateLayer.lineWidth = 1;
    self.calculateLayer.frame = self.bounds;
    self.calculateLayer.fillColor = [UIColor clearColor].CGColor;
    self.calculateLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.layer insertSublayer:self.calculateLayer atIndex:0];
}

#pragma mark - Actions
- (void)scan
{
    self.indicatorView.alpha = 0;
    
    CGFloat start = -M_PI * 0.5;
    CGFloat end =  M_PI  * 0.5 ;
    CGFloat sectionRadius = self.radius / self.sectionsNum;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
    for (NSInteger i  = 0 ; i < self.sectionsNum; i ++)
    {
        [self drawRoundView:centerPoint withStartAngle:start withEndAngle:end  withRadius: sectionRadius - 5 * (self.sectionsNum - i - 1) alpha:(1 - (float)i / (self.sectionsNum + 1)) * 0.5];
        
        [self drawRoundView:centerPoint withStartAngle:end withEndAngle:start  withRadius: sectionRadius - 5 * (self.sectionsNum - i - 1) alpha:(1 - (float)i / (self.sectionsNum + 1)) * 0.5];
        
        sectionRadius += self.radius / self.sectionsNum;
    }
    sectionRadius -= self.radius / self.sectionsNum;
    [self calculatePointsLayer:centerPoint withStartAngle:start withEndAngle:end * 3 withRadius:sectionRadius];
    
    
}


- (void)show
{
    for (UIView *subview in self.pointsView.subviews)
    {
        [subview removeFromSuperview];
    }
    [self.pointsArray removeAllObjects];
    BOOL addPoint = YES;
//    arc4random() 
    NSInteger maxPointCount =  arc4random() % self.maxPointCount + self.minPointCount;
    while (addPoint)
    {
        
        NSInteger diameter = (self.radius * 2 + self.pointSize.width * 2);
        NSInteger width = (arc4random() % diameter) + ((NSInteger)(CGRectGetWidth(self.calculateLayer.frame) - diameter)) / 2.0f;
        NSInteger height = (arc4random() % diameter) + ((NSInteger)CGRectGetHeight(self.calculateLayer.frame) - diameter) / 2.0;
        CGPoint point = CGPointMake(width, height);
        CGRect frame = CGRectMake(width - self.pointSize.width / 2.0f, height - self.pointSize.height / 2.0f, self.pointSize.width, self.pointSize.height);
        BOOL contains = NO;
        for (NSValue *value in self.pointsArray)
        {
            CGPoint valuePoint = [value CGPointValue];
            CGRect valueFrame = CGRectMake(valuePoint.x - self.pointSize.width / 2.0f, valuePoint.y - self.pointSize.height / 2.0f, self.pointSize.width, self.pointSize.height);
            contains = CGRectIntersectsRect(valueFrame, frame);
            if (contains) break;
            contains = CGRectContainsRect(valueFrame, frame);
            if (contains) break;
        }
        if (CGPathContainsPoint(self.calculateLayer.path, NULL, point, NO) && !contains)
        {

            [self.pointsArray addObject:[NSValue valueWithCGPoint:point]];
            addPoint = self.pointsArray.count == maxPointCount ? NO : YES;
        }
    }
    

    for (int index = 0; index < self.pointsArray.count; index++)
    {
        CGPoint point = [self.pointsArray[index] CGPointValue];

        UIImageView *pointView = [UIImageView new];
        pointView.tag = index;
        pointView.image = [UIImage imageNamed:self.pointViewImageName];
        pointView.frame = CGRectZero;
        pointView.center = point;
        pointView.contentMode = UIViewContentModeScaleAspectFit;

        [UIView animateWithDuration:0.25 delay:index * 0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            pointView.frame = ({
                CGRect frame  = pointView.frame;
                frame.size = CGSizeMake(self.pointSize.width * 1.1, self.pointSize.height * 1.1);
                frame;
            });;
            pointView.center = point;
        }  completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                pointView.frame = ({
                    CGRect frame  = pointView.frame;
                    frame.size = self.pointSize;
                    frame;
                });;
                pointView.center = point;
            } completion:^(BOOL finished) {
                
            }];
        }];
        [self.pointsView addSubview:pointView];
    }
}




#pragma mark -----画圆生成的动画效果------
- (void)drawRoundView:(CGPoint)centerPoint withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withRadius:(CGFloat)radius  alpha:(CGFloat)alpha
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle  clockwise:YES];
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    //arcLayer.strokeColor可设置画笔颜色
    arcLayer.lineWidth = 1;
    arcLayer.frame = self.bounds;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = [self.roundBorderColor colorWithAlphaComponent:alpha].CGColor;
    [self.layer insertSublayer:arcLayer atIndex:0];
    
    //动画显示圆则调用  [self drawLineAnimation:arcLayer];
    [self drawLineAnimation:arcLayer];
}

- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}




#pragma mark -----CAAnimationDelegate  扇形的出现与动画效果------
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _count ++ ;
    if (_count == (self.sectionsNum * 2))
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorView.alpha = 1;
        } completion:^(BOOL finished) {
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: (self.indicatorClockwise ? 1 : -1) * M_PI * 2.0 ];
            rotationAnimation.duration = 1.25f;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = 3;
            rotationAnimation.delegate = self;
            [_indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//            INT_MAX
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self show];
            });
        }];
    }
}


@end
