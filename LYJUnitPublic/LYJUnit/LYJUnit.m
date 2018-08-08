//
//  LYJUnit.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnit.h"
#import "LYJUnitAttributedData.h"
#import <CoreLocation/CoreLocation.h>
#import "LYJScanHelper.h"
#import <objc/runtime.h>
#import "LYJAlertController.h"
#import "UIColor+LYJColor.h"
#import "NSArray+LYJArray.h"
#import "NSDate+LYJDate.h"
#import "UIImage+LYJImage.h"
@implementation LYJUnit

static NSMutableArray *__KVOHandlers;
+ (void)load
{
    __KVOHandlers = [NSMutableArray array];
}

#pragma mark -----SystemSetting------

+ (UIWindow *)_keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIViewController *)_rootViewController
{
    return [self _keyWindow].rootViewController;
}

+ (UIViewController *)_currentViewController
{
    UIViewController *viewController = [self _rootViewController];
    if ([viewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        viewController = [tabBarController selectedViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.viewControllers.lastObject;
    }
    return viewController;
}

+ (void)_setSystemStatusBarColor:(LYJSystemStatusBarColorType)type
{
    if (type == LYJSystemStatusBarColorBlack)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else if (type == LYJSystemStatusBarColorWhite)
    {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


+ (void)_registerLocalNotification
{
    if (IS_IOS10)
    {
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    }
    else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}



+ (BOOL)_hasOpenLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        return NO;
    }
    return YES;
}

+ (NSString *)_documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)_tempPath
{
    return NSTemporaryDirectory();
}

#pragma mark RuntimeMethod

+ (void)_classCopyPropertyListWithTarget:(id)target confirmBlock:(void (^)(id, NSString *))confirmBlock
{
    Class Class = [target class];
    [self _classCopyPropertyListWithClass:Class confirmBlock:^(NSString *propertyName) {
        id value  = [target valueForKey:propertyName];
        if (confirmBlock)
        {
            confirmBlock(value,propertyName);
        }
    }];
}

+ (void)_classCopyPropertyListWithClass:(Class)Class confirmBlock:(void (^)(NSString *))confirmBlock

{
    unsigned int outCount = 0;
    objc_property_t *propertys = class_copyPropertyList(Class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if (confirmBlock)
        {
            confirmBlock(propertyName);
        }
    }
    free(propertys);
}


+ (void)_classCopyIvarListWithTarget:(id)target confirmBlock:(void (^)(id, NSString *))confirmBlock
{
    Class Class = [target class];
    [self _classCopyIvarListWithClass:Class confirmBlock:^(NSString *key) {
        id value  = [target valueForKey:key];
        if (confirmBlock)
        {
            confirmBlock(value,key);
        }
    }];
}

+ (void)_classCopyIvarListWithClass:(Class)Class confirmBlock:(void (^)(NSString *))confirmBlock
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(Class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if (confirmBlock)
        {
            confirmBlock(key);
        }
    }
    free(ivars);
}

+ (void)_classCopyMethodListWithClass:(Class)Class confirmBlock:(void (^)(NSString *))confirmBlock
{
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(Class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
       ;
        
        NSString *methodName = NSStringFromSelector(method_getName(method));
        if (confirmBlock)
        {
            confirmBlock(methodName);
        }
    }
    free(methods);
}

+ (void)_classCopyMethodListWithTarget:(id)target confirmBlock:(void (^)(SEL, NSString *))confirmBlock
{
    Class Class = [target class];
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(Class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        if (confirmBlock)
        {
            confirmBlock(selector,methodName);
        }
    }
    free(methods);
}

#pragma mark ActionController
+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles viewController:(UIViewController *)viewController clickBlock:(void (^)(NSInteger))clickBlock
{
    return [self _showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles: otherButtonTitles viewController:viewController textFieldCount:0 textFieldsBlock:nil textChangeBlock:nil clickBlock:clickBlock];
}

