//
//  PEAppDelegate.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEAppDelegate.h"
#import "PERootViewController.h"

//#import "PEFMDBManager.h"


//NAMESPACE_BAIDU_FRAMEWORK_USE

BMKMapManager* _mapManager;

@implementation PEAppDelegate

@synthesize naviController;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //test git hub
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"SNca0lYIP5oDUAzAmK9DLUbG" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    application.applicationSupportsShakeToEdit=YES;
    //FMDB test
//    PEFMDBManager *manager =[PEFMDBManager sharedManager];
//    [manager check];
//    [manager creatNewTableWithTableName:@"test" AndColumns:@[@"c1", @"c2", @"c3"]];
//    [manager deleteDataforTable:@"test" WithColumn:@"c2" AndObject:@"22"];
//    [manager editTable:@"test" WithOldData:@{@"c2":@"hehe"} AndNewData:@{@"c2":@"22222"}];
//    [manager selectTestDataWithObject:@"333" AndColumn:@"c2"];
//    [manager close];
    
    //默认设置为未登录
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGINED]; //2014-07-15
    [[NSUserDefaults standardUserDefaults]setObject:@"null" forKey:USER_INFO_ID];
    //判断是否为首次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HAS_USED]) {
        //设置排版格式为列表
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LIST];
    }
    
    //判断设置项
    [Common checkSetting];
    
    //提取本机信息
    PEMobile *mobileManager =[PEMobile sharedManager];
    mobileManager.mobileDelegate =self;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    PERootViewController *rCtr =[[PERootViewController alloc] init];
    
    naviController =[[UINavigationController alloc] initWithRootViewController:rCtr];
    //导航背景已换
    [naviController.navigationBar setBackgroundImage:[UIHelper imageName:@"root_nav_top_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
    //设置back按钮,这样下一界面的back会更换字体 by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    naviController.navigationItem.backBarButtonItem = backItem;
    [naviController.navigationBar setTintColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]];
    [naviController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.rootViewController =naviController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 
#pragma GET MOBILE INFO DELEGATE
- (void)getMessageSucc:(NSMutableDictionary *)dict {
    NSDictionary *dictionary =(NSDictionary *)dict;
    
    //start app 请求
    [[PENetWorkingManager sharedClient] startApp:dictionary completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"******START APP SUCCESS*******");
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GETINFO_SUCC object:nil];
            
            //login 请求
            if ([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]) {
                NSString *cellStr =[[NSUserDefaults standardUserDefaults] objectForKey:CELLACCOUNT];
                NSString *passwordString =[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
                NSString *mailStr =[[NSUserDefaults standardUserDefaults] objectForKey:MAILACCOUNT];
                
                NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
                NSDictionary *userInfo = @{@"mobileNumber":cellStr, //cellStr
                                           @"password":[Common md5:passwordString],//密码做简单的md5加密
                                           @"emailAddress":mailStr,
                                           };
                NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
                [request setObject:userInfo forKey:LOGIN_INFO_KEY];
                NSLog(@"%@", request);
                [[PENetWorkingManager sharedClient]login:request completion:^(NSDictionary *results, NSError *error) {
                    if(results){
                        if ([[results objectForKey:@"result"] isEqualToString:@"0"]) {
                            
                            //登录成功保存userId
                            NSString *userID = [results objectForKey:USER_INFO_ID];
                            NSString *userName = [results objectForKey:USER_INFO_NAME];
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud setObject:userID forKey:USER_INFO_ID];
                            [ud setObject:userName forKey:USER_INFO_NAME];
                            [ud setObject:cellStr forKey:CELLACCOUNT];
                            [ud setObject:mailStr forKey:MAILACCOUNT];
                            [ud setObject:passwordString forKey:PASSWORD];
                            //修改IS_LOGINED的值
                            [ud setBool:YES forKey:IS_LOGINED];
                            NSLog(@"登录成功");
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                            [[PEXMPP sharedInstance] login];
                        }else {
                            [Common showAlert:[results objectForKey:@"errMsg"]];
                        }
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }
            
        }else {
            NSLog(@"%@", error);
        }
    }];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Pet.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Baidu Map Delegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
