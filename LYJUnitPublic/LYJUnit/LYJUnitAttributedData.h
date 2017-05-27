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

typedef LYJUnitAttributedDictionary *(^AttributedDataUnderlineStyle)(NSUnderlineStyle style);

typedef LYJUnitAttributedDictionary *(^AttributedDataStrokeWidth)(CGFloat strokeWidth);

typedef LYJUnitAttributedDictionary *(^AttributedDataShadow)(CGSize shadowOffset,CGFloat shadowBlurRadius,UIColor *shadowColor);

typedef LYJUnitAttributedDictionary *(^AttributedDataExpansion)(CGFloat expansion);

typedef LYJUnitAttributedDictionary *(^AttributedDataObliqueness)(CGFloat obliqueness);

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


- (NSMutableAttributedString *)attributedString;

- (void)restdictionaryKeyAndCount:(NSString *)key count:(NSInteger)count andDictionaryKeyAndCount:(AttributedDataKeyRestCount)dictionaryKeyAndCount;
@end


@interface LYJUnitAttributedDictionary : NSObject


@property (strong ,nonatomic) NSString *fullText;

/**
 key 创建 count 全部默认:0
 */
@property (copy ,nonatomic ,readonly) AttributedDataKey dictionaryKey;

/**
 color 该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryColor;

/**
 color 该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryBackgroundColor;

/**
 font 如果不指定该属性，则默认为12-point Helvetica(Neue)
 */
@property (copy ,nonatomic ,readonly) AttributedDataFont dictionaryFont;

/**
 lineOffset 正值top上升，负值top下降
 */
@property (copy ,nonatomic ,readonly) AttributedDataLineOffset dictionaryLineOffset;

/**
 kern 正值间距加宽，负值间距变窄
 */
@property (copy ,nonatomic ,readonly) AttributedDataKern dictionaryKern;

/**
 dictionaryCount 设置第为几个字符串
 */
@property (copy ,nonatomic ,readonly) AttributedDataCount dictionaryCount;

/**
 dictionaryStrikethrough NSUnderlineStyle 删除线
 */
@property (copy ,nonatomic ,readonly) AttributedDataUnderlineStyle dictionaryStrikethrough;

/**
 dictionaryStrikethroughColor NSUnderlineStyle 删除线颜色
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryStrikethroughColor;

/**
 dictionaryUnderline NSUnderlineStyle 下划线
 */
#pragma mark 与shadow同时使用时出bug
@property (copy ,nonatomic ,readonly) AttributedDataUnderlineStyle dictionaryUnderline;

/**
 dictionaryUnderlineColor NSUnderlineStyle 下划线颜色
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryUnderlineColor;

/**
 dictionaryStrokeColor 描边颜色
 */
@property (copy ,nonatomic ,readonly) AttributedDataColor dictionaryStrokeColor;

/**
 dictionaryStrokeWidth 描边宽度
 */
@property (copy ,nonatomic ,readonly) AttributedDataStrokeWidth dictionaryStrokeWidth;

/**
 dictionaryShadow 阴影
 */
#pragma mark 与underline同时使用时出bug
@property (copy ,nonatomic ,readonly) AttributedDataShadow dictionaryShadow;

/**
 dictionaryVerticalGlyph 垂直样式
 */
@property (copy ,nonatomic ,readonly) AttributedDataObliqueness dictionaryObliqueness;

/**
 dictionaryVerticalGlyph 扁平化样式
 */
@property (copy ,nonatomic ,readonly) AttributedDataExpansion dictionaryExpansion;

/**
 目标 range
 */
@property (assign ,nonatomic) NSRange range;

/**
 key
 */
@property (strong ,nonatomic,readonly) NSString *key;

/**
 当前是第几个同样字符 当前字符出现相同时才 有使用效果
 */
@property (assign ,nonatomic,readonly) NSInteger count;

/**
 文字颜色 默认 nil
 */
@property (strong ,nonatomic ,readonly) UIColor *color;

/**
 背景颜色 默认 nil
 */
@property (strong ,nonatomic ,readonly) UIColor *backgroundColor;

/**
 垂直高度 默认 0
 */
@property (assign ,nonatomic ,readonly) CGFloat kern;

/**
 文字分隔 默认 0
 */
@property (assign ,nonatomic ,readonly) CGFloat lineOffset;

/**
 字体大小 默认 nil
 */
@property (strong ,nonatomic ,readonly) UIFont *font;

/**
 删除线 默认 NSUnderlineStyleNone
 */
@property (assign ,nonatomic ,readonly) NSUnderlineStyle strikethroughStyle;

/**
 删除线 默认 黑色
 */
@property (strong ,nonatomic ,readonly) UIColor *strikethroughColor;

/**
 下划线 默认 NSUnderlineStyleNone
 */
@property (assign ,nonatomic ,readonly) NSUnderlineStyle underlineStyle;

/**
 下划线 默认 黑色
 */
@property (strong ,nonatomic ,readonly) UIColor *underlineColor;

/**
 描边颜色 默认 nil
 */
@property (strong ,nonatomic ,readonly) UIColor *strokeColor;

/**
 描边宽度 默认 0;
 */
@property (assign ,nonatomic ,readonly) CGFloat strokeWidth;

/**
 阴影 默认 nil
 */
@property (strong ,nonatomic ,readonly) NSShadow *shadow;

/** 
 横竖排版 横：0 竖：1 默认：0
 */
@property (assign ,nonatomic, readonly) NSInteger verticalGlyph;


/**
 斜体 默认 0  value < 0 斜左面 value > 0 斜右面
 */
@property (assign ,nonatomic ,readonly) CGFloat obliqueness;


/**
 扁平化 默认 0 value < 0 缩小 value > 0 扩大
 */
@property (assign ,nonatomic ,readonly) CGFloat expansion;

/**
 当前是否有效
 */
@property (assign ,nonatomic)  BOOL isValid;


@end