+ (LYJAlertController *)_showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles viewController:(UIViewController *)viewController textFieldCount:(NSInteger)textFieldCount textFieldsBlock:(void (^)(NSMutableArray <UITextField *>*))textFieldsBlock textChangeBlock:(void(^)(UITextField *,NSString *))textChangeBlock clickBlock:(void (^)(NSInteger))clickBlock
{
    LYJAlertController *alert = [LYJAlertController alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    alert.clickBlock = clickBlock;
    if (textFieldCount > 0)
    {
        NSMutableArray *textFields = [NSMutableArray array];
        for (NSInteger i = 0; i < textFieldCount; i++)
        {
            __block LYJAlertController *blockAlert = alert;
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField addTarget:blockAlert action:@selector(textFieldTextChangeValue:) forControlEvents:UIControlEventEditingChanged];
                [textFields addObject:textField];
            }];
        }
        if (textFieldsBlock)
        {
            textFieldsBlock(textFields);
        }
    }
    
    alert.textChangeBlock = ^(UITextField *textField, NSString *newText) {
        if (textChangeBlock)
        {
            textChangeBlock(textField,newText);
        }
    };
    
    [viewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

+ (LYJAlertController *)_showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles viewController:(UIViewController *)viewController clickBlock:(void (^)(NSInteger))clickBlock
{
    LYJAlertController *alert = [LYJAlertController actionSheetWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveTitle:destructiveTitle otherButtonTitles:otherButtonTitles];
    alert.clickBlock = clickBlock;
    [viewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

#pragma mark ScanMethod

+ (void)_showScanWithView:(UIView *)view complete:(void (^)(NSString *))complete
{
    [[LYJScanHelper manager]addScanWithView:view];
    [LYJScanHelper manager].resultBlock = ^(NSString *result) {
        if (complete)
        {
            complete(result);
        }
    };
    [self _startScanView];
}

+ (void)_hiddenScanView
{
    [self _hiddenScanViewWithRemove:NO];
}

+ (void)_hiddenScanViewWithRemove:(BOOL)remove
{
    [[LYJScanHelper manager]stopScanWithRemove:remove];
}

+ (void)_startScanView
{
    [[LYJScanHelper manager]startScan];
}

#pragma mark -----UIImageMethod------

+ (UIImage *)_createImageWithColor:(UIColor *)color size:(CGSize)size
{
    return [UIImage _createImageWithColor:color size:size];
}


+ (UIImage *)_resizableImageWithCapInsets:(UIEdgeInsets)edgInsets resizingMode:(UIImageResizingMode)resizingMode image:(UIImage *)image
{
    return [image _resizableImageWithCapInsets:edgInsets resizingMode:resizingMode];
}

+ (UIImage *)_codeWithContent:(NSString *)content codeSize:(CGSize)codeSize andMidLogoImage:(UIImage *)logoImage
{
    return [UIImage _codeWithContent:content codeSize:codeSize andMidLogoImage:logoImage];
}

+ (UIImage *)_imageModelAlwaysTemplateWithImage:(UIImage *)image
{
    return [image _imageModelAlwaysTemplate];
}

/**
 压图片质量
 
 @param image image
 @return image
 */

+ (UIImage *)_zipImageWithImage:(UIImage *)image
{
    return [image _zipImage];
}


+ (UIImage *)_zipImageWithImage:(UIImage *)image maxFileSize:(CGFloat)maxFileSize compression:(CGFloat)compression
{
    return [image _zipImageWithMaxFileSize:maxFileSize compression:compression];
}

+ (UIImage *)_changeChromaWithTargetImage:(UIImage *)anImage type:(int)type
{
    return [anImage _changeChromaWithType:type];
}

+ (UIColor *)_imageColorWithImageName:(NSString *)imageName
{
    return [UIImage _imageColorWithImageName:imageName];
}


#pragma mark -----NSArray------

+ (NSArray *)_ascendQuickSortArray:(NSMutableArray *)array
{
    return [array _ascendQuickSort];
}

+ (NSArray *)_descendQuickSortArray:(NSMutableArray *)array
{
    return [array _descendQuickSort];
}

+ (NSArray *)_ascendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath
{
    return [array _ascendQuickSortWithKeyPath:keyPath];
}

+ (NSArray *)_descendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath
{
    return [array _descendQuickSortWithKeyPath:keyPath];
}

+ (NSArray *)_mapWithTargetArray:(NSArray *)array mapBlock:(arrayMapBlock)mapBlock
{
    return [array _mapWithMapBlock:mapBlock];
}

+ (CGFloat)_accumulateWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath
{
    return [array _accumulateWithKeyPath:keyPath];
}

+ (BOOL)_allMatchingWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    return [array _allMatchingWithKeyPath:keyPath matchType:matchType matchValue:matchValue];
}

+ (BOOL)_allNoneMatchingWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    return [array _allNoneMatchingWithKeyPath:keyPath matchType:matchType matchValue:matchValue];
}

+ (NSInteger)_reduceEachIntegerWithArray:(NSArray *)array
{
    return array._reduceEachInteger;
}

+ (CGFloat)_reduceEachFloatWithArray:(NSArray *)array
{
    return array._reduceEachFloat;
}

+ (NSArray *)_takeWithArray:(NSArray *)array count:(NSInteger)count
{
    return [array _takeWithCount:count];
}

+ (NSArray *)_takeLastWithArray:(NSArray *)array count:(NSInteger)count
{
    return [array _takeLastWithCount:count];
}

+ (NSArray *)_takeUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [array _takeUntilWithBlock:block];
}

