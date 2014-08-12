//
//  PEFindContactsFriendsViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-21.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEFindContactsFriendsViewController.h"
#import "UIHelper.h"
#import "PEAddFindFrinedsViewController.h"
@interface PEFindContactsFriendsViewController ()

@end

@implementation PEFindContactsFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(FIND_CONTACTFRIENDS_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.backBarButtonItem = backItem;
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)setupUI{
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIHelper imageName:@"Contact_findfriendsBig"];
    bgImageView.frame = CGRectMake(47, 92.5, 209.5, 276);
    [self.view addSubview:bgImageView];
    
    
    UILabel *remaindLbl = [[UILabel alloc]init];
    remaindLbl.textColor =[UIHelper colorWithHexString:@"#727f81"];
    remaindLbl.font = [UIFont systemFontOfSize:12];
    remaindLbl.text = @"查找通讯录中的宠遇好友，通讯录仅用于查找好友，不会泄露隐私和保存资料";
    remaindLbl.lineBreakMode = NSLineBreakByCharWrapping;
    remaindLbl.numberOfLines = 0;
    CGSize sizeRM = [remaindLbl.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    remaindLbl.frame = CGRectMake(33, 385, 254, sizeRM.height);
    [self.view addSubview:remaindLbl];
    
    
    UIImageView *bgForNextBtn = [[UIImageView alloc]init];
    bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#ee8d59"];
    bgForNextBtn.layer.cornerRadius = 5;
    bgForNextBtn.layer.masksToBounds = YES;
    bgForNextBtn.frame = CGRectMake(20, 505, 280, 40);
    bgForNextBtn.userInteractionEnabled = YES;
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [nextStepBtn setTitle:@"添加通讯录好友" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:bgForNextBtn.image forState:UIControlStateNormal];
    nextStepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStepBtn.frame = CGRectMake(20, 505, 280, 40);
    [nextStepBtn addTarget:self action:@selector(nextStepBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nextStepBtn];
    
   
}

- (void)nextStepBtnPressed{
    
    PEAddFindFrinedsViewController *addFindFriends = [[PEAddFindFrinedsViewController alloc]init];
    [self.navigationController pushViewController:addFindFriends animated:YES];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
