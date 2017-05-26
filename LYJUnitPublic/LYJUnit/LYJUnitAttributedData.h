//
//  LYJUnitAttributedData.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYJUnitMacro.h"

@class LYJUnitAttributedDictionary,LYJUnitAttributedData;

typedef LYJUnitAttributedDictionary *(^AttributedDataKeyRestAll)(NSString *key);

typedef LYJUnitAttributedDictionary *(^AttributedDataKeyRestCount)(NSString *key,NSInteger count);

typedef LYJUnitAttributedDictionary * (^AttributedDataKey)(NSString *key);

typedef LYJUnitAttributedDictionary *(^AttributedDataColor)(UIColor *color);

typedef LYJUnitAttributedDictionary *(^AttributedDataFont)(UIFont *font);

typedef LYJUnitAttributedDictionary *(^AttributedDataLineOffset)(CGFloat value);

typedef LYJUnitAttributedDictionary *(^AttributedDataKern)(CGFloat value);

typedef LYJUnitAttributedDictionary *(^AttributedDataCount)(NSInteger value);



@interface LYJUnitAttributedData : NSObject

/**
 完整字符串
 */
@property (strong ,nonatomic,readonly)  NSString *fullText;


/**
 key 创建 count 全部默认:0
 */
@property (copy ,nonatomic ,readonly) AttributedDataKey dictionaryKey;


/**
 key 创建全部与 key 相关的dictionary count 自增长 0 - 无限 
 */
@property (copy ,nonatomic ,readonly) AttributedDataKey dictionaryKeyAll;

/**
 key count 修改 目标字符串
 */
@property (copy ,nonatomic ,readonly) AttributedDataKeyRestCount dictionaryKeyAndCount;

/**
 key 全修改
 */
@property (copy ,nonatomic ,readonly) AttributedDataKeyRestAll dictionaryKeyRestAll;


+ (instancetype)dataWithFullText:(NSString *)fullText;


- (instancetype)initWithFullText:(NSString *)fullText;




- (void)setObject:(id)object forKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType;


- (void)setObject:(id)object forAllKeyIfNotNil:(NSString *)key andDataType:(LYJAttributedDataType)dataType;

- (void)setIfNotNilWithDictionary:(LYJUnitAttributedDictionary *)dictionary andDataType:(LYJAttributedDataType)dataType;

/**
 *  改变字典中数值
 */
- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary andCount:(NSInteger)count;

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count andKey:(NSString *)key;

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count key:(NSString *)key andObject:(id)object;

- (void)changeValueWithDictionary:(LYJUnitAttributedDictionary *)dictionary count:(NSInteger)count key:(NSString *)key object:(id)object andDataType:(LYJAttributedDataType)dataType;



- (NSArray *)objectOrNilForKey:(NSString *)key andDataType:(LYJAttributedDataType)dataType;



- (NSArray *)allObjectOrNilForKey:(NSString *)key;

- (BOOL)hasObjectForCompletionKeyIfNotNil:(NSString *)completionkey andDataType:(LYJAttributedDataType)dataType;


- (NSMutableAttributedString *)attributedString;


@end


@interface LYJUnitAttributedDictionary : NSObject


@property (strong ,nonatomic) NSString *fullText;

/**
 key 创建 count 全部默认:0
 */
@property (copy ,nonatomic ,readonly) AttributedDataKey dictionaryKey;

/**
 color
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryColor;

/**
 font
 */
@property (copy ,nonatomic ,readonly) AttributedDataFont dictionaryFont;

/**
 lineOffset
 */
@property (copy ,nonatomic ,readonly) AttributedDataLineOffset dictionaryLineOffset;

/**
 kern
 */
@property (copy ,nonatomic ,readonly) AttributedDataKern dictionaryKern;

/**
 dictionaryCount
 */
@property (copy ,nonatomic ,readonly) AttributedDataCount dictionaryCount;


/**
 object
 */
@property (assign ,nonatomic) id object;


/**
 目标 range
 */
@property (assign ,nonatomic) NSRange range;

/**
 key
 */
@property (strong ,nonatomic,readonly) NSString *key;

/**
 当前 dictionary 类型
 */
@property (assign ,nonatomic,readonly) LYJAttributedDataType dataType;

/**
 当前是第几个同样字符 当前字符出现相同时才 有使用效果
 */
@property (assign ,nonatomic,readonly) NSInteger count;

/**
 color
 */
@property (strong ,nonatomic ,readonly) UIColor *color;

/**
 kern
 */
@property (assign ,nonatomic ,readonly) CGFloat kern;

/**
 lineOffset
 */
@property (assign ,nonatomic ,readonly) CGFloat lineOffset;

/**
 font
 */
@property (strong ,nonatomic ,readonly) UIFont *font;


/**
 当前是否有效
 */
@property (assign ,nonatomic)  BOOL isValid;
@end
