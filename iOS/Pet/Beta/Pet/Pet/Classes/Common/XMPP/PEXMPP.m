//
//  PEXMPP.m
//  Pet
//
//  Created by Wu Evan on 7/17/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEXMPP.h"
#import <XMPPMessage.h>
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#define QueryRoster_ID          @"4001"

@implementation PEXMPP

//@synthesize stream=xmppStream,isLogined,roomPool;
@synthesize xmppStream,isLogined;
@synthesize xmppReconnect, xmppRoster, xmppRosterStorage, room;
@synthesize allowSelfSignedCertificates, allowSSLHostNameMismatch;

@synthesize peXmppDelegate;

@synthesize msgPlayer;

static PEXMPP *sharedManager;

+ (PEXMPP *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[PEXMPP alloc]init];
        sharedManager.isLogined = NO;
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [sharedManager setupPlayer];
        [sharedManager setupStream];
    });
    
    return sharedManager;

}

-(void)login{
    if(isLogined)
        return;
    if (![self connect]) {
        [Common showAlert:@"服务器连接失败"];
    };
}

-(void)logout{
    if(!isLogined)
        return;
    self.isLogined = NO;
    [self disconnect];
//    [roomPool deleteAll];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotifaction object:[NSNumber numberWithBool:isLogined]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 配置mp3播放
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupPlayer
{
    msgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"msg" ofType:@"mp3"]] error:nil];
    [msgPlayer prepareToPlay];
    msgPlayer.enableRate = YES;
    msgPlayer.meteringEnabled = YES;
    [msgPlayer setVolume:1];   //设置音量大小
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 配置XML流
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = NO;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
    [xmppStream setHostName:xmppHOST];
    [xmppStream setHostPort:5222];
    
	// You may need to alter these settings depending on the server you're connecting to
	customCertEvaluation = YES;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginXmppSuccess" object:nil];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:USER_INFO_ID];
//	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    NSString *myPassword = @"12345678";
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", myJID, xmppDomain]]];
    password=myPassword;
	
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - xmpp 操作
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)queryRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:QueryRoster_ID];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    NSString* date = [fmt stringFromDate:now];
    NSString *to = [NSString stringWithFormat:@"%@", user];
    NSString *from = [NSString stringWithFormat:@"%@@%@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID], xmppDomain];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    [msg addAttributeWithName:@"type" stringValue:@"chat"];
    [msg addAttributeWithName:@"to" stringValue:to];
    [msg addAttributeWithName:@"nickName" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME]];
    [msg addChild:body];
    [xmppStream sendElement:msg];

    
    [self saveChatMassageWithFromToContentAndDate:from :to :message :date :nickName];
}

- (void)sendMessage:(NSString *)message toRoom:(NSString *)cRoom {
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    NSString* date = [fmt stringFromDate:now];
    NSString *to = [NSString stringWithFormat:@"%@", cRoom];
    NSString *from = [NSString stringWithFormat:@"%@@%@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID], xmppDomain];
    NSString *nickName =[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    XMPPMessage *msg = [XMPPMessage message];
    [msg addAttributeWithName:@"type" stringValue:@"groupChat"];
    [msg addAttributeWithName:@"to" stringValue:to];
    [msg addAttributeWithName:@"nickName" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_NAME]];
    [msg addChild:body];
    
    [room sendMessage:msg];
    [self saveChatMassageWithFromToContentAndDate:from :to :message :date :nickName];
}

//设置room
- (void)setupRoom:(NSString *)roomName {
    XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
    
    if (rosterstorage == nil) {
        
        rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
        
    }
    room =nil;
    room = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@", roomName, xmppDomain]] dispatchQueue:dispatch_get_main_queue()];
}
- (void)releaseRoom {
    XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
    
    if (rosterstorage != nil) {
        
        rosterstorage = nil;
        
    }
    room =nil;
}

//创建room
- (void)createGroup:(NSString *)name {
    
    NSDate *d=[NSDate date];
    NSString *time =[NSString stringWithFormat:@"%ld%08u", (long)[d timeIntervalSince1970], arc4random()%10000000];
    
    [self setupRoom:name];
    
    [room activate:xmppStream];
    [room joinRoomUsingNickname:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID] history:nil];
    
    [room configureRoomUsingOptions:nil];
    
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//持久化保存
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm
{
    NSLog(@"config : %@", configForm);
    NSXMLElement *newConfig = [configForm copy];
    NSArray* fields = [newConfig elementsForName:@"field"];
    for (NSXMLElement *field in fields) {
        NSString *var = [field attributeStringValueForName:@"var"];
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
    }
    [sender configureRoomUsingOptions:newConfig];
}

//加入群组
- (void)addGroup:(NSString *)name {
    //设置room
    [self setupRoom:name];
    
    //加入群组
    [room activate:xmppStream];
    [room joinRoomUsingNickname:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID] history:nil];
}

