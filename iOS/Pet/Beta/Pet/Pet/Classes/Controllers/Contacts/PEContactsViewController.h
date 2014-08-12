//
//  PEContactsViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PENearViewController.h"
#import "PEContactTableView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"

@protocol ContactViewDelegate <NSObject>

- (void)didSelectedSearch:(NSString *)searchContent;

@end


@protocol ContactSearchDelegate <NSObject>


@end

@interface PEContactsViewController : UIViewController <PefmdbDelegate, ContactTableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) PEContactTableView *contactTable;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) UITextField *searchText;

@property (nonatomic, retain) UIButton *friendBtn;
@property (nonatomic, retain) UIButton *focusBtn;
@property (nonatomic, retain) UIButton *funsBtn;
@property (nonatomic, retain) UIButton *groupBtn;

@property (nonatomic, retain) UIImageView *selectedView;

@property(nonatomic,retain)UILabel *searchInfoLabel;
@property(nonatomic,retain)UITextField *searchField;
@property(nonatomic,retain)NSDictionary *dataDic;

//by wu
@property(nonatomic,retain)UITableView *contactsGroupTable;
@property (assign)BOOL isOpen;//控制是展开还是收起来
@property (nonatomic,retain)NSIndexPath *selectIndex;//选中的是哪行
@property(nonatomic,retain)NSMutableArray *groupDataArray;
@property(nonatomic,retain)UIImageView *searchBarBg;

@end
