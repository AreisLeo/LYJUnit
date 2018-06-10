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

+ (UIColor *)_textColorWithImage:(NSString *)image
{
    return [UIColor colorWithPatternImage:[UIImage
                                           imageNamed:image]];
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

+ (NSArray *)_mapWithTargetArray:(NSArray *)array mapBlock:(arrayMapBlock)mapBlock
{
    if (!mapBlock) return @[];
    NSMutableArray *mapArray = [NSMutableArray array];
    for (id model in array)
    {
        id targetValue = mapBlock(model);
        [mapArray addObject:targetValue];
    }
    return mapArray;
}

+ (CGFloat)_accumulateWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath
{
    CGFloat floatValue = 0.0f;
    for (id model in array)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        floatValue += [targetValue floatValue];
    }
    return floatValue;
}

+ (BOOL)_allMatchingWithWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    BOOL allMatch = YES;
    for (id model in array)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        allMatch = [self _modelWithMatchType:matchType matchValue:matchValue targetValue:targetValue];
        if (!allMatch)
        {
            return allMatch;
        }
    }
    return allMatch;
}

+ (BOOL)_allNoneMatchingWithWithTargetArray:(NSArray *)array keyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    BOOL allMatch = NO;
    for (id model in array)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        allMatch = [self _modelWithMatchType:matchType matchValue:matchValue targetValue:targetValue];
        if (allMatch)
        {
            return allMatch;
        }
    }
    return allMatch;
}

+ (id)_targetValueWithKeyPath:(NSString *)keyPath model:(id)model
{
    id targetValue = keyPath && (keyPath.length > 0) ? [model objectForKey:keyPath] : model;
    return targetValue;
}


+ (BOOL)_modelWithMatchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue targetValue:(id)targetValue
{
    if (![matchValue isKindOfClass:[NSString class]])
    {
        matchType = LYJUnitMatchTypeContains;
    }
    BOOL isContains = YES;
    switch (matchType)
    {
        case LYJUnitMatchTypePrefix:
        {
            isContains = [targetValue hasPrefix:matchValue];
        }
            break;
        case LYJUnitMatchTypeSuffix:
        {
            isContains = [targetValue hasSuffix:matchValue];
        }
            break;
        case LYJUnitMatchTypeContainsString:
        {
            isContains = [targetValue containsString:matchValue];
        }
            break;
        case LYJUnitMatchTypeContains:
        default:
        {
            isContains = [targetValue containsObject:matchValue];
        }
            break;
    }
    return isContains;
}

+ (NSInteger)_reduceEachIntegerWithArray:(NSArray *)array
{
    NSInteger originalNum = 0;
    for (NSNumber *number in array)
    {
        originalNum += number.integerValue;
    }
    return originalNum;
}

+ (CGFloat)_reduceEachFloatWithArray:(NSArray *)array
{
    CGFloat originalNum = 0;
    for (NSNumber *number in array)
    {
        originalNum += number.floatValue;
    }
    return originalNum;
}

+ (NSArray *)_takeWithArray:(NSArray *)array count:(NSInteger)count
{
    if (count == 0) return @[];

    __block NSMutableArray *takeArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeArray addObject:obj];
        if (idx + 1 == count)
        {
            *stop = YES;
        }
    }];
    return takeArray;
}

+ (NSArray *)_takeLastWithArray:(NSArray *)array count:(NSInteger)count
{
    if (count == 0) return @[];

    __block NSMutableArray *takeArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeArray addObject:obj];
        while (takeArray.count > count)
        {
            [takeArray removeObjectAtIndex:0];
        }
    }];
    return takeArray;
}

+ (NSArray *)_takeUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    if (!block) return @[];

    NSMutableArray *takeUntilArray = [NSMutableArray array];
    for (id model in array)
    {
        BOOL predicate = block(model);
        if (predicate)
        {
            [takeUntilArray addObject:model];
        }
        else
        {
            break;
        }
    }
    return takeUntilArray;
}

+ (NSArray *)_takeWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [self _takeUntilWithArray:array block:^BOOL(id value) {
        BOOL predicate = block(value);
        return !predicate;
    }];
}

+ (NSArray *)_skipWithArray:(NSArray *)array skipCount:(NSInteger)skipCount
{
    __block NSMutableArray *skipArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > skipCount)
        {
            [skipArray addObject:obj];
        }
    }];
    return skipArray;
}

+ (NSArray *)_skipLastWithArray:(NSArray *)array skipLastCount:(NSInteger)skipLastCount
{
    return [self _takeWithArray:array count:(array.count - skipLastCount)];
}

+ (NSArray *)_skipUntilWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    if (!block) return @[];

    BOOL skipping = YES;
    NSMutableArray *skipUntilArray = [NSMutableArray array];
    for (id model in array)
    {
        if (skipping)
        {
            BOOL predicate = block(model);
            if (predicate)
            {
                skipping = NO;
                [skipUntilArray addObject:model];
            }
        }
        else
        {
            [skipUntilArray addObject:model];
        }
    }
    return skipUntilArray;
}

+ (NSArray *)_skipWhileWithArray:(NSArray *)array block:(valuePredicateBlock)block
{
    return [self _skipUntilWithArray:array block:^BOOL(id value) {
        BOOL predicate = block(value);
        return !predicate;
    }];
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

#pragma mark UIColorMethod

+ (UIColor *)_randomColor
{
    CGFloat r = arc4random()% 256;
    CGFloat g = arc4random()% 256;
    CGFloat b = arc4random()% 256;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1];
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
