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
#import "WXViewController.h"
#import "LYJUnit.h"
@interface NavigationPushAndPopControl ();

/** <#message#> */
@property (strong ,nonatomic) NavigationControllerPresentAnimatedTransitioning *trans;

/** <#message#> */
@property (strong ,nonatomic) UIPercentDrivenInteractiveTransition *interTrans;

/** <#message#> */
@property (assign ,nonatomic) BOOL interactive;

@property (strong ,nonatomic) UIViewController *vc;
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

+ (void)setCurrentViewController:(UIViewController *)vc
{
    _PAPC.vc = vc;
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
            CGFloat fromAlpha = 1.0f;
            if (per > 0.2 && per < 0.3)
            {
                fromAlpha = 0.7f - per ;
            }
            else if (per  > 0.3)
            {
                fromAlpha = 0.5f - per ;
            }
            [self setFromLabelTextColorWithAlpha:fromAlpha];
            [self setToLabelTextColorWithAlpha:per];
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
        {
            if(currentPoint.x == 0)
            {
                [self.interTrans cancelInteractiveTransition];
                [self setToLabelTextColorWithAlpha:0.0f];
            }
            else if (per > 0.5)
            {
                [self.interTrans finishInteractiveTransition];
                [self setToLabelTextColorWithAlpha:1.0f];
            }
            else
            {
                [ self.interTrans cancelInteractiveTransition];
                [self setToLabelTextColorWithAlpha:0.0f];
            }
            [self setFromLabelTextColorWithAlpha:1.0f];
            
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

- (void)setFromLabelTextColorWithAlpha:(CGFloat)alpha
{
//    self.vc.navigationController.navigationBar.alpha = alpha;
//    UILabel *fromlabel = (UILabel *)self.vc.navigationItem.titleView;
//    [self setLabelTextColorWithAlpha:alpha label:fromlabel];
    UIView *contentView = [LYJUnit _subViewOfClassName:@"_UINavigationBarContentView" targetView:self.vc.navigationController.navigationBar];
    contentView.alpha = alpha;

}

- (void)setToLabelTextColorWithAlpha:(CGFloat)alpha
{
    UITabBarController *tabbarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navi = tabbarVC.selectedViewController;
//    UIViewController *vc = navi.viewControllers.lastObject;
    UIView *contentView = [LYJUnit _subViewOfClassName:@"_UINavigationBarContentView" targetView:navi.navigationBar];
    contentView.alpha = alpha;
//    UILabel *tolabel = (UILabel *)vc.navigationItem.titleView;
//    [self setLabelTextColorWithAlpha:alpha label:tolabel];
}

- (void)setLabelTextColorWithAlpha:(CGFloat)alpha label:(UILabel *)label
{
    label.textColor = [label.textColor colorWithAlphaComponent:alpha];
}


@end
