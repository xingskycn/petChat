//
//  PEContactsGroupViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-23.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEContactsGroupViewController.h"
#import "UIHelper.h"
#import "PEDisGroupCellTwo.h"
#import "PEDisContactsTableCell.h"
#import "PESearchViewController.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
//#import "PEDisContactsCreateGroupViewController.h"
@interface PEContactsGroupViewController ()

@end

@implementation PEContactsGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(CONSTACT_GROUP_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;

    

    
    
    // Do any additional setup after loading the view from its nib.
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source





@end
