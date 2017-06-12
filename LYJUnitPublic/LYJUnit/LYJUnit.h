//
//  LYJUnit.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "LYJUnitMacro.h"
#import "LYJAlertController.h"
@class LYJUnitAttributedData;

@interface LYJUnit : NSObject

#pragma mark SystemSettingMethod
/**
 是否大于ios <version> 系统版本
 */
+ (BOOL)_ISIOSWithVersion:(CGFloat)version;

/**
 是否大于ios10
 */
+ (BOOL)_ISIOS10;

/**
 注册本地通知
 */
+ (void)_registerLocalNotification;


/**
 *  是否有允许打开定位
 *
 *  @return YES / NO
 */
+ (BOOL)_hasOpenLocation;

#pragma mark ActionController

/**
 showAlertView
 */
+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles viewController:(UIViewController *)viewController clickBlock:(void(^)(NSInteger index))clickBlock;

/**
 showAlertView 带textField textField数量自定义
 */
+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles viewController:(UIViewController *)viewController textFieldCount:(NSInteger)textFieldCount textFieldsBlock:(void(^)(NSMutableArray *textFields))textFieldsBlock clickBlock:(void(^)(NSInteger index))clickBlock;

/**
 showActionSheet
 */
+ (LYJAlertController *)_showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles viewController:(UIViewController *)viewController clickBlock:(void(^)(NSInteger index))clickBlock;

#pragma mark ScanMethod

/** 
 快速集成系统扫描
 */
+ (void)_showScanWithView:(UIView *)view complete:(void(^)(NSString *result))complete;

+ (void)_hiddenScanViewWithRemove:(BOOL)remove;

+ (void)_hiddenScanView;

+ (void)_startScanView;

#pragma mark UIImageMethod


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
+ (UIImage *)_resizableImageWithCapInsets:(UIEdgeInsets)edgInsets resizingMode:(UIImageResizingMode)resizingMode image:(UIImage *)image;

/**
 生成二维码
 */
+ (UIImage *)_codeWithContent:(NSString *)content codeSize:(CGSize)codeSize andMidLogoImage:(UIImage *)logoImage;

/**
 用 image 生成一个模版 可以通过 tintColor改变颜色
 */
+ (UIImage *)_imageModelAlwaysTemplateWithImage:(UIImage *)image;

/**
 压图片质量
 
 @param image image 默认大小 小于300K  压缩比率 0.9f
 @return image
 */
+ (UIImage *)_zipImageWithImage:(UIImage *)image;


+ (UIImage *)_zipImageWithImage:(UIImage *)image maxFileSize:(CGFloat)maxFileSize compression:(CGFloat)compression;


/**
 设置图片变黑白色
 
 @param anImage 目标图片
 @param type 变色属性 1为灰色 2 3 为特定色阶 不同图片效果不一样
 @return 变色后的图片
 */
+ (UIImage*)_changeChromaWithTargetImage:(UIImage*)anImage type:(int)type;


#pragma mark NSArrayMethod
/**
 快速排序
 第一个方法 升序
 第二个方法 降序
 第三个方法 升序 model keyPath值进行排序
 第四个方法 降序 model keyPath值进行排序
 */
+ (void)_ascendQuickSortArray:(NSMutableArray *)array;

+ (void)_descendQuickSortArray:(NSMutableArray *)array;

+ (void)_ascendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath;

+ (void)_descendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath;

#pragma mark NSDateMethod
/**
 求出下一天 一月 一年 或者 上一天  上一月 上一年
 year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
 返回的是 修改后的时间
 */
+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index;

+ (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType andTargetDate:(NSDate *)targetDate;

#pragma mark UILocalNotificationMethod
/**
 本地通知
 key 可以用于取消对应的localNotification alertBody 用于显示正文
 第一种方法 立即发送本地通知 没有时间设置的
 第二种方法 按设置好的时间发送本地通知
 第三种方法 完整方法
 第四种方法 取消localNotification 需要之前创建添加的key
 第五种方法 取消全部localNotification
 第六种方法 系统版本10.0后可使用新的本地推送方法
 */
+ (void)_localNotificationWithAlertBody:(NSString *)alertBody;

+ (void)_localNotificationWithDate:(NSDate *)date andAlertBody:(NSString *)alertBody;

+ (void)_localNotificationWithDate:(NSDate *)date alertBody:(NSString *)alertBody key:(NSString *)key andIsNow:(BOOL)isNow;

+ (void)_cancelLocalNotificationWithKey:(NSString *)key;

+ (void)_cancelAllLocalNotifications;

/**
 10.0后才能使用的本地推送方法
 */
//item 对应为 TimeInterval 最少为60秒  NSDateComponents CLRegion
+ (UNNotificationTrigger *)_UNNotificationTriggerWithType:(LYJUnitNotificationTriggerType)type item:(id)item andRepeats:(BOOL)repeats;

+ (void)_UNUserNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body identifier:(NSString *)identifier badge:(NSNumber *)badge trigger:(UNNotificationTrigger *)trigger;



#pragma mark NSMutableAttributedStringMethod
/**
 添加富文本
 fullText 必需填写完整的文本
 attributedData 使用链式编程的书写方法
 */
+ (NSMutableAttributedString *)_attributedStringWithFullText:(NSString *)fullText andAttributedData:(void(^)(LYJUnitAttributedData *attributedData))attributedData;

@end
