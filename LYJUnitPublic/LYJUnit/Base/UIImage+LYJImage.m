//
//  UIImage+LYJImage.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "UIImage+LYJImage.h"

@implementation UIImage (LYJImage)

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


- (UIImage *)_resizableImageWithCapInsets:(UIEdgeInsets)edgInsets resizingMode:(UIImageResizingMode)resizingMode
{
    return [self resizableImageWithCapInsets:edgInsets resizingMode:resizingMode];
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

- (UIImage *)_imageModelAlwaysTemplate
{
    UIImage *changeImage = nil;
    changeImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return changeImage;
}


/**
 压图片质量
 
 @return image
 */

- (UIImage *)_zipImage
{
    return [self _zipImageWithMaxFileSize:30 * 1000 compression:0.9f];
}


- (UIImage *)_zipImageWithMaxFileSize:(CGFloat)maxFileSize compression:(CGFloat)compression
{
    if (!self) {
        return nil;
    }
    NSData *compressedData = UIImageJPEGRepresentation(self, 1);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([self  compressNewWidth:self.size.width * compression], compression);
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
- (UIImage *)compressNewWidth:(CGFloat)newImageWidth
{
    if (!self) return nil;
    float imageWidth = self.size.width;
    float imageHeight = self.size.height;
    float width = newImageWidth;
    float height = self.size.height/(self.size.width/width);

    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));

    if (widthScale > heightScale) {
        [self drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [self drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }

    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    return newImage;

}

- (UIImage *)_changeChromaWithType:(int)type
{
    CGImageRef imageRef = self.CGImage;

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

+ (UIColor *)_imageColorWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [UIColor colorWithPatternImage:image];
}


@end