+ (NSArray *)_takeWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [array _takeWhileWithBlock:block];
}

+ (NSArray *)_skipWithArray:(NSArray *)array skipCount:(NSInteger)skipCount
{
    return [array _skipWithSkipCount:skipCount];
}

+ (NSArray *)_skipLastWithArray:(NSArray *)array skipLastCount:(NSInteger)skipLastCount
{
    return [self _takeWithArray:array count:(array.count - skipLastCount)];
}

+ (NSArray *)_skipUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [array _skipUntilWithBlock:block];
}

+ (NSArray *)_skipWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [array _skipWhileWithBlock:block];
}



#pragma mark -----NSDate------

+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index
{
    return [targetDate _dateNextType:dateType andIndex:index];
}

+ (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType andTargetDate:(NSDate *)targetDate
{
    return [targetDate _dateStrFromDateType:dateType];
}

#pragma mark UIColorMethod

+ (UIColor *)_randomColor
{
    return [UIColor LYJ_randomColor];
}


#pragma mark -----UILocalNotification------

+ (void)_localNotificationWithAlertBody:(NSString *)alertBody
{
    [self _localNotificationWithDate:[NSDate new] alertBody:alertBody key:nil andIsNow:YES];
}

+ (void)_localNotificationWithDate:(NSDate *)date andAlertBody:(NSString *)alertBody
{
    [self _localNotificationWithDate:date alertBody:alertBody key:nil andIsNow:NO];
}

+ (void)_localNotificationWithDate:(NSDate *)date alertBody:(NSString *)alertBody key:(NSString *)key andIsNow:(BOOL)isNow
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    if (key)
    {
        localNotification.userInfo = @{@"key":key};
    }
    localNotification.alertBody = alertBody;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    if (isNow)
    {
        [[UIApplication sharedApplication]presentLocalNotificationNow:localNotification];
    }
    else
    {

    
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    }
}

+ (void)_cancelLocalNotificationWithKey:(NSString *)key
{
    UILocalNotification *targetLocalNotification = nil;
    NSArray *localNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *localNotification in localNotifications)
    {
        
        if ([key isEqualToString:localNotification.userInfo[@"key"]])
        {
            targetLocalNotification = localNotification;
            break;
        }
    }
    if (targetLocalNotification)
    {
        NSLog(@"取消目标的key:%@",key);
        [[UIApplication sharedApplication]cancelLocalNotification:targetLocalNotification];
    }
}

