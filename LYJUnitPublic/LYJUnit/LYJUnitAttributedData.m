//
//  LYJUnitAttributedData.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnitAttributedData.h"

#define kAttributedDataNewKey @"LYJUnitAttributedDataNewKey"
#define kAttributedDataNewAllKey @"LYJUnitAttributedDataNewAllKey"
#define kWeakSelf __weak typeof(self) weakSelf = self;

@interface AttributedValue ()


/**
 color
 */
@property (strong ,nonatomic ,readwrite) UIColor *color;

/**
 backgroundColor
 */
@property (strong ,nonatomic ,readwrite) UIColor *backgroundColor;

/**
 kern
 */
@property (assign ,nonatomic ,readwrite) CGFloat kern;

/**
 lineOffset
 */
@property (assign ,nonatomic ,readwrite) CGFloat lineOffset;

/**
 font
 */
@property (strong ,nonatomic ,readwrite) UIFont *font;

@property (strong ,nonatomic ,readwrite) UIColor *strokeColor;

@property (assign ,nonatomic ,readwrite) CGFloat strokeWidth;

@property (assign ,nonatomic ,readwrite) NSUnderlineStyle underlineStyle;

@property (strong ,nonatomic ,readwrite) UIColor *underlineColor;

@property (assign ,nonatomic ,readwrite) NSUnderlineStyle strikethroughStyle;

@property (strong ,nonatomic ,readwrite) UIColor *strikethroughColor;

@property (strong ,nonatomic ,readwrite) NSShadow *shadow;

@property (assign ,nonatomic ,readwrite) NSInteger verticalGlyph;

@property (assign ,nonatomic ,readwrite) CGFloat obliqueness;

@property (assign ,nonatomic ,readwrite) CGFloat expansion;

@end

@implementation AttributedValue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.kern = 0;
        self.lineOffset = 0;
        self.color = nil;
        self.font = nil;
        self.strokeWidth = 0;
        self.obliqueness = 0;
        self.expansion = 0;
        self.verticalGlyph = 0;
    }
    return self;
}

@end

#pragma mark LYJUnitAttributedDictionary

@interface LYJUnitAttributedDictionary ()



/**
 key
 */
@property (strong ,nonatomic ,readwrite) NSString *key;


/**
 newKey
 */
@property (strong ,nonatomic) NSString *completionKey;

///**
// 当前 dictionary 类型
// */
//@property (assign ,nonatomic,readwrite) LYJAttributedDataType dataType;

/**
 当前是第几个同样字符 当前字符出现相同时才 有使用效果
 */
@property (assign ,nonatomic,readwrite) NSInteger count;

@property (strong ,nonatomic ,readwrite) AttributedValue *value;

/**  */
@property (copy ,nonatomic) BOOL (^hasCompletionKey)(NSString *key);

/**  */
@property (copy ,nonatomic) void (^changeValid)(LYJUnitAttributedDictionary *dictionary);

+ (NSInteger)calculateSubStringCountWithKey:(NSString *)key fullText:(NSString *)fullText;

//设置key 与对应的 count
- (BOOL)setKey:(NSString *)key count:(NSInteger)count;

- (NSString *)identifier;

@end

@implementation LYJUnitAttributedDictionary
@synthesize dictionaryKey = _dictionaryKey;
@synthesize dictionaryFont = _dictionaryFont;
@synthesize dictionaryColor = _dictionaryColor;
@synthesize dictionaryKern = _dictionaryKern;
@synthesize dictionaryCount = _dictionaryCount;
@synthesize dictionaryLineOffset = _dictionaryLineOffset;
@synthesize dictionaryBackgroundColor = _dictionaryBackgroundColor;
@synthesize dictionaryStrikethrough = _dictionaryStrikethrough;
@synthesize dictionaryUnderline = _dictionaryUnderline;
@synthesize dictionaryUnderlineColor = _dictionaryUnderlineColor;
@synthesize dictionaryStrikethroughColor = _dictionaryStrikethroughColor;
@synthesize dictionaryStrokeColor = _dictionaryStrokeColor;
@synthesize dictionaryStrokeWidth = _dictionaryStrokeWidth;
@synthesize dictionaryShadow = _dictionaryShadow;
@synthesize dictionaryExpansion = _dictionaryExpansion;
@synthesize dictionaryObliqueness = _dictionaryObliqueness;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.key = @"";
        self.completionKey = @"";
        self.count = 0;
        self.value = [[AttributedValue alloc]init];

    }
    return self;
}

