//
//  LYJUnitAttributedData.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJUnitAttributedData.h"

#define kAttributedDataNewKey @"LYJUnitAttributedDataNewKey"

#define kWeakSelf __weak typeof(self) weakSelf = self;

#pragma mark LYJUnitAttributedDictionary
@interface LYJUnitAttributedDictionary ()



/**
 key
 */
@property (strong ,nonatomic ,readwrite) NSString *key;

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

@property (assign ,nonatomic ,readwrite) NSUnderlineStyle underlineStyle;
@property (strong ,nonatomic,readwrite) UIColor *underlineColor;

@property (assign ,nonatomic ,readwrite) NSUnderlineStyle strikethroughStyle;

@property (strong ,nonatomic,readwrite) UIColor *strikethroughColor;

@property (strong ,nonatomic,readwrite) NSShadow *shadow;

@property (assign ,nonatomic, readwrite) NSInteger verticalGlyph;

@property (assign ,nonatomic ,readwrite) CGFloat obliqueness;

@property (assign ,nonatomic ,readwrite) CGFloat expansion;

/**  */
@property (copy ,nonatomic) BOOL (^hasCompletionKey)(NSString *key);

/**  */
@property (copy ,nonatomic) void (^changeValid)(LYJUnitAttributedDictionary *dictionary);

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

- (void)setFullText:(NSString *)fullText
{
    _fullText = fullText;
    self.isValid = [self setKey:self.key count:self.count];
}
- (void)setIsValid:(BOOL)isValid
{
    _isValid = isValid;
    !isValid && [self.key length] > 0 ? NSLog(@"当前 AttributedDictionary 无效! key = %@",self.key) :nil;
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
            weakSelf.isValid = [weakSelf setKey:key count:0];
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
            weakSelf.color = color;
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
            weakSelf.kern = value;
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
            weakSelf.font = font;
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
            weakSelf.lineOffset = value;
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
          
            weakSelf.backgroundColor = color;
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
            weakSelf.strikethroughStyle = style;
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
            weakSelf.strikethroughColor = color;
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
            weakSelf.underlineStyle = style;
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
            weakSelf.underlineColor = color;
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
            weakSelf.strokeColor = color;
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
            weakSelf.strokeWidth = strokeWidth;
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
            weakSelf.shadow = shadow;
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
            weakSelf.obliqueness = obliqueness;
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
            weakSelf.expansion = expansion;
            return weakSelf;
        };
    }
    return _dictionaryExpansion;
}


