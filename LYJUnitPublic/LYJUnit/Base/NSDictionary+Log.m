//
//  NSDictionary+Log.m
//  pashong
//
//  Created by Aries li on 2017/5/19.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
    
    
//    NSString *lineStr = level == 0 ? @"" : @"\n";
    NSString *tipsString = [NSString stringWithFormat:@"(%ld = Json)",level];
    NSMutableString *nmString = [NSMutableString stringWithString:@"\n"];
    
    NSMutableString *spaceTString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++)
    {
        [spaceTString appendString:@"\t"];
    }
    [nmString appendString:spaceTString];
//    [nmString appendString:@"@{\n"];
    [nmString appendFormat:@"%@@{",tipsString];
//    @"\n{\n"
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]] ||
            [obj isKindOfClass:[NSArray class]])
        {
            NSString *description = [obj descriptionWithLocale:locale indent:level + 1];
            NSString *n = @"\n";
            if ([description hasPrefix:@"\n"])
            {
                n = @"\n";
            }
            [nmString appendFormat:@"%@\t%@\"%@\" = %@,",n,spaceTString,key,description];
        }
        else
        {
            [nmString appendFormat:@"\n\t%@\"%@\" = \"%@\",",spaceTString,key,obj];
        }
     
    }];
    [nmString appendFormat:@"\n%@",spaceTString];
    [nmString appendFormat:@"}%@",tipsString];
    NSRange range = [nmString rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [nmString deleteCharactersInRange:range];
    }
    return nmString.copy;
}

@end