- (void)setFullText:(NSString *)fullText
{
    _fullText = fullText;
    self.isValid = [self setKey:self.key count:self.count];
}
- (void)setIsValid:(BOOL)isValid
{
    
    _isValid = isValid;
    !isValid && [self.key length] > 0 ? NSLog(@"当前 %@ 无效! key = %@",NSStringFromClass(self.class),self.key) :nil;
    if (self.changeValid)
    {
        self.changeValid(self);
    }
}

- (AttributedDataKey)dictionaryKey
{
    if (!_dictionaryKey)
    {
        kWeakSelf;
        _dictionaryKey = ^(NSString *key){
            weakSelf.key = key;
            weakSelf.isValid = [weakSelf setKey:key count:weakSelf.count];
            return weakSelf;
        };
    }
    return _dictionaryKey;
}

- (AttributedDataColor)dictionaryColor
{
    if (!_dictionaryColor)
    {
        kWeakSelf;
        _dictionaryColor = ^(UIColor *color){
            weakSelf.value.color = color;
            return weakSelf;
        };
    }
    return _dictionaryColor;
}

- (AttributedDataKern)dictionaryKern
{
    if (!_dictionaryKern)
    {
        kWeakSelf;
        _dictionaryKern = ^(CGFloat value){
            weakSelf.value.kern = value;
            return weakSelf;
        };
    }
    return _dictionaryKern;
}

- (AttributedDataFont)dictionaryFont
{
    if (!_dictionaryFont)
    {
        kWeakSelf;
        _dictionaryFont = ^(UIFont *font){
            weakSelf.value.font = font;
            return weakSelf;
        };
    }
    return _dictionaryFont;
}


- (AttributedDataCount)dictionaryCount
{
    if (!_dictionaryCount)
    {
        kWeakSelf;
        _dictionaryCount = ^(NSInteger count){
            if (weakSelf.count != count)
            {
                weakSelf.count = count;
                weakSelf.isValid = [weakSelf setKey:weakSelf.key count:count];
            }
            return weakSelf;
        };
    }
    return _dictionaryCount;
}

- (AttributedDataLineOffset)dictionaryLineOffset
{
    if (!_dictionaryLineOffset)
    {
        kWeakSelf;
        _dictionaryLineOffset = ^(CGFloat value){
            weakSelf.value.lineOffset = value;
            return weakSelf;
        };
    }
    return _dictionaryLineOffset;
}

- (AttributedDataColor)dictionaryBackgroundColor
{
    if (!_dictionaryBackgroundColor)
    {
        kWeakSelf;
        _dictionaryBackgroundColor = ^(UIColor *color){
          
            weakSelf.value.backgroundColor = color;
            return weakSelf;
        };
    }
    return _dictionaryBackgroundColor;
}


- (AttributedDataUnderlineStyle)dictionaryStrikethrough
{
    if (!_dictionaryStrikethrough)
    {
        kWeakSelf;
        _dictionaryStrikethrough = ^(NSUnderlineStyle style){
            weakSelf.value.strikethroughStyle = style;
            return weakSelf;
        };
    }
    return _dictionaryStrikethrough;
}

- (AttributedDataColor)dictionaryStrikethroughColor
{
    if (!_dictionaryStrikethroughColor)
    {
        kWeakSelf;
        _dictionaryStrikethroughColor = ^(UIColor *color){
            weakSelf.value.strikethroughColor = color;
            return weakSelf;
        };
    }
    return _dictionaryStrikethroughColor;
}

