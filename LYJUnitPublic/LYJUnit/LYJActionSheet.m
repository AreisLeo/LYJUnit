//
//  LYJActionSheet.m
//  Unit
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYJActionSheet.h"
#import "LYJUnitMacro.h"
@implementation LYJActionSheet

+ (instancetype)_actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)titles
{
    LYJActionSheet *actionSheet = [[LYJActionSheet alloc]initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles: nil];
    for (NSString *title in titles)
    {
        [actionSheet addButtonWithTitle:title];
    }
    
    
    [actionSheet showInView:KeyWindow];
    return actionSheet;
}
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)titles
{
    LYJActionSheet *actionSheet = [[LYJActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles: nil];
    actionSheet.delegate = actionSheet;
    return actionSheet;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickBlock)
    {
        self.clickBlock(buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.dismissBlock)
    {
        self.dismissBlock(buttonIndex);
    }
}


@end
