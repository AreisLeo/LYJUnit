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

@class LYJUnitAttributedData,LYJKVOHandler,LYJAlertController;

@interface LYJUnit : NSObject

#pragma mark SystemSettingMethod
/**
 快速返回当前 keywindow
 */
+ (UIWindow *)_keyWindow;


/**
 快速返回当前 keywindow.rootViewController
 */
+ (UIViewController *)_rootViewController;

/**
 返回当前 viewcontroller
 */
+ (UIViewController *)_currentViewController;




/**
 需要在 info.plist 中添加 View controller-based status bar appearance = NO 才能生效

 @param type LYJSystemStatusBarColorType 控制StatusBar Color
 */
+ (void)_setSystemStatusBarColor:(LYJSystemStatusBarColorType)type;


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

/**
 系统文件夹方法
 */
+ (NSString *)_documentPath;

+ (NSString *)_tempPath;

#pragma mark RuntimeMethod
/** 
 获取属性列表
 */
+ (void)_classCopyPropertyListWithTarget:(id)target confirmBlock:(void(^)(id value, NSString *propertyName))confirmBlock;;
/**
 获取属性列表 和 value值 kvc方法
 */
+ (void)_classCopyPropertyListWithClass:(Class)Class confirmBlock:(void(^)(NSString *propertyName))confirmBlock;

/**
 获取整个成员变量列表
 */
+ (void)_classCopyIvarListWithClass:(Class)Class confirmBlock:(void(^)(NSString *key))confirmBlock;

/**
 获取整个成员变量列表 和 value值 kvc方法
 */
+ (void)_classCopyIvarListWithTarget:(id)target confirmBlock:(void(^)(id value, NSString *key))confirmBlock;
/**
 获取所有方法的数组
 */
+ (void)_classCopyMethodListWithClass:(Class)Class confirmBlock:(void(^)(NSString *methodName))confirmBlock;

/**
 获取所有方法的数组 和 value值 kvc方法
 */
+ (void)_classCopyMethodListWithTarget:(id)target confirmBlock:(void(^)(SEL method, NSString *methodName))confirmBlock;

#pragma mark ActionController

/**
 showAlertView
 */
+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles viewController:(UIViewController *)viewController clickBlock:(void(^)(NSInteger index))clickBlock;

/**
 showAlertView 带textField textField数量自定义
 */
+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles viewController:(UIViewController *)viewController textFieldCount:(NSInteger)textFieldCount textFieldsBlock:(void(^)(NSMutableArray <UITextField *>*textFields))textFieldsBlock textChangeBlock:(void(^)(UITextField *textField,NSString *newText))textChangeBlock clickBlock:(void(^)(NSInteger index))clickBlock;

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


/**
 *  渐变颜色 使用图片
 */
+ (UIColor *)_textColorWithImage:(NSString *)image;

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

/**
 数据转换 mapBlock 返回需要的转换 model
 */
+ (NSArray *)_mapWithTargetArray:(NSArray *)array mapBlock:(arrayMapBlock)mapBlock;

/**
 累加计算 当 keyPath 为 nil 时 直接取出 floatValue
 */
+ (CGFloat)_accumulateWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath;

/**
 计算当前数组是否全部满足条件 当其它一个不满足时返回 NO
 */
+ (BOOL)_allMatchingWithWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue;

/**
 计算当前数组是否全部不满足条件 当其它一个满足时返回 NO
 */
+ (BOOL)_allNoneMatchingWithWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue;

/**
 求和 integer
 */
+ (NSInteger)_reduceEachIntegerWithArray:(NSArray *)array;

/**
 求和 float
 */
+ (CGFloat)_reduceEachFloatWithArray:(NSArray *)array;

/**
 取出当前数组需要的 count,count 后面的直接放弃 从前到后
 */
+ (NSArray *)_takeWithArray:(NSArray *)array count:(NSInteger)count;

/**
 取出当前数组需要的 count,count 前面的直接放弃 从后到前
 */
+ (NSArray *)_takeLastWithArray:(NSArray *)array count:(NSInteger)count;

/**
 取出当前数组中符合条件的值 当不条件符合后 后面不再进行条件判断 直接返回
 */
+ (NSArray *)_takeUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block;

/**
 取出当前数组中不符合条件的值 当条件符合后 后面不再进行条件判断 直接返回
 */
+ (NSArray *)_takeWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block;

/**
 取出当前数组跳过的 count 后的值 取后值
 */
+ (NSArray *)_skipWithArray:(NSArray *)array skipCount:(NSInteger)skipCount;

