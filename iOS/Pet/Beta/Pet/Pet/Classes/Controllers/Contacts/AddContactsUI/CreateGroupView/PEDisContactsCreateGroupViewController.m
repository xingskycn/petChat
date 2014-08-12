//
//  PEDisContactsCreateGroupViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-23.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisContactsCreateGroupViewController.h"
#import "UIHelper.h"
#import "PECreateGroupSiteViewController.h"
#import "PECreateDetailViewController.h"

@interface PEDisContactsCreateGroupViewController ()

@end

@implementation PEDisContactsCreateGroupViewController

@synthesize label1,label2,label3,label4,label5,label6,label7,label8,label9,label10;
@synthesize centerImageView;
@synthesize nextStepBtn;
@synthesize bgForSmallCommunity, bgForBusinessBuilding, bgForPublicGreen;
@synthesize smallCommunityBtn, publicGreenBtn, businessBuildingBtn, siteBtn;
@synthesize step, siteLbl;

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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATE_GROUP_SITE];
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(CONSTACT_CREATE_GROUP_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    
    label1 = [[UILabel alloc]init];
    label2 = [[UILabel alloc]init];
    label3 = [[UILabel alloc]init];
    label4 = [[UILabel alloc]init];
    label5 = [[UILabel alloc]init];
    label6 = [[UILabel alloc]init];
    label7 = [[UILabel alloc]init];
    label8 = [[UILabel alloc]init];
    label9 = [[UILabel alloc]init];
    label10 = [[UILabel alloc]init];
    
    nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CREATE_GROUP_SITE]) {
        siteLbl.text =[[NSUserDefaults standardUserDefaults] objectForKey:CREATE_GROUP_SITE];
        nextStepBtn.selected =NO;
        nextStepBtn.userInteractionEnabled =YES;
    }
}