+ (void)_cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (UNNotificationTrigger *)_UNNotificationTriggerWithType:(LYJUnitNotificationTriggerType)type item:(id)item andRepeats:(BOOL)repeats
{
    UNNotificationTrigger *trigger = nil;
    switch (type) {
        case LYJUnitNotificationTriggerTypeTimeInterval:
        {
            trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:[item floatValue] repeats:repeats];
        }
            break;
        case LYJUnitNotificationTriggerTypeCalendar:
        {
            trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:item repeats:repeats];
        }
            break;
        case LYJUnitNotificationTriggerTypeLocation:
        {
            trigger = [UNLocationNotificationTrigger triggerWithRegion:item repeats:repeats];
        }
            break;
        default:
            break;
    }
    return trigger;
}

+ (void)_UNUserNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body identifier:(NSString *)identifier badge:(NSNumber *)badge trigger:(UNNotificationTrigger *)trigger
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //        UNMutableNotificationContent *mutableContent = [UNMutableNotificationContent new];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body;
    content.badge = badge;
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark -----NSMutableAttributedString------
+ (NSMutableAttributedString *)_attributedStringWithFullText:(NSString *)fullText andAttributedData:(void (^)(LYJUnitAttributedData *))attributedData
{
    return [LYJUnitAttributedData  attributedStringWithFullText:fullText attributedData:attributedData];
}


#pragma mark UIViewMethod
+ (UIView *)_subViewOfClassName:(NSString *)className
                    targetView:(UIView *)targetView
{
    for (UIView *subView in targetView.subviews)
    {
        if ([NSStringFromClass(subView.class) isEqualToString:className])
        {
            return subView;
        }
        for (UIView *subTargetView in subView.subviews) {
            UIView* resultFound = [self _subViewOfClassName:className targetView:subTargetView];
            if (resultFound)
            {
                return resultFound;
            }
        }

    }
    return nil;
}

+ (NSMutableAttributedString *)_attributedStringWithShadowColor:(UIColor *)color offset:(CGSize)offset blurRadius:(CGFloat)bluradius attributedString:(NSMutableAttributedString *)attributedString
{

    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = bluradius;
    shadow.shadowOffset = offset;
    shadow.shadowColor = color;
    [attributedString addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}



+ (NSDictionary *)_classNameDictOfTargetView:(UIView *)targetView
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in targetView.subviews)
    {
        NSString *subViewClassName = NSStringFromClass(subView.class);
        [array addObject:subViewClassName];
        if (subView.subviews.count > 0)
        {
            NSDictionary *subDict = [self _classNameDictOfTargetView:subView];
            [dict setObject:subDict forKey:subViewClassName];
        }
    }
    [dict setObject:array forKey:NSStringFromClass(targetView.class)];
    return dict;
}

+ (void)_cornerRadius:(CGFloat)cornerRadius
          borderWidth:(CGFloat)borderWidth
          borderColor:(UIColor *)borderColor
        masksToBounds:(BOOL)masksToBounds
                 view:(UIView *)view
{
    view.layer.cornerRadius = cornerRadius;
    if (borderColor)
    {
        view.layer.borderColor = borderColor.CGColor;
    }
    view.layer.masksToBounds = masksToBounds;
    view.layer.borderWidth = borderWidth;
}



#pragma mark LayerMethod

+ (CAShapeLayer *)_bezierPathByView:(UIView *)view roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return maskLayer;
}

+ (void)_bezierPathWithView:(UIView *)view shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset andShadowOpacity:(CGFloat)shadowOpacity
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];

    view.layer.masksToBounds = NO;

    view.layer.shadowColor = shadowColor.CGColor;

    view.layer.shadowOffset = shadowOffset;

    view.layer.shadowOpacity = shadowOpacity;

    view.layer.shadowPath = shadowPath.CGPath;
}

