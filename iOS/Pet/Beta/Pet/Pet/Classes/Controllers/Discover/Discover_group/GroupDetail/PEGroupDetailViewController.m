//
//  PEGroupDetailViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupDetailViewController.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "Animations.h"
#import "PEDisGroupMemberListingViewController.h"
#import "PEGroupNewsViewController.h"
#import "PEGroupSetupViewController.h"
#import "PELoginViewController.h"
typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;

@interface PEGroupDetailViewController ()

@end

@implementation PEGroupDetailViewController
@synthesize data, memberImages, petImages;
@synthesize groupID, groupName;
@synthesize photoSV,sv,tabV,groupDetailView;
@synthesize typeBtn,isUp;
@synthesize actionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        data = [[NSDictionary alloc]init];// Custom initialization
        memberImages =[[NSMutableArray alloc] init];
        petImages =[[NSMutableArray alloc] init];
        groupID = [[NSString alloc] init];
        groupName =[[NSString alloc] init];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text =groupName;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    //by wu
    [self.myTable removeFromSuperview];
    [self.myWater removeFromSuperview];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    //底下的ScrollView
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight- 64)];//ScreenHeight- 64
    sv.bounces =NO;
    sv.showsVerticalScrollIndicator =NO;
    sv.showsHorizontalScrollIndicator =NO;

    //=============加入群组
    tabV =[[UIView alloc]initWithFrame:CGRectMake(0.0f, ScreenHeight-49.5, ScreenWidth, 49.5)];
    UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tabButton.frame = CGRectMake(0, 0, 320, 50);
    [tabButton setImage:[UIHelper imageName:@"group_add"] forState:UIControlStateNormal];
    [tabButton setImage:[UIHelper imageName:@"group_addSelected"] forState:UIControlStateSelected];
    [tabButton addTarget:self action:@selector(tabButtonIsPreesed) forControlEvents:UIControlEventTouchUpInside];
    [tabV addSubview:tabButton];
    
    [self.view addSubview:sv];
//    [self.view addSubview:tabV];
    
    
    //右边的设置按钮
    UIBarButtonItem *setupBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"group_detailSet"] style:UIBarButtonItemStyleBordered target:self action:@selector(setupBtn)];
    setupBtn.tintColor =[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem =setupBtn;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *groupInfo =@{@"groupID": groupID};
    
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:groupInfo forKey:HTTP_DISCOVER_GROUPINFO];
    
    [[PENetWorkingManager sharedClient] discoverGroupDetail:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*******Discover Group Detail Success********");
            NSLog(@"%@",results);
            data =results;
            NSArray *petArray =[data objectForKey:DISCOVER_GROUPDETAIL_IMAGELIST];
            NSMutableArray *pets =[[NSMutableArray alloc] init];
            for (NSDictionary *info in petArray) {
                [pets addObject:[info objectForKey:DISCOVER_GROUPDETAIL_IMAGELIST_GROUPIMGURL]];
            }
            petImages =pets;//photoSV用到的数组
            
            [self setUpUI];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建视图
-(void)setUpUI
{
    //黑色背景区域显示一拍图片
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 97.0f) data:petImages AndType:YES];
    [sv addSubview:photoSV];
    
    //白色的按钮，展开更多图片显示
    //黑色区域收起和打卡的白色箭头button
    typeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [typeBtn setImage:[UIHelper imageName:@"group_downBg"] forState:UIControlStateNormal];
    [typeBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [typeBtn setFrame:CGRectMake(0.0f, 0.0, 320, 20)];
    
    //如果没有图片，就隐藏掉 
    if(petImages.count <5)
    {
        typeBtn.hidden = YES;
    }
    isUp = NO;
    
    UIImageView *bgImage =[[UIImageView alloc] init];
    bgImage.backgroundColor =[UIColor colorWithRed:229.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0];
    bgImage.frame =CGRectMake(0.0f, 20.0f, ScreenWidth,530);//450  530（加入群组）
    
    //显示详情
    groupDetailView = [[PEGroupDetailView alloc]initWithFrame:CGRectMake(0, 20, 320.f, 459.0f)];//399
    groupDetailView.groupIDLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_ID];
    groupDetailView.siteLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_LOCATION];
    //=======显示距离
    NSString *distanceString = [data objectForKey:DISCOVER_GROUPDETAIL_DISTANCE];
    int ditance = [distanceString intValue];
    float distanceFloat =[distanceString floatValue];
    if(ditance>=500){
        int m = ditance/500;
//        int n = m/1000;
        groupDetailView.distanceLabel.text =[NSString stringWithFormat:@"%d公里",m];
    }
