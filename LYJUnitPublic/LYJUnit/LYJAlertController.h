//
//  LYJAlertController.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/12.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYJAlertController : UIAlertController


+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles;

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 点击block */
@property (copy ,nonatomic) void(^clickBlock)(NSInteger index);
@end