- (AttributedDataUnderlineStyle)dictionaryUnderline
{
    if (!_dictionaryUnderline)
    {
        kWeakSelf;
        _dictionaryUnderline = ^(NSUnderlineStyle style){
            weakSelf.value.underlineStyle = style;
            return weakSelf;
        };
    }
    return _dictionaryUnderline;
}

- (AttributedDataColor)dictionaryUnderlineColor
{
    if (!_dictionaryUnderlineColor)
    {
        kWeakSelf;
        _dictionaryUnderlineColor = ^(UIColor *color){
            weakSelf.value.underlineColor = color;
            return weakSelf;
        };
    }
    return _dictionaryUnderlineColor;
}

- (AttributedDataColor)dictionaryStrokeColor
{
    if (!_dictionaryStrokeColor)
    {
        kWeakSelf;
        _dictionaryStrokeColor = ^(UIColor *color){
            weakSelf.value.strokeColor = color;
            return weakSelf;
        };
    }
    return _dictionaryStrokeColor;
}

- (AttributedDataStrokeWidth)dictionaryStrokeWidth
{
    if (!_dictionaryStrokeWidth)
    {
        kWeakSelf;
        _dictionaryStrokeWidth = ^(CGFloat strokeWidth){
            weakSelf.value.strokeWidth = strokeWidth;
            return weakSelf;
        };
    }
    return _dictionaryStrokeWidth;
}

- (AttributedDataShadow)dictionaryShadow
{
    if (!_dictionaryShadow)
    {
        kWeakSelf;
        _dictionaryShadow = ^(CGSize shadowOffset,CGFloat shadowBlurRadius,UIColor *shadowColor) {
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowOffset = shadowOffset;
            shadow.shadowBlurRadius = shadowBlurRadius;
            shadow.shadowColor = shadowColor;
            weakSelf.value.shadow = shadow;
            return weakSelf;
        };
    }
    return _dictionaryShadow;
}

- (AttributedDataObliqueness)dictionaryObliqueness
{
    if (!_dictionaryObliqueness)
    {
        kWeakSelf;
        _dictionaryObliqueness = ^(CGFloat obliqueness) {
            weakSelf.value.obliqueness = obliqueness;
            return weakSelf;
        };
    }
    return _dictionaryObliqueness;
}

- (AttributedDataExpansion)dictionaryExpansion
{
    if (!_dictionaryExpansion)
    {
        kWeakSelf;
        _dictionaryExpansion = ^(CGFloat expansion) {
            weakSelf.value.expansion = expansion;
            return weakSelf;
        };
    }
    return _dictionaryExpansion;
}

- (BOOL)setKey:(NSString *)key count:(NSInteger)count;
{
    NSInteger currentCount = [self.class calculateSubStringCountWithKey:key fullText:self.fullText];
    if (currentCount == 0)  return NO;
    count = count >= currentCount ? currentCount - 1 : count;
    
    BOOL hasKey = YES;
    while (count < currentCount)
    {
        NSString *completionKey = [self.class completionKeyWithCount:count key:key identifier:[self identifier]];
        hasKey = self.hasCompletionKey(completionKey);
        self.completionKey = completionKey;
        self.count = count;
        self.range = [self rangeWithCount:count andKey:key];
        count++;
        if (!hasKey) break;
    }

    return !hasKey;
}
/**
 *计算出共有多少个重复的key值
 */
+ (NSInteger)calculateSubStringCountWithKey:(NSString *)key fullText:(NSString *)fullText
{
    NSInteger count = 0; //有值时最少值为1
    NSRange range = [fullText rangeOfString:key];
    NSString *subText = fullText;
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

+ (NSString *)completionKeyWithCount:(NSInteger)count key:(NSString *)key identifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"%@%@%ld",key,identifier,count];
}

- (NSString *)identifier
{
    return kAttributedDataNewKey;
}

@end



#pragma mark LYJUnitAttributedAllDictionary

@interface LYJUnitAttributedAllDictionary ()

