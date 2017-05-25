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

@class LYJUnitAttributedDictionary;
@interface LYJUnitAttributedData : NSObject

/**
 完整字符串
 */
@property (strong ,nonatomic,readonly)  NSString *fullText;


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





- (BOOL)hasObjectForCompletionKeyIfNotNil:(NSString *)completionkey andDataType:(LYJAttributedDataType)dataType;


- (NSMutableAttributedString *)attributedString;


@end


@interface LYJUnitAttributedDictionary : NSObject


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

@end
