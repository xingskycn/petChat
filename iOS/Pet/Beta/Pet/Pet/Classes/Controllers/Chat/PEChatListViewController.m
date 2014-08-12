//
//  PEChatListViewController.m
//  Pet
//
//  Created by Wu Evan on 7/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEChatListViewController.h"
#import "PEChatViewController.h"
#import "PELoginViewController.h"
typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;


@interface PEChatListViewController ()

@end

@implementation PEChatListViewController
@synthesize chatListTableView,tableDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tableDataArray = [[NSArray alloc]init];// Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(CHAT_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeListView) name:@"loginXmppSuccess" object:nil];
    [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //进入登录界面
    bool n = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(n == NO){
        PELoginViewController *lCtr =[[PELoginViewController alloc] init];
        lCtr.type =type_chat;
        [self.navigationController pushViewController:lCtr animated:YES];
    }
    
}

- (void)addTableView{
    
    self.chatListTableView =[[PEChatListTableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight -64-50)];
    chatListTableView.backgroundColor =[UIColor clearColor];
    chatListTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    chatListTableView.chatTableListDelegate =self;
    
    [self.view addSubview:chatListTableView];
    [chatListTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeListView {
    [self addTableView];
}

#pragma mark - Table Delegate
- (void)didSelectAtChatListTable:(NSDictionary *)dataDict {
    PEChatViewController *cCtr =[[PEChatViewController alloc] init];
    
    cCtr.type =[[dataDict objectForKey:DB_COLUMN_MSG_TYPE] intValue];
    if (!cCtr.type) {
        cCtr.toJID =[dataDict objectForKey:DB_COLUMN_MSG_FROM];
        cCtr.title =[dataDict objectForKey:DB_COLUMN_MSG_NICKNAME];
        cCtr.toName =[dataDict objectForKey:DB_COLUMN_MSG_NICKNAME];
    } else {
        
        cCtr.toRoomJID =[dataDict objectForKey:DB_COLUMN_MSG_FROM];
        cCtr.title =@"上海仲昕信息科技有限公司";
        cCtr.toName =@"roomtest";
    }
    
    [self.navigationController pushViewController:cCtr animated:YES];
}

@end