//
//  PEChatListViewController.h
//  Pet
//
//  Created by Wu Evan on 7/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PEChatListTableView.h"
@interface PEChatListViewController : UIViewController <ChatTableListDelegate>

@property(nonatomic,retain)PEChatListTableView *chatListTableView;
@property(nonatomic,retain)NSArray *tableDataArray;




@end
