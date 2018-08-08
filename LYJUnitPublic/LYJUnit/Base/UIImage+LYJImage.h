//
//  UIImage+LYJImage.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYJImage)

/**
 *  颜色转换成image
 *
 *  @param color 颜色
 *
 *  @return image
 */
+ (UIImage *)_createImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 图片指定范围不进行拉伸

 @param edgInsets CGFloat top, left, bottom, right;
 @param resizingMode UIImageResizingModeTile == 拉伸 UIImageResizingModeStretch == 平铺
 @return 修改后的image
 */
- (UIImage *)_resizableImageWithCapInsets:(UIEdgeInsets)edgInsets resizingMode:(UIImageResizingMode)resizingMode;

/**
 生成二维码
 */
+ (UIImage *)_codeWithContent:(NSString *)content codeSize:(CGSize)codeSize andMidLogoImage:(UIImage *)logoImage;

/**
 用 image 生成一个模版 可以通过 tintColor改变颜色
 */
- (UIImage *)_imageModelAlwaysTemplate;

/**
 压图片质量

 默认大小 小于300K  压缩比率 0.9f
 @return image
 */
- (UIImage *)_zipImage;

- (UIImage *)_zipImageWithMaxFileSize:(CGFloat)maxFileSize compression:(CGFloat)compression;

/**
 设置图片变黑白色

 @param type 变色属性 1为灰色 2 3 为特定色阶 不同图片效果不一样
 @return 变色后的图片
 */
- (UIImage*)_changeChromaWithType:(int)type;

/**
 *  渐变颜色 使用图片
 */
+ (UIColor *)_imageColorWithImageName:(NSString *)imageName;
@end
