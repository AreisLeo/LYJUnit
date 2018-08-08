//
//  NSArray+LYJArray.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "NSArray+LYJArray.h"
#import "NSData+LYJData.h"

@implementation NSArray (LYJArray)

+ (NSArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (NSData *)plistData
{
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString
{
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

- (id)randomObject
{
    if (self.count)
    {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)objectOrNilAtIndex:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

- (NSString *)jsonPrettyStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return jsonString;
    }
    return nil;
}


- (NSArray *)_ascendQuickSort
{
    NSMutableArray *targetArray = [NSMutableArray arrayWithArray:self];
     [self _quickSortWithArray:targetArray leftIndex:0 andRightIndex:self.count - 1];
    return targetArray;
}

- (NSArray *)_descendQuickSort
{
    NSMutableArray *targetArray = (NSMutableArray *)[self _ascendQuickSort];
    [targetArray reverse];
    return targetArray;
}

//排序
- (void)_quickSortWithArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }

    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] floatValue];

    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] floatValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];

        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] floatValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];

    }
    //将基准数放到正确位置
    array[i] = @(key);

    /**** 递归排序 ***/
    //排序基准数左边的
    [self _quickSortWithArray:array leftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self _quickSortWithArray:array leftIndex:i + 1 andRightIndex:rightIndex];
}

- (NSArray *)_ascendQuickSortWithKeyPath:(NSString *)keyPath
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [self _quickSortWithArray:array keyPath:keyPath leftIndex:0 andRightIndex:self.count - 1];
    return array;
}

- (NSArray *)_descendQuickSortWithKeyPath:(NSString *)keyPath
{
    NSMutableArray *targetArray = (NSMutableArray *)[self _ascendQuickSortWithKeyPath:keyPath];
    [targetArray reverse];
    return targetArray;
}

- (void)_quickSortWithArray:(NSMutableArray *)array
                    keyPath:(NSString *)keyPath
                  leftIndex:(NSInteger)leftIndex
              andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    id item = array[i] ;
    CGFloat keyPathValue = [[item valueForKey:keyPath] floatValue];
    while (i < j) {
        while (i < j && [self _getValueWithKeyPath:keyPath index:j andSortArray:array] >= keyPathValue) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [self _getValueWithKeyPath:keyPath index:i andSortArray:array] <= keyPathValue) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = item;
    [self _quickSortWithArray:array keyPath:keyPath leftIndex:leftIndex andRightIndex:i - 1];
    [self _quickSortWithArray:array keyPath:keyPath leftIndex:i + 1 andRightIndex:rightIndex];
}

- (CGFloat)_getValueWithKeyPath:(NSString *)keyPath index:(NSInteger)index andSortArray:(NSArray *)array
{
    id item = array[index] ;
    return [[item valueForKey:keyPath] floatValue];
}


- (NSArray *)_mapWithMapBlock:(arrayMapBlock)mapBlock
{
    if (!mapBlock || !self || self.noValue) return @[];
    NSMutableArray *mapArray = [NSMutableArray array];
    for (id model in self)
    {
        id targetValue = mapBlock(model);
        [mapArray addObject:targetValue];
    }
    return mapArray;
}

- (NSArray *)_skipUntilWithBlock:(valuePredicateBlock)block
{
    if (!block || !self || self.noValue) return @[];

    BOOL skipping = YES;
    NSMutableArray *skipUntilArray = [NSMutableArray array];
    for (id model in self)
    {
        if (skipping)
        {
            BOOL predicate = block(model);
            if (predicate)
            {
                skipping = NO;
                [skipUntilArray addObject:model];
            }
        }
        else
        {
            [skipUntilArray addObject:model];
        }
    }
    return skipUntilArray;
}

- (NSArray *)_skipWhileWithBlock:(valuePredicateBlock)block
{
    if (!block || !self || self.noValue) return @[];

    return [self _skipUntilWithBlock:^BOOL(id value) {
        BOOL predicate = block(value);
        return !predicate;
    }];
}


- (NSArray *)_takeWithCount:(NSInteger)count
{
    if (count < 0) return @[];

    if (count >= self.count) return self;

    __block NSMutableArray *takeArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeArray addObject:obj];
        if (idx + 1 == count)
        {
            *stop = YES;
        }
    }];
    return takeArray;
}

- (NSArray *)_takeLastWithCount:(NSInteger)count
{
    if (count < 0) return @[];

    if (count >= self.count) return self;

    __block NSMutableArray *takeArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [takeArray addObject:obj];
        while (takeArray.count > count)
        {
            [takeArray removeObjectAtIndex:0];
        }
    }];
    return takeArray;
}

