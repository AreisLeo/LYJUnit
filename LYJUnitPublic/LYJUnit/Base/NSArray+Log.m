//
//  NSArray+Log.m
//  pashong
//
//  Created by Aries li on 2017/5/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{

    NSMutableString *nmString = [NSMutableString stringWithString:@"\n"];
    NSString *tipsString = [NSString stringWithFormat:@"(%ld = Array)",level];
    NSMutableString *spaceTString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++)
    {
        [spaceTString appendString:@"\t"];
    }
    [nmString appendString:spaceTString];
    [nmString appendFormat:@"@%@[",tipsString];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]] ||
            [obj isKindOfClass:[NSArray class]])
        {
            NSString *description = [obj descriptionWithLocale:locale indent:level + 1];
            NSString *n = @"\n";
            if ([description hasPrefix:@"\n"])
            {
                n = @"";
            }
            [nmString appendFormat:@"%@%@%@,",n,spaceTString,description];
        }
        else
        {
            [nmString appendFormat:@"\n%@\"%@\",",spaceTString,obj];
        }
     
        
    }];
    [nmString appendFormat:@"\n%@",spaceTString];
    [nmString appendFormat:@"]%@",tipsString];
    NSRange range = [nmString rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [nmString deleteCharactersInRange:range];
    }
    return nmString.copy;
}

@end
