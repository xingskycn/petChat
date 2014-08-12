//
//  PEPrivacyViewController.m
//  Pet
//
//  Created by Wu Evan on 7/3/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEPrivacyViewController.h"

@interface PEPrivacyViewController ()

@end

@implementation PEPrivacyViewController

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
    titleLabel.text=NSLocalizedString(SETTING_PRIVACY_TITLE, nil);
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
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"setting_privacy_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    UIImage *panelImg =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [panelImg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImageView *panelView1 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 80.0f)];
    panelView1.alpha =0.5f;
    [panelView1 setImage:panelImg];
    
    UIImageView *panelView2 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 164.0f, 320.0f, 80.0f)];
    panelView2.alpha =0.5f;
    [panelView2 setImage:panelImg];
    
    UIImageView *panelView3 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 279.0f, 320.0f, 40.0f)];
    panelView3.alpha =0.5f;
    [panelView3 setImage:panelImg];
    
    UIImageView *panelView4 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 329.0f, 320.0f, 40.0f)];
    panelView4.alpha =0.5f;
    [panelView4 setImage:panelImg];
    
    UIImageView *panelView5 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 379.0f, 320.0f, 80.0f)];
    panelView5.alpha =0.5f;
    [panelView5 setImage:panelImg];
    
    
    
    UIImageView *lineView1 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 113.5f, 300.0f, 1.0f)];
    [lineView1 setImage:[UIHelper imageName:@"setting_privacy_line"]];
    UIImageView *lineView2 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 203.5f, 300.0f, 1.0f)];
    [lineView2 setImage:[UIHelper imageName:@"setting_privacy_line"]];
    UIImageView *lineView3 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 418.5f, 300.0f, 1.0f)];
    [lineView3 setImage:[UIHelper imageName:@"setting_privacy_line"]];
    
    //hide button
    UIButton *hideBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [hideBtn setFrame:CGRectMake(0.0f, 74.0f, 320.0f, 40.0f)];
    UILabel *hideTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    hideTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    hideTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    hideTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_HIDE, nil);
    UIImageView *hideArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [hideArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [hideBtn addSubview:hideTitleLbl];
    [hideBtn addSubview:hideArrow];
    
    //seilent button
    UIButton *seilentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [seilentBtn setFrame:CGRectMake(0.0f, 114.0f, 320.0f, 40.0f)];
    UILabel *seilentTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    seilentTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    seilentTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    seilentTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_SEILENT, nil);
    UIImageView *seilentArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [seilentArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [seilentBtn addSubview:seilentTitleLbl];
    [seilentBtn addSubview:seilentArrow];
    
    //search button
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0.0f, 164.0f, 320.0f, 40.0f)];
    UILabel *searchTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    searchTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    searchTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    searchTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_SEARCHME, nil);
    UISwitch *searchSwitch = [[UISwitch alloc] initWithFrame:
                              CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
    [searchSwitch setOn:YES];
    [searchBtn addSubview:searchTitleLbl];
    [searchBtn addSubview:searchSwitch];
    
    //friend button
    UIButton *friendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [friendBtn setFrame:CGRectMake(0.0f, 204.0f, 320.0f, 40.0f)];
    UILabel *friendTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    friendTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    friendTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    friendTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_CONSTACT, nil);
    UISwitch *friendSwitch = [[UISwitch alloc] initWithFrame:
                          CGRectMake(260.0f, 5.0f, 0.0f, 0.0f)];
    [friendSwitch setOn:YES];
    [friendBtn addSubview:friendTitleLbl];
    [friendBtn addSubview:friendSwitch];

    
    //block button
    UIButton *blockBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [blockBtn setFrame:CGRectMake(0.0f, 279.0f, 320.0f, 40.0f)];
    UILabel *blockTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    blockTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    blockTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    blockTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_BLOCK, nil);
    UIImageView *blockArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [blockArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [blockBtn addSubview:blockTitleLbl];
    [blockBtn addSubview:blockArrow];
    
    //news button
    UIButton *newsBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [newsBtn setFrame:CGRectMake(0.0f, 329.0f, 320.0f, 40.0f)];
    UILabel *newsTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    newsTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    newsTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    newsTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_NEWS, nil);
    UIImageView *newsArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [newsArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [newsBtn addSubview:newsTitleLbl];
    [newsBtn addSubview:newsArrow];
    
    //newsBlock button
    UIButton *newsBlockBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [newsBlockBtn setFrame:CGRectMake(0.0f, 379.0f, 320.0f, 40.0f)];
    UILabel *newsBlockTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    newsBlockTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    newsBlockTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    newsBlockTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_NEWSBLOCK, nil);
    UIImageView *newsBlockArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [newsBlockArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [newsBlockBtn addSubview:newsBlockTitleLbl];
    [newsBlockBtn addSubview:newsBlockArrow];
    
    //photoBlock button
    UIButton *photoBlockBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [photoBlockBtn setFrame:CGRectMake(0.0f, 419.0f, 320.0f, 40.0f)];
    UILabel *photoBlockTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 200.0f, 40.0f)];
    photoBlockTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    photoBlockTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    photoBlockTitleLbl.text =NSLocalizedString(SETTING_PRIVACY_PHOTOBLOCK, nil);
    UIImageView *photoBlockArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [photoBlockArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [photoBlockBtn addSubview:photoBlockTitleLbl];
    [photoBlockBtn addSubview:photoBlockArrow];
    
    //info label
    UILabel *infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 249.0f, 280.0f, 11.0f)];
    infoLbl.textColor =[UIHelper colorWithHexString:@"#75898f"];
    infoLbl.font =[UIFont systemFontOfSize:11.0f];
    infoLbl.text =@"开启后，为您推荐已经开启微信的手机联系人";
    
    
    [self.view addSubview:bgV];
    [self.view addSubview:panelView1];
    [self.view addSubview:panelView2];
    [self.view addSubview:panelView3];
    [self.view addSubview:panelView4];
    [self.view addSubview:panelView5];
    [self.view addSubview:lineView1];
    [self.view addSubview:lineView2];
    [self.view addSubview:lineView3];
    [self.view addSubview:hideBtn];
    [self.view addSubview:seilentBtn];
    [self.view addSubview:searchBtn];
    [self.view addSubview:friendBtn];
    [self.view addSubview:blockBtn];
    [self.view addSubview:newsBtn];
    [self.view addSubview:newsBlockBtn];
    [self.view addSubview:photoBlockBtn];
    [self.view addSubview:infoLbl];
}
@end
