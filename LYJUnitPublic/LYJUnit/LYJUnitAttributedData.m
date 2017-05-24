//
//  LYJUnitAttributedData.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnitAttributedData.h"

#define kAttributedDataNewKey @"LYJUnitAttributedDataNewKey"

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

- (void)setObject:(id)object forKey:(id)key andDataType:(LYJAttributedDataType)dataType
{
    [self.mutableDictionary setObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    id object = [self.mutableDictionary objectForKey:key];
    return object;
}

- (void)setObject:(id)object forAllKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    if (object && key)
    {
        NSInteger count = [self calculateSubStringCountWithKey:key];
        NSInteger tag = 0;
        while (tag < count)
        {
            LYJUnitAttributedDictionary *dictionary = [self attributedDictionaryWithKey:key andDataType:dataType];
            dictionary.object = object;
            [self addDictionary:dictionary andDataType:dataType];
            tag++;
        }
    }
}


- (void)setObject:(id)object forKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    if (object && key)
    {
        LYJUnitAttributedDictionary *dictionary = [self attributedDictionaryWithKey:key andDataType:dataType];
        dictionary.object = object;
        [self addDictionary:dictionary andDataType:dataType];
    }
}




- (void)setIfNotNilWithDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType
{
     [self addDictionary:dictionary andDataType:dataType];
}

- (BOOL)hasObjectForkeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    return [self hasKeyWithItems:[self itemsWithDataType:dataType] andKey:key];
}

- (LYJUnitAttributedDictionary *)attributedDictionaryWithKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType
{
    LYJUnitAttributedDictionary *dictionary = [LYJUnitAttributedDictionary new];
    dictionary.dataType = dataType;
    dictionary.key = key;
    NSInteger currentCount = [self calculateSubStringCountWithKey:key dictionary:dictionary];
    NSInteger count = 0;
    while (count < currentCount)
    {
        dictionary.completionKey = [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count];
        dictionary.count = count;
        dictionary.range = [self rangeWithCount:count andKey:key];
        if (![self hasObjectForkeyIfNotNil:dictionary.completionKey andDataType:dictionary.dataType])break;
        count++;
    }
    return dictionary;
}
- (NSInteger)calculateSubStringCountWithKey:(NSString *)key
{
    return [self calculateSubStringCountWithKey:key dictionary:nil];
}

- (NSInteger)calculateSubStringCountWithKey:(NSString *)key dictionary:(LYJUnitAttributedDictionary *)dictionary
{
    NSInteger count = 0;
    NSRange range = [self.fullText rangeOfString:key];
    dictionary.range = range;
    NSString *subText = self.fullText;
    while (range.location != NSNotFound)
    {
        count++;
        subText = [subText substringFromIndex:range.location + range.length];
        dictionary.range = range;
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

- (BOOL)hasKeyWithItems:(NSArray *)items andKey:(NSString *)key
{
    
    for (LYJUnitAttributedDictionary *dictionary in items)
    {
        if ([dictionary.completionKey isEqualToString:key])
        {
            return YES;
        }
    }
    return NO;
}

- (void)addDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType
{
    NSMutableArray *items = [self itemsWithDataType:dataType];
    [items addObject:dictionary];
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
