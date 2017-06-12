//
//  UIAlertController+Category.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/12.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "UIAlertController+Category.h"
#import <objc/runtime.h>
@implementation UIAlertController (Category)

@end


@implementation UIAlertAction (Category)

static char *ActionIndexLYJ = "ActionIndexLYJ";
- (void)setActionIndex:(NSInteger)actionIndex
{
    objc_setAssociatedObject(self, ActionIndexLYJ, @(actionIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)actionIndex
{
    return [objc_getAssociatedObject(self, ActionIndexLYJ) integerValue];
}

@end
