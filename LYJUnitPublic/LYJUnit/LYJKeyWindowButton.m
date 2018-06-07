//
//  LYJKeyWindowButton.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "LYJKeyWindowButton.h"
#import "LYJKeyWindowCancelView.h"

#define kCancelViewWidth 150.0f
#define kButtonWidth 60.0f
@interface LYJKeyWindowButton ()
;
/** <#message#> */
@property (assign ,nonatomic) CGPoint lastPoint;
/** <#message#> */
@property (assign ,nonatomic) CGPoint touchPoint;

@end

@implementation LYJKeyWindowButton

static LYJKeyWindowButton *_keywindowBtn;
static LYJKeyWindowCancelView *_cancelView;
static dispatch_once_t onceToken;

+ (instancetype)showBtn
{
    dispatch_once(&onceToken, ^{
        _keywindowBtn = [[LYJKeyWindowButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kButtonWidth - 10, 200, kButtonWidth, kButtonWidth)];
        _keywindowBtn.backgroundColor = [UIColor yellowColor];
        _keywindowBtn.layer.cornerRadius = _keywindowBtn.frame.size.height / 2.0f;
        _keywindowBtn.layer.masksToBounds = YES;

        _cancelView = [[LYJKeyWindowCancelView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, kCancelViewWidth, kCancelViewWidth)];
    });
    [[UIApplication sharedApplication].keyWindow addSubview:_cancelView];
    [[UIApplication sharedApplication].keyWindow addSubview:_keywindowBtn];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_keywindowBtn];
    return _keywindowBtn;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.lastPoint = [[touches allObjects].lastObject locationInView: self.superview];
    self.touchPoint = [[touches allObjects].lastObject locationInView: self];
//    NSLog(@"%@",NSStringFromCGPoint(self.touchPoint) );
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [touches.allObjects.lastObject locationInView:self.superview];
//    CGPoint touchCurrentPoint = [touches.allObjects.lastObject locationInView:self];
    CGPoint selfCurrentPoint = self.frame.origin;
    selfCurrentPoint.x += currentPoint.x - selfCurrentPoint.x - self.touchPoint.x;
    selfCurrentPoint.y += currentPoint.y - selfCurrentPoint.y - self.touchPoint.y;

    if ((selfCurrentPoint.x + self.frame.size.width >= [UIScreen mainScreen].bounds.size.width || selfCurrentPoint.x < 0) || (selfCurrentPoint.y < 0 || selfCurrentPoint.y + self.frame.size.height > [UIScreen mainScreen].bounds.size.height ))
    {
        return;
    }

    self.frame = ({
        CGRect frame  = self.frame;
        frame.origin = CGPointMake(selfCurrentPoint.x, selfCurrentPoint.y);
        frame.size = CGSizeMake(frame.size.width, frame.size.height);
        frame;
    });
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, kCancelViewWidth,kCancelViewWidth);

    if (CGRectEqualToRect(_cancelView.frame, frame))
    {
        [UIView animateWithDuration:0.2f animations:^{
            _cancelView.frame = ({
                CGRect frame  = _cancelView.frame;
                frame.origin = CGPointMake([UIScreen mainScreen].bounds.size.width - kCancelViewWidth, [UIScreen mainScreen].bounds.size.height - kCancelViewWidth);
                frame;
            });
        }];
    }


}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [touches.allObjects.lastObject locationInView:self.superview];

    if (CGPointEqualToPoint(self.lastPoint, currentPoint))
    {
        NSLog(@"点击");
    }
    else
    {
        CGFloat marginLeft = self.frame.origin.x;
        CGFloat marginRight = [UIScreen mainScreen].bounds.size.width - self.frame.origin.x - self.frame.size.width;

        CGFloat maxX = [UIScreen mainScreen].bounds.size.width - 10 - self.frame.size.width;
        CGFloat left = marginLeft > marginRight ? maxX : 10.0f;
        if (self.frame.origin.y < 10)
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.frame = ({
                    CGRect frame  = self.frame;
                    frame.origin = CGPointMake(left, 10);
                    frame.size = CGSizeMake(frame.size.width, frame.size.height);
                    frame;
                });
            }];
        }
        else if ([UIScreen mainScreen].bounds.size.height - (self.frame.origin.y + self.frame.size.height) < 10)
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.frame = ({
                    CGRect frame  = self.frame;
                    frame.origin = CGPointMake(left, [UIScreen mainScreen].bounds.size.height - self.frame.size.height - 10);
                    frame.size = CGSizeMake(frame.size.width, frame.size.height);
                    frame;
                });
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.frame = ({
                    CGRect frame  = self.frame;
                    frame.origin = CGPointMake(left, frame.origin.y);
                    frame.size = CGSizeMake(frame.size.width, frame.size.height);
                    frame;
                });
            }];
        }

        CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, kCancelViewWidth,kCancelViewWidth);

        if (!CGRectEqualToRect(_cancelView.topView.frame, frame))
        {
            [UIView animateWithDuration:0.2f animations:^{
                if (CGRectContainsRect(_cancelView.frame, self.frame))
                {
                    [self removeFromSuperview];
                    self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - kButtonWidth - 10, 200, kButtonWidth, kButtonWidth);
                }
                _cancelView.frame = frame;
            }];
        }
    }
}


@end
