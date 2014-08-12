//
//  PESettingViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PESettingViewController.h"
#import "PELoginViewController.h"
#import "UIHelper.h"

#import "PEBindViewController.h"
#import "PEGeneralViewController.h"
#import "PEPrivacyViewController.h"
#import "PEMessageViewController.h"
#import "PESettingEditViewController.h"

typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;

@interface PESettingViewController ()

@end

@implementation PESettingViewController

@synthesize bgView;
@synthesize headBgView, secondBgView, thirdBgView, endBgView;
@synthesize headIconBgView, headIcon, headArrowView, nameLbl, numberLbl;
@synthesize vipInfoIcon, vipInfoLbl, vipInfoArrowView, secondLineView, bindIcon, bindLbl, bindArrowView;
@synthesize messageIcon, messageLbl, messageArrowView, thirdOneLineView, privacyIcon, privacyLbl, privacyArrowView, thirdTwoLineView, generalIcon, generalLbl, generalArrowView;
@synthesize emoIcon, emoArrowView, emoLbl,dic;


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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewReloadData) name:@"loginSuccess" object:nil];
    [[self navigationController].navigationBar setBackgroundImage:[UIHelper imageName:@"root_nav_top_bg"]
                                                    forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(SETTING_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    //先创建UI
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //进入登陆界面，先判断是否为已经登录
    bool n = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED];
    if(n == NO ){
        PELoginViewController *lCtr =[[PELoginViewController alloc] init];
        lCtr.type =type_chat;
        [self.navigationController pushViewController:lCtr animated:YES];
    }
    //请求数据
    [self request];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - REQUEST DATA
//登录成功收到通知，刷新数据
- (void)viewReloadData{
    [self request];
}

- (void)request{
    //=================拿数据
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    [[PENetWorkingManager sharedClient]userSetting:appInfo completion:^(NSDictionary *results, NSError *error) {
        if(results)
        {
            NSLog(@"%@",results);
            self.dic = results;
            NSLog(@"===================%@",dic);
            [self setupUI];//数据请求成功
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark -
#pragma SETUP UI
- (void)setupUI {
    //set bg
    [bgView setImage:[UIHelper imageName:@"setting_bg"]];
    
    
    //setting bg image
    UIImage *bgImage =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [bgImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    //set headView
    [headBgView setImage:bgImage];
    headBgView.alpha =0.5f;
    
    [headIconBgView setImage:[UIHelper imageName:@"setting_head_bg"]];
    //===============用户头像
    [headIcon setImageWithURL:[NSURL URLWithString:[dic objectForKey:SETTING_USER_HEADIMAG]] placeholderImage:[UIImage imageNamed:@"setting_head_test.png"]];
    headIcon.layer.cornerRadius =28.5f;
    headIcon.clipsToBounds =YES;
    
    nameLbl.font =[UIFont systemFontOfSize:18.0f];
//    nameLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    //================名字
    nameLbl.text =[dic objectForKey:SETTING_USER_NAME];
    NSLog(@"%@",nameLbl.text);
    
    numberLbl.font =[UIFont systemFontOfSize:15.0f];
    numberLbl.textColor =[UIHelper colorWithHexString:@"#738f95"];
    
    //===============宠聊号
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *userId = [config objectForKey:USER_INFO_ID];
    numberLbl.text =[NSString stringWithFormat:@"宠聊号%@",userId];
    
    [headArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    //set secondView
    [secondBgView setImage:bgImage];
    secondBgView.alpha =0.5f;
    [vipInfoIcon setImage:[UIHelper imageName:@"setting_vipInfo_icon"]];
    [vipInfoArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    vipInfoLbl.font =[UIFont systemFontOfSize:16.0f];
    vipInfoLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    vipInfoLbl.text =NSLocalizedString(SETTING_VIPINFO_TITLE, nil);
    
    [secondLineView setImage:[UIHelper imageName:@"setting_line"]];
    
    [bindIcon setImage:[UIHelper imageName:@"setting_binding_icon"]];
    [bindArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    bindLbl.font =[UIFont systemFontOfSize:16.0f];
    bindLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    bindLbl.text =NSLocalizedString(SETTING_BIND_TITLE, nil);
    
    //set thirdView
    [thirdBgView setImage:bgImage];
    thirdBgView.alpha =0.5f;
    [messageIcon setImage:[UIHelper imageName:@"setting_message_icon"]];
    [messageArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    messageLbl.font =[UIFont systemFontOfSize:16.0f];
    messageLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    messageLbl.text =NSLocalizedString(SETTING_MSG_TITLE, nil);
    
    [thirdOneLineView setImage:[UIHelper imageName:@"setting_line"]];
    
    [privacyIcon setImage:[UIHelper imageName:@"setting_privacy_icon"]];
    [privacyArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    privacyLbl.font =[UIFont systemFontOfSize:16.0f];
    privacyLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    privacyLbl.text =NSLocalizedString(SETTING_PRIVACY_TITLE, nil);
    
    [thirdTwoLineView setImage:[UIHelper imageName:@"setting_line"]];
    
    [generalIcon setImage:[UIHelper imageName:@"setting_general_icon"]];
    [generalArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    generalLbl.font =[UIFont systemFontOfSize:16.0f];
    generalLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    generalLbl.text =NSLocalizedString(SETTING_GENERAL_TITLE, nil);
    
    //set endView
    [endBgView setImage:bgImage];
    endBgView.alpha =0.5f;
    [emoIcon setImage:[UIHelper imageName:@"setting_emo_icon"]];
    [emoArrowView setImage:[UIHelper imageName:@"setting_arrow_right"]];
    emoLbl.font =[UIFont systemFontOfSize:16.0f];
    emoLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    emoLbl.text =NSLocalizedString(SETTING_EMO_TITLE, nil);
    
    
    //显示所有字体
//    NSArray *familyNames = [UIFont familyNames];
//    for( NSString *familyName in familyNames ){
//        printf( "Family: %s \n", [familyName UTF8String] );
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames ){
//            printf( "\tFont: %s \n", [fontName UTF8String] );
//        }
//    }
}

- (IBAction)editBtnPressed:(id)sender {
    PESettingEditViewController *sCtr =[[PESettingEditViewController alloc] init];
     sCtr.userName = [dic objectForKey:SETTING_USER_NAME];
    [self.navigationController pushViewController:sCtr animated:YES];
}

- (IBAction)cellBtnPressed:(id)sender {
    PEBindViewController *bCtr =[[PEBindViewController alloc] init];
    [self.navigationController pushViewController:bCtr animated:YES];
}

- (IBAction)generalBtnPressed:(id)sender {
    PEGeneralViewController *gCtr =[[PEGeneralViewController alloc] init];
    [self.navigationController pushViewController:gCtr animated:YES];
}

- (IBAction)messageBtnPressed:(id)sender {
    PEMessageViewController *mCtr =[[PEMessageViewController alloc] init];
    [self.navigationController pushViewController:mCtr animated:YES];
}

- (IBAction)privacyBtnPressed:(id)sender {
    PEPrivacyViewController *pCtr =[[PEPrivacyViewController alloc] init];
    [self.navigationController pushViewController:pCtr animated:YES];
}


@end
