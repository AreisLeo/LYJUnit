//
//  LYJKeyWindowButton.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYJKeyWindowButton : UIButton

/** <#message#> */
@property (strong ,nonatomic) UIViewController *currentController;

+ (instancetype)showBtn;

+ (LYJKeyWindowButton *)keyWindowBtn;

@end
