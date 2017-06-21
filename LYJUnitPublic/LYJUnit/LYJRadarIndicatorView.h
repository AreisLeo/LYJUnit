//
//  LYJRadarIndicatorView.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/21.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYJRadarIndicatorView : UIView

/*半径*/
@property (assign ,nonatomic) CGFloat radius;
/*渐变开始颜色*/
@property (strong ,nonatomic) UIColor *startColor;
/*渐变结束颜色*/
@property (strong ,nonatomic) UIColor *endColor;
/*渐变角度*/
@property (assign ,nonatomic) CGFloat angle;
/*是否顺时针*/
@property (assign ,nonatomic) BOOL clockwise;

@end