//    NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
//    dotteLine.lineDashPhase = 1.0;
//    dotteLine.lineDashPattern = arr;
+ (CAShapeLayer *)_drawCircleWithCircleFrame:(CGRect)frame strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth
{
    CAShapeLayer *circleShapeLayer =  [CAShapeLayer layer];
    CGMutablePathRef dottePath =  CGPathCreateMutable();
    circleShapeLayer.lineWidth = lineWidth ;
    circleShapeLayer.strokeColor = strokeColor.CGColor;
    circleShapeLayer.fillColor = fillColor.CGColor;
    CGPathAddEllipseInRect(dottePath, nil, frame);
    circleShapeLayer.path = dottePath;
    CGPathRelease(dottePath);
    return circleShapeLayer;
}

+ (CAShapeLayer *)_drawArcWithCenter:(CGPoint)center
                              radius:(CGFloat)radius
                          startAngle:(CGFloat)startAngle
                            endAngle:(CGFloat)endAngle
                           clockwise:(BOOL)clockwise
                      layerLineWidth:(CGFloat)lineWidth
                    layerStrokeColor:(UIColor *)strokeColor
                      layerFillColor:(UIColor *)fillColor
                        layerLineCap:(NSString *)lineCap
                          animations:(void(^)(CAShapeLayer *shapeLayer))animations
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];

    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    if (!lineCap)
    {
        lineCap = kCALineCapButt;
    }
    shapeLayer.lineCap = lineCap;

    if (animations)
    {
        animations(shapeLayer);
    }
    return shapeLayer;
}


+ (NSArray *)_gradientLayerColorsForColors:(NSArray<UIColor *> *)colors
{
    NSMutableArray *targetColors = [NSMutableArray array];
    for (UIColor *color in colors)
    {
        [targetColors addObject:(__bridge id)color.CGColor];
    }
    return targetColors;
}


+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors originType:(LYJGradientLayerType)originType endType:(LYJGradientLayerType)endType targetView:(UIView *)view
{
    return [self _gradientLayerWithColors:colors startPoint:[self _pointWithGradientLayerType:originType] endPoint:[self _pointWithGradientLayerType:endType] targetView:view];
}

+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint targetView:(UIView *)view
{
    return [self _gradientLayerWithColors:colors startPoint:startPoint endPoint:endPoint locations:nil targetView:view];
}


+ (CAGradientLayer *)_gradientLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint locations:(NSArray *)locations targetView:(UIView *)view
{
    CAGradientLayer *gradientLayer = nil;
    NSArray *sulayers = [view.layer sublayers];
    for (CALayer *layer in sulayers)
    {
        if ([layer isKindOfClass:[CAGradientLayer class]])
        {
            gradientLayer = (CAGradientLayer *)layer;
            break;
        }
    }


    if (!gradientLayer)
    {
        gradientLayer = [CAGradientLayer layer];
        [view.layer addSublayer:gradientLayer];
    }


    gradientLayer.frame = view.bounds;


    //set gradient colors
    if (colors) gradientLayer.colors = colors;

    //set locations
    if (locations) gradientLayer.locations = locations;

    //set gradient start and end points
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;

    return gradientLayer;
}

+ (CGPoint)_pointWithGradientLayerType:(LYJGradientLayerType)type
{
    CGPoint point = CGPointZero;
    switch (type) {
        case LYJGradientLayerTypeTopLeft:
            point = CGPointMake(0, 0);
            break;
        case LYJGradientLayerTypeTopMid:
            point = CGPointMake(0.5, 0);
            break;
        case LYJGradientLayerTypeTopRight:
            point = CGPointMake(1, 0);
            break;
        case LYJGradientLayerTypeMidLeft:
            point = CGPointMake(0, 0.5);
            break;
        case LYJGradientLayerTypeMidMid:
            point = CGPointMake(0.5, 0.5);
            break;
        case LYJGradientLayerTypeMidRight:
            point = CGPointMake(1, 0.5);
            break;
        case LYJGradientLayerTypeBottomLeft:
            point = CGPointMake(0, 1);
            break;
        case LYJGradientLayerTypeBottomMid:
            point = CGPointMake(0.5, 1);
            break;
        case LYJGradientLayerTypeBottomRight:
            point = CGPointMake(1, 1);
            break;
        default:
            point = CGPointZero;
            break;
    }

    return point;
}

@end
