//
//  PEDisGroupMemberListingViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//


#import "PEGroupMemberListView.h"
#import "PEMemberContentView.h"

@interface PEDisGroupMemberListingViewController : UIViewController


@property(nonatomic,retain)NSMutableArray *ownerListArray;
@property(nonatomic,retain)NSMutableArray *managerListArray;
@property(nonatomic,retain)NSMutableArray *memberListArray;

@property(nonatomic,retain)UITableView *ownerListTable;
@property(nonatomic,retain)UITableView *mangerListTable;
@property(nonatomic,retain)UITableView *memberListTable;

@property(nonatomic,retain)PEGroupMemberListView *headerView1;
@property(nonatomic,retain)PEGroupMemberListView *headerView2;
@property(nonatomic,retain)PEGroupMemberListView *headerView3;
@property(nonatomic,retain)PEMemberContentView *memberDetailView1;
@property(nonatomic,retain)PEMemberContentView *memberDetailView2;
@property(nonatomic,retain)PEMemberContentView *memberDetailView3;
@property(nonatomic,retain)UIScrollView *sv;

@property(nonatomic,retain)NSString *tempGroupID;



@end
