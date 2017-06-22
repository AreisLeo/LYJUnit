//
//  LYJJellyView.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/22.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYJJellyView : UIView

/** 核心动画layer */
@property (strong ,nonatomic) CADisplayLink *displayLinkLayer;

- (void)beginAnimation;

- (void)endAnimation;

- (void)refreshDisplayLinkLayer:(CADisplayLink *)displayLinkLayer;


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
