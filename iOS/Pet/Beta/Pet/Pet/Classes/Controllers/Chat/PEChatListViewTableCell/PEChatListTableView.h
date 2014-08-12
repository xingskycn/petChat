//
//  PEChatListTableView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-14.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEXMPP.h"

@protocol ChatTableListDelegate <NSObject>

- (void)didSelectAtChatListTable:(NSDictionary *)dataDict;

@end

@interface PEChatListTableView : UITableView<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate, PefmdbDelegate>
{
   	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property(nonatomic,retain) NSArray *dataArray;

@property (nonatomic, assign) id<ChatTableListDelegate> chatTableListDelegate;

- (void)refreshDataRequest;

@end
