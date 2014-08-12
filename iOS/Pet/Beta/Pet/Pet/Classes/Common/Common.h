//
//  Common.h
//  Pet
//
//  Created by Evan Wu on 6/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
@interface Common : NSObject

+ (void)checkSetting;

+ (NSString *)deviceString;

//正则表达式判断电话号码是否合法
+ (BOOL)regexer: (NSString *)str rx_matchesPattern: (NSString *)regexerStr;

//正则表达式判断邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)Email;

+ (void)commonAlertShowWithTitle:(NSString *)title Message:(NSString *)msg;

+ (void) showAlert: (NSString *) message;

+ (NSDateComponents *)getDateConponent:(NSString *)dateString;

+ (NSDateComponents *)getTempDateConponent;



//md5
+ (NSString *)md5:(NSString *)str;

+ (NSString *)docFilePath;
+ (NSString *)dataFilePath;
+ (NSString *)tempFilePath;
+ (NSString *)imageFilePath;
+ (UIButton*)createFooterButton:(NSString*)s action:(SEL)action target:(id)target;

+ (NSString*)formatdateFromStr:(NSString*)s format:(NSString*)str;
+ (NSString*)formatdate:(NSDate*)d format:(NSString*)str;
@end
