//
//  NSObject+LYJKVO.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "NSObject+LYJKVO.h"
#import "LYJUnitMacro.h"
#import <objc/runtime.h>

@interface LYJKVObserver : NSObject

@property (copy ,nonatomic) valueChangeBlock block;

- (instancetype)initWithKVOBlock:(valueChangeBlock)block;

@end

@implementation LYJKVObserver
- (instancetype)initWithKVOBlock:(valueChangeBlock)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.block) return;

    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;

    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey]integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;

    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) oldValue = nil;

    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (newValue == [NSNull null]) newValue = nil;

    if (oldValue != newValue) self.block(newValue, oldValue, object, keyPath);
}
@end


const char *LYJKVOBlockKey = "LYJKVOValueChangeBlock";

const char *LYJKVOTargetsKey = "LYJKVOTargets";

@interface  NSObject ()

@property (strong ,nonatomic) NSMutableDictionary *observerDict;

@end

@implementation NSObject (LYJKVO)

- (NSMutableDictionary *)observerDict
{
    NSMutableDictionary *observerDict = objc_getAssociatedObject(self, LYJKVOBlockKey);
    if (!observerDict)
    {
        observerDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, LYJKVOBlockKey, observerDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observerDict;
}


- (void)LYJ_addObserverForKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)LYJKVOvalueChangeBlock
{
    if (!keyPath || !LYJKVOvalueChangeBlock || keyPath.length == 0) return;




    NSMutableArray *observers = [self.observerDict objectForKey:keyPath];
    if (!observers)
    {
        observers = [NSMutableArray array];
        [self.observerDict setObject:observers forKey:keyPath];
    }

    LYJKVObserver *observer = [[LYJKVObserver alloc]initWithKVOBlock:LYJKVOvalueChangeBlock];
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [observers addObject:observer];

}



- (void)LYJ_removeObserverForKeyPath:(NSString *)keyPath
{
    if (!keyPath || keyPath.length == 0) return;
    NSMutableArray *observers = [self.observerDict objectForKey:keyPath];
    [observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [self.observerDict removeObjectForKey:keyPath];
}

- (void)LYJ_removeAllObserverBlocks
{
    [self.observerDict enumerateKeysAndObjectsUsingBlock:^(NSString *key,  NSMutableArray *observers, BOOL * _Nonnull stop) {
        [observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [self.observerDict removeAllObjects];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method orginalDealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method newDealoc = class_getInstanceMethod(self, NSSelectorFromString(@"autoRemoveObserverDealloc"));
        method_exchangeImplementations(orginalDealloc, newDealoc);
    });
}

- (void)autoRemoveObserverDealloc
{
    if (objc_getAssociatedObject(self, LYJKVOBlockKey)) {
        [self LYJ_removeAllObserverBlocks];
    }
    [self autoRemoveObserverDealloc];
}


@end
