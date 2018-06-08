//
//  NavigationPushAndPopControl.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationPushAndPopControl.h"
#import "NavigationControllerPresentAnimatedTransitioning.h"
#import "NavigationViewControllerInteractiveTransitioning.h"
@interface NavigationPushAndPopControl ();

/** <#message#> */
@property (strong ,nonatomic) NavigationControllerPresentAnimatedTransitioning *trans;

/** <#message#> */
@property (strong ,nonatomic) UIPercentDrivenInteractiveTransition *interTrans;

/** <#message#> */
@property (assign ,nonatomic) BOOL interactive;
@end

@implementation NavigationPushAndPopControl

static NavigationPushAndPopControl *_PAPC = nil;
static dispatch_once_t onceToken;
+ (instancetype)pushAndPopControl
{
    dispatch_once(&onceToken, ^{
        _PAPC = [[self alloc]init];
    });
    return _PAPC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trans = [NavigationControllerPresentAnimatedTransitioning new];
        self.interTrans = [UIPercentDrivenInteractiveTransition new];
    }
    return self;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.trans.isPush = YES;
    return self.trans;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.trans.isPush = NO;
    return self.trans;
}




- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive)
    {
        return self.interTrans;
    }
    return nil;
}

+ (void)setInteractive:(BOOL)interactive
{
    _PAPC.interactive = interactive;
}

- (void)popGes:(UIGestureRecognizer *)gestureRecognizer
{

    CGPoint currentPoint = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
    self.trans.ges = gestureRecognizer;
    if (currentPoint.x>=0) {
        //手势滑动的比例
        CGFloat per = currentPoint.x / ([UIScreen mainScreen].bounds.size.width);
        per = MIN(1.0,(MAX(0.0, per)));

        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            self.interactive = YES;
            self.interTrans = [UIPercentDrivenInteractiveTransition new];
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                [NavigationPushAndPopControl setInteractive:NO];
            }];
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
            if(currentPoint.x  == 0)
            {
                [self.interTrans updateInteractiveTransition:0.01];
            }
            else
            {
                [self.interTrans updateInteractiveTransition:per];
            }
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
        {
            if(currentPoint.x == 0)
            {
                [self.interTrans cancelInteractiveTransition];
            }
            else if (per > 0.5)
            {
                [self.interTrans finishInteractiveTransition];
            }
            else
            {
                [ self.interTrans cancelInteractiveTransition];
                
            }
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interTrans updateInteractiveTransition:0.01];
        [self.interTrans cancelInteractiveTransition];
    }
    else if ((gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled))
    {
        self.interTrans = nil;
    }
    //    [self interactionControllerForDismissal:self.transition];
    //    self dis
}

@end
