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

/** valueChangeBlock */
@property (copy ,nonatomic) valueChangeBlock LYJKVOvalueChangeBlock;

/** LYJtargets */
@property (strong ,nonatomic) NSMutableArray *LYJKVOTargets;

- (void)LYJ_addObserver:(id)target valueChangeBlock:(valueChangeBlock)valueChangeBlock;

- (void)LYJ_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)LYJKVOvalueChangeBlock;

- (void)LYJ_removeObserver:(id)target forKeyPath:(NSString *)keyPath;

- (void)LYJ_removeObserver:(id)target;
@end
