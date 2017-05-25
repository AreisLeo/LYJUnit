//
//  LYJUnitAttributedData.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnitAttributedData.h"

#define kAttributedDataNewKey @"LYJUnitAttributedDataNewKey"

#pragma mark LYJUnitAttributedDictionary
@interface LYJUnitAttributedDictionary ()



/**
 key
 */
@property (strong ,nonatomic,readwrite) NSString *key;

/**
 newKey
 */
@property (strong ,nonatomic) NSString *completionKey;

/**
 当前 dictionary 类型
 */
@property (assign ,nonatomic,readwrite) LYJAttributedDataType dataType;

/**
 当前是第几个同样字符 当前字符出现相同时才 有使用效果
 */
@property (assign ,nonatomic,readwrite) NSInteger count;
@end

@implementation LYJUnitAttributedDictionary

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.key = @"";
        self.completionKey = @"";
        self.count = 0;
    }
    return self;
}


@end


#pragma mark LYJUnitAttributedData
@interface LYJUnitAttributedData ()

@property (strong ,nonatomic) NSMutableDictionary *mutableDictionary;

@property (strong ,nonatomic) NSMutableArray *colors;

@property (strong ,nonatomic) NSMutableArray *fonts;

@property (strong ,nonatomic) NSMutableArray *lineOffsets;

@property (strong ,nonatomic) NSMutableArray *kerns;

@property (strong ,nonatomic , readwrite) NSString *fullText;

@end

@implementation LYJUnitAttributedData

- (NSMutableDictionary *)mutableDictionary
{
    if (!_mutableDictionary)
    {
        _mutableDictionary = [NSMutableDictionary dictionary];
    }
    return _mutableDictionary;
}


+ (instancetype)dataWithFullText:(NSString *)fullText
{
    LYJUnitAttributedData *data = [[LYJUnitAttributedData alloc] initWithFullText:fullText];
    return data;
}

- (instancetype)initWithFullText:(NSString *)fullText
{
    if (self = [super init])
    {
        self.fullText = fullText;
        self.colors = [NSMutableArray array];
        self.fonts = [NSMutableArray array];
        self.lineOffsets = [NSMutableArray array];
        self.kerns = [NSMutableArray array];
    }
    return self;
}
#pragma mark -----Add------
- (void)addDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType
{
    NSMutableArray *items = [self itemsWithDataType:dataType];
    [items addObject:dictionary];
}

#pragma mark -----Set------
- (void)setObject:(id)object forKey:(id)key andDataType:(LYJAttributedDataType)dataType
{
    LYJUnitAttributedDictionary *dictionary = [self attributedDictionaryWithKey:key andDataType:dataType];
    dictionary.object = object;
    [self addDictionary:dictionary andDataType:dataType];
}


- (void)setObject:(id)object forAllKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    if (object && key)
    {
        NSInteger count = [self calculateSubStringCountWithKey:key];
        NSInteger tag = 0;
        while (tag < count)
        {
            [self setObject:object forKey:key andDataType:dataType];
            tag++;
        }
    }
}

- (void)setObject:(id)object forKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    if (object && key)
    {
        [self setObject:object forKey:key andDataType:dataType];
    }
}

- (void)setIfNotNilWithDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType
{
    if (![self hasObjectForCompletionKeyIfNotNil:dictionary.completionKey andDataType:dataType])
    {
        [self addDictionary:dictionary andDataType:dataType];
    }
    
}

#pragma mark -----Remove------
- (void)removeObjectForDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType
{
    NSMutableArray *items = [self itemsWithDataType:dataType];
    [items removeObject:dictionary];
}

#pragma mark -----Get------
- (NSArray *)objectForKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    NSMutableArray *dictionarys = [NSMutableArray array];
    NSArray *items = [self itemsWithDataType:dataType];
    for (LYJUnitAttributedDictionary *dictionary in items)
    {
        if ([dictionary.key isEqualToString:key])
        {
            [dictionarys addObject:dictionary];
        }
    }
    return dictionarys;
}



#pragma mark -----ChangeValue------
- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count key:(NSString *)key object:(id)object andDataType:(LYJAttributedDataType)dataType
{
    NSInteger maxCount = [self calculateSubStringCountWithKey:key];
    if (maxCount == 0)
    {
        NSLog(@"当前不包含修改的Key");
        return;
    }
    NSString *completionKey = [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count];
    
    if (![dictionary.completionKey isEqualToString:completionKey] &&
        [self hasObjectForCompletionKeyIfNotNil:completionKey andDataType:dataType])
    {
        NSLog(@"你修改的目标已经存在");
        return;
    }
    
    dictionary.count = count > maxCount ? maxCount : count;
    dictionary.key = key;
    dictionary.range = [self rangeWithCount:count andKey:key];
    
    dictionary.completionKey = completionKey;
    dictionary.object = object;
    if (dictionary.dataType != dataType)
    {
        [self removeObjectForDictionary:dictionary andDataType:dictionary.dataType];
        dictionary.dataType = dataType;
        [self setIfNotNilWithDictionary:dictionary andDataType:dataType];
    }
}

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary andCount:(NSInteger)count
{
    [self changeValueWithDictionary:dictionary count:count andKey:dictionary.key];
}

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count andKey:(NSString *)key
{
    [self changeValueWithDictionary:dictionary count:count key:key andObject:dictionary.object];
}

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count key:(NSString *)key andObject:(id)object
{
    [self changeValueWithDictionary:dictionary count:count key:key object:object andDataType:dictionary.dataType];
}



