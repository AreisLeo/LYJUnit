//
//  NavigationPushAndPopControl.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NavigationPushAndPopControl.h"
#import "NavigationControllerAnimatedTransitioning.h"
@interface NavigationPushAndPopControl ()


@end

@implementation NavigationPushAndPopControl

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    NavigationControllerAnimatedTransitioning *trans = [NavigationControllerAnimatedTransitioning new];
    trans.isPush = operation == UINavigationControllerOperationPush;
    return trans;
}


@end
