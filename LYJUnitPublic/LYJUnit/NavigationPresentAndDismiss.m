//
//  NavigationPresentAndDismiss.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationPresentAndDismiss.h"
#import "NavigationControllerAnimatedTransitioning.h"
@implementation NavigationPresentAndDismiss


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NavigationControllerAnimatedTransitioning *trans = [NavigationControllerAnimatedTransitioning new];
    trans.isPush = YES;
    return trans;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NavigationControllerAnimatedTransitioning *trans = [NavigationControllerAnimatedTransitioning new];
    trans.isPush = NO;
    return trans;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