/**
 取出当前数组最后跳过的 count 前的值 取前值
 */
+ (NSArray *)_skipLastWithArray:(NSArray *)array skipLastCount:(NSInteger)skipLastCount;

/**
 取出当前数组中符合条件的值 当条件符合后 后面不再进行条件判断
 */
+ (NSArray *)_skipUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block;

/**
 取出当前数组中不符合条件的值 当条件符合后 后面不再进行条件判断
 */
+ (NSArray *)_skipWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block;

#pragma mark NSDateMethod
/**
 求出下一天 一月 一年 或者 上一天  上一月 上一年
 year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
 返回的是 修改后的时间
 */
+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index;

+ (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType andTargetDate:(NSDate *)targetDate;

#pragma mark UIColorMethod

/**
 生成随机颜色

 @return 随机 color 值
 */
+ (UIColor *)_randomColor;

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


/**
 文字投影

 @param color 投影颜色
 @param offset 投影面积
 @param bluradius 模糊程度
 @param attributedString 需要添加的对象文本
 @return 添加完成后的对象文本
 */
+ (NSMutableAttributedString *)_attributedStringWithShadowColor:(UIColor *)color offset:(CGSize)offset blurRadius:(CGFloat)bluradius attributedString:(NSMutableAttributedString *)attributedString;

#pragma mark UIViewMethod
/**
 输入 classname 可直接从 targetView 中获取到对应的 view ,如果所有子 view 都不包含情况下返回 nil 只能从 subviews 中存在的 view 搜索得到
 classname 需要获取的 view 的 ClassName
 targetView 目标查找的targetView
 */
+ (UIView *)_subViewOfClassName:(NSString *)className
                    targetView:(UIView *)targetView;

/**
 targetView 中获取到对应的 view ,返回所有 subview 中可以搜索 view 到的 ClassName
 targetView 目标查找的targetView
 */
+ (NSDictionary *)_classNameDictOfTargetView:(UIView *)targetView;

/**
 *  创建视图的属性
 *
 *  @param cornerRadius 圆角
 *  @param borderWidth  描边宽度
 *  @param borderColor  描边颜色
 *  @param view         视图
 *  @param masksToBounds 是否删除多余的视图
 *
 */
+ (void)_cornerRadius:(CGFloat)cornerRadius
          borderWidth:(CGFloat)borderWidth
          borderColor:(UIColor *)borderColor
        masksToBounds:(BOOL)masksToBounds
                 view:(UIView *)view;


#pragma mark LayerMethod
/**
 添加圆角，使用UIBezierPath

 @param view 需要圆角的视图
 @param corners 需要的圆角的角 可以UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight|
 @param cornerRadii 圆角的大小
 */
+ (CAShapeLayer *)_bezierPathByView:(UIView *)view roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 投影
 */
+ (void)_bezierPathWithView:(UIView *)view shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset andShadowOpacity:(CGFloat)shadowOpacity;


/**
 画圆

 @param frame 需要画的frame
 @param strokeColor 描边颜色
 @param fillColor 填充颜色
 @param lineWidth 线宽
 @return CAShapeLayer
 */
+ (CAShapeLayer *)_drawCircleWithCircleFrame:(CGRect)frame strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth;

/**
 描写扇形

 @param center 起点
 @param radius 半径
 @param startAngle 开始位置
 @param endAngle 结束位置
 @param clockwise 顺时针
 @param lineWidth 半径宽度
 @param strokeColor 描边颜色
 @param fillColor 填充颜色
 @param lineCap kCALineCapButt 默认
 @param animations 动画block
 @return shapeLayer
 */
+ (CAShapeLayer *)_drawArcWithCenter:(CGPoint)center
                              radius:(CGFloat)radius
                          startAngle:(CGFloat)startAngle
                            endAngle:(CGFloat)endAngle
                           clockwise:(BOOL)clockwise
                      layerLineWidth:(CGFloat)lineWidth
                    layerStrokeColor:(UIColor *)strokeColor
                      layerFillColor:(UIColor *)fillColor
                        layerLineCap:(NSString *)lineCap
                          animations:(void(^)(CAShapeLayer *shapeLayer))animations;

/**
 *  渐变颜色 layer层
 */
+ (NSArray *)_gradientLayerColorsForColors:(NSArray <UIColor *>*)colors;

+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors originType:(LYJGradientLayerType)originType endType:(LYJGradientLayerType)endType targetView:(UIView *)view;

+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint targetView:(UIView *)view;

+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations targetView:(UIView *)view;
@end
