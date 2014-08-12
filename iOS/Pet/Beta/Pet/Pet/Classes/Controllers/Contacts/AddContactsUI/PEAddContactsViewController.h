//
//  PEAddContactsViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PENearViewController.h"
#import "PEDisAddContactsView.h"
@interface PEAddContactsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)UIImageView *bgImageViewForHead;
@property(nonatomic,retain)UILabel *searchForAddLabel;
@property(nonatomic,retain)UIImageView *bgImageViewForSearchInfo;
@property(nonatomic,retain)UIImageView *bgForSearchBar;

@property(nonatomic,retain)UITextField *searchTextField;
@property(nonatomic,retain)UIImageView *bgForSearchButton;
@property(nonatomic,retain)UIImageView *bgForSearchButtonPreesed;
@property(nonatomic,retain)UIButton *searchButton;

@property(nonatomic,retain)PEDisAddContactsView *addContactsView;
@property(nonatomic,retain)NSDictionary *dic;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UITableView *myTableView;

@end