- (void)setupUI{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIHelper colorWithHexString:@"#c3b29e"];
    titleLabel.font = [UIFont systemFontOfSize:17.5];
    titleLabel.text = @"群组是遍布城市宠友们的公开组织";
    titleLabel.frame = CGRectMake(25, 83.5, 270, 17.5);
    [self.view addSubview:titleLabel];
    
    
    centerImageView = [[UIImageView alloc]init];
    centerImageView.backgroundColor = [UIColor clearColor];
    centerImageView.image = [UIHelper imageName:@"Contact_centerImage"];
    centerImageView.frame = CGRectMake(9, 133, 293, 259);
    [self.view addSubview:centerImageView];
    
    label1.textColor = [UIHelper colorWithHexString:@"#707070"];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"群组可容纳";
    CGSize sizeLb1 = [label1.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label1.frame = CGRectMake(34, 409, sizeLb1.width, 12);
    [self.view addSubview:label1];
    
    
    label2.textColor = [UIHelper colorWithHexString:@"#29cfe1"];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"20";
    CGSize sizeLb2 = [label2.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label2.frame = CGRectMake(36+sizeLb1.width, 409, sizeLb2.width, 12);
    [self.view addSubview:label2];
    
    
    label3.textColor = [UIHelper colorWithHexString:@"#707070"];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"人，提升等级以增加基础人数，";
    CGSize sizeLb3 = [label3.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label3.frame = CGRectMake(38+sizeLb1.width+sizeLb2.width, 409, sizeLb3.width, 12);
    [self.view addSubview:label3];
    
    
    label4.textColor = [UIHelper colorWithHexString:@"#707070"];
    label4.font = [UIFont systemFontOfSize:12];
    label4.text = @"成为";
    CGSize sizeLb4 = [label4.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label4.frame = CGRectMake(34, 424, sizeLb4.width, 12);
    [self.view addSubview:label4];
    
    label5.textColor = [UIHelper colorWithHexString:@"#29cfe1"];
    label5.font = [UIFont systemFontOfSize:12];
    label5.text = @"宠乐会员";
    CGSize sizeLb5 = [label5.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label5.frame = CGRectMake(34+sizeLb4.width, 424, sizeLb5.width, 12);
    [self.view addSubview:label5];
    
    
    
    label6.textColor = [UIHelper colorWithHexString:@"#707070"];
    label6.font = [UIFont systemFontOfSize:12];
    label6.text = @"可创建";
    CGSize sizeLb6 = [label6.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label6.frame = CGRectMake(34+sizeLb4.width+sizeLb5.width, 424, sizeLb6.width, 12);
    [self.view addSubview:label6];
    
    
    
    label7.textColor = [UIHelper colorWithHexString:@"#29cfe1"];
    label7.font = [UIFont systemFontOfSize:12];
    label7.text = @"2";
    CGSize sizeLb7 = [label7.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label7.frame = CGRectMake(36+sizeLb4.width+sizeLb5.width+sizeLb6.width, 424, sizeLb7.width, 12);
    [self.view addSubview:label7];
    
    
    label8.textColor = [UIHelper colorWithHexString:@"#707070"];
    label8.font = [UIFont systemFontOfSize:12];
    label8.text = @"个群组，人数增加";
    CGSize sizeLb8 = [label8.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label8.frame = CGRectMake(38+sizeLb4.width+sizeLb5.width+sizeLb6.width+sizeLb7.width, 424, sizeLb8.width, 12);
    [self.view addSubview:label8];
    
    
    label9.textColor = [UIHelper colorWithHexString:@"#29cfe1"];
    label9.font = [UIFont systemFontOfSize:12];
    label9.text = @"30";
    CGSize sizeLb9 = [label7.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label9.frame = CGRectMake(40+sizeLb4.width+sizeLb5.width+sizeLb6.width+sizeLb7.width+sizeLb8.width, 424, sizeLb9.width, 12);
    [self.view addSubview:label9];
    
    
    label10.textColor = [UIHelper colorWithHexString:@"#707070"];
    label10.font = [UIFont systemFontOfSize:12];
    label10.text = @"人";
    CGSize sizeLb10 = [label10.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    label10.frame = CGRectMake(42+sizeLb4.width+sizeLb5.width+sizeLb6.width+sizeLb7.width+sizeLb8.width+sizeLb9.width, 424, sizeLb10.width, 12);
    [self.view addSubview:label10];
    
    
    
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [nextStepBtn setTitle:@"当前可创建一个群组" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#ee8d59"]] forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#c4c4c4"]] forState:UIControlStateSelected];
    [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    nextStepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStepBtn.frame = CGRectMake(20, 505, 280, 40);
    [nextStepBtn addTarget:self action:@selector(nextStepBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    nextStepBtn.layer.cornerRadius = 5;
    nextStepBtn.layer.masksToBounds = YES;

    [self.view addSubview:nextStepBtn];
    
    smallCommunityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smallCommunityBtn.frame  = CGRectMake(7.5, ScreenHeight, 101, 60);
    [smallCommunityBtn setTitle:@"小区" forState:UIControlStateNormal];
    smallCommunityBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    
    [smallCommunityBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#ececec"]] forState:UIControlStateNormal];
    [smallCommunityBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#61becd"]] forState:UIControlStateSelected];
    smallCommunityBtn.selected =YES;
    [smallCommunityBtn setTitleColor:[UIHelper colorWithHexString:@"#707070"] forState:UIControlStateNormal];
    [smallCommunityBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    [smallCommunityBtn addTarget:self action:@selector(smallCommunityBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    smallCommunityBtn.layer.cornerRadius =5.0f;
    smallCommunityBtn.clipsToBounds =YES;
    
    [self.view addSubview:smallCommunityBtn];
    
    publicGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publicGreenBtn.frame  = CGRectMake(109.5, ScreenHeight, 101, 60);
    [publicGreenBtn setTitle:@"公园" forState:UIControlStateNormal];
    publicGreenBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [publicGreenBtn setTitleColor:[UIHelper colorWithHexString:@"#707070"] forState:UIControlStateNormal];
    [publicGreenBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    
    [publicGreenBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#ececec"]] forState:UIControlStateNormal];
    [publicGreenBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#61becd"]] forState:UIControlStateSelected];
    publicGreenBtn.selected =NO;
    [publicGreenBtn addTarget:self action:@selector(publicGreenBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    publicGreenBtn.layer.cornerRadius =5.0f;
    publicGreenBtn.clipsToBounds =YES;
    [self.view addSubview:publicGreenBtn];
    
    businessBuildingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    businessBuildingBtn.frame  = CGRectMake(211.5, ScreenHeight, 101, 60);
    [businessBuildingBtn setTitle:@"商务楼" forState:UIControlStateNormal];
    businessBuildingBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [businessBuildingBtn setTitleColor:[UIHelper colorWithHexString:@"#707070"] forState:UIControlStateNormal];
    [businessBuildingBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    
    [businessBuildingBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#ececec"]] forState:UIControlStateNormal];
    [businessBuildingBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#61becd"]] forState:UIControlStateSelected];
    businessBuildingBtn.selected =NO;
    [businessBuildingBtn addTarget:self action:@selector(businessBuildingBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    businessBuildingBtn.layer.cornerRadius =5.0f;
    businessBuildingBtn.clipsToBounds =YES;
    [self.view addSubview:businessBuildingBtn];
    
    //设置地址
    siteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    siteBtn.frame  = CGRectMake(0.0f, ScreenHeight, ScreenWidth, 40.0f);
    [siteBtn addTarget:self action:@selector(siteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:siteBtn];
    
    UILabel *sLbl =[[UILabel alloc] init];
    sLbl.textColor =[UIHelper colorWithHexString:@"#707070"];
    sLbl.text= @"选择地点";
    sLbl.font =[UIFont systemFontOfSize:13.0f];
    [sLbl setFrame:CGRectMake(12.0f, 13.0f, 56.0f, 14.0f)];
    [siteBtn addSubview:sLbl];
    
    UIImageView *sLine =[[UIImageView alloc] init];
    [sLine setFrame:CGRectMake(70.5f, 39.0f, 240.0f, 1.0f)];
    [sLine setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#c4c4c4"]]];
    [siteBtn addSubview:sLine];
    
    siteLbl =[[UILabel alloc] init];
    siteLbl.textColor =[UIHelper colorWithHexString:@"#707070"];
    siteLbl.font =[UIFont systemFontOfSize:13.0f];
//    siteLbl.text =@"哈哈哈哈哈";
    [siteLbl setFrame:CGRectMake(70.5f, 427.0f, 280.0f, 14.0f)];
    [self.view addSubview:siteLbl];
    
    UIImageView *sArrow =[[UIImageView alloc] init];
    [sArrow setFrame:CGRectMake(300.0f, 13.0f, 7.5f, 13.0f)];
    [sArrow setImage:[UIHelper imageName:@"createGroup_arrow"]];
    [siteBtn addSubview:sArrow];
    
    
}

- (void)nextStepBtnPressed{
    if (step) {
        PECreateDetailViewController *dCtr =[[PECreateDetailViewController alloc] init];
        dCtr.groupSite =siteLbl.text;
        [self.navigationController pushViewController:dCtr animated:YES];
    }else {
        label1.hidden =YES;
        label2.hidden =YES;
        label3.hidden =YES;
        label4.hidden =YES;
        label5.hidden =YES;
        label6.hidden =YES;
        label7.hidden =YES;
        label8.hidden =YES;
        label9.hidden =YES;
        label10.hidden =YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        centerImageView.frame = CGRectMake(51.5f, 120.5f, 217.0f, 191.5f);
        smallCommunityBtn.frame  = CGRectMake(7.5, 339, 101, 60);
        publicGreenBtn.frame  = CGRectMake(109.5, 339, 101, 60);
        businessBuildingBtn.frame  = CGRectMake(211.5, 339, 101, 60);
        siteBtn.frame  = CGRectMake(0.0f, 414.0f, ScreenWidth, 40.0f);
        [UIView commitAnimations];
        
        nextStepBtn.selected =YES;
        [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextStepBtn.userInteractionEnabled =NO;
        step =1;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - BUTTONPRESSED
- (void)smallCommunityBtnPressed{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATE_GROUP_SITE];
    siteLbl.text =@"";
    smallCommunityBtn.selected =YES;
    publicGreenBtn.selected =NO;
    businessBuildingBtn.selected =NO;
    nextStepBtn.selected =YES;
    nextStepBtn.userInteractionEnabled =NO;
}


- (void)publicGreenBtnPressed{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATE_GROUP_SITE];
    siteLbl.text =@"";
    smallCommunityBtn.selected =NO;
    publicGreenBtn.selected =YES;
    businessBuildingBtn.selected =NO;
    nextStepBtn.selected =YES;
    nextStepBtn.userInteractionEnabled =NO;
}

- (void)businessBuildingBtnPressed{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATE_GROUP_SITE];
    siteLbl.text =@"";
    smallCommunityBtn.selected =NO;
    publicGreenBtn.selected =NO;
    businessBuildingBtn.selected =YES;
    nextStepBtn.selected =YES;
    nextStepBtn.userInteractionEnabled =NO;
}

- (void)siteBtnPressed {
    PECreateGroupSiteViewController *sCtr =[[PECreateGroupSiteViewController alloc] init];
    
    if (smallCommunityBtn.selected) {
        sCtr.key =@"小区";
    }else if (publicGreenBtn.selected){
        sCtr.key =@"公园";
    }else {
        sCtr.key =@"商务楼";
    }
    
    [self.navigationController pushViewController:sCtr animated:YES];
}

@end
