//
//  Common.m
//  Pet
//
//  Created by Evan Wu on 6/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (void)checkSetting {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UI_THEME]) {
        [[NSUserDefaults standardUserDefaults] setObject:UI_THEME_DEFAULT forKey:UI_THEME];
    }
    
}

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

//正则表达式判断电话号码是否合法
+ (BOOL)regexer: (NSString *)str rx_matchesPattern: (NSString *)regexerStr {
    
    NSError *error = NULL;
    //定义正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexerStr
                                                                           options:0
                                                                             error:&error];
    //使用正则表达式匹配字符
    NSTextCheckingResult *isMatch = [regex firstMatchInString:str
                                                      options:0
                                                        range:NSMakeRange(0, [str length])];
    if (isMatch) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

//md5 加密
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}


//AlterView
+(void)commonAlertShowWithTitle:(NSString *)title Message:(NSString *)msg {
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+ (void) showAlert: (NSString *) message
{
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    //[self showMsg:message];
}

+ (NSString *)docFilePath {
    NSString* s = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    //NSLog(@"%@",s);
    return s;
}

+ (NSString *)dataFilePath {
    NSString* s = [NSString stringWithFormat:@"%@/Library/Caches/",NSHomeDirectory()];
    //NSLog(@"%@",s);
    return s;
}

+ (NSString *)tempFilePath {
    NSString* s = [NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    //NSLog(@"%@",s);
    return s;
}

+ (NSString *)imageFilePath {
    NSString *s=[[NSBundle mainBundle] bundlePath];
    s = [s stringByAppendingString:@"/"];
    //NSLog(@"%@",s);
    return s;
}

+ (UIButton*)createFooterButton:(NSString*)s action:(SEL)action target:(id)target{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame   = CGRectMake((320-76)/2, (49-36)/2, 152/2, 72/2);
    
    //    UIImage* jpg = [[UIImage alloc]initWithContentsOfFile:[[self imageFilePath] stringByAppendingPathComponent:@"button@2x.png"]];
    UIImage* jpg = [UIImage imageWithContentsOfFile:[[self imageFilePath] stringByAppendingPathComponent:@"tabbar_button_normal@2x.png"]];
    jpg = [jpg stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    [btn setBackgroundImage:jpg forState:UIControlStateNormal];
    
    jpg = [UIImage imageWithContentsOfFile:[[self imageFilePath] stringByAppendingPathComponent:@"tabbar_button_normal@2x.png"]];
    jpg = [jpg stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    [btn setBackgroundImage:jpg forState:UIControlStateHighlighted];
    
    btn.showsTouchWhenHighlighted = YES;
    [btn setTitle:s forState:UIControlStateNormal];
    btn.font = [UIFont systemFontOfSize:13];
    //btn.titleLabel.textColor = [UIColor yellowColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (NSDateComponents *)getDateConponent:(NSString *)dateString;{

    NSString *tempAgeString =[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
        //将字符串转化成NSDate类型
    NSDate *tempAgeDate =[formatter dateFromString:tempAgeString];
        
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:tempAgeDate];
    return conponent;
 
    
}

+ (NSDateComponents *)getTempDateConponent;{
    
    NSDate * tempDate=[NSDate date];
    NSCalendar * tempCal=[NSCalendar currentCalendar];
    NSUInteger tempUnitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * tempConponent= [tempCal components:tempUnitFlags fromDate:tempDate];
    return tempConponent;
    
}

+ (NSString*)formatdateFromStr:(NSString*)s format:(NSString*)str{
    NSDateFormatter* f=[[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* d = [f dateFromString:s];
    
    f.dateFormat = str;
    NSString* s1 = [f stringFromDate:d];
    return  s1;
}

+ (NSString*)formatdate:(NSDate*)d format:(NSString*)str{
    NSDateFormatter* f=[[NSDateFormatter alloc]init];
    f.dateFormat = str;
    NSString* s = [f stringFromDate:d];
    return  s;
}


@end
