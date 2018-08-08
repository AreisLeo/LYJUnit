//
//  NSObject+LYJKVO.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJUnitMacro.h"
@interface NSObject (LYJKVO)

- (void)LYJ_addObserverForKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)LYJKVOvalueChangeBlock;

- (void)LYJ_removeObserverForKeyPath:(NSString *)keyPath;

- (void)LYJ_removeAllObserverBlocks;

@end
