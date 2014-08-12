//
//  PEMessageViewController.m
//  Pet
//
//  Created by Wu Evan on 7/3/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEMessageViewController.h"

@interface PEMessageViewController ()

@end

@implementation PEMessageViewController

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
    titleLabel.text=NSLocalizedString(SETTING_MSG_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"setting_general_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    UIImageView *panelView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 80.0f)];
    UIImage *panelImg =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [panelImg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    panelView.alpha =0.5f;
    [panelView setImage:panelImg];
    
    UIImageView *panelView2 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 125.0f, 320.0f, 360.0f)];
    panelView2.alpha =0.5f;
    [panelView2 setImage:panelImg];
    
    UIScrollView *sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 504.0f)];
    sv.backgroundColor =[UIColor clearColor];
    sv.showsHorizontalScrollIndicator =NO;
    sv.showsVerticalScrollIndicator =NO;
    [sv setContentSize:CGSizeMake(320.0f, 594.0f)];
    
    [sv addSubview:panelView];
    [sv addSubview:panelView2];
    
    
    UIView *soundBtn =[[UIView alloc] init];
    [soundBtn setFrame:CGRectMake(0.0f, 10.0f, 320.0f, 40.0f)];
    UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 39.5f, 300.0f, 1.0f)];
    [lineView setImage:[UIHelper imageName:@"setting_bind_line"]];
    UILabel *soundTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    soundTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    soundTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    soundTitleLbl.text =NSLocalizedString(SETTING_MESSAGE_SOUND, nil);
    UISwitch *soundSwitch = [[UISwitch alloc] initWithFrame:
                          CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
    [soundSwitch setOn:YES];
    
    [soundBtn addSubview:lineView];
    [soundBtn addSubview:soundTitleLbl];
    [soundBtn addSubview:soundSwitch];
    [sv addSubview:soundBtn];
    
    
    UIView *shakeBtn =[[UIView alloc] init];
    [shakeBtn setFrame:CGRectMake(0.0f, 50.0f, 320.0f, 40.0f)];
    UILabel *shakeTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    shakeTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    shakeTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    shakeTitleLbl.text =NSLocalizedString(SETTING_MESSAGE_SHAKE, nil);
    UISwitch *shakeSwitch = [[UISwitch alloc] initWithFrame:
                             CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
    [shakeSwitch setOn:YES];
    
    [shakeBtn addSubview:shakeTitleLbl];
    [shakeBtn addSubview:shakeSwitch];
    [sv addSubview:shakeBtn];
    
    NSArray *titles =@[SETTING_MESSAGE_MSGNOTI,
                       SETTING_MESSAGE_HELLONOTI,
                       SETTING_MESSAGE_SHOUTNOTI,
                       SETTING_MESSAGE_FOCUSNOTI,
                       SETTING_MESSAGE_FIRENDNEWSNOTI,
                       SETTING_MESSAGE_GROUPNEWSNOTI,
                       SETTING_MESSAGE_ACTIONNEWSNOTI,
                       SETTING_MESSAGE_CLUBNOTI,
                       SETTING_MESSAGE_HIDENOTI];
    
    for (int i =0; i <titles.count; i++) {
        if (i<1) {
            //cell button
            UIButton *cellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [cellBtn setFrame:CGRectMake(0.0f, 125.0f +40*i, 320.0f, 40.0f)];
            UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
            cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
            cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
            cellTitleLbl.text =NSLocalizedString(titles[i], nil);
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:
                                  CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
            [mySwitch setOn:YES];
            [cellBtn addSubview:cellTitleLbl];
            [cellBtn addSubview:mySwitch];
            
            [sv addSubview:cellBtn];
        } else {
            //cell button
            UIView *cellBtn =[[UIView alloc] init];
            [cellBtn setFrame:CGRectMake(0.0f, 125.0f +40*i, 320.0f, 40.0f)];
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
        
        //info label
        UILabel *infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 95.0f, 280.0f, 11.0f)];
        infoLbl.textColor =[UIHelper colorWithHexString:@"#75898f"];
        infoLbl.font =[UIFont systemFontOfSize:11.0f];
        infoLbl.text =@"管理宠聊内的声音和震动";
        
        //info label
        UILabel *infoLbl2 =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 490.0f, 280.0f, 11.0f)];
        infoLbl2.textColor =[UIHelper colorWithHexString:@"#75898f"];
        infoLbl2.font =[UIFont systemFontOfSize:11.0f];
        infoLbl2.text =@"开启后，收到新的通知提醒时不再显示发送人和消息内容";
        
        [sv addSubview:infoLbl];
        [sv addSubview:infoLbl2];
        
        [self.view addSubview:bgV];
        [self.view addSubview:sv];
    }
}

@end
