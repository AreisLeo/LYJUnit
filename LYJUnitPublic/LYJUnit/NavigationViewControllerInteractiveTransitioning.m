//
//  NavigationViewControllerInteractiveTransitioning.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationViewControllerInteractiveTransitioning.h"

@implementation NavigationViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
//    UIPercentDrivenInteractiveTransition
    self.transitionContext = transitionContext;
//    [transitionContext updateInteractiveTransition:100];
////    NSLog(@"%@",@(transitionContext.interactive));
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//
//    [transitionContext.containerView addSubview:toView];
//    [transitionContext.containerView addSubview:fromView];
//
//
//    CGPoint currentPoint = [self.ges locationInView:[UIApplication sharedApplication].keyWindow];
//    NSLog(@"%@",NSStringFromCGPoint(currentPoint));
//    fromView.frame = ({
//        CGRect frame  = fromView.frame;
//        frame.origin = CGPointMake(currentPoint.x, 0);
//        frame;
//    });
////    [transitionContext finishInteractiveTransition];
//    if (self.ges.state == UIGestureRecognizerStateEnded)
//    {
//        [transitionContext completeTransition:YES];
//    }

}

@end
