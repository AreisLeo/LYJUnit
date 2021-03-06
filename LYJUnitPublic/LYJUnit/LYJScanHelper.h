//
//  LYJScanHelper.h
//  Fit
//
//  Created by Aries li on 2017/4/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LYJScanHelper : NSObject
#pragma mark 请在plist文件中添加 Privacy - Camera Usage Description 
/**
 回调
 */

/** rectOfInterest这个方法设置的区域是相对于设备的大小的，默认值是CGRectMake(0, 0, 1, 1)，是有比例关系的 */
@property (assign ,nonatomic) CGRect rectOfInterest;

@property (strong ,nonatomic) void(^resultBlock)(NSString *result);

+ (LYJScanHelper *)manager;

- (void)addScanWithView:(UIView *)view;

- (void)startScan;

- (void)stopScan;

- (void)stopScanWithRemove:(BOOL)remove;
@end
