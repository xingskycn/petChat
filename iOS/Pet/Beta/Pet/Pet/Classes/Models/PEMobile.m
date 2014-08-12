//
//  PEMobile.m
//  Pet
//
//  Created by Wuzhiyong on 5/29/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEMobile.h"
#import <AFNetworking.h>
#import "Common.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation PEMobile

@synthesize uuID,appName, version, osName, phoneTime, timeZone, mobileType, ipOut, ipIn, networkProvider, contact, latitude, lbsTime, longitude;
@synthesize mobileDelegate;

//创建单例
+ (PEMobile *)sharedManager {
    static PEMobile *_sharedManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager =[[PEMobile alloc]init];
        [_sharedManager initClass];
    });
    
    return _sharedManager;
}

//设置属性
- (void)initClass {
    NSString *systemName =[[UIDevice currentDevice] systemName];
    NSString *systemVersion =[[UIDevice currentDevice] systemVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    appName =APP_NAME;
    version = [[infoDictionary valueForKey:@"CFBundleVersion"] floatValue];
    
    osName = [NSString stringWithFormat:@"%@%@", systemName, systemVersion];
    mobileType = [Common deviceString];
    
    phoneTime =[NSString stringWithFormat:@"%@", [NSDate date]];
    timeZone =[NSString stringWithFormat:@"%@", [NSTimeZone systemTimeZone]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HAS_USED]) {
        uuID =[NSString stringWithString:[self generateUuidString]];
        
        [[NSUserDefaults standardUserDefaults] setValue:uuID forKey:MOBILE_INFO_UUID];
    }
    
    [self checkNetworking];
}


