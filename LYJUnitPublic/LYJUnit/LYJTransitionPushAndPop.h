//
//  LYJTransitionPushAndPop.h
//  LYJUnitPublic
//
//  Created by Aries li on 2018/6/9.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LYJTransitionPushAndPop : NSObject<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

+ (instancetype)pushAndPopControl;

+ (void)setCurrentViewController:(UIViewController *)vc;

- (void)popGes:(UIGestureRecognizer *)ges;

@end
