//
//  PEMobile.h
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MobileDelegate ;

static CLLocationManager *locManager;
@interface PEMobile : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) id <MobileDelegate> mobileDelegate;//委托

@property (nonatomic) float version;//版本号
@property (nonatomic, retain) NSString * uuID;//手机uuid
@property (retain, nonatomic) NSString *appName;//app名字
@property (nonatomic, retain) NSString * phoneTime;//手机时间
@property (nonatomic, retain) NSString * timeZone;//时区

@property (nonatomic, retain) NSString * mobileType;//手机型号
@property (nonatomic, retain) NSString * osName;//系统名

@property (nonatomic, retain) NSString * contact;

@property (nonatomic, retain) NSString * ipIn;//内网ip
@property (nonatomic, retain) NSString * ipOut;//外网ip
@property (nonatomic, retain) NSString * networkProvider;//网络状况

@property (nonatomic) float longitude;//经度
@property (nonatomic) float latitude;//纬度
@property (nonatomic, retain) NSString *lbsTime;//GPS时间

//创建单例
+ (PEMobile *) sharedManager;

//设置StartApp字典
- (NSMutableDictionary *)getStartAppSetting;
- (NSMutableDictionary *)getStartAppSettingTest;
- (NSDictionary *)getAppInfo;
- (NSDictionary *)getAppInfoTest;
@end

//设置委托
@protocol MobileDelegate <NSObject>

- (void)getMessageSucc:(NSMutableDictionary *)dict;

@end