#pragma mark - CHECK NETWORKING
- (void)checkNetworking {
    //networkProvider
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        
        //getIPAddress
//        NSLog(@"%@", [self getIPAddressIn:YES]);
//        NSLog(@"%@", [self getIPAddressOut:YES]);
        
        //设置属性
        ipIn =[NSString stringWithString:[self getIPAddressIn:YES]];
        ipOut =[NSString stringWithString:[self getIPAddressOut:YES]];
        networkProvider =[NSString stringWithString:AFStringFromNetworkReachabilityStatus(status)];
        
        
        [self getGPSData];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


#pragma mark - GET IP ADDRESS
- (NSString *)getIPAddressIn:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSString *)getIPAddressOut:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - GPS METHOD
- (void)getGPSData {
    locManager =[[CLLocationManager alloc]init];
    locManager.delegate =self;
    locManager.desiredAccuracy =kCLLocationAccuracyBest;
    locManager.distanceFilter =5.0f;
    
    [locManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //    NSLog(@"%@", locations);
    CLLocation *newLocation =locations[0];
    
    longitude =newLocation.coordinate.longitude;
    latitude =newLocation.coordinate.latitude;
    lbsTime =[NSString stringWithFormat:@"%@", newLocation.timestamp];
    
    [locManager stopUpdatingLocation];
    
    [self saveSetting];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    longitude =0.0f;
    latitude =0.0f;
    lbsTime =@"";
    
    [Common commonAlertShowWithTitle:NSLocalizedString(WEL_ALERT_TITLE, nil) Message:NSLocalizedString(WEL_ALERT_MSG, nil)];
    
    [locManager stopUpdatingLocation];
    
    [self saveSetting];
}

#pragma mark - GENERATE DEVICE UUID

- (NSString *)generateUuidString {
	
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    
    return uuidString;
}

#pragma mark - SETTING USERDEFAULT
- (void)saveSetting {
    
    //setting app info
    [[NSUserDefaults standardUserDefaults] setValue:appName forKey:APPINFO_NAME];
    [[NSUserDefaults standardUserDefaults] setFloat:version forKey:APPINFO_VERSION];
    
    //setting mobile info
    [[NSUserDefaults standardUserDefaults] setValue:mobileType forKey:MOBILE_INFO_TYPE];
    [[NSUserDefaults standardUserDefaults] setValue:osName forKey:MOBILE_INFO_OSNAME];
    [[NSUserDefaults standardUserDefaults] setValue:phoneTime forKey:MOBILE_INFO_TIME];
    [[NSUserDefaults standardUserDefaults] setValue:timeZone forKey:MOBILE_INFO_TIMEZONE];
    
    //setting networking
    [[NSUserDefaults standardUserDefaults] setValue:ipIn forKey:NETINFO_IP_IN];
    [[NSUserDefaults standardUserDefaults] setValue:ipOut forKey:NETINFO_IP_OUT];
    [[NSUserDefaults standardUserDefaults] setValue:networkProvider forKey:NETINFO_PROVIDER];
    
    //setting gps
    [[NSUserDefaults standardUserDefaults] setValue:lbsTime forKey:GPS_TIME];
    [[NSUserDefaults standardUserDefaults] setFloat:latitude forKey:GPS_LATITUDE];
    [[NSUserDefaults standardUserDefaults] setFloat:longitude forKey:GPS_LONGITUDE];
    
    //setting userID
    [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:USER_INFO_ID];
    
    //delegate
    if (longitude) {
        [mobileDelegate getMessageSucc:[self getStartAppSetting]];
//        [mobileDelegate getMessageSucc:[self getStartAppSettingTest]];
    }else {
        [Common commonAlertShowWithTitle:NSLocalizedString(WEL_ALERT_TITLE, nil) Message:NSLocalizedString(WEL_ALERT_MSG, nil)];
    }
    
}

#pragma mark -
#pragma mark SETTING START APP INFO
- (NSMutableDictionary *)getStartAppSetting {
    NSDictionary *apiDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:APPINFO_NAME],
                                                                 [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults] floatForKey:APPINFO_VERSION]]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_APPINFO_NAME,
                                                                 HTTP_APPINFO_VERSION
                                                                 ]
                            ];
    
    NSDictionary *cellsDict =[NSDictionary dictionaryWithObjects:@[
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_UUID],
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:USER_INFO_ID]
                                                                   ]
                                                         forKeys:@[
                                                                   HTTP_MOBILE_INFO_UUID,
                                                                   HTTP_USER_INFO_ID
                                                                   ]
                              ];
    
    NSDictionary *mobileDict =[NSDictionary dictionaryWithObjects:@[
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_IP_IN],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_IP_OUT],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_PROVIDER],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TYPE],
                                                                     [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_OSNAME],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TIME],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TIMEZONE]
                                                                    ]
                                                          forKeys:@[
                                                                    HTTP_NETINFO_IP_IN,
                                                                    HTTP_NETINFO_IP_OUT,
                                                                    HTTP_NETINFO_PROVIDER,
                                                                    HTTP_MOBILE_INFO_TYPE,
                                                                    HTTP_MOBILE_INFO_OSNAME,
                                                                    HTTP_MOBILE_INFO_TIME,
                                                                    HTTP_MOBILE_INFO_TIMEZONE
                                                                    ]
                               ];
    NSDictionary *lbsDict =[NSDictionary dictionaryWithObjects:@[
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LATITUDE],
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LONGITUDE],
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:GPS_TIME]
                                                                   ]
                                                         forKeys:@[
                                                                   HTTP_GPS_LATITUDE,
                                                                   HTTP_GPS_LONGITUDE,
                                                                   HTTP_GPS_TIME
                                                                   ]
                              ];
    
    NSMutableDictionary *startDict =[[NSMutableDictionary alloc]init];
    [startDict setObject:apiDict forKey:API_INFO_KEY];
    [startDict setObject:cellsDict forKey:CELLS_INFO_KEY];
    [startDict setObject:mobileDict forKey:MOBILE_INFO_KEY];
    [startDict setObject:lbsDict forKey:LBS_INFO_KEY];
    
    return startDict;
}

