//
//  PEXMPP.h
//  Pet
//
//  Created by Wu Evan on 7/17/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "XMPPFramework.h"
#import "PEFMDBManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilities.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRoster.h"
#import "XMPPMessage.h"
#import "TURNSocket.h"
//#import "SBJsonWriter.h"
#import "JSONKit.h"
#import "PEAppDelegate.h"
#import "FMDatabase.h"
//#import "emojiViewController.h"
//#import "JXRoomPool.h"

//------------获取好友列表-----------------
@protocol PExmppDelegate <NSObject>

@optional
//获取好友成功
- (void)getRosterSuccess:(NSArray *)rosterArray;
//获取消息
- (void)receiveMessageSuccess:(NSDictionary *)msgDict;
@end

@class XMPPMessage,XMPPRoster,XMPPRosterCoreDataStorage,FMDatabase,emojiViewController;
@interface PEXMPP : NSObject <UIApplicationDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
	NSString *password;
	
	BOOL customCertEvaluation;
	
	BOOL isXmppConnected;
    
    FMDatabase* _db;
    NSString* _userIdOld;
}

@property (retain, nonatomic) AVAudioPlayer* msgPlayer;
@property (retain, nonatomic) XMPPStream *xmppStream;
@property (retain, nonatomic) XMPPReconnect *xmppReconnect;
@property (retain, nonatomic) XMPPRoster *xmppRoster;
@property (retain, nonatomic) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (retain, nonatomic) XMPPRoom *room;

@property BOOL allowSelfSignedCertificates;
@property BOOL allowSSLHostNameMismatch;
@property BOOL isXmppConnected;

@property (retain, nonatomic) FMDatabase* _db;
@property (retain, nonatomic) NSString* _userIdOld;
@property (retain, nonatomic) NSString *password;

//--------委托----------
@property (assign, nonatomic) id<PExmppDelegate> peXmppDelegate;

- (NSManagedObjectContext *)managedObjectContext_roster;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (assign, nonatomic) XMPPStream* stream;
@property (assign, nonatomic) BOOL isLogined;
//@property (retain, nonatomic) JXRoomPool* roomPool;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)connect;
- (void)disconnect;
//- (FMDatabase*)getDatabase;
- (FMDatabase *)openUserDb:(NSString*)userId;




+ (PEXMPP *)sharedInstance;


#pragma mark -------配置XML流-----------

- (void)setupStream;
- (void)teardownStream;


#pragma mark ----------收发信息------------
- (void)goOnline;
- (void)goOffline;

- (void)login;
- (void)logout;

//- (void)sendMessage:(JXMessageObject*)msg roomName:(NSString*)roomName;
- (void)addSomeBody:(NSString *)userId;


#pragma mark ---------文件传输-----------
- (void)sendFile:(NSData*)aData toJID:(XMPPJID*)aJID;

#pragma mark ---------xmpp 操作-----------
///好友列表
- (void)queryRoster;
///发送消息
- (void)sendMessage:(NSString *) message toUser:(NSString *) user;
- (void)sendMessage:(NSString *) message toRoom:(NSString *) cRoom;

/*****设置群组*****/
- (void)setupRoom:(NSString *)roomName;
///创建群组
- (void)createGroup:(NSString *)name;
/*******加入群组*******/
- (void)addGroup:(NSString *)name;
/*******退出群组*******/
- (void)exitGroup;
@end
