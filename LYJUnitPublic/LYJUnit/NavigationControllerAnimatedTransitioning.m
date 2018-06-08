//
//  NavigationControllerAnimatedTransitioning.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationControllerAnimatedTransitioning.h"
#import "LYJKeyWindowButton.h"
#import "LYJUnit.h"
@implementation NavigationControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPush)
    {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

        //        UITableViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *contarinerView = transitionContext.containerView;

        [contarinerView addSubview:toView];
        //    [contarinerView addSubview:toVC.view];

        LYJKeyWindowButton *windowBtn = [LYJKeyWindowButton keyWindowBtn];
        [windowBtn removeFromSuperview];
        UIView *maskView = [[UIView alloc]initWithFrame:windowBtn.frame];
        maskView.backgroundColor = [UIColor blackColor];
        [LYJUnit _cornerRadius:10 borderWidth:0 borderColor:nil masksToBounds:YES view:maskView];
        toView.maskView = maskView;

        [UIView animateWithDuration:0.2f animations:^{
            maskView.frame = ({
                CGRect frame  = maskView.frame;
                frame.origin = CGPointMake(0, 0);
                frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                frame;
            });
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    }
    else
    {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        LYJKeyWindowButton *windowBtn = [LYJKeyWindowButton keyWindowBtn];
        UIView *contarinerView = transitionContext.containerView;


        [contarinerView addSubview:toView];
        [contarinerView addSubview:fromVC.view];


        UIView *maskView = [[UIView alloc]initWithFrame:fromVC.view.frame];
        maskView.backgroundColor = [UIColor blackColor];
        [LYJUnit _cornerRadius:10 borderWidth:0 borderColor:nil masksToBounds:YES view:maskView];
        fromVC.view.maskView = maskView;

        [UIView animateWithDuration:0.2f animations:^{
            maskView.frame = ({
                CGRect frame  = windowBtn.frame;
                frame;
            });
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [LYJKeyWindowButton showBtn];
            windowBtn.currentController = fromVC;
        }];
    }

}




@end
