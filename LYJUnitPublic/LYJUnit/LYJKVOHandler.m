//
//  LYJKVOHandler.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/13.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJKVOHandler.h"
#import "NSObject+LYJKVOCategory.h"
#import <objc/message.h>
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
- (void)removeObserverWithSEL:(SEL)selector removeBlock:(removeBlock)removeBlock
{
    self.removeBlock = removeBlock;
    
    NSString *selectorName = NSStringFromSelector(selector);
    SEL aliasSelector = NSSelectorFromString([NSString stringWithFormat:@"LYJKVO_%@",selectorName]);
    Class class = [self.target class];
    
    objc_setAssociatedObject(self.target, aliasSelector, self, OBJC_ASSOCIATION_RETAIN);
    Method targetMethod = class_getInstanceMethod(class, selector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    
    class_addMethod(class, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
    
    class_replaceMethod(class, selector, _objc_msgForward, typeEncoding);
    
    
    //    [self.target setAssociatedObject:selector item:removeBlock];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
