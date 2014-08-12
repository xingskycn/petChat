//
//  PEGeneralViewController.m
//  Pet
//
//  Created by Wu Evan on 7/3/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEGeneralViewController.h"
#import "PEXMPP.h"

@interface PEGeneralViewController ()

@end

@implementation PEGeneralViewController

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
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(SETTING_GENERAL_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"setting_general_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    UIImageView *panelView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 440.0f)];
    UIImage *panelImg =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [panelImg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    panelView.alpha =0.5f;
    [panelView setImage:panelImg];
    
    UIImageView *panelView2 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 460.0f, 320.0f, 40.0f)];
    panelView2.alpha =0.5f;
    [panelView2 setImage:panelImg];
    
    UIScrollView *sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 504.0f)];
    sv.backgroundColor =[UIColor clearColor];
    sv.showsHorizontalScrollIndicator =NO;
    sv.showsVerticalScrollIndicator =NO;
    [sv setContentSize:CGSizeMake(320.0f, 670.0f)];
    
    [sv addSubview:panelView];
    [sv addSubview:panelView2];
    
    NSArray *titles =@[SETTING_GENERAL_PASSWORD,
                       SETTING_GENERAL_GPS,
                       SETTING_GENERAL_LANGUAGE,
                       SETTING_GENERAL_FONT,
                       SETTING_GENERAL_CHATBG,
                       SETTING_GENERAL_EMO,
                       SETTING_GENERAL_SOUND,
                       SETTING_GENERAL_SHARE,
                       SETTING_GENERAL_FEEDBACK,
                       SETTING_GENERAL_RANK,
                       SETTING_GENERAL_HELP];
    
    for (int i =0; i <11; i++) {
        if (i<1) {
            //cell button
            UIButton *cellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setFrame:CGRectMake(0.0f, 10.0f +40*i, 320.0f, 40.0f)];
            UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
            cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
            cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
            cellTitleLbl.text =NSLocalizedString(titles[i], nil);
            UIImageView *cellArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
            [cellArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
            
            [cellBtn addSubview:cellTitleLbl];
            [cellBtn addSubview:cellArrow];
            
            [sv addSubview:cellBtn];
        } else if(i !=6){
            //cell button
            UIButton *cellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setFrame:CGRectMake(0.0f, 10.0f +40*i, 320.0f, 40.0f)];
            UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 1.0f)];
            [lineView setImage:[UIHelper imageName:@"setting_general_line"]];
            UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
            cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
            cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
            cellTitleLbl.text =NSLocalizedString(titles[i], nil);
            UIImageView *cellArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
            [cellArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
            
            [cellBtn addSubview:lineView];
            [cellBtn addSubview:cellTitleLbl];
            [cellBtn addSubview:cellArrow];
            
            [sv addSubview:cellBtn];
        }else {
            //cell button
            UIView *cellBtn =[[UIView alloc] init];
            [cellBtn setFrame:CGRectMake(0.0f, 10.0f +40*i, 320.0f, 40.0f)];
            UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 1.0f)];
            [lineView setImage:[UIHelper imageName:@"setting_bind_line"]];
            UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
            cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
            cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
            cellTitleLbl.text =NSLocalizedString(titles[i], nil);
            
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:
                             CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
            [mySwitch setOn:YES];
            
            [cellBtn addSubview:lineView];
            [cellBtn addSubview:cellTitleLbl];
            [cellBtn addSubview:mySwitch];
            
            [sv addSubview:cellBtn];
        }
    }
    
    UIView *cellBtn =[[UIView alloc] init];
    [cellBtn setFrame:CGRectMake(0.0f, 460.0f, 320.0f, 40.0f)];
    UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 1.0f)];
    [lineView setImage:[UIHelper imageName:@"setting_bind_line"]];
    UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    cellTitleLbl.text =NSLocalizedString(SETTING_GENERAL_CLEAR, nil);
    UIImageView *cellArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [cellArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    [cellBtn addSubview:lineView];
    [cellBtn addSubview:cellTitleLbl];
    [cellBtn addSubview:cellArrow];
    
    [sv addSubview:cellBtn];
    
    //退出当前账号 1.清楚userID  2.将当前是否登录的标示设为NO
    UIButton *loginOut =[UIButton buttonWithType:UIButtonTypeCustom];
    [loginOut setFrame:CGRectMake(10.0f, 530.0f, 300.0f, 43.0f)];
    [loginOut setImage:[UIHelper imageName:@"setting_general_loginOut"] forState:UIControlStateNormal];
    [loginOut addTarget:self action:@selector(loginOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [sv addSubview:loginOut];
    
    [self.view addSubview:bgV];
    [self.view addSubview:sv];
}

#pragma mark - BUTTON IS PRESSED
- (void)loginOutButtonPressed{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setBool:NO forKey:IS_LOGINED];
    [config setObject:@"null" forKey:USER_INFO_ID];
    
    [[PEXMPP sharedInstance] logout];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOut Succ" object:nil];
    
}
@end