@end

@implementation LYJUnitAttributedAllDictionary

- (BOOL)setKey:(NSString *)key count:(NSInteger)count
{
    NSInteger maxCount = [self.class calculateSubStringCountWithKey:key fullText:self.fullText];
    if (count > maxCount - 1)
    {
        return NO;
    }
    [self.ranges removeAllObjects];
    [self.counts removeAllObjects];
    for (int i = 0; i < maxCount; i++)
    {
        [self.ranges addObject:[NSValue valueWithRange:[self rangeWithCount:i andKey:key]]];
        [self.counts addObject:@(i)];
        [self.values addObject:[[AttributedValue alloc] init]];
    }
    
    self.completionKey = [self.class completionKeyWithCount:count key:key identifier:[self identifier]];
    if (([self.ranges count] == 0 ||
        [self.counts count] == 0) ||
        self.ranges.count != self.counts.count)
    {
        
        return NO;
    }
    return !self.hasCompletionKey(self.completionKey);
}

- (NSMutableArray *)counts
{
    if (!_counts)
    {
        _counts = [NSMutableArray array];
    }
    return _counts;
}


- (NSMutableArray *)ranges
{
    if (!_ranges)
    {
        _ranges = [NSMutableArray array];
    }
    return _ranges;
}

- (NSString *)identifier
{
    return kAttributedDataNewAllKey;
}

@end


#pragma mark LYJUnitAttributedData
@interface LYJUnitAttributedData ()

@property (strong ,nonatomic) NSMutableArray *mutableDictionarys;

@property (strong ,nonatomic) NSMutableArray *invalidMutableDictionarys;

@property (copy ,nonatomic ,readwrite) AttributedDataKey dictionaryKey;
@property (copy ,nonatomic ,readwrite) AttributedDataKeyAll dictionaryKeyAll;
@property (copy ,nonatomic ,readwrite) AttributedDataKeyRestCount dictionaryKeyAndCount;
@property (copy ,nonatomic ,readwrite) AttributedDataKeyRestAll dictionaryKeyRestAll;
@property (copy ,nonatomic ,readwrite) AttributedDataColor dictionaryColor;
@property (strong ,nonatomic ,readwrite) NSString *fullText;

@property (strong ,nonatomic ,readwrite) LYJUnitAttributedDictionary *fullTextDictionary;

@end

@implementation LYJUnitAttributedData

@synthesize dictionaryKey = _dictionaryKey;

- (NSMutableArray *)mutableDictionarys
{
    if (!_mutableDictionarys)
    {
        _mutableDictionarys = [NSMutableArray array];
    }
    return _mutableDictionarys;
}

- (NSMutableArray *)invalidMutableDictionarys
{
    if (!_invalidMutableDictionarys)
    {
        _invalidMutableDictionarys = [NSMutableArray array];
    }
    return _invalidMutableDictionarys;
}

+ (instancetype)dataWithFullText:(NSString *)fullText
{
    LYJUnitAttributedData *data = [[LYJUnitAttributedData alloc] initWithFullText:fullText];
    return data;
}

+ (NSMutableAttributedString *)attributedStringWithFullText:(NSString *)fullText attributedData:(void (^)(LYJUnitAttributedData *))attributedData
{
    LYJUnitAttributedData *data = [self dataWithFullText:fullText];
    if (attributedData) attributedData(data);
    return [data attributedString];
}

- (instancetype)initWithFullText:(NSString *)fullText
{
    if (self = [super init])
    {
        self.fullText = fullText;
    }
    return self;
}


- (AttributedDataKey)dictionaryKey
{
    if (!_dictionaryKey)
    {
        LYJUnitAttributedDictionary *dictionary = [self dictionary];
        _dictionaryKey = dictionary.dictionaryKey;
    }
    return _dictionaryKey;
}

