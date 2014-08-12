//
//  PEDiscoverViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEDiscoverViewController.h"
//设置图片方法封装的类
#import "UIHelper.h"
#import "PEDisNewsViewController.h"
#import "PEDisGroupViewController.h"
#import "PEDisShoutViewController.h"
#import "PEDisClubViewController.h"
#import "PEDisGameViewController.h"
#import "PEDisEventViewController.h"
#import "PELoginViewController.h"
@interface PEDiscoverViewController ()

@end

@implementation PEDiscoverViewController
@synthesize isLogin, shoutType;
@synthesize fliterView;
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
    
    //fliteView
    fliterView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    
    
    [self setupUI];
    
    //将状态条修改为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]];
    
    [fliterView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark SETTING BUTTON VIEW
- (void)setupUI {
    //add news view
    UIButton *newsButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [newsButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
    [newsButton addTarget:self action:@selector(newsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [newsButton setFrame:CGRectMake(10.0f, 74.0f, 300.0f, 49.0f)];
    
    UIImageView *newsIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_news_icon"]];
    [newsIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
    
    UILabel *newsLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
    newsLbl.font =[UIFont systemFontOfSize:16.0f];
    newsLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    newsLbl.text =NSLocalizedString(DISCOVER_NEWS, nil);
    
    UIImageView *newsArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
    [newsArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
    
    [newsButton addSubview:newsIcon];
    [newsButton addSubview:newsLbl];
    [newsButton addSubview:newsArrow];
    [self.view addSubview:newsButton];
    
    
    //add gruop view
    UIButton *groupButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [groupButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
    [groupButton addTarget:self action:@selector(groupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [groupButton setFrame:CGRectMake(10.0f, 133.0f, 300.0f, 49.0f)];
    
    UIImageView *groupIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_group_icon"]];
    [groupIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
    
    UILabel *groupLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
    groupLbl.font =[UIFont systemFontOfSize:16.0f];
    groupLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    groupLbl.text =NSLocalizedString(DISCOVER_GROUP, nil);
    
    UIImageView *groupArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
    [groupArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
    
    [groupButton addSubview:groupIcon];
    [groupButton addSubview:groupLbl];
    [groupButton addSubview:groupArrow];
    [self.view addSubview:groupButton];
    
    
    //add shout view
    UIButton *shoutButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [shoutButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
    [shoutButton addTarget:self action:@selector(shoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shoutButton setFrame:CGRectMake(10.0f, 192.0f, 300.0f, 49.0f)];
    
    UIImageView *shoutIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_shout_icon"]];
    [shoutIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
    
    UILabel *shoutLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
    shoutLbl.font =[UIFont systemFontOfSize:16.0f];
    shoutLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    shoutLbl.text =NSLocalizedString(DISCOVER_SHOUT, nil);
    
    UIImageView *shoutArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
    [shoutArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
    
    [shoutButton addSubview:shoutIcon];
    [shoutButton addSubview:shoutLbl];
    [shoutButton addSubview:shoutArrow];
    [self.view addSubview:shoutButton];
    
/*****************暂时取消掉宠聊俱乐部******************************/
//    //add club view
//    UIButton *clubButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [clubButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
//    [clubButton addTarget:self action:@selector(clubButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [clubButton setFrame:CGRectMake(10.0f, 251.0f, 300.0f, 49.0f)];
//    
//    UIImageView *clubIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_club_icon"]];
//    [clubIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
//    
//    UILabel *clubLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
//    clubLbl.font =[UIFont systemFontOfSize:16.0f];
//    clubLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
//    clubLbl.text =NSLocalizedString(DISCOVER_CLUB, nil);
//    
//    UIImageView *clubArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
//    [clubArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
//    
//    [clubButton addSubview:clubIcon];
//    [clubButton addSubview:clubLbl];
//    [clubButton addSubview:clubArrow];
//    [self.view addSubview:clubButton];
    
    
    //add game view
    UIButton *gameButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [gameButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
    [gameButton addTarget:self action:@selector(gameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [gameButton setFrame:CGRectMake(10.0f, 251.0f, 300.0f, 49.0f)];//310
    
    UIImageView *gameIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_game_icon"]];
    [gameIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
    
    UILabel *gameLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
    gameLbl.font =[UIFont systemFontOfSize:16.0f];
    gameLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    gameLbl.text =NSLocalizedString(DISCOVER_GAME, nil);
    
    UIImageView *gameArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
    [gameArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
    
    [gameButton addSubview:gameIcon];
    [gameButton addSubview:gameLbl];
    [gameButton addSubview:gameArrow];
//    [self.view addSubview:gameButton];//8-2   20140809
    
    
    //add event view
    UIButton *eventButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [eventButton setImage:[UIHelper imageName:@"discover_btn"] forState:UIControlStateNormal];
    [eventButton addTarget:self action:@selector(eventButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [eventButton setFrame:CGRectMake(10.0f, 310.0f, 300.0f, 49.0f)];
    
    UIImageView *eventIcon =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_event_icon"]];
    [eventIcon setFrame:CGRectMake(10.0f, 13.0f, 23.0f, 23.0f)];
    
    UILabel *eventLbl =[[UILabel alloc] initWithFrame:CGRectMake(42.5f, 16.0f, 200.0f, 17.0f)];
    eventLbl.font =[UIFont systemFontOfSize:16.0f];
    eventLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    eventLbl.text =NSLocalizedString(DISCOVER_EVENT, nil);
    
    UIImageView *eventArrow =[[UIImageView alloc] initWithImage:[UIHelper imageName:@"discover_arrow_right"]];
    [eventArrow setFrame:CGRectMake(282.0f, 17.75f, 8.0f, 13.5f)];
    
    [eventButton addSubview:eventIcon];
    [eventButton addSubview:eventLbl];
    [eventButton addSubview:eventArrow];
//    [self.view addSubview:eventButton];//8-2  20140809
    
    
    UIImageView *fliterBg =[[UIImageView alloc] initWithFrame:CGRectInset(fliterView.frame, 0.0f, 0.0f)];
    [fliterBg setImage:[UIHelper setImageFromColor:[UIColor blackColor]]];
    fliterBg.alpha =0.8f;
    
    [fliterView addSubview:fliterBg];
    
    NSArray *sortData =@[@"品种", @"养护", @"健康", @"繁殖", @"训练", @"美容"];
    NSArray *sortImage =@[@"discover_sort", @"discover_care", @"discover_health", @"discover_add", @"discover_trill", @"discover_beauty"];
    NSArray *sortColor =@[@"#ff8e2c", @"#75e137", @"#0083bd", @"#ab47ac", @"#ff603b", @"#ffacf0"];
    
    for (int i =0; i <6; i++) {
        int m =i/3;
        int n =i%3;
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIHelper imageName:sortImage[i]] forState:UIControlStateNormal];
        btn.tag =i+1;
        [btn setFrame:CGRectMake(14.0f+n*108.5f, 182.0f + 129.0f*m, 75.0f, 75.0f)];
        [btn addTarget:self action:@selector(fliterBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lbl =[[UILabel alloc] initWithFrame:CGRectMake(14.0f+n*108.5f, 267.0f + 129.0f*m, 75.0f, 14.0f)];
        lbl.textColor =[UIHelper colorWithHexString:sortColor[i]];
        lbl.font =[UIFont systemFontOfSize:14.0f];
        lbl.textAlignment =NSTextAlignmentCenter;
        lbl.text =sortData[i];
        
        [fliterView addSubview:btn];
        [fliterView addSubview:lbl];
    }
    
    [self.view addSubview:fliterView];
}

#pragma mark -
#pragma mark BUTTON ACTION
//群组 喊话  游戏  活动 无需登录
- (void)fliterBtnPressed:(UIButton *)sender {
    
    [fliterView setHidden:YES];
    shoutType =[NSString stringWithFormat:@"%d", sender.tag];
    
    PEDisShoutViewController *shoutView = [[PEDisShoutViewController alloc]init];
    shoutView.shoutType =shoutType;
    shoutView.title = NSLocalizedString(DISCOVER_SHOUT, nil);
    [self.navigationController pushViewController:shoutView animated:YES];
    
}

- (void)newsButtonPressed:(id)sender {
    
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    PEDisNewsViewController *newsView = [[PEDisNewsViewController alloc]init];
    newsView.title = NSLocalizedString(DISCOVER_NEWS, nil);
    if(isLogin){
        [self.navigationController pushViewController:newsView animated:YES];
    }else{
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
        
    }
    
    
}

- (void)groupButtonPressed:(id)sender {
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    PEDisGroupViewController *groupView = [[PEDisGroupViewController alloc]init];
    groupView.title = NSLocalizedString(DISCOVER_GROUP, nil);
    [self.navigationController pushViewController:groupView animated:YES];
    
}

- (void)shoutButtonPressed:(id)sender {
    
    [fliterView setHidden:NO];
}

//- (void)clubButtonPressed:(id)sender {
//    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
//    
//    PEDisClubViewController *clubView = [[PEDisClubViewController alloc]init];
//    clubView.title = NSLocalizedString(DISCOVER_CLUB, nil);
//    if(isLogin){
//        [self.navigationController pushViewController:clubView animated:YES];
//    }else{
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alter show];
//        
//    }}

- (void)gameButtonPressed:(id)sender {
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    PEDisGameViewController*gameView = [[PEDisGameViewController alloc]init];
    gameView.title = NSLocalizedString(DISCOVER_GAME, nil);
    [self.navigationController pushViewController:gameView animated:YES];
    
}

- (void)eventButtonPressed:(id)sender {
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    PEDisEventViewController *eventView = [[PEDisEventViewController alloc]init];
    eventView.title = NSLocalizedString(DISCOVER_EVENT, nil);
    [self.navigationController pushViewController:eventView animated:YES];
    
}

#pragma mark - ALTERVIEWDELEGATE

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        PELoginViewController *loginView = [[PELoginViewController alloc]init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
    
}


@end
