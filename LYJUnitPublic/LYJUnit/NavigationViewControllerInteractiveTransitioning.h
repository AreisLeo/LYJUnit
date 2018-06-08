//
//  NavigationViewControllerInteractiveTransitioning.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationViewControllerInteractiveTransitioning : NSObject <UIViewControllerInteractiveTransitioning>

/** <#message#> */
@property (strong ,nonatomic) UIGestureRecognizer *ges;


/** <#message#> */
@property (strong ,nonatomic) id <UIViewControllerContextTransitioning>transitionContext;


@end