#pragma mark -----取消包含key噶dictionarys------
- (NSArray *)objectOrNilForKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    
    if (key)
    {
        return [self objectForKey:key andDataType:dataType];
    }
    return nil;
    
}


- (BOOL)hasObjectForCompletionKeyIfNotNil:(NSString *)completionkey andDataType:(LYJAttributedDataType)dataType
{
    return [self hasKeyWithItems:[self itemsWithDataType:dataType] andCompletionKey:completionkey];
}

/**
 *创建dictionary
 */
- (LYJUnitAttributedDictionary *)attributedDictionaryWithKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    LYJUnitAttributedDictionary *dictionary = [LYJUnitAttributedDictionary new];
    dictionary.dataType = dataType;
    dictionary.key = key;
    NSInteger currentCount = [self calculateSubStringCountWithKey:key];
    if (currentCount == 0) return nil;
    NSInteger count = 0;
    while (count < currentCount)
    {
        dictionary.completionKey = [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count];
        dictionary.count = count;
        dictionary.range = [self rangeWithCount:count andKey:key];
        if (![self hasObjectForCompletionKeyIfNotNil:dictionary.completionKey andDataType:dictionary.dataType])break;
        count++;
    }
    return dictionary;
}

/**
 *计算出共有多少个重复的key值
 */
- (NSInteger)calculateSubStringCountWithKey:(NSString *)key
{
    NSInteger count = 0; //有值时最少值为1
    NSRange range = [self.fullText rangeOfString:key];
    NSString *subText = self.fullText;
    while (range.location != NSNotFound)
    {
        count++;
        subText = [subText substringFromIndex:range.location + range.length];
        range = [subText rangeOfString:key];
    }
    return count;
}


- (NSRange)rangeWithCount:(NSInteger)count andKey:(NSString *)key
{
    NSRange range = [self.fullText rangeOfString:key];
    if (count == 0)
    {
        return range;
    }
    else
    {
        //求每个重复或者对应的字符的 range 位置
        NSInteger currentCount = 0;
        NSInteger location = 0;
        NSRange tempRange = range;
        NSString *subText = self.fullText;
        while (tempRange.location != NSNotFound && currentCount < count + 1)
        {
            currentCount++;
            NSInteger tempLenth = tempRange.location + tempRange.length;
            subText = [subText substringFromIndex:tempLenth];
            range = tempRange;
            location += tempLenth;
            tempRange = [subText rangeOfString:key];
        }
        range.location = location - range.length;
        return range;
    }
}

- (BOOL)hasKeyWithItems:(NSArray *)items andCompletionKey:(NSString *)completionKey
{
    
    for (LYJUnitAttributedDictionary *dictionary in items)
    {
        if ([dictionary.completionKey isEqualToString:completionKey])
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark 核心方法
- (NSMutableAttributedString *)attributedString
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.fullText];
    
    //设置颜色
    [self setAttrStringWithItems:self.colors attributeName:NSForegroundColorAttributeName attrString:attrString];
    //设置字体
    [self setAttrStringWithItems:self.fonts attributeName:NSFontAttributeName attrString:attrString];
    //设置位置
    [self setAttrStringWithItems:self.lineOffsets attributeName:NSBaselineOffsetAttributeName attrString:attrString];
    //设置间距
    [self setAttrStringWithItems:self.kerns attributeName:NSKernAttributeName  attrString:attrString];

    return attrString;
}


- (void)setAttrStringWithItems:(NSArray *)items attributeName:(NSString *)attibuteName attrString:(NSMutableAttributedString *)attrString
{
    for (LYJUnitAttributedDictionary *dictionary in items)
    {
        [attrString addAttribute:attibuteName value:dictionary.object range:dictionary.range];
    }
    
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
- (NSMutableArray *)itemsWithDataType:(LYJAttributedDataType)dataType
{
    switch (dataType)
    {
        case LYJAttributedDataTypeColor:
        {
            return self.colors;
        }
            break;
        case LYJAttributedDataTypeFont:
        {
            return self.fonts;
        }
            break;
        case LYJAttributedDataTypeLineOffset:
        {
            return self.lineOffsets;
        }
            break;
        case LYJAttributedDataTypeKern:
        {
            return self.kerns;
        }
            break;
        default:
            break;
    }

    return [@[] mutableCopy];
}
#pragma clang diagnostic pop
@end



