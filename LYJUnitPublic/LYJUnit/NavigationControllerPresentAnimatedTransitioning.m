//
//  NavigationControllerPresentAnimatedTransitioning.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationControllerPresentAnimatedTransitioning.h"
#import "LYJUnitHeader.h"
@implementation NavigationControllerPresentAnimatedTransitioning



- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
//                NSLog(@"action");
    if (self.isPush)
    {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

        UITableViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *contarinerView = transitionContext.containerView;

        [LYJUnit _bezierPathWithView:toView shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(-2, 2) andShadowOpacity:0.5];

        [contarinerView addSubview:toView];
        toView.frame = ({
            CGRect frame  = toView.frame;
            frame.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
            frame;
        });
        [contarinerView addSubview:fromVC.view];
        [contarinerView bringSubviewToFront:toView];

        [UIView animateWithDuration:0.25f animations:^{
            toView.frame = ({
                CGRect frame  = toView.frame;
                frame.origin = CGPointMake(0, 0);
                frame;
            });
        } completion:^(BOOL finished) {

        }];

        [UIView animateWithDuration:0.35f animations:^{
            fromVC.view.frame = ({
                CGRect frame  = fromVC.view.frame;
                frame.origin = CGPointMake(-[UIScreen mainScreen].bounds.size.width, 0);
                frame;
            });
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    }
    else
    {
//        UITabBarController *tabbarVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UINavigationController *navi = tabbarVC.selectedViewController;
//        UIViewController *vc = navi.viewControllers.lastObject;
//        UIView *toTopView = [navi.view copy];
//        UIView *toView = [vc.view copy];


        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//        NSLog(@"%@",[LYJUnit _classNameDictOfTargetView:toView]);

        toView.frame = ({
            CGRect frame  = toView.frame;
            frame.origin = CGPointMake(-([UIScreen mainScreen].bounds.size.width / 3.0f),0);
            frame;
        });
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        UIView *contarinerView = transitionContext.containerView;
        [LYJUnit _bezierPathWithView:fromVC.view shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(-2, 2) andShadowOpacity:0.5];

//        [contarinerView addSubview:toTopView];
        [contarinerView addSubview:toView];
        [contarinerView addSubview:fromVC.view];
        if (transitionContext.interactive)
        {
            [UIView animateWithDuration:0.25f animations:^{
                toView.frame = ({
                    CGRect frame  = toView.frame;
                    frame.origin = CGPointMake(0, frame.origin.y);
                    frame;
                });
            } completion:^(BOOL finished) {

            }];


            [UIView animateWithDuration:0.35f animations:^{
                fromVC.view.frame = ({
                    CGRect frame  = fromVC.view.frame;
                    frame.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
                    frame;
                });
            } completion:^(BOOL finished) {
                BOOL complete = transitionContext.transitionWasCancelled ? NO : YES;
                [transitionContext completeTransition:complete];

            }];
        }
        else
        {


            [UIView animateWithDuration:0.25f animations:^{
                toView.frame = ({
                    CGRect frame  = toView.frame;
                    frame.origin = CGPointMake(0, 0);
                    frame;
                });
            } completion:^(BOOL finished) {

            }];


            [UIView animateWithDuration:0.35f animations:^{
                fromVC.view.frame = ({
                    CGRect frame  = fromVC.view.frame;
                    frame.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
                    frame;
                });
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }

}



@end