- (AttributedDataKeyRestCount)dictionaryKeyAndCount
{
    if (!_dictionaryColor)
    {
        kWeakSelf;
        _dictionaryKeyAndCount = ^(NSString *key,NSInteger count) {
            NSString *completionKey = [LYJUnitAttributedDictionary completionKeyWithCount:count key:key identifier:kAttributedDataNewAllKey];
            LYJUnitAttributedAllDictionary *dictionary = [weakSelf objectForCompletionKeyIfNotNil:completionKey];
            dictionary.count = count;
            dictionary.dictionaryKey(key);
            dictionary.changeCount = @(count);
            [weakSelf addDictionary:dictionary];
            return dictionary;
        };
    }
    return _dictionaryKeyAndCount;
}



- (AttributedDataKeyAll)dictionaryKeyAll
{
    if (!_dictionaryKeyAll)
    {
        kWeakSelf;
        _dictionaryKeyAll = ^(NSString *key) {
            LYJUnitAttributedAllDictionary *dictionary = [weakSelf allDictionary];
            dictionary.dictionaryKey(key);
            [weakSelf addDictionary:dictionary];
            return dictionary;
        };
    }
    
    return _dictionaryKeyAll;
}

- (AttributedDataKeyRestAll)dictionaryKeyRestAll
{
    if (!_dictionaryKeyRestAll)
    {
        kWeakSelf;
        _dictionaryKeyRestAll = ^(NSString *key)
        {
            NSString *completionKey = [LYJUnitAttributedAllDictionary completionKeyWithCount:0 key:key identifier:kAttributedDataNewAllKey];
            LYJUnitAttributedAllDictionary *dictionary = [weakSelf objectForCompletionKeyIfNotNil:completionKey];
            [weakSelf addDictionary:dictionary];
            return dictionary;
        };
    }
    return _dictionaryKeyRestAll;
}


- (LYJUnitAttributedDictionary *)fullTextDictionary
{
    if (!_fullTextDictionary)
    {
        _fullTextDictionary = [self dictionary];
        _fullTextDictionary.dictionaryKey(self.fullText);
    }
    return _fullTextDictionary;
}


#pragma mark -----Add------
- (LYJUnitAttributedDictionary *)dictionary
{
    LYJUnitAttributedDictionary *dictionary = [[LYJUnitAttributedDictionary alloc] init];
    [self dictionaryBlockMethod:dictionary];
    return dictionary;
}


- (LYJUnitAttributedAllDictionary *)allDictionary
{
    LYJUnitAttributedAllDictionary *dictionary = [[LYJUnitAttributedAllDictionary alloc] init];
    [self dictionaryBlockMethod:dictionary];
    return dictionary;
}

- (void)dictionaryBlockMethod:(LYJUnitAttributedDictionary *)dictionary
{
    kWeakSelf
    dictionary.changeValid = ^(LYJUnitAttributedDictionary *dictionary){
        [weakSelf addDictionary:dictionary];
    };
    dictionary.fullText = self.fullText;
    dictionary.hasCompletionKey = ^BOOL(NSString *key){
        return [weakSelf hasObjectForCompletionKeyIfNotNil:key];
    };
}


//修改数据源
- (void)addDictionary:(LYJUnitAttributedDictionary *)dictionary
{
    [self.mutableDictionarys containsObject:dictionary] ? [self.mutableDictionarys removeObject:dictionary] : nil;
    
    [self.invalidMutableDictionarys containsObject:dictionary] ? [self.invalidMutableDictionarys removeObject:dictionary] : nil;
    
    dictionary.isValid ? [self.mutableDictionarys addObject:dictionary] : [self.invalidMutableDictionarys addObject:dictionary];
}

//是否已经存在唯一 key 控制不做多余操作
- (BOOL)hasObjectForCompletionKeyIfNotNil:(NSString *)completionkey
{
    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if ([dictionary.completionKey isEqualToString:completionkey])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark -----求出有效数组中的 dictionary------
- (__kindof LYJUnitAttributedDictionary *)objectForCompletionKeyIfNotNil:(NSString *)completionkey
{
    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if ([dictionary.completionKey isEqualToString:completionkey])
        {
            return dictionary;
        }
    }
    //当没有时自动创建一个
    return [completionkey containsString:kAttributedDataNewAllKey] ? [self allDictionary] : [self dictionary];
}



