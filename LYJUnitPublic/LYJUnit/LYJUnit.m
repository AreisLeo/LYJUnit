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
#import "LYJKVOHandler.h"
@implementation LYJUnit

static NSMutableArray *__KVOHandlers;
+ (void)load
{
    __KVOHandlers = [NSMutableArray array];
}

#pragma mark -----SystemSetting------
+ (void)_registerLocalNotification
{
    if ([self _ISIOS10])
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

+ (BOOL)_ISIOS10
{
    return [self _ISIOSWithVersion:10.0];
}

+ (BOOL)_ISIOSWithVersion:(CGFloat)version
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if ([[[phoneVersion componentsSeparatedByString:@"."]firstObject]floatValue] >= version)
    {
        return YES;
    }
    return NO;
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


#pragma mark KVOMethod
+ (LYJKVOHandler *)_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)valueChangeBlock
{
    LYJKVOHandler *KVOHandler = [LYJKVOHandler _addObserver:target forKeyPath:keyPath valueChangeBlock:valueChangeBlock];
    [__KVOHandlers addObject:KVOHandler];
    NSLog(@"%@",__KVOHandlers);
    return KVOHandler;
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
    CGRect rect = CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+ (UIImage *)_resizableImageWithCapInsets:(UIEdgeInsets)edgInsets resizingMode:(UIImageResizingMode)resizingMode image:(UIImage *)image
{
    return [image resizableImageWithCapInsets:edgInsets resizingMode:resizingMode];
}

+ (UIImage *)_codeWithContent:(NSString *)content codeSize:(CGSize)codeSize andMidLogoImage:(UIImage *)logoImage
{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage *qrocdeImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:codeSize.width];
    
    UIGraphicsBeginImageContext(codeSize);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrocdeImage drawInRect:CGRectMake(0, 0, codeSize.width, codeSize.width)];
    
    //再把小图片画上去
    if (logoImage)
    {
        UIImage *sImage = logoImage;
        CGFloat sImageW =  codeSize.width * 0.2;
        CGFloat sImageH = sImageW;
        CGFloat sImageX = (codeSize.width - sImageW) * 0.5;
        CGFloat sImgaeY = (codeSize.width - sImageH) * 0.5;
        
        [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    }
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return finalyImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    
    
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    return [UIImage imageWithCGImage:scaledImage];
    
}

+ (UIImage *)_imageModelAlwaysTemplateWithImage:(UIImage *)image
{
    UIImage *changeImage = nil;
    changeImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return changeImage;
}


/**
 压图片质量
 
 @param image image
 @return image
 */

+ (UIImage *)_zipImageWithImage:(UIImage *)image
{
    return [self _zipImageWithImage:image maxFileSize:30*1000 compression:0.9f];
}


+ (UIImage *)_zipImageWithImage:(UIImage *)image maxFileSize:(CGFloat)maxFileSize compression:(CGFloat)compression
{
    if (!image) {
        return nil;
    }
    NSData *compressedData = UIImageJPEGRepresentation(image, 1);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([self  compressImage:image newWidth:image.size.width*compression], compression);
    }
    return [UIImage imageWithData:compressedData];
}



/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImage *)_changeChromaWithTargetImage:(UIImage *)anImage type:(int)type
{
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
    
}

#pragma mark -----NSArray------

+ (void)_ascendQuickSortArray:(NSMutableArray *)array
{
    [self _quickSortArray:array leftIndex:0 andRightIndex:array.count - 1];
}

+ (void)_descendQuickSortArray:(NSMutableArray *)array
{
    [self _ascendQuickSortArray:array];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    [array removeAllObjects];
    for (id item in tempArray)
    {
        [array insertObject:item atIndex:0];
    }
}

//排序
+ (void)_quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] floatValue];
    
    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] floatValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] floatValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    //将基准数放到正确位置
    array[i] = @(key);
    
    /**** 递归排序 ***/
    //排序基准数左边的
    [self _quickSortArray:array leftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self _quickSortArray:array leftIndex:i + 1 andRightIndex:rightIndex];
}

