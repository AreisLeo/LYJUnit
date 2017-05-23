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
    }
    return self;
}

- (void)setObject:(id)object forKey:(id)key
{
    [self.mutableDictionary setObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key
{
    id object = [self.mutableDictionary objectForKey:key];
    return object;
}


- (void)setObject:(id)object forKeyIfNotNil:(id)key
{
    if (object && key)
    {
//        if ([self hasObjectForkeyIfNotNil:key])
//        {
//            [self setObject:object forKey:[self newKeyWithKey:key]];
//        }
//        else
//        {
//            [self setObject:object forKey:key];
//        }
        [self setObject:object forKey:[self newKeyWithKey:key]];
    }
}


- (id)objectOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else
    {
        return object;
    }
}


- (void)setIfNotNilWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        [self.mutableDictionary setDictionary:dictionary];
    }
}

- (BOOL)hasObjectForkeyIfNotNil:(id)key
{
    return [[self.mutableDictionary allKeys] containsObject:key];
}

- (NSString *)newKeyWithKey:(NSString *)key
{
    NSString *newKey = @"";
    newKey = [NSString stringWithFormat:@""];
    NSInteger currentCount = [self calculateSubStringCountWithKey:key];
    NSInteger count = 0;
    while (count < currentCount)
    {
        newKey = [NSString stringWithFormat:@"%@%@%ld",key,kAttributedDataNewKey,count];
        if (![self hasObjectForkeyIfNotNil:newKey])break;
        count++;
    }
    return newKey;
}
- (NSInteger)calculateSubStringCountWithKey:(NSString *)key
{
    NSInteger count = 0;
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

@end
