//
//  PETableView.h
//  Pet
//
//  Created by Wu Evan on 6/19/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEXMPP.h"
#import "JSONKit.h"

@class OHAttributedLabel;

@interface PETableView : UITableView<UITableViewDataSource, UITableViewDelegate, PExmppDelegate, PefmdbDelegate>{
    NSMutableArray* contentArray;
    NSMutableArray* arrayHeight;
    NSMutableArray* arrayLabel;
    NSDictionary *emoArray;
}

@property int chatType;
@property (nonatomic, retain) NSString *toRoomJID;

@property (nonatomic, retain) NSString *toJID;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) PEXMPP *xmpp;

- (void)setupData;
- (void)addTextContent:(NSString*)str WithIsRoomChat:(BOOL)isRoom;
- (void)addImageContent:(NSString*)urlStr WithIsRoomChat:(BOOL)isRoom;
- (void)scrollToBottom;
@end