//退出群组
- (void)exitGroup{
    [room leaveRoom];
    
    //设置room
    [self releaseRoom];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	
//	NSString *expectedCertName = [xmppStream.myJID domain];
//	if (expectedCertName)
//	{
//		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
//	}
//	
//	if (customCertEvaluation)
//	{
//		[settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
//	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	// The delegate method should likely have code similar to this,
	// but will presumably perform some extra security code stuff.
	// For example, allowing a specific self-signed certificate that is known to the app.
	
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    [xmppRoster fetchRoster];
    self.isLogined = YES;
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (error) {
        DDLogError(@"Error notAuthenticate: %@", error);
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
/////////////////////////////////////////////////////////////////////////////
//	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, iq);
/////////////////////////////////////////////////////////////////////////////
    
//    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
//    NSLog(@"收到iq:%@",iq);
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            //新建数据词典
            NSMutableArray *rosters =[[NSMutableArray alloc] init];
            for (NSXMLElement *item in items) {
                if ([item attributeStringValueForName:@"jid"]) {
                    
                    NSString *jid = [item attributeStringValueForName:@"jid"];
                    NSString *name = [item attributeStringValueForName:@"name"];
                    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                    
                    NSDictionary *dict =@{@"jid":xmppJID, @"name": name};
                    [rosters addObject:dict];
                    //                [xmppRoster addObject:xmppJID];
//                    DDLogVerbose(@"收到IQ*****%@: %@ - %@", THIS_FILE, THIS_METHOD, name);
                }
            }
//            [peXmppDelegate getRosterSuccess:(NSArray*)rosters];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_ROSTER_RECEIVE object:(NSArray*)rosters];
        }
    }
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@  -  %@", THIS_FILE, THIS_METHOD, message);
    
    if ([message elementForName:@"delay"]) {
        //取出delay元素
        NSXMLElement *xElement =[message elementForName:@"x"];
        NSString *dateStr =[[xElement attributeForName:@"stamp"] stringValue];
        //取出时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd'T'HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSTimeZone *timeZone =[NSTimeZone systemTimeZone];
        NSDate *dateData = [dateFormatter dateFromString:dateStr];
        //转化为本地时间
        NSInteger interval = [timeZone secondsFromGMTForDate:dateData];
        NSDate *localDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:dateData];
        dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddHHmmss"];
        NSString *date = [dateFormatter stringFromDate:localDate];
        
        //判断私聊还是群聊
        if ([[[message attributeForName:@"type"] stringValue] isEqual: @"chat"]) {
            //私聊
            //其他数据
            NSString *bodyMsg = [[message elementForName:@"body"] stringValue];
            NSString *from = [[message attributeForName:@"from"] stringValue];
            NSString *fromStr =[from componentsSeparatedByString:@"/"][0];
            NSString *toStr = [[message attributeForName:@"to"] stringValue];
            NSString *nickName;
            if ([[message attributeForName:@"nickName"] stringValue]) {
                nickName =[[message attributeForName:@"nickName"] stringValue];
            }else {
                nickName =@"";
            }
            
            NSMutableDictionary *bodyDict =[NSMutableDictionary dictionaryWithDictionary:[bodyMsg objectFromJSONString]];
            if ([bodyDict objectForKey:@"isSelf"]) {
                NSNumber* num = [NSNumber numberWithBool:NO];
                [bodyDict setObject:num forKey:@"isSelf"];
                bodyMsg =[bodyDict JSONString];
            }
            if (bodyMsg &&date &&fromStr &&toStr) {
                [self saveChatMassageWithFromToContentAndDate:fromStr :toStr :bodyMsg :date :nickName];
                [self saveNewestMessage:date :fromStr :[NSString stringWithFormat:@"%d", chatType_Single] :nickName];
                //创建新字典
                NSMutableDictionary *msgData =[NSMutableDictionary dictionaryWithDictionary:bodyDict];
                [msgData setObject:fromStr forKey:@"fromStr"];
                [msgData setObject:nickName forKey:@"nickName"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_RECEIVE object:msgData];
                
                [msgPlayer play];
            }
        }else {
//            //群聊
//            NSString *bodyMsg = [[message elementForName:@"body"] stringValue];
//            NSString *from = [[message attributeForName:@"from"] stringValue];
//            NSString *fromStr =[from componentsSeparatedByString:@"/"][0];
//            NSString *nickName =[from componentsSeparatedByString:@"/"][1];
//            NSString *toStr = [[message attributeForName:@"to"] stringValue];
//            
//            NSMutableDictionary *bodyDict =[NSMutableDictionary dictionaryWithDictionary:[bodyMsg objectFromJSONString]];
//            
//            if ([bodyDict objectForKey:@"isSelf"]) {
//                NSNumber* num = [NSNumber numberWithBool:NO];
//                [bodyDict setObject:num forKey:@"isSelf"];
//                bodyMsg =[bodyDict JSONString];
//            }
//            if (bodyMsg &&date &&fromStr &&toStr &&nickName) {
//                [self saveGroupMassageWithFromToContentAndDate:fromStr :toStr :bodyMsg :date :nickName];
//                //创建新字典
//                NSMutableDictionary *msgData =[NSMutableDictionary dictionaryWithDictionary:bodyDict];
//                [msgData setObject:fromStr forKey:@"fromStr"];
//                [msgData setObject:nickName forKey:@"nickName"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_RECEIVE object:msgData];
//            }
        }
    } else {
        //取时间
        NSDate* now = [NSDate date];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyyMMddHHmmss";
        NSString* date = [fmt stringFromDate:now];
        
        NSString *msg;
        if ([[[message attributeForName:@"type"] stringValue] isEqual: @"chat"]) {
            msg = [[message elementForName:@"body"] stringValue];
            NSString *from = [[message attributeForName:@"from"] stringValue];
            NSString *fromStr =[from componentsSeparatedByString:@"/"][0];
            NSString *toStr = [[message attributeForName:@"to"] stringValue];
            NSString *nickName ;
            if ([[message attributeForName:@"nickName"] stringValue]) {
                nickName =[[message attributeForName:@"nickName"] stringValue];
            }else {
                nickName =@"";
            }
            
            NSMutableDictionary *bodyDict =[NSMutableDictionary dictionaryWithDictionary:[msg objectFromJSONString]];
            
            if ([bodyDict objectForKey:@"isSelf"]) {
                NSNumber* num = [NSNumber numberWithBool:NO];
                [bodyDict setObject:num forKey:@"isSelf"];
                msg =[bodyDict JSONString];
            }
            if (msg &&date &&fromStr &&toStr) {
                [self saveChatMassageWithFromToContentAndDate:fromStr :toStr :msg :date :nickName];
                [self saveNewestMessage:date :fromStr :[NSString stringWithFormat:@"%d", chatType_Single] :nickName];
                
                //创建新字典
                NSMutableDictionary *msgData =[NSMutableDictionary dictionaryWithDictionary:bodyDict];
                [msgData setObject:fromStr forKey:@"fromStr"];
                [msgData setObject:nickName forKey:@"nickName"];
                [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_RECEIVE object:msgData];
                
                [msgPlayer play];
            }
        } else {
            msg = [[message elementForName:@"body"] stringValue];
            //群聊
            NSString *bodyMsg = [[message elementForName:@"body"] stringValue];
            NSString *from = [[message attributeForName:@"from"] stringValue];
            NSString *fromStr =[from componentsSeparatedByString:@"/"][0];
            NSString *fromID =[from componentsSeparatedByString:@"/"][1];
            NSString *nickName =[[message attributeForName:@"nickName"] stringValue];
            NSString *toStr = [[message attributeForName:@"to"] stringValue];
            
            NSMutableDictionary *bodyDict =[NSMutableDictionary dictionaryWithDictionary:[bodyMsg objectFromJSONString]];
            
            if ([bodyDict objectForKey:@"isSelf"]) {
                NSNumber* num = [NSNumber numberWithBool:NO];
                [bodyDict setObject:num forKey:@"isSelf"];
                bodyMsg =[bodyDict JSONString];
            }
            if (bodyMsg &&date &&fromStr &&toStr &&nickName) {
                if (![fromID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]]) {
                    
                    [self saveGroupMassageWithFromToContentAndDate:fromStr :toStr :bodyMsg :date :nickName];
                    [self saveNewestMessage:date :fromStr :[NSString stringWithFormat:@"%d", chatType_Room] :nickName];
                    //创建新字典
                    NSMutableDictionary *msgData =[NSMutableDictionary dictionaryWithDictionary:bodyDict];
                    [msgData setObject:fromStr forKey:@"fromStr"];
                    [msgData setObject:nickName forKey:@"nickName"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_RECEIVE object:msgData];
                    
                    [msgPlayer play];
                }
                
            }
        }
    }
    
