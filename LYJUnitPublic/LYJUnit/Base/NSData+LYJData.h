//
//  NSData+LYJData.h
//  LYJUnitPublic
//
//  Created by yuwang on 2018/8/7.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LYJData)

- (NSString *)md2String;

- (NSData *)md2Data;

- (NSString *)md4String;

- (NSData *)md4Data;

- (NSString *)md5String;

- (NSData *)md5Data;

- (NSString *)sha1String;

- (NSData *)sha1Data;

- (NSString *)sha224String;

- (NSData *)sha224Data;

- (NSString *)sha256String;

- (NSData *)sha256Data;

- (NSString *)sha384String;

- (NSData *)sha384Data;

- (NSString *)sha512String;

- (NSData *)sha512Data;

- (NSString *)hmacMD5StringWithKey:(NSString *)key;

- (NSData *)hmacMD5DataWithKey:(NSData *)key;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

- (NSData *)hmacSHA1DataWithKey:(NSData *)key;

- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

- (NSData *)hmacSHA224DataWithKey:(NSData *)key;

- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

- (NSData *)hmacSHA256DataWithKey:(NSData *)key;

- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

- (NSData *)hmacSHA384DataWithKey:(NSData *)key;

- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

- (NSData *)hmacSHA512DataWithKey:(NSData *)key;

- (NSString *)crc32String;

- (uint32_t)crc32;

- (nullable NSData *)aes256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

- (nullable NSData *)aes256DecryptWithkey:(NSData *)key iv:(nullable NSData *)iv;

- (nullable NSString *)utf8String;

- (nullable NSString *)hexString;

+ (nullable NSData *)dataWithHexString:(NSString *)hexString;

- (nullable NSString *)base64EncodedString;

+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

- (nullable id)jsonValueDecoded;

- (nullable NSData *)gzipInflate;

- (nullable NSData *)gzipDeflate;

- (nullable NSData *)zlibInflate;

- (nullable NSData *)zlibDeflate;

+ (nullable NSData *)dataNamed:(NSString *)name;
@end
