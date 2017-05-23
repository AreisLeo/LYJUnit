//
//  LYJUnitAttributedData.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYJUnitAttributedData : NSObject

/**
 完整字符串
 */
@property (strong ,nonatomic,readonly)  NSString *fullText;


+ (instancetype)dataWithFullText:(NSString *)fullText;

- (instancetype)initWithFullText:(NSString *)fullText;

- (void)setObject:(id)object forKeyIfNotNil:(id)key;

- (id)objectOrNilForKey:(NSString *)key;

- (void)setIfNotNilWithDictionary:(NSDictionary *)dictionary;

- (BOOL)hasObjectForkeyIfNotNil:(id)key;
@end