//    NSDictionary *msgDict =@{@"content": msg, @"isSelf": [NSNumber numberWithBool:NO]};
    
	// A simple example of inbound message handling.
    
    //xmpp
//	if ([message isChatMessageWithBody])
//	{
//		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
//		                                                         xmppStream:xmppStream
//		                                               managedObjectContext:[self managedObjectContext_roster]];
//		
//		NSString *body = [[message elementForName:@"body"] stringValue];
//		NSString *displayName = [user displayName];
//        
//		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//		{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//                                                                message:body
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//			[alertView show];
//		}
//		else
//		{
//			// We are not active, so use a local notification instead
//			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//			localNotification.alertAction = @"Ok";
//			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//            
//			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//		}
//	}
    
    //my
//    DLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    NSString *delay = [[message elementForName:@"delay"] stringValue];
//    NSString* type = [[message attributeForName:@"type"] stringValue];
//    if(delay != nil && [type isEqualToString:@"groupchat"])
//        return;
//    
//    NSString *body = [[message elementForName:@"body"] stringValue];
//    NSString *displayName = [[message from]bare];
//    NSArray *strs=[displayName componentsSeparatedByString:@"@"];
//    
//    SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
//    NSDictionary* resultObject = [resultParser objectWithString:body];
//    
//    JXMessageObject *msg=[[JXMessageObject alloc] init];
//    if([type isEqualToString:@"chat"] || [type isEqualToString:@"groupchat"]){
//        //创建message对象
//        [msg fromDictionary:resultObject];
//        
//        if (![JXUserObject haveSaveUserById:strs[0]] && [type isEqualToString:@"chat"] ) {
//            [self fetchUser:strs[0]];
//        }
//        
//        if(msg.type != nil ){
//            if([type isEqualToString:@"chat"]){
//                [msg save];
//            }else{
//                msg.isGroup = YES;
//                NSString* room = [[message attributeForName:@"from"] stringValue];
//                NSRange range = [room rangeOfString:@"@"];
//                if(range.location != NSNotFound)
//                    room = [room substringToIndex:range.location];
//                [msg saveRoomMsg:room];
//            }
//        }
//    }
//    
//    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//    {
//        // We are not active, so use a local notification instead
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertAction = @"Ok";
//        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"新消息:",@"123"];
//        //        localNotification.userInfo  = [NSDictionary dictionaryWithObject:msg forKey:@"newMsg"];
//        
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//    }
}