+ (void)_ascendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath
{
    [self _quickSortArray:array keyPath:keyPath leftIndex:0 andRightIndex:array.count - 1];
}

+ (void)_descendQuickSortArray:(NSMutableArray *)array andKeyPath:(NSString *)keyPath
{
    [self _ascendQuickSortArray:array andKeyPath:keyPath];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    [array removeAllObjects];
    for (id item in tempArray)
    {
        [array insertObject:item atIndex:0];
    }
}

+ (void)_quickSortArray:(NSMutableArray *)array keyPath:(NSString *)keyPath leftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    id item = array[i] ;
    CGFloat keyPathValue = [[item valueForKey:keyPath] floatValue];
    while (i < j) {
        while (i < j && [self _getValueWithKeyPath:keyPath index:j andSortArray:array] >= keyPathValue) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [self _getValueWithKeyPath:keyPath index:i andSortArray:array] <= keyPathValue) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = item;
    [self _quickSortArray:array keyPath:keyPath leftIndex:leftIndex andRightIndex:i - 1];
    [self _quickSortArray:array keyPath:keyPath leftIndex:i + 1 andRightIndex:rightIndex];
}

+ (CGFloat)_getValueWithKeyPath:(NSString *)keyPath index:(NSInteger)index andSortArray:(NSArray *)array
{
    id item = array[index] ;
    return [[item valueForKey:keyPath] floatValue];
}


#pragma mark -----NSDate------

+ (NSDate *)_dateNextType:(LYJUnitDateNextType)dateType targetDate:(NSDate *)targetDate andIndex:(NSInteger)index
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    switch (dateType)
    {
        case LYJUnitDateNextTypeMinute:
            [lastMonthComps setMinute: -index];
            break;
        case LYJUnitDateNextTypeHour:
            [lastMonthComps setHour: -index];
            break;
        case LYJUnitDateNextTypeDay:
            [lastMonthComps setDay: -index];
            break;
        case LYJUnitDateNextTypeMonth:
            [lastMonthComps setMonth: -index];
            break;
        case LYJUnitDateNextTypeYear:
            [lastMonthComps setYear: -index];
            break;
        default:
            break;
    }
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:targetDate options:0];
    return newdate;
}

+ (NSString *)_dateStrFromDateType:(LYJUnitDateType)dateType andTargetDate:(NSDate *)targetDate
{
    NSString *dateTypeStr = @"yyyy-MM-dd HH:mm:ss";
    switch (dateType) {
        case LYJUnitDateTypeHH:
            dateTypeStr = @"HH";
            break;
        case LYJUnitDateTypeHHMM:
            dateTypeStr = @"HH:mm";
            break;
        case LYJUnitDateTypeHHMMSS:
            dateTypeStr = @"HH:mm:ss";
            break;
        case LYJUnitDateTypeDD:
            dateTypeStr = @"dd";
            break;
        case LYJUnitDateTypeMMDD:
            dateTypeStr = @"MM-dd";
            break;
        case LYJUnitDateTypeYYYYMMDD:
            dateTypeStr = @"yyyy-MM-dd";
            break;
        case LYJUnitDateTypeYYYYMMDDHH:
            dateTypeStr = @"yyyy-MM-dd HH";
            break;
        case LYJUnitDateTypeYYYYMMDDHHMM:
            dateTypeStr = @"yyyy-MM-dd HH:mm";
            break;
        case LYJUnitDateTypeYYYYMMDDHHMMSS:
            dateTypeStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateTypeStr];
    return [dateFormatter stringFromDate:targetDate];
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
    LYJUnitAttributedData *data = [LYJUnitAttributedData dataWithFullText:fullText];
    if (attributedData) attributedData(data);
    return [data attributedString];
}
@end
