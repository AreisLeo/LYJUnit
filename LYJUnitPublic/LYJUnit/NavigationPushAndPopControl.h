//
//  NavigationPushAndPopControl.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NavigationPushAndPopControl : NSObject <UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

+ (instancetype)pushAndPopControl;

+ (void)setInteractive:(BOOL)interactive;

- (void)popGes:(UIGestureRecognizer *)ges;
@end