//接收好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, presence);
}

//接受错误
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@ - %@ ", THIS_FILE, THIS_METHOD, error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, error);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}


- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSString *body = [[message elementForName:@"body"] stringValue];
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, body);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    XMPPJID *jid=[XMPPJID jidWithString:[presence stringValue]];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)addSomeBody:(NSString *)userId
{
    [xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", userId, xmppDomain]]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRoomDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    NSLog(@"create success!!!!");
    [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_GROUP_SUCC object:nil];
    
    
    
    [sender fetchConfigurationForm];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark --------数据存储-----------
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//存消息
- (void)saveChatMassageWithFromToContentAndDate:(NSString *)from :(NSString *)to :(NSString *)content :(NSString *)date :(NSString *)nickName {
    NSString *tableName =[NSString stringWithFormat:@"%@%@", DB_MSG_NAME, [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]];
    NSArray *dataArray =@[date, from, to, content, nickName];
    
    PEFMDBManager *dbManager =[PEFMDBManager sharedManager];
    [dbManager check];
    if (![dbManager isTableExisted:tableName]) {
        //创建表
        NSArray *cArray =@[DB_COLUMN_MSG_DATE,
                           DB_COLUMN_MSG_FROM,
                           DB_COLUMN_MSG_TO,
                           DB_COLUMN_MSG_CONTENT,
                           DB_COLUMN_MSG_NICKNAME
                           ];
        [dbManager creatNewTableWithTableName:tableName AndColumns:cArray];
    }
    if ([dbManager addChatMessageToTable:tableName :dataArray]) {
        NSLog(@"******Meassage Insert Success******");
    } else {
        NSLog(@"******Meassage Insert Failure******");
    }
    [dbManager close];
}

//存消息
- (void)saveGroupMassageWithFromToContentAndDate:(NSString *)from :(NSString *)to :(NSString *)content :(NSString *)date :(NSString *)nickName {
    NSString *tableName =[NSString stringWithFormat:@"%@%@", DB_MSG_NAME, [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]];
    NSArray *dataArray =@[date, from, to, content, nickName];
    
    PEFMDBManager *dbManager =[PEFMDBManager sharedManager];
    [dbManager check];
    if (![dbManager isTableExisted:tableName]) {
        //创建表
        NSArray *cArray =@[DB_COLUMN_MSG_DATE,
                           DB_COLUMN_MSG_FROM,
                           DB_COLUMN_MSG_TO,
                           DB_COLUMN_MSG_CONTENT,
                           DB_COLUMN_MSG_NICKNAME
                           ];
        [dbManager creatNewTableWithTableName:tableName AndColumns:cArray];
    }
    if ([dbManager addGroupMessageToTable:tableName :dataArray]) {
        NSLog(@"******Meassage Insert Success******");
    } else {
        NSLog(@"******Meassage Insert Failure******");
    }
    [dbManager close];
}

- (void)saveNewestMessage:(NSString *)date :(NSString *)from :(NSString *)type :(NSString *)nickName{
    NSString *tableName =[NSString stringWithFormat:@"%@%@", DB_MSG_NEW, [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]];
    
    PEFMDBManager *dbManager =[PEFMDBManager sharedManager];
    [dbManager check];
    if (![dbManager isTableExisted:tableName]) {
        //创建表
        NSArray *cArray =@[DB_COLUMN_MSG_DATE,
                           DB_COLUMN_MSG_FROM,
                           DB_COLUMN_MSG_TYPE,
                           DB_COLUMN_MSG_NICKNAME
                           ];
        [dbManager creatNewTableWithTableName:tableName AndColumns:cArray];
    }
    
    if ([dbManager insertNewMessageToTable:tableName :date :type :nickName :from]) {
        NSLog(@"******NewestMeassage Insert Success******");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessage" object:nil];
    }else {
        NSLog(@"******NewestMeassage Insert Failure******");
    }
    
    [dbManager close];
}

@end