- (NSMutableDictionary *)getStartAppSettingTest {
    NSDictionary *apiDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:APPINFO_NAME],
                                                                 [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults] floatForKey:APPINFO_VERSION]]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_APPINFO_NAME,
                                                                 HTTP_APPINFO_VERSION
                                                                 ]
                            ];
    
    NSDictionary *cellsDict =[NSDictionary dictionaryWithObjects:@[
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_UUID],
                                                                   @"15678"
                                                                   ]
                                                         forKeys:@[
                                                                   HTTP_MOBILE_INFO_UUID,
                                                                   HTTP_USER_INFO_ID
                                                                   ]
                              ];
    
    NSDictionary *mobileDict =[NSDictionary dictionaryWithObjects:@[
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_IP_IN],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_IP_OUT],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:NETINFO_PROVIDER],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TYPE],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_OSNAME],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TIME],
                                                                    [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_TIMEZONE]
                                                                    ]
                                                          forKeys:@[
                                                                    HTTP_NETINFO_IP_IN,
                                                                    HTTP_NETINFO_IP_OUT,
                                                                    HTTP_NETINFO_PROVIDER,
                                                                    HTTP_MOBILE_INFO_TYPE,
                                                                    HTTP_MOBILE_INFO_OSNAME,
                                                                    HTTP_MOBILE_INFO_TIME,
                                                                    HTTP_MOBILE_INFO_TIMEZONE
                                                                    ]
                               ];
    NSDictionary *lbsDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LATITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LONGITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_TIME]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_GPS_LATITUDE,
                                                                 HTTP_GPS_LONGITUDE,
                                                                 HTTP_GPS_TIME
                                                                 ]
                            ];
    
    NSMutableDictionary *startDict =[[NSMutableDictionary alloc]init];
    [startDict setObject:apiDict forKey:API_INFO_KEY];
    [startDict setObject:cellsDict forKey:CELLS_INFO_KEY];
    [startDict setObject:mobileDict forKey:MOBILE_INFO_KEY];
    [startDict setObject:lbsDict forKey:LBS_INFO_KEY];
    
    return startDict;
}
#pragma mark -
#pragma mark SETTING APP INFO
- (NSDictionary *)getAppInfo {
    NSDictionary *apiDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:APPINFO_NAME],
                                                                 [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults] floatForKey:APPINFO_VERSION]]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_APPINFO_NAME,
                                                                 HTTP_APPINFO_VERSION
                                                                 ]];
    NSDictionary *cellsDict =[NSDictionary dictionaryWithObjects:@[
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_UUID],
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:USER_INFO_ID]
                                                                   ]
                                                         forKeys:@[
                                                                   HTTP_MOBILE_INFO_UUID,
                                                                   HTTP_USER_INFO_ID
                                                                   ]];
    NSDictionary *lbsDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LATITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LONGITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_TIME]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_GPS_LATITUDE,
                                                                 HTTP_GPS_LONGITUDE,
                                                                 HTTP_GPS_TIME
                                                                 ]];
    
    NSMutableDictionary *startDict =[[NSMutableDictionary alloc]init];
    [startDict setObject:apiDict forKey:API_INFO_KEY];
    [startDict setObject:cellsDict forKey:CELLS_INFO_KEY];
    [startDict setObject:lbsDict forKey:LBS_INFO_KEY];
    
    return startDict;
}

- (NSDictionary *)getAppInfoTest {
    NSDictionary *apiDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:APPINFO_NAME],
                                                                 [NSNumber numberWithFloat:[[NSUserDefaults standardUserDefaults] floatForKey:APPINFO_VERSION]]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_APPINFO_NAME,
                                                                 HTTP_APPINFO_VERSION
                                                                 ]];
    NSDictionary *cellsDict =[NSDictionary dictionaryWithObjects:@[
                                                                   [[NSUserDefaults standardUserDefaults] valueForKey:MOBILE_INFO_UUID],
                                                                   @"15678" //HTTP_USER_INFO_ID   15678
                                                                   ]
                                                         forKeys:@[
                                                                   HTTP_MOBILE_INFO_UUID, //UUID
                                                                   HTTP_USER_INFO_ID //userID
                                                                   ]];
    NSDictionary *lbsDict =[NSDictionary dictionaryWithObjects:@[
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LATITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_LONGITUDE],
                                                                 [[NSUserDefaults standardUserDefaults] valueForKey:GPS_TIME]
                                                                 ]
                                                       forKeys:@[
                                                                 HTTP_GPS_LATITUDE,
                                                                 HTTP_GPS_LONGITUDE,
                                                                 HTTP_GPS_TIME
                                                                 ]];
    
    NSMutableDictionary *startDict =[[NSMutableDictionary alloc]init];
    //这三个字典是基本的信息：
    [startDict setObject:apiDict forKey:API_INFO_KEY];
    [startDict setObject:cellsDict forKey:CELLS_INFO_KEY];
    [startDict setObject:lbsDict forKey:LBS_INFO_KEY];
    
    return startDict;
}

@end
