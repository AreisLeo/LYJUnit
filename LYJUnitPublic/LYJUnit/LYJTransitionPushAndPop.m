//
//  LYJTransitionPushAndPop.m
//  LYJUnitPublic
//
//  Created by Aries li on 2018/6/9.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "LYJTransitionPushAndPop.h"
#import "NavigationControllerPresentAnimatedTransitioning.h"
#import "LYJUnit.h"
@interface LYJTransitionPushAndPop ()

/** <#message#> */
@property (strong ,nonatomic) NavigationControllerPresentAnimatedTransitioning *trans;

/** <#message#> */
@property (strong ,nonatomic) UIPercentDrivenInteractiveTransition *interTrans;

/** <#message#> */
@property (assign ,nonatomic) BOOL interactive;

@property (strong ,nonatomic) UIViewController *vc;
@end

@implementation LYJTransitionPushAndPop


static LYJTransitionPushAndPop *_PAPC = nil;
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
                self.interactive = NO;
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
            CGFloat toAlpha = per;
            if (per > 0.2 && per < 0.3)
            {
                fromAlpha = 0.7f - per ;
            }
            else if (per  > 0.3)
            {
                fromAlpha = 0.5f - per ;
            }
            [self setFromToNavigationBarContentViewWithAlpha:fromAlpha];
            [self setToNavigationBarContentViewWithAlpha:toAlpha];
        }
        else if (gestureRecognizer.state ==
                 UIGestureRecognizerStateEnded ||
                 gestureRecognizer.state ==
                 UIGestureRecognizerStateCancelled)
        {
            if(currentPoint.x == 0)
            {
                [LYJUnit _setSystemStatusBarColor:
                 LYJSystemStatusBarColorBlack];
                [self.interTrans cancelInteractiveTransition];
                [self setToNavigationBarContentViewHidden];
            }
            else if (per > 0.5)
            {
                [LYJUnit _setSystemStatusBarColor:
                 LYJSystemStatusBarColorWhite];
                [self.interTrans finishInteractiveTransition];
                [self setToNavigationBarContentViewShow];
            }
            else
            {
                [LYJUnit _setSystemStatusBarColor:
                 LYJSystemStatusBarColorBlack];
                [ self.interTrans cancelInteractiveTransition];
                [self setToNavigationBarContentViewHidden];
            }
            [self setFromNavigationBarContentViewShow];
        }
    }
}

- (void)setFromToNavigationBarContentViewWithAlpha:(CGFloat)alpha
{
    UIView *contentView = [LYJUnit _subViewOfClassName:@"_UINavigationBarContentView" targetView:self.vc.navigationController.navigationBar];
    contentView.alpha = alpha;
    
}

- (void)setToNavigationBarContentViewWithAlpha:(CGFloat)alpha
{
    UITabBarController *tabBarController = (UITabBarController *)[LYJUnit _rootViewController];
    UINavigationController *navi = tabBarController.selectedViewController;
    UIView *contentView = [LYJUnit _subViewOfClassName:@"_UINavigationBarContentView" targetView:navi.navigationBar];
    contentView.alpha = alpha;
}

- (void)setFromNavigationBarContentViewShow
{
    [self setFromToNavigationBarContentViewWithAlpha:1];
}

- (void)setToNavigationBarContentViewHidden
{
    [self setToNavigationBarContentViewWithAlpha:0];
}

- (void)setToNavigationBarContentViewShow
{
    [self setToNavigationBarContentViewWithAlpha:1];
}

@end
