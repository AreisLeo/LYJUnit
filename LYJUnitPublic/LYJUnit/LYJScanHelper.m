//
//  LYJScanHelper.m
//  Fit
//
//  Created by Aries li on 2017/4/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYJScanHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "LYJUnitMacro.h"
@interface LYJScanHelper () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong ,nonatomic) AVCaptureVideoPreviewLayer *layer;

@end

@implementation LYJScanHelper
static LYJScanHelper *_manager = nil;
static dispatch_once_t onceToken;
static AVCaptureSession *_session;
+ (LYJScanHelper *)manager
{

    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        _session =  [[AVCaptureSession alloc]init];
    });
    return _manager;
}


- (void)addScanWithView:(UIView *)view
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied||
       authStatus == AVAuthorizationStatusNotDetermined)
    {
        kWeakSelf;
        /**
         请求权限方法
         */
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            if (granted)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setSessionWithView:view];
                });
            }
            else
            {
                
            }
        }];
    }
    else
    {
        [self setSessionWithView:view];
    }
}

- (void)setSessionWithView:(UIView *)view
{
    [_session removeInput:[_session.inputs lastObject]];
    [_session removeOutput:[_session.outputs lastObject]];
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input)
    {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        self.layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        self.layer.frame = view.bounds;
        [view.layer insertSublayer:self.layer atIndex:0];
    }

}

- (void)startScan
{
    [_session startRunning];
}

- (void)stopScan
{
    [self stopScanWithRemove:NO];
}

- (void)stopScanWithRemove:(BOOL)remove
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_session stopRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (remove)
            {
                //移除扫描视图:
                [self.layer removeFromSuperlayer];
                self.layer = nil;
            }
        });

    }) ;


}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        if (self.resultBlock)
        {
            self.resultBlock( metaDataObject.stringValue);
        }
    }
}

@end
