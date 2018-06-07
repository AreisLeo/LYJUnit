//
//  LYJKeyWindowCancelView.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYJKeyWindowCancelView : UIButton

/** <#message#> */
@property (strong ,nonatomic) UIView *topView;

/** <#message#> */
@property (strong ,nonatomic) UIView *midView;

- (void)animations;

- (void)setupMidView;

- (CGRect)containsRect;

@end
