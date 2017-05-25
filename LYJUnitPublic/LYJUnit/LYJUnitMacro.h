//
//  LYJUnitMacro.h
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#ifndef LYJUnitMacro_h
#define LYJUnitMacro_h


#define KeyWindow [UIApplication sharedApplication].keyWindow






#pragma mark ------ENUM------
typedef enum : NSUInteger {
    LYJAttributedDataTypeColor = 1 << 0,
    LYJAttributedDataTypeFont = 1 << 1,
    LYJAttributedDataTypeLineOffset = 1 << 2,
    LYJAttributedDataTypeKern = 1 << 3,
} LYJAttributedDataType;

typedef enum : NSUInteger {
    LYJAttributedDictionaryChangeTypeObject = 1 << 0,
    LYJAttributedDictionaryChangeTypeKey = 1 << 1,
    LYJAttributedDictionaryChangeTypeCount = 1 << 2,
} LYJAttributedDictionaryChangeType;


#endif /* LYJUnitMacro_h */
