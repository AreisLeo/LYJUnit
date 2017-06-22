//
//  LYJRadarView.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/20.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYJRadarIndicatorView.h"
@interface LYJRadarView : UIView


/** 扇形View */
@property (strong ,nonatomic) LYJRadarIndicatorView *indicatorView;

/** 半径 */
@property (nonatomic, assign) CGFloat radius;

/** 圆的边框颜色 */
@property (strong ,nonatomic) UIColor *roundBorderColor;

/** 渐变开始颜色 */
@property (nonatomic, strong) UIColor *indicatorStartColor;

/** 渐变结束颜色 */
@property (nonatomic, strong) UIColor *indicatorEndColor;

/** 指针渐变角度 */
@property (nonatomic, assign) CGFloat indicatorAngle;

/** 是否顺时针 */
@property (nonatomic, assign) BOOL indicatorClockwise;

/** 是否随机生成点 default:YES */
@property (assign ,nonatomic) BOOL isRandomPoint;

/** 最大随机生成点 default:6*/
@property (assign ,nonatomic) NSInteger maxPointCount;

/** 最小随机生成点 default:2*/
@property (assign ,nonatomic) NSInteger minPointCount;

/** 生成点 */
@property (strong ,nonatomic) NSMutableArray *pointsArray;

/** 多少个圆 默认:3 */
@property (assign ,nonatomic) NSInteger sectionsNum;

/** 标注的size */
@property (assign ,nonatomic) CGSize pointSize;;

/** 标注的图标 */
@property (strong ,nonatomic) NSString *pointViewImageName;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)scan;
- (void)show;

- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