- (BOOL)setKey:(NSString *)key count:(NSInteger)count;
{
    NSInteger currentCount = [self calculateSubStringCountWithKey:key];
    if (currentCount == 0)  return NO;
    count = count >= currentCount ? currentCount - 1 : count;
    
    BOOL hasKey = YES;
    while (count < currentCount)
    {
        NSString *completionKey = [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count];
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

@end


#pragma mark LYJUnitAttributedData
@interface LYJUnitAttributedData ()

@property (strong ,nonatomic) NSMutableArray *mutableDictionarys;

@property (strong ,nonatomic) NSMutableArray *invalidMutableDictionarys;

@property (copy ,nonatomic ,readwrite) AttributedDataKey dictionaryKey;
@property (copy ,nonatomic ,readwrite) AttributedDataKey dictionaryKeyAll;
@property (copy ,nonatomic ,readwrite) AttributedDataKeyRestCount dictionaryKeyAndCount;
@property (copy ,nonatomic ,readwrite) AttributedDataKeyRestAll dictionaryKeyRestAll;
@property (copy ,nonatomic ,readwrite) AttributedDataColor dictionaryColor;
@property (strong ,nonatomic , readwrite) NSString *fullText;

@end

@implementation LYJUnitAttributedData

@synthesize dictionaryKey = _dictionaryKey;

- (AttributedDataKey)dictionaryKey
{
    LYJUnitAttributedDictionary *dictionary = [self dictionary];
    
    _dictionaryKey = dictionary.dictionaryKey;

    return _dictionaryKey;
}

- (void)restdictionaryKeyAndCount:(NSString *)key count:(NSInteger)count andDictionaryKeyAndCount:(AttributedDataKeyRestCount)dictionaryKeyAndCount
{
//    [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count]
    LYJUnitAttributedDictionary *dictionary = [self object:(NSString *)];
}

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

- (instancetype)initWithFullText:(NSString *)fullText
{
    if (self = [super init])
    {
        self.fullText = fullText;
    }
    return self;
}
#pragma mark -----Add------

#pragma mark -----Set------
- (LYJUnitAttributedDictionary *)dictionary
{
    kWeakSelf;
    LYJUnitAttributedDictionary *dictionary = [[LYJUnitAttributedDictionary alloc] init];
    dictionary.changeValid = ^(LYJUnitAttributedDictionary *dictionary) {
        [weakSelf addDictionary:dictionary];
    };
    dictionary.fullText = self.fullText;
    dictionary.hasCompletionKey = ^BOOL(NSString *key) {
       return [weakSelf hasObjectForCompletionKeyIfNotNil:key];
    };
    return dictionary;
}


- (void)addDictionary:(LYJUnitAttributedDictionary *)dictionary
{
    [self.mutableDictionarys containsObject:dictionary] ? [self.mutableDictionarys removeObject:dictionary] : nil;
    
    [self.invalidMutableDictionarys containsObject:dictionary] ? [self.invalidMutableDictionarys removeObject:dictionary] : nil;
    
    dictionary.isValid ? [self.mutableDictionarys addObject:dictionary] : [self.invalidMutableDictionarys addObject:dictionary];
}

- (BOOL)hasObjectForCompletionKeyIfNotNil:(NSString *)completionkey
{
    BOOL hasKey = NO;
    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if ([dictionary.completionKey isEqualToString:completionkey])
        {
            hasKey = YES;
            break;
        }
    }
    return hasKey;
}

#pragma mark -----Remove------
- (LYJUnitAttributedDictionary *)objectForCompletionKeyIfNotNil:(NSString *)completionkey
{
    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if ([dictionary.completionKey isEqualToString:completionkey])
        {
            return dictionary;
        }
    }
    return [self dictionary];
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

//    [self.invalidMutableDictionarys removeAllObjects];

    for (LYJUnitAttributedDictionary *dictionary in self.mutableDictionarys)
    {
        if (!dictionary.isValid) continue;
        //设置颜色
        [self setAttrStringWithObject:dictionary.color attributeName:NSForegroundColorAttributeName attrString:attrString range:dictionary.range];
        //设置字体
        [self setAttrStringWithObject:dictionary.font attributeName:NSFontAttributeName attrString:attrString range:dictionary.range];
        //设置位置
        [self setAttrStringWithObject:@(dictionary.lineOffset) attributeName:NSBaselineOffsetAttributeName attrString:attrString range:dictionary.range];
        //设置间距
        [self setAttrStringWithObject:@(dictionary.kern) attributeName:NSKernAttributeName  attrString:attrString range:dictionary.range];
        //文字背景颜色
        [self setAttrStringWithObject:dictionary.backgroundColor attributeName:NSBackgroundColorAttributeName attrString:attrString range:dictionary.range];
        //删除线
        [self setAttrStringWithObject:@(dictionary.strikethroughStyle) attributeName:NSStrikethroughStyleAttributeName attrString:attrString range:dictionary.range];
        //删除线颜色
        [self setAttrStringWithObject:dictionary.strikethroughColor attributeName:NSStrikethroughColorAttributeName attrString:attrString range:dictionary.range];
        //下划线
        [self setAttrStringWithObject:@(dictionary.underlineStyle) attributeName:NSUnderlineStyleAttributeName attrString:attrString range:dictionary.range];
        //下划线颜色
        [self setAttrStringWithObject:dictionary.underlineColor attributeName:NSUnderlineColorAttributeName attrString:attrString range:dictionary.range];
        //描边宽度
        [self setAttrStringWithObject:@(dictionary.strokeWidth) attributeName:NSStrokeWidthAttributeName attrString:attrString range:dictionary.range];
        //描边颜色
        [self setAttrStringWithObject:dictionary.strokeColor attributeName:NSStrokeColorAttributeName attrString:attrString range:dictionary.range];
        //阴影
        [self setAttrStringWithObject:dictionary.shadow attributeName:NSShadowAttributeName attrString:attrString range:dictionary.range];
        //字体倾斜
        [self setAttrStringWithObject:@(dictionary.obliqueness) attributeName:NSObliquenessAttributeName attrString:attrString range:dictionary.range];
        //文本扁平化
        [self setAttrStringWithObject:@(dictionary.expansion) attributeName:NSExpansionAttributeName attrString:attrString range:dictionary.range];
        
    }
    return attrString;
}


- (void)setAttrStringWithObject:(id)object attributeName:(NSString *)attibuteName attrString:(NSMutableAttributedString *)attrString range:(NSRange)range
{
    if (!object)
    {
        return;
    }
    [attrString addAttribute:attibuteName value:object range:range];
}

@end



