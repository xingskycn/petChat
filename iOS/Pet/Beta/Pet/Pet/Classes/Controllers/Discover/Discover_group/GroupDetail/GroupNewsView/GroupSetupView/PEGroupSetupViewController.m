//
//  PEGroupSetupViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupSetupViewController.h"
#import "UIHelper.h"
@interface PEGroupSetupViewController ()

@end

@implementation PEGroupSetupViewController
@synthesize remaindBtn,silentmodeBtn,turnDownBtn;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(GROUP_SETUP_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI{
    
    UILabel *newsRemaindLbl = [[UILabel alloc]init];
    newsRemaindLbl.textColor = [UIHelper colorWithHexString:@"#00b7ee"];
    newsRemaindLbl.font = [UIFont systemFontOfSize:14.5];
    newsRemaindLbl.text = @"群消息提醒";
    newsRemaindLbl.frame = CGRectMake(12.5, 89.5, 76, 14.5);
    [self.view addSubview:newsRemaindLbl];
    
    
    remaindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remaindBtn.frame = CGRectMake(111, 77.5, 30, 30);
    [remaindBtn setImage:[UIHelper imageName:@"group_setup_remind"] forState:UIControlStateNormal];
    [remaindBtn setImage:[UIHelper imageName:@"group_setup_remind_selected"] forState:UIControlStateSelected];
    [self.view addSubview:remaindBtn];
    
    
    silentmodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    silentmodeBtn.frame = CGRectMake(111, 77.5, 30, 30);
    [silentmodeBtn setImage:[UIHelper imageName:@"group_setup_remind"] forState:UIControlStateNormal];
    [silentmodeBtn setImage:[UIHelper imageName:@"group_setup_remind_selected"] forState:UIControlStateSelected];
    [self.view addSubview:silentmodeBtn];
    
    
    turnDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnDownBtn.frame = CGRectMake(111, 77.5, 30, 30);
    [turnDownBtn setImage:[UIHelper imageName:@"group_setup_remind"] forState:UIControlStateNormal];
    [turnDownBtn setImage:[UIHelper imageName:@"group_setup_remind_selected"] forState:UIControlStateSelected];
    [self.view addSubview:turnDownBtn];
    
}













- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
