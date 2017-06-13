//
//  LYJKVOHandler.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/13.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJKVOHandler.h"
#import <objc/runtime.h>
@implementation LYJKVOHandler

+ (instancetype)_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)valueChangeBlock
{
    LYJKVOHandler *handler = [LYJKVOHandler new];
    [handler addObserver:target forKeyPath:keyPath];
    handler.target = target;
    handler.valueChangeBlock = valueChangeBlock;
    return handler;
}


- (void)addObserver:(id)target forKeyPath:(NSString *)keyPath
{
    [target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.valueChangeBlock)
    {
        id newValue = change[NSKeyValueChangeNewKey];
        id oldValue = change[NSKeyValueChangeOldKey];
        self.valueChangeBlock(newValue, oldValue, object, keyPath);
    }
}
- (void)removeObserverWithSEL:(SEL)selector removeBlock:(void (^)(void))removeBlock
{
    objc_setAssociatedObject(self.target, selector, removeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