- (NSArray *)_takeUntilWithBlock:(valuePredicateBlock)block
{
    if (!block || !self || self.noValue) return @[];

    NSMutableArray *takeUntilArray = [NSMutableArray array];
    for (id model in self)
    {
        BOOL predicate = block(model);
        if (predicate)
        {
            [takeUntilArray addObject:model];
        }
        else
        {
            break;
        }
    }
    return takeUntilArray;
}

- (NSArray *)_takeWhileWithBlock:(valuePredicateBlock)block
{
    return [self _takeUntilWithBlock:^BOOL(id value) {
        BOOL predicate = block(value);
        return !predicate;
    }];
}

- (NSArray *)_skipWithSkipCount:(NSInteger)skipCount
{
    __block NSMutableArray *skipArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > skipCount)
        {
            [skipArray addObject:obj];
        }
    }];
    return skipArray;
}

- (NSInteger)_reduceEachInteger
{
    if (!self || self.noValue) return 0;

    NSInteger originalNum = 0;
    for (NSNumber *number in self)
    {
        originalNum += number.integerValue;
    }
    return originalNum;
}

- (CGFloat)_reduceEachFloat
{
    if (!self || self.noValue) return 0.0f;

    CGFloat originalNum = 0.0f;
    for (NSNumber *number in self)
    {
        originalNum += number.floatValue;
    }
    return originalNum;
}



- (CGFloat)_accumulateWithKeyPath:(NSString *)keyPath
{
    CGFloat floatValue = 0.0f;
    for (id model in self)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        floatValue += [targetValue floatValue];
    }
    return floatValue;
}

- (BOOL)_allMatchingWithKeyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    if (!self || self.noValue) return NO;

    BOOL allMatch = YES;
    for (id model in self)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        allMatch = [self _modelWithMatchType:matchType matchValue:matchValue targetValue:targetValue];
        if (!allMatch)
        {
            return allMatch;
        }
    }
    return allMatch;
}

- (BOOL)_allNoneMatchingWithKeyPath:(NSString *)keyPath matchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue
{
    if (!self || self.noValue) return NO;

    BOOL allMatch = NO;
    for (id model in self)
    {
        id targetValue = [self _targetValueWithKeyPath:keyPath model:model];
        allMatch = [self _modelWithMatchType:matchType matchValue:matchValue targetValue:targetValue];
        if (allMatch)
        {
            return allMatch;
        }
    }
    return allMatch;
}

- (id)_targetValueWithKeyPath:(NSString *)keyPath model:(id)model
{
    id targetValue = model;
    if (keyPath && (keyPath.length > 0))
    {
        if ([model isKindOfClass:[NSDictionary class]]) {
            targetValue = [model objectForKey:keyPath];
        }
        else
        {
            targetValue = [model valueForKey:keyPath];
        }
    }
    return targetValue;
}


- (BOOL)_modelWithMatchType:(LYJUnitMatchType)matchType matchValue:(id)matchValue targetValue:(id)targetValue
{
    if (![matchValue isKindOfClass:[NSString class]])
    {
        matchType = LYJUnitMatchTypeContains;
    }
    BOOL isContains = YES;
    switch (matchType)
    {
        case LYJUnitMatchTypePrefix:
        {
            isContains = [targetValue hasPrefix:matchValue];
        }
            break;
        case LYJUnitMatchTypeSuffix:
        {
            isContains = [targetValue hasSuffix:matchValue];
        }
            break;
        case LYJUnitMatchTypeContainsString:
        {
            isContains = [targetValue containsString:matchValue];
        }
            break;
        case LYJUnitMatchTypeContains:
        default:
        {
            isContains = [targetValue containsObject:matchValue];
        }
            break;
    }
    return isContains;
}

- (BOOL)noValue
{
    if (self.count == 0) return YES;
    return NO;
}

@end

@implementation NSMutableArray (LYJArray)

+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (void)removeFirstObject
{
    if (self.count)
    {
        [self removeObjectAtIndex:0];
    }
}

- (id)popFirstObject
{
    id obj = nil;
    if (self.count)
    {
        obj = self.firstObject;
        [self removeFirstObject];
    }
    return obj;
}

- (id)popLastObject
{
    id obj = nil;
    if (self.count)
    {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)prependObject:(id)object
{
    [self insertObject:object atIndex:0];
}

- (void)prependObjects:(NSArray *)objects
{
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects)
    {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSUInteger i = index;
    for (id obj in objects)
    {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)reverse
{
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++)
    {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle
{
    for (NSUInteger i = self.count; i > 1; i--)
    {
        [self exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end

