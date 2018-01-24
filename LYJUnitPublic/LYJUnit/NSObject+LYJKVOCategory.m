//
//  NSObject+LYJKVOCategory.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "NSObject+LYJKVOCategory.h"
#import "LYJUnitMacro.h"
#import <objc/runtime.h>

const char *LYJKVOBlockKey = "LYJKVOValueChangeBlock";

const char *LYJKVOTargetsKey = "LYJKVOTargets";

@implementation NSObject (LYJKVOCategory)

- (void)setLYJKVOTargets:(NSMutableArray *)LYJKVOTargets
{
    objc_setAssociatedObject(self, LYJKVOTargetsKey, LYJKVOTargets, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)LYJKVOTargets
{
    NSMutableArray *LYJKVOTargets = objc_getAssociatedObject(self, LYJKVOTargetsKey);
    if (!LYJKVOTargets)
    {
        LYJKVOTargets = [NSMutableArray array];
        objc_setAssociatedObject(self, LYJKVOTargetsKey, LYJKVOTargets, OBJC_ASSOCIATION_RETAIN);
    }
    return LYJKVOTargets;
}

- (void)setLYJKVOvalueChangeBlock:(valueChangeBlock)LYJKVOvalueChangeBlock
{
    objc_setAssociatedObject(self, LYJKVOBlockKey, LYJKVOvalueChangeBlock, OBJC_ASSOCIATION_COPY);
}

- (valueChangeBlock)LYJKVOvalueChangeBlock
{
    return objc_getAssociatedObject(self, LYJKVOBlockKey);
}

- (void)LYJ_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)LYJKVOvalueChangeBlock
{
    self.LYJKVOvalueChangeBlock = LYJKVOvalueChangeBlock;
    [target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    [self.LYJKVOTargets addObject:target];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.LYJKVOvalueChangeBlock)
    {
        id newValue = change[NSKeyValueChangeNewKey];
        id oldValue = change[NSKeyValueChangeOldKey];
        self.LYJKVOvalueChangeBlock(newValue, oldValue, object, keyPath);
    }
}

- (void)LYJ_removeObserver:(id)target forKeyPath:(NSString *)keyPath
{
    if (!target) return;
    [target removeObserver:self forKeyPath:keyPath];
    [self.LYJKVOTargets removeObject:target];
}

@end
