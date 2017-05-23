//
//  LYJActionSheet.h
//  Unit
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LYJActionSheetClickBlock)(NSInteger index);
@interface LYJActionSheet : UIActionSheet <UIActionSheetDelegate>


@property (copy ,nonatomic) LYJActionSheetClickBlock clickBlock;

@property (copy ,nonatomic) LYJActionSheetClickBlock dismissBlock;

+ (instancetype)_actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)titles;

@end