//    }else if (ditance >=1000){
//        float m = distanceFloat - 1000.0;
//        float n = m/1000;
//        groupDetailView.distanceLabel.text =[NSString stringWithFormat:@"%fkm",n+1.0];
    else{
        groupDetailView.distanceLabel.text =[NSString stringWithFormat:@"%@m", [data objectForKey:DISCOVER_GROUPDETAIL_DISTANCE]];
    }
    groupDetailView.groupNewsCountLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_COMMENTCOUNT];
    
    //群空间
    UIImage *img = [NSURL URLWithString:[data objectForKey:DISCOVER_GROUPDETAIL_PETIMAGE]];
    if(img == nil){
        groupDetailView.newsOwnerImageView.hidden = YES;
    }
    [groupDetailView.newsOwnerImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:DISCOVER_GROUPDETAIL_PETIMAGE]]
                                       placeholderImage:[UIHelper imageName:@"group_memberBg"]];
    groupDetailView.newsTitleLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_ACTIONDES];
    groupDetailView.newsContentLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_SHORTCONTENT];
    NSString *groupMemberCountString = [data objectForKey:DISCOVER_GROUPDETAIL_TOTALMEMBER];
    groupDetailView.groupMemberCountLabel.text = groupMemberCountString;
    if([groupMemberCountString isEqualToString:@""] ||groupMemberCountString == nil){
         groupDetailView.groupMemberCountLabel.text = @"0";
        
    }
    if([groupDetailView.groupMemberCountLabel.text isEqualToString:@"0"]){
        
        groupDetailView.arrowImageView5.alpha = 0.0f;
        
    }else{
        //群成员列表按钮
        [groupDetailView.groupMemberButton addTarget:self action:@selector(groupMemberButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    groupDetailView.members =[data objectForKey:DISCOVER_GROUPDETAIL_PETLIST];
     //群介绍
    NSString *descripString = [data objectForKey:DISCOVER_GROUPDETAIL_DES];
    groupDetailView.groupDescriptionLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_DES];
    groupDetailView.groupRankCountLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_RANK];
    groupDetailView.groupRankDescriptionLabel.text =[data objectForKey:DISCOVER_GROUPDETAIL_RANKDES];
    groupDetailView.dateLabel.text =[[data objectForKey:DISCOVER_GROUPDETAIL_CREATETIME] substringToIndex:10];

     //进入群组动态页面
    [groupDetailView.groupNewsButton addTarget:self action:@selector(groupNewsButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    //set action view
    actionView =[[UIView alloc] init];
    actionView.backgroundColor =[UIColor clearColor];
    actionView.frame =CGRectMake(0.0f, 77.0f, ScreenWidth,490);//450  490（加入群组）

    
    [actionView addSubview:bgImage];
    [actionView addSubview:typeBtn];
    [actionView addSubview:groupDetailView];
    [sv addSubview:actionView];
    sv.contentSize =CGSizeMake(ScreenWidth,546);//  546  606（加入群组)
    
}

#pragma mark -
#pragma mark - ButtonPressed
//进入群设置界面
//- (void)setupBtn{
//    
//    NSLog(@"设置");
//    PEGroupSetupViewController *groupSetupView = [[PEGroupSetupViewController alloc]init];
//    [self.navigationController pushViewController:groupSetupView animated:YES];
//    
//}

//加入群组按钮点击事件
-(void)tabButtonIsPreesed{
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogin == NO){
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
        return;
    }else{
        [Common showAlert:@"申请成功，请等待管理员确认!"];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        PELoginViewController *lCtr =[[PELoginViewController alloc] init];
        lCtr.type =type_chat;
        [self.navigationController pushViewController:lCtr animated:YES];
    }
    
}

//进入群组动态按钮点击事件
- (void)groupNewsButtonPressed{
//    PEGroupNewsViewController *groupNewsView = [[PEGroupNewsViewController alloc]init];
//    [self.navigationController pushViewController:groupNewsView animated:YES];
    
}

//进入群成员列表
- (void)groupMemberButtonPressed
{

    
    PEDisGroupMemberListingViewController *listView = [[PEDisGroupMemberListingViewController alloc]init];
    listView.tempGroupID = groupID;
    [self.navigationController pushViewController:listView animated:YES];
    
}

- (void)typeBtnPressed:(id)sender {
    isUp =!isUp;
    if (isUp) {
        sv.contentSize =CGSizeMake(ScreenWidth, sv.contentSize.height +77);
        [typeBtn setImage:[UIHelper imageName:@"nearDetail_arrow_up"] forState:UIControlStateNormal];
        [Animations moveDown:actionView andAnimationDuration:0.5f andWait:0.0f andLength:77.0f];
        
        [self performSelector:@selector(typeBtnPressedActionDown) withObject:nil afterDelay:0.1];
    } else {
        sv.contentSize =CGSizeMake(ScreenWidth, sv.contentSize.height -77);
        [typeBtn setImage:[UIHelper imageName:@"nearDetail_arrow_down"] forState:UIControlStateNormal];
        [Animations moveUp:actionView andAnimationDuration:0.5f andWait:0.0f andLength:77.0f];
        
        [self performSelector:@selector(typeBtnPressedActionUp) withObject:nil afterDelay:0.4];
    }
}

- (void)typeBtnPressedActionDown {
    
    [photoSV removeFromSuperview];
    NSArray *arr =[data objectForKey:NEAR_DETAIL_IMAGE_LIST];
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 174.0f) data:arr AndType:NO];
    [photoSV layoutSubviews];
    [sv addSubview:photoSV];
    [sv bringSubviewToFront:actionView];
}

- (void)typeBtnPressedActionUp {
    
    [photoSV removeFromSuperview];
    NSArray *arr =[data objectForKey:NEAR_DETAIL_IMAGE_LIST];
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 97.0f) data:arr AndType:YES];
    [photoSV layoutSubviews];
    [sv addSubview:photoSV];
    [sv bringSubviewToFront:actionView];
}

@end
