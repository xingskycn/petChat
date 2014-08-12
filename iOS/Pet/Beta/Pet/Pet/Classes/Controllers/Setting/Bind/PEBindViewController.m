//
//  PEBindViewController.m
//  Pet
//
//  Created by Wu Evan on 7/3/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEBindViewController.h"

@interface PEBindViewController ()

@end

@implementation PEBindViewController

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
    titleLabel.text=NSLocalizedString(SETTING_BIND_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
//    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(NEAR_FLITER_TITLE, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPressed:)];
//    backBtn.tintColor =[UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem =backBtn;
    
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
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"setting_bind_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    UIImageView *panelView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 200.0f)];
    UIImage *panelImg =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [panelImg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    panelView.alpha =0.5f;
    [panelView setImage:panelImg];
    
    UIImageView *lineView1 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 113.0f, 300.0f, 1.0f)];
    [lineView1 setImage:[UIHelper imageName:@"setting_bind_line"]];
    UIImageView *lineView2 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 153.0f, 300.0f, 1.0f)];
    [lineView2 setImage:[UIHelper imageName:@"setting_bind_line"]];
    UIImageView *lineView3 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 193.0f, 300.0f, 1.0f)];
    [lineView3 setImage:[UIHelper imageName:@"setting_bind_line"]];
    UIImageView *lineView4 =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 233.0f, 300.0f, 1.0f)];
    [lineView4 setImage:[UIHelper imageName:@"setting_bind_line"]];
    
    //cell button
    UIButton *cellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cellBtn setFrame:CGRectMake(0.0f, 74.0f, 320.0f, 40.0f)];
    UIImageView *cellIcon =[[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 10.5f, 19.0f, 19.0f)];
    [cellIcon setImage:[UIHelper imageName:@"setting_bind_mobile_icon"]];
    UILabel *cellTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, 200.0f, 40.0f)];
    cellTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    cellTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    cellTitleLbl.text =NSLocalizedString(SETTING_BIND_CELL_TITLE, nil);
    UILabel *cellDetailLbl =[[UILabel alloc] initWithFrame:CGRectMake(86.0f, 0.0f, 200.0f, 40.0f)];
    cellDetailLbl.font =[UIFont systemFontOfSize:16.0f];
    cellDetailLbl.textAlignment =NSTextAlignmentRight;
    cellDetailLbl.textColor =[UIHelper colorWithHexString:@"#9aafb6"];
    cellDetailLbl.text =@"未开启通讯录";
    UIImageView *cellArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [cellArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [cellBtn addSubview:cellIcon];
    [cellBtn addSubview:cellTitleLbl];
    [cellBtn addSubview:cellDetailLbl];
    [cellBtn addSubview:cellArrow];
    
    //mail button
    UIButton *mailBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [mailBtn setFrame:CGRectMake(0.0f, 114.0f, 320.0f, 40.0f)];
    UIImageView *mailIcon =[[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 10.5f, 19.0f, 19.0f)];
    [mailIcon setImage:[UIHelper imageName:@"setting_bind_email_icon"]];
    UILabel *mailTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, 200.0f, 40.0f)];
    mailTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    mailTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    mailTitleLbl.text =NSLocalizedString(SETTING_BIND_MAIL_TITLE, nil);
    UILabel *mailDetailLbl =[[UILabel alloc] initWithFrame:CGRectMake(86.0f, 0.0f, 200.0f, 40.0f)];
    mailDetailLbl.font =[UIFont systemFontOfSize:16.0f];
    mailDetailLbl.textAlignment =NSTextAlignmentRight;
    mailDetailLbl.textColor =[UIHelper colorWithHexString:@"#9aafb6"];
    mailDetailLbl.text =@"未绑定";
    UIImageView *mailArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [mailArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [mailBtn addSubview:mailIcon];
    [mailBtn addSubview:mailTitleLbl];
    [mailBtn addSubview:mailDetailLbl];
    [mailBtn addSubview:mailArrow];
    
    //sina button
    UIButton *sinaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sinaBtn setFrame:CGRectMake(0.0f, 154.0f, 320.0f, 40.0f)];
    UIImageView *sinaIcon =[[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 10.5f, 19.0f, 19.0f)];
    [sinaIcon setImage:[UIHelper imageName:@"setting_bind_sina_icon"]];
    UILabel *sinaTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, 200.0f, 40.0f)];
    sinaTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    sinaTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    sinaTitleLbl.text =NSLocalizedString(SETTING_BIND_SINA_TITLE, nil);
    UILabel *sinaDetailLbl =[[UILabel alloc] initWithFrame:CGRectMake(86.0f, 0.0f, 200.0f, 40.0f)];
    sinaDetailLbl.font =[UIFont systemFontOfSize:16.0f];
    sinaDetailLbl.textAlignment =NSTextAlignmentRight;
    sinaDetailLbl.textColor =[UIHelper colorWithHexString:@"#9aafb6"];
    sinaDetailLbl.text =@"未绑定";
    UIImageView *sinaArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [sinaArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [sinaBtn addSubview:sinaIcon];
    [sinaBtn addSubview:sinaTitleLbl];
    [sinaBtn addSubview:sinaDetailLbl];
    [sinaBtn addSubview:sinaArrow];
    
    //tencent button
    UIButton *tencentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [tencentBtn setFrame:CGRectMake(0.0f, 194.0f, 320.0f, 40.0f)];
    UIImageView *tencentIcon =[[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 10.5f, 19.0f, 19.0f)];
    [tencentIcon setImage:[UIHelper imageName:@"setting_bind_tencent_icon"]];
    UILabel *tencentTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, 200.0f, 40.0f)];
    tencentTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    tencentTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    tencentTitleLbl.text =NSLocalizedString(SETTING_BIND_QQWEIBO_TITLE, nil);
    UILabel *tencentDetailLbl =[[UILabel alloc] initWithFrame:CGRectMake(86.0f, 0.0f, 200.0f, 40.0f)];
    tencentDetailLbl.font =[UIFont systemFontOfSize:16.0f];
    tencentDetailLbl.textAlignment =NSTextAlignmentRight;
    tencentDetailLbl.textColor =[UIHelper colorWithHexString:@"#9aafb6"];
    tencentDetailLbl.text =@"未绑定";
    UIImageView *tencentArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [tencentArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [tencentBtn addSubview:tencentIcon];
    [tencentBtn addSubview:tencentTitleLbl];
    [tencentBtn addSubview:tencentDetailLbl];
    [tencentBtn addSubview:tencentArrow];
    
    //sina button
    UIButton *renrenBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [renrenBtn setFrame:CGRectMake(0.0f, 234.0f, 320.0f, 40.0f)];
    UIImageView *renrenIcon =[[UIImageView alloc] initWithFrame:CGRectMake(18.0f, 10.5f, 19.0f, 19.0f)];
    [renrenIcon setImage:[UIHelper imageName:@"setting_bind_renren_icon"]];
    UILabel *renrenTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, 200.0f, 40.0f)];
    renrenTitleLbl.font =[UIFont systemFontOfSize:16.0f];
    renrenTitleLbl.textColor =[UIHelper colorWithHexString:@"#063741"];
    renrenTitleLbl.text =NSLocalizedString(SETTING_BIND_RENREN_TITLE, nil);
    UILabel *renrenDetailLbl =[[UILabel alloc] initWithFrame:CGRectMake(86.0f, 0.0f, 200.0f, 40.0f)];
    renrenDetailLbl.font =[UIFont systemFontOfSize:16.0f];
    renrenDetailLbl.textAlignment =NSTextAlignmentRight;
    renrenDetailLbl.textColor =[UIHelper colorWithHexString:@"#9aafb6"];
    renrenDetailLbl.text =@"未绑定";
    UIImageView *renrenArrow=[[UIImageView alloc] initWithFrame:CGRectMake(297.0f, 13.25f, 8.0f, 13.5f)];
    [renrenArrow setImage:[UIHelper imageName:@"setting_arrow_right"]];
    
    [renrenBtn addSubview:renrenIcon];
    [renrenBtn addSubview:renrenTitleLbl];
    [renrenBtn addSubview:renrenDetailLbl];
    [renrenBtn addSubview:renrenArrow];
    
    [self.view addSubview:bgV];
    [self.view addSubview:panelView];
    [self.view addSubview:lineView1];
    [self.view addSubview:lineView2];
    [self.view addSubview:lineView3];
    [self.view addSubview:lineView4];
    [self.view addSubview:cellBtn];
    [self.view addSubview:mailBtn];
    [self.view addSubview:sinaBtn];
    [self.view addSubview:tencentBtn];
    [self.view addSubview:renrenBtn];
}

#pragma mark -
#pragma BUTTON ACTION

- (void)backBtnPressed:(id)sender {
}

@end
