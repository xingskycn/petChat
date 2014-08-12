//
//  PEClubDeatilViewController.m
//  Pet
//
//  Created by Wu Evan on 7/9/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEClubDeatilViewController.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "Animations.h"
@interface PEClubDeatilViewController ()

@end

@implementation PEClubDeatilViewController
@synthesize data, memberImages, petImages;
@synthesize clubID, clubName;
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
        clubID = [[NSString alloc] init];
        clubName =[[NSString alloc] init];
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
    titleLabel.text =clubName;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    //底下的ScrollView
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight- 64)];
    sv.bounces =NO;
    sv.showsVerticalScrollIndicator =NO;
    sv.showsHorizontalScrollIndicator =NO;
    
    //添加关注
    tabV =[[UIView alloc]initWithFrame:CGRectMake(0.0f, ScreenHeight-49.5, ScreenWidth, 49.5)];
    UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tabButton.frame = CGRectMake(0, 0, 320, 50);
    [tabButton setImage:[UIHelper imageName:@"group_add"] forState:UIControlStateNormal];
    [tabButton setImage:[UIHelper imageName:@"group_addSelected"] forState:UIControlStateSelected];
    [tabButton addTarget:self action:@selector(tabButtonIsPreesed) forControlEvents:UIControlEventTouchUpInside];
    [tabV addSubview:tabButton];
    
    [self.view addSubview:sv];
    [self.view addSubview:tabV];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *groupInfo =@{@"clubID": clubID};
    
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:groupInfo forKey:HTTP_DISCOVER_CLUBINFO];
    
    [[PENetWorkingManager sharedClient] discoverClubDetail:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*******Discover Club Detail Success********");
            data =results;
            NSArray *petArray =[data objectForKey:DISCOVER_CLUBDETAIL_IMAGELIST];
            NSMutableArray *pets =[[NSMutableArray alloc] init];
            for (NSDictionary *info in petArray) {
                [pets addObject:[info objectForKey:DISCOVER_CLUBDETAIL_IMAGELIST_CLUBIMGURL]];
            }
            petImages =pets;
            
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
    //    typeBtn.backgroundColor = [UIColor redColor];
    [typeBtn setImage:[UIHelper imageName:@"group_downBg"] forState:UIControlStateNormal];
    [typeBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [typeBtn setFrame:CGRectMake(0.0f, 0.0, 320, 20)];
    
    //    [photoSV addSubview:typeBtn];
    //如果没有图片，就隐藏掉
    if(petImages.count <5)
    {
        typeBtn.hidden = YES;
    }
    isUp = NO;
    
    UIImageView *bgImage =[[UIImageView alloc] init];
    bgImage.backgroundColor =[UIColor colorWithRed:229.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0];
    bgImage.frame =CGRectMake(0.0f, 20.0f, ScreenWidth, 450);
    
    //显示详情
    groupDetailView = [[PEClubDetailView alloc]initWithFrame:CGRectMake(0, 20, 320.f, 399)];
    groupDetailView.groupIDLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_ID];
    groupDetailView.siteLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_LOCATION];
    float d =0.0f;
    if ([[data objectForKey:DISCOVER_CLUBDETAIL_DISTANCE] floatValue] >=1000) {
        d =[[data objectForKey:DISCOVER_CLUBDETAIL_DISTANCE] floatValue]/1000.0f;
        groupDetailView.distanceLabel.text =[NSString stringWithFormat:@"%.fkm", d];
    } else {
        groupDetailView.distanceLabel.text =[NSString stringWithFormat:@"%@m", [data objectForKey:DISCOVER_CLUBDETAIL_DISTANCE]];
    }
    groupDetailView.groupNewsCountLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_COMMENTCOUNT];
    [groupDetailView.newsOwnerImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:DISCOVER_CLUBDETAIL_PETIMAGE]]
                                       placeholderImage:[UIHelper imageName:@"group_memberBg"]];
    groupDetailView.newsTitleLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_ACTIONDES];
    groupDetailView.newsContentLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_SHORTCONTENT];
    groupDetailView.groupMemberCountLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_TOTALMEMBER];
    groupDetailView.members =[data objectForKey:DISCOVER_CLUBDETAIL_PETLIST];
    
    groupDetailView.groupDescriptionLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_DES];
    groupDetailView.groupRankCountLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_RANK];
    groupDetailView.groupRankDescriptionLabel.text =[data objectForKey:DISCOVER_CLUBDETAIL_RANKDES];
    groupDetailView.dateLabel.text =[[data objectForKey:DISCOVER_CLUBDETAIL_CREATETIME] substringToIndex:10];
    
    //set action view
    actionView =[[UIView alloc] init];
    actionView.backgroundColor =[UIColor clearColor];
    
    actionView.frame =CGRectMake(0.0f, 77.0f, ScreenWidth, 450);
    
    
    [actionView addSubview:bgImage];
    [actionView addSubview:typeBtn];
    [actionView addSubview:groupDetailView];
    [sv addSubview:actionView];
    sv.contentSize =CGSizeMake(ScreenWidth,546);
    
}


#pragma mark - buttonPressed
-(void)tabButtonIsPreesed
{
    
    
    
    
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
