//
//  LYJAlertController.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/12.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJAlertController.h"
#import "UIAlertController+Category.h"
@interface LYJAlertController ()

@end

@implementation LYJAlertController

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    return [self alertControllerWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveTitle:nil otherButtonTitles:otherButtonTitles preferredStyle:UIAlertControllerStyleAlert];
}


+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    return [self alertControllerWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveTitle:destructiveTitle otherButtonTitles:otherButtonTitles preferredStyle:UIAlertControllerStyleActionSheet];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveTitle:(NSString *)destructiveTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    NSInteger count = 0;
    LYJAlertController *alert = [super alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (cancelButtonTitle)
    {
        UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (alert.clickBlock)
            {
                alert.clickBlock(action.actionIndex);
            }
        }];
        cancelAlertAction.actionIndex = count;
        count++;
        [alert addAction:cancelAlertAction];
    }
    if (destructiveTitle)
    {
        UIAlertAction *destructiveAlertAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (alert.clickBlock)
            {
                alert.clickBlock(action.actionIndex);
            }
        }];

        destructiveAlertAction.actionIndex = count;
        count++;
        [alert addAction:destructiveAlertAction];
    }
    for (NSString *title in otherButtonTitles)
    {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            alert.clickBlock(action.actionIndex);
        }];
        alertAction.actionIndex = count;
        count++;
        [alert addAction:alertAction];
    }
    return alert;
}

- (void)textFieldTextChangeValue:(UITextField *)textField
{
    if (self.textChangeBlock)
    {
        self.textChangeBlock(textField, textField.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
