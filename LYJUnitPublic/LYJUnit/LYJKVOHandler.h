//
//  LYJKVOHandler.h
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/13.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYJUnitMacro.h"

@interface LYJKVOHandler : NSObject
/** target */
@property (strong ,nonatomic) id target;

/** valueChangeBlock */
@property (copy ,nonatomic) valueChangeBlock valueChangeBlock ;

/** removeBlock */
@property (copy ,nonatomic) removeBlock removeBlock ;

+ (instancetype)_addObserver:(id)target forKeyPath:(NSString *)keyPath valueChangeBlock:(valueChangeBlock)valueChangeBlock;

- (void)removeObserverWithSEL:(SEL)selector removeBlock:(removeBlock)removeBlock;
@end