#pragma mark 核心方法
- (NSMutableAttributedString *)attributedString
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.fullText];

    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if (!dictionary.isValid) continue;
        
        if ([dictionary isKindOfClass:[LYJUnitAttributedAllDictionary class]])
        {
            
            LYJUnitAttributedAllDictionary *allDictionary = (LYJUnitAttributedAllDictionary *)dictionary;
            if (allDictionary.changeCount && [allDictionary.counts containsObject:allDictionary.changeCount])
            {
                NSValue *rangeValue = allDictionary.ranges[[allDictionary.changeCount integerValue] ];
                [self addAttributeWithDictionary:dictionary attrString:attrString range:[rangeValue rangeValue]];
            }
            else
            {
                for (NSValue *rangeValue in allDictionary.ranges)
                {
                    [self addAttributeWithDictionary:dictionary attrString:attrString range:[rangeValue rangeValue]];
                }
            }
        }
        else
        {
            [self addAttributeWithDictionary:dictionary attrString:attrString range:dictionary.range];
        }
    }
    return attrString;
}

- (void)addAttributeWithDictionary:(LYJUnitAttributedDictionary *)dictionary attrString:(NSMutableAttributedString *)attrString range:(NSRange)range
{
    
    //设置颜色
    [self setAttrStringWithObject:dictionary.value.color attributeName:NSForegroundColorAttributeName attrString:attrString range:range];
    //设置字体
    [self setAttrStringWithObject:dictionary.value.font attributeName:NSFontAttributeName attrString:attrString range:range];
    //设置位置
    [self setAttrStringWithObject:@(dictionary.value.lineOffset) attributeName:NSBaselineOffsetAttributeName attrString:attrString range:range];
    //设置间距
    [self setAttrStringWithObject:@(dictionary.value.kern) attributeName:NSKernAttributeName  attrString:attrString range:range];
    //文字背景颜色
    [self setAttrStringWithObject:dictionary.value.backgroundColor attributeName:NSBackgroundColorAttributeName attrString:attrString range:range];
    //删除线
    [self setAttrStringWithObject:@(dictionary.value.strikethroughStyle) attributeName:NSStrikethroughStyleAttributeName attrString:attrString range:range];
    //删除线颜色
    [self setAttrStringWithObject:dictionary.value.strikethroughColor attributeName:NSStrikethroughColorAttributeName attrString:attrString range:range];
    //下划线
    [self setAttrStringWithObject:@(dictionary.value.underlineStyle) attributeName:NSUnderlineStyleAttributeName attrString:attrString range:range];
    //下划线颜色
    [self setAttrStringWithObject:dictionary.value.underlineColor attributeName:NSUnderlineColorAttributeName attrString:attrString range:range];
    //描边宽度
    [self setAttrStringWithObject:@(dictionary.value.strokeWidth) attributeName:NSStrokeWidthAttributeName attrString:attrString range:range];
    //描边颜色
    [self setAttrStringWithObject:dictionary.value.strokeColor attributeName:NSStrokeColorAttributeName attrString:attrString range:range];
    //阴影
    [self setAttrStringWithObject:dictionary.value.shadow attributeName:NSShadowAttributeName attrString:attrString range:range];
    //字体倾斜
    [self setAttrStringWithObject:@(dictionary.value.obliqueness) attributeName:NSObliquenessAttributeName attrString:attrString range:range];
    //文本扁平化
    [self setAttrStringWithObject:@(dictionary.value.expansion) attributeName:NSExpansionAttributeName attrString:attrString range:range];
}


- (void)setAttrStringWithObject:(id)object attributeName:(NSString *)attibuteName attrString:(NSMutableAttributedString *)attrString range:(NSRange)range
{
    if (!object) return;
    [attrString addAttribute:attibuteName value:object range:range];
}

@end


