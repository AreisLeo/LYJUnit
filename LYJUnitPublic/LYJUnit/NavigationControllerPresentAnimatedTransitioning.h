//
//  NavigationControllerPresentAnimatedTransitioning.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NavigationControllerPresentAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/** <#message#> */
@property (assign ,nonatomic) BOOL isPush;

/** <#message#> */
@property (strong ,nonatomic) UIGestureRecognizer *ges;

@end
