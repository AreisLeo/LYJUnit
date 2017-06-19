//
//  NSObject+LYJKVOCategory.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJUnitMacro.h"
@interface NSObject (LYJKVOCategory)

- (void)LYJ_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)valueChangeBlock;

@end
