//
//  PENearDetailViewController.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailViewController.h"
#import "UIHelper.h"
#import "Animations.h"
#import "PENetWorkingManager.h"
#import "PEDisNewsViewController.h"
#import "PEDisShoutViewController.h"
#import "PEGroupDetailViewController.h"
#import "Common.h"
#import "PELoginViewController.h"
#import "PENearVedioListViewController.h"
#import "PEChatViewController.h"
@interface PENearDetailViewController ()

@end

@implementation PENearDetailViewController

@synthesize petID, ownerID;
@synthesize data;
@synthesize sv, tabV, typeBtn, isUp, listView, newsView;
@synthesize shoutView, vedioView, roomView, clubView, moreView, otherView;
@synthesize actionView;
@synthesize topImageBgV, ownerIconV, petIconV, lineView;
@synthesize photoSV;
@synthesize isHaveFocus,isHaveBlock,isHaveFocused,isHaveFriend,vedioDic;
@synthesize sendBtn,loveBtn,hateBtn,sheet;
@synthesize imageView1,imageView2,tabVV,isLogin,reportAlter;
@synthesize fliterView,fliterViewTwo,reportField,reportFieldLabel;
@synthesize shoutDic,newsDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        petID =[[NSString alloc] init];
        ownerID =[[NSString alloc] init];
        data =[[NSDictionary alloc] init];
        vedioDic = [[NSDictionary alloc]init];
        shoutDic = [[NSDictionary alloc]init];
        newsDic = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //界面背景图已换
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=self.title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    //底下的ScrollView
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight- 64)];
    sv.bounces =NO;
    sv.showsVerticalScrollIndicator =NO;
    sv.showsHorizontalScrollIndicator =NO;
    
    //添加关注，发送消息，举报拉黑
    tabV =[[UIView alloc]initWithFrame:CGRectMake(0.0f, ScreenHeight-50, ScreenWidth, 50)];
    [self.view addSubview:bgV];
    
    //初始化sheet
    sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拉黑",@"举报", nil];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    //根据petID获取数据
    NSDictionary *appDict =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *petDict =@{DB_COLUMN_NEAR_PETID: petID};
    
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appDict];
    [requestDict setObject:petDict forKey:HTTP_NEARDTAIL_PETINFO];
    
    [[PENetWorkingManager sharedClient] nearDetailDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            
            data =[[results objectForKey:NEAR_DETAIL_DATA] objectAtIndex:0];
            //====是否已经关注：添加关注后该值要发生变化
            //====是否已经拉黑：显示的图片要切换
            //1.是否是好友   2.是否关注：关注  3.是否被关注,相互关注，粉丝
            isHaveFriend = [results objectForKey:NEAR_DETAIL_USER_HAVEFRIEND];
            isHaveFocus = [results objectForKey:NEAR_DETAIL_USER_FOCUS];
            isHaveFocused = [results objectForKey:NEAR_DETAIL_USER_HAVEFOCUSED];
            
            isHaveBlock = [results objectForKey:NEAR_DETAIL_USER_BLOCK];
            vedioDic = [results objectForKey:NEAR_DETAIL_VEDIO_LIST];
            shoutDic = [results objectForKey:NEAR_DETAIL_SHOUT_INFOLIST];
            newsDic = [results objectForKey:NEAR_DETAIL_NEWSINFO_INFOLIST];
            [self setupUI];
            [self.view addSubview:sv];
            [self.view addSubview:tabV];
            
            
            [self.view addSubview:fliterView];
            fliterView.hidden = YES;
            
            [self.view addSubview:fliterViewTwo];
            fliterViewTwo.hidden = YES;
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

#pragma mark - 创建view
- (void)setupUI{
    
    //顶部导航蓝色背景
    topImageBgV =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 74.0f)];
    topImageBgV.image =[UIHelper imageName:@"nearDetail_top_bg"];
    
    //宠物Icon
    petIconV =[[UIImageView alloc]initWithFrame:CGRectMake(28.0f, 16.0f, 44.0f, 44.0f)];
    [petIconV setImageWithURL:[NSURL URLWithString:[data objectForKey:NEAR_DETAIL_PET_ICON]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    petIconV.layer.cornerRadius =22.0f;
    petIconV.clipsToBounds =YES;
    petIconV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(petIconPressed:)];
    [petIconV addGestureRecognizer:tapGesture1];
    
    //用户Icon
    ownerIconV =[[UIImageView alloc]initWithFrame:CGRectMake(260.0f, 16.0f, 44.0f, 44.0f)];
    [ownerIconV setImageWithURL:[NSURL URLWithString:[data objectForKey:NEAR_DETAIL_OWNER_ICON]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    ownerIconV.layer.cornerRadius =22.0f;
    ownerIconV.clipsToBounds =YES;
    ownerIconV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ownerIconPressed:)];//添加手势
    [ownerIconV addGestureRecognizer:tapGesture2];
    
    //
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(50.0f, 60.0f, 1.0f, 14.0f)];
    lineView.backgroundColor =[UIColor whiteColor];
    
    
    //黑色背景区域显示一排图片
    NSArray *arr =[data objectForKey:NEAR_DETAIL_IMAGE_LIST];
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 97.0f) data:arr AndType:YES];
    
    //set action view
    actionView =[[UIView alloc] init];
    actionView.backgroundColor =[UIColor clearColor];
    
    UIImageView *bgImage =[[UIImageView alloc] init];
    bgImage.backgroundColor =[UIColor colorWithRed:229.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    //黑色区域收起和打卡的白色箭头button
    typeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [typeBtn setImage:[UIHelper imageName:@"nearDetail_arrow_down"] forState:UIControlStateNormal];
    [typeBtn addTarget:self action:@selector(typeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [typeBtn setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)];
    //如果没有图片，就隐藏掉
    if(arr.count == 0)
    {
        typeBtn.hidden = YES;
    }
    isUp =NO;
    
    //宠物和用户的详细信息显示
    listView =[[PENearDetailListView alloc]initWithFrame:CGRectMake(0.0f, 20.0f, ScreenWidth, 181)];//157 +24
    listView.petNameLbl.text =[data objectForKey:NEAR_DETAIL_PET_NAME];
    listView.petSortLbl.text =[data objectForKey:NEAR_DETAIL_PET_SUBNAME];
    //宠物年龄显示进行处理
    NSString *petAgeString =[data objectForKey:NEAR_DETAIL_PETBIRTHDAY];
    if([petAgeString isEqualToString:@""] || petAgeString == nil){
        listView.petAgeLbl.text = @"0月";
        
    }else{
        NSString *tempAgeString =[petAgeString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMdd"];
        //将字符串转化成NSDate类型
        NSDate *tempAgeDate =[formatter dateFromString:tempAgeString];
        
        NSCalendar * cal=[NSCalendar currentCalendar];
        NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:tempAgeDate];
        
        NSDate * tempDate=[NSDate date];
        NSCalendar * tempCal=[NSCalendar currentCalendar];
        NSUInteger tempUnitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * tempConponent= [tempCal components:tempUnitFlags fromDate:tempDate];
        
        int year=[tempConponent year]-[conponent year];
        int month = [tempConponent month]- [conponent month];
        if(year >0){
            listView.petAgeLbl.text =[NSString stringWithFormat:@"%d岁",year];
        }else{
            listView.petAgeLbl.text =[NSString stringWithFormat:@"%d月",month];
            
        }
    }
    
    listView.petPreferLbl.text =[data objectForKey:NEAR_DETAIL_PET_FAV];
    listView.petSiteLbl.text =[data objectForKey:NEAR_DETAIL_PET_SITE];
    listView.chateNumber = [data objectForKey:NEAR_DEFAIL_USERID];//宠聊号
    listView.ownerSignLbl.text =[data objectForKey:NEAR_DETAIL_OWNER_SIGN];
    listView.distanceLbl.text =[NSString stringWithFormat:@"%@km", [data objectForKey:NEAR_DETAIL_DISTANCE]];
    //显示时间
    NSString *timrString = [data objectForKey:NEAR_DETAIL_TIME];
    
    if([timrString intValue] >=1440){
        int n = [timrString intValue]/1440;
        listView.timeLbl.text = [NSString stringWithFormat:@"%d天前",n];
    }else if([timrString intValue]>=60){
        int n = [timrString intValue]/60;
        
        listView.timeLbl.text = [NSString stringWithFormat:@"%d小时前",n];
    }else if([timrString intValue]>0){
        listView.timeLbl.text = [NSString stringWithFormat:@"%@分钟前",timrString];;
    }else{
        listView.timeLbl.text =@"刚刚";
    }
    //    listView.timeLbl.text =[NSString stringWithFormat:@"%@分钟前", [data objectForKey:NEAR_DETAIL_TIME]];
    listView.ownerNameLbl.text =[data objectForKey:NEAR_DETAIL_OWNER_NAME];
    listView.petNumberLbl.text =[NSString stringWithFormat:@"宠遇号：%@", [data objectForKey:NEAR_DETAIL_PET_ID]];
    listView.petSex =[data objectForKey:NEAR_DETAIL_PET_SEX];
    listView.ownerSex =[data objectForKey:NEAR_DETAIL_OWNER_SEX];
    listView.petType =[data objectForKey:NEAR_DETAIL_PET_TYPE];
    //by wu
    listView.ownerChatLabel.text = [NSString stringWithFormat:@"宠聊号:%@",[data objectForKey:@""]];//赋值宠聊号
//    [listView.petForwardV setImageWithURL:[NSURL URLWithString:[data objectForKey:@""]] placeholderImage:[UIHelper imageName:@"near_pet_forward_marry"]];//宠物名字后面的icon
    listView.petForward = [data objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
    
    if([isHaveBlock isEqualToString:@"1"]){
        listView.relationDetailLbl.text = @"陌生人";
    }else{
    if([isHaveFriend isEqualToString:@"1"])
    {
        listView.relationDetailLbl.text = @"好友";
    }else
    {
        if([isHaveFocus isEqualToString:@"1"])
        {
            listView.relationDetailLbl.text = @"关注";
            if([isHaveFocused isEqualToString:@"1"])
            {
                listView.relationDetailLbl.text = @"好友";//相互关注为好友
            }else
            {
                listView.relationDetailLbl.text = @"关注";
            }
        }else
        {
            listView.relationDetailLbl.text = @"陌生人";
            if([isHaveFocused isEqualToString:@"1"])
            {
                listView.relationDetailLbl.text = @"粉丝";
            }
        }
        
        
     }
    }
    
    
    NSDate * date=[NSDate date];
    NSCalendar * cal1=[NSCalendar currentCalendar];
    NSUInteger unitFlags1=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent1= [cal1 components:unitFlags1 fromDate:date];
    int year1=[conponent1 year];
    int age1 =year1 - [[[data objectForKey:NEAR_DETAIL_OWNER_Birth] substringWithRange:NSMakeRange(0, 4)] intValue];
    listView.ownerAgeLbl.text =[NSString stringWithFormat:@"%d岁", age1];//用户年龄
    
    //最新动态
    newsView =[[PENearDetailNewsView alloc] initWithFrame:CGRectMake(0.0f, 207.0, 320.0f, 80)];//183
    newsView.nearDetailNewsDelegate =self;
    if (newsDic.count == 0) {
        newsView.newsTitleLbl.alpha =0.0f;
        newsView.newsPetIconV.alpha = 0.0f;
        newsView.newsNumLbl.alpha = 0.0f;
        newsView.arrowImgV.hidden = YES;
        
    }else{
        NSString *newsNumString = [newsDic objectForKey:NEAR_DETAIL_NEWSINFO_NEWSCOUNT];
        newsView.newsNumLbl.text = newsNumString;
        if([newsNumString isEqualToString:@""] || newsNumString == nil){
            newsView.newsNumLbl.text = @"0";
        }
        NSString *petIconString = [newsDic objectForKey:NEAR_DETAIL_NEWSINFO_IMAGEURL];
        //    if([petIconString isEqualToString:@""] || petIconString == nil){
        //
        //    }
        //        newsView.newsPetIconV.layer.cornerRadius = 31;
        //        newsView.newsPetIconV.clipsToBounds = YES;
        [newsView.newsPetIconV setImageWithURL:[NSURL URLWithString:petIconString] placeholderImage:[UIImage imageNamed:@"owner1.png"]];
        newsView.newsPetIconV.layer.cornerRadius = 15.5;
        newsView.newsPetIconV.clipsToBounds = YES;
        NSString *newsNameString = [newsDic objectForKey:NEAR_DETAIL_NEWSINFO_CONTENT];
        newsView.newsTitleLbl.text =  newsNameString;
        if([newsNameString isEqualToString:@""] || newsNameString == nil){
            newsView.newsTitleLbl.text = @"最新动态";
        }
        
    }
    
    //最新喊话
    shoutView =[[PENearDetailShoutView alloc] initWithFrame:CGRectMake(0.0f, 293.0, 320.0f, 80)];//269.f
    shoutView.nearDetailShoutDelegate =self;
    
    if (shoutDic.count == 0) {
        shoutView.shoutTitleLbl.alpha =0.0f;
        shoutView.shoutPetIconV.alpha = 0.0f;
        shoutView.shoutNumLbl.alpha = 0.0f;
        shoutView.arrowImgV.alpha = 0.0f;
        
    }else{
        NSString *shoutNumString = [shoutDic objectForKey:NEAR_DETAIL_SHOUTINFO_COUNT];
        shoutView.shoutNumLbl.text = shoutNumString;
        if([shoutNumString isEqualToString:@""] || shoutNumString == nil){
            shoutView.shoutNumLbl.text = @"0";
        }
        NSString *petIconString = [shoutDic objectForKey:NEAR_DETAIL_SHOUTINFO_IMAGEURL];
        //    if([petIconString isEqualToString:@""] || petIconString == nil){
        //
        //    }
        [shoutView.shoutPetIconV setImageWithURL:[NSURL URLWithString:petIconString] placeholderImage:[UIImage imageNamed:@"owner1.png"]];
        shoutView.shoutPetIconV.layer.cornerRadius = 15.5;
        shoutView.shoutPetIconV.clipsToBounds = YES;
        NSString *shoutNameString = [shoutDic objectForKey:NEAR_DETAIL_SHOUTINFO_CONTENT];
        shoutView.shoutTitleLbl.text =  shoutNameString;
        if([shoutNameString isEqualToString:@""] || shoutNameString == nil){
            shoutView.shoutTitleLbl.text = @"最新喊话";
        }
        
    }
    
    
    //视频
    vedioView =[[PENearDetailVedioView alloc] initWithFrame:CGRectMake(0.0f, 379.0, 320.0f, 100)];//355.0f.
    [vedioView.playVedioBtn addTarget:self action:@selector(playVedioBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [vedioView.arrowBtn addTarget:self action:@selector(arrowBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    if(vedioDic.count == 0){
//        vedioView.vedioNumLbl.text = @"0";
        vedioView.vedioPetIconV.alpha = 0.0f;
        vedioView.vedioTitleLbl.alpha = 0.0f;
        
    }else{
        NSString *videoNumString = [vedioDic objectForKey:NEAR_DETAIL_VEDIO_COUNT];
        vedioView.vedioNumLbl.text =videoNumString;
        if([videoNumString isEqualToString:@""] || videoNumString == nil){
        vedioView.vedioNumLbl.text = @"0";
    }
       NSString *videoNameString = [vedioDic objectForKey:NEAR_DETAIL_VEDIO_NAME];
       vedioView.vedioTitleLbl.text = videoNameString;
       if([videoNameString isEqualToString:@""] || videoNameString == nil){
        vedioView.vedioTitleLbl.text = @"最新视频";
    }
        vedioView.vedioPetIconV.image = [self getVideoPreViewImage];
        [self getVideoPreViewImage];
    }
    
    
    
    //宠聊群组
    roomView =[[PENearDetailGroupView alloc] initWithFrame:CGRectMake(0.0f, 485.0f, 320.0, 88.5)];//485.f
    roomView.dataArray =[data objectForKey:NEAR_DETAIL_GROUP_LIST];
    roomView.nearDetailGroupDelegate =self;
    roomView.titleName =@"宠聊群组";
    
    //宠聊俱乐部
    clubView =[[PENearDetailGroupView alloc] initWithFrame:CGRectMake(0.0f, 579.5, 320.0, 88.5)];//579.5f
    clubView.count =3;
    clubView.titleName =@"宠聊俱乐部";
    
    //更多说明
    moreView =[[PEMoreInfoView alloc] initWithFrame:CGRectMake(0.0f, 579.5f, 320.0, 75)];//674.0f  579.5f
    moreView.moreInfoLbl.text =[data objectForKey:NEAR_DETAIL_USER_DES];//20140809
    
    //其他宠物
    UILabel *otherPet = [[UILabel alloc]init];
    otherPet.font =[UIFont systemFontOfSize:14.5];
    otherPet.textColor = [UIHelper colorWithHexString:@"#000000"];
    otherPet.text =@"其他宠物";
    CGSize sizeOP = [otherPet.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    otherPet.frame =CGRectMake(13.0f, 670.0f, 80.0f, sizeOP.height);//765.0f   670.0f
    
    CGFloat f = 641+sizeOP.height+8;
    
    
    
    
    [sv addSubview:topImageBgV];
    [sv addSubview:petIconV];
    [sv addSubview:ownerIconV];
    [sv addSubview:lineView];
    [sv addSubview:photoSV];
    
    
    
    NSArray *otherPets =[data objectForKey:NEAR_DETAIL_OTHER_PET];
    
    int count =[otherPets count];
    
    bgImage.frame =CGRectMake(0.0f, 20.0f, ScreenWidth, 829.0f + (count +1)/2*82.0f);
    
    [actionView addSubview:bgImage];
    
    for (int i =0; i<count; i++) {
        
        NSDictionary *petData =[otherPets objectAtIndex:i];
        //创建其他宠物视图的对象
        PEOtherPetView *view =[[PEOtherPetView alloc] init];
        int row =i/2;
        int c =i %2;
        view.frame =CGRectMake(0,24, 150.0f, 77.0f);
        view.layer.cornerRadius =7.0f;
        view.clipsToBounds =YES;
        
        view.petNameLbl.text =[petData objectForKey:NEAR_DETAIL_PET_NAME];
        view.petSortLbl.text =[petData objectForKey:NEAR_DETAIL_PET_SUBNAME];
        //        view.petAgeLbl.text =[NSString stringWithFormat:@"%@岁", [petData objectForKey:NEAR_DETAIL_PET_AGE]];
        //时间显示：
        NSString *ageString =[petData objectForKey:NEAR_DETAIL_PETBIRTHDAY];//NEAR_DETAIL_PET_AGE
        if([ageString isEqualToString:@""] || ageString ==nil ){
            view.petAgeLbl.text = @"0月";
        }else{
            NSString *tempAgeString =[petAgeString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSDateComponents *ageConponents = [Common getDateConponent:tempAgeString];
            NSDateComponents *tempDateConponents = [Common getTempDateConponent];
            int year=[tempDateConponents year]-[ageConponents year];
            int month = [tempDateConponents month]- [ageConponents month];
            if(year >0){
                view.petAgeLbl.text =[NSString stringWithFormat:@"%d岁",year];
            }else{
                view.petAgeLbl.text =[NSString stringWithFormat:@"%d月",month];
                
            }
        }
        
//                if ([ageString intValue]>12) {
//                    int n = [ageString intValue]/12;
//                    view.petAgeLbl.text =[NSString stringWithFormat:@"%d岁", n];
//                }else{
//                    view.petAgeLbl.text =[NSString stringWithFormat:@"%@个月", [petData objectForKey:NEAR_DETAIL_PET_AGE]];
//        
//            }
        
        view.petType =[petData objectForKey:NEAR_DETAIL_PET_TYPE];
        [view.petIconV setImageWithURL:[NSURL URLWithString:[petData objectForKey:NEAR_DETAIL_PET_ICON]]];
        view.tag =[[petData objectForKey:NEAR_DETAIL_PET_ID] intValue];
        view.userInteractionEnabled =NO;
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(5.0f+156.0f*c, f +82.0f*row, 150.0f, 77.0f)];//5.0f+156.0f*c, 783.0f +82.0f*row, 150.0f, 77.0f
        btn.tag =[[petData objectForKey:NEAR_DETAIL_PET_ID] intValue];
        [btn addTarget:self action:@selector(otherPetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:view];
        
        [actionView addSubview:btn];//修改的是这个button的位置
    }
    actionView.frame =CGRectMake(0.0f, 151.0f, ScreenWidth, 849.0f + (count +1)/2*82.0f);
    
    
    [actionView addSubview:typeBtn];
    
    [actionView addSubview:listView];
    [actionView addSubview:newsView];
    [actionView addSubview:shoutView];
    [actionView addSubview:vedioView];
    
    [actionView addSubview:roomView];
    //    [actionView addSubview:clubView];
    [actionView addSubview:moreView];
    
    [actionView addSubview:otherPet];
    
    
    [sv addSubview:actionView];
    sv.contentSize =CGSizeMake(ScreenWidth, 911.5f + (count +1)/2*82.0f);//ScreenWidth, 1000.0f + (count +1)/2*82.0f
    
    
    
    
    //set up tab view - 下面的发送消息 添加关注 举报拉黑
    tabVV =[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 50)];
    tabVV.image =[UIHelper imageName:@"nearDetail_tab_bg"];
    tabVV.alpha = 1.0f;
    
    
    //1.添加关注
    loveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [loveBtn addTarget:self action:@selector(addLoveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [loveBtn setFrame:CGRectMake(0.0f, 0.0f, 106.0f, 50.0f)];
    [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
    [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love_selected"] forState:UIControlStateHighlighted];
    loveBtn.alpha = 1.0f;
    
    imageView1 = [[UIImageView alloc]init];
    imageView1.image =[UIHelper imageName:@"nearDetail_fengexian"];
    imageView1.frame = CGRectMake(106, 0, 1, 49);
    imageView1.alpha = 1.0f;
    
    //2.发送消息
    sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(sendMessageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setFrame:CGRectMake(106.0f, 0.0f, 106.0f, 50.0f)];
    [sendBtn setImage:[UIHelper imageName:@"nearDetail_chat"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIHelper imageName:@"nearDetail_chat_selected"] forState:UIControlStateHighlighted];
    sendBtn.alpha = 1.0f;
    
    imageView2 = [[UIImageView alloc]init];
    imageView2.image =[UIHelper imageName:@"nearDetail_fengexian"];
    imageView2.frame = CGRectMake(213, 0, 1, 49);
    imageView2.alpha = 1.0f;
    
    //3.举报拉黑
    hateBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [hateBtn addTarget:self action:@selector(hateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [hateBtn setFrame:CGRectMake(212.0f, 0.0f, 106.0f, 50.0f)];
    [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate"] forState:UIControlStateNormal];
    [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate_selected"] forState:UIControlStateHighlighted];
    hateBtn.alpha = 1.0;
    
    //如果已经关注或者是自己
    if([isHaveFocus isEqualToString:@"1"]){
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love"] forState:UIControlStateNormal];
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love_selected"] forState:UIControlStateHighlighted];
        
    }else{//没有被关注
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love_selected"] forState:UIControlStateHighlighted];
        
    }
    
    if([isHaveBlock isEqualToString:@"1"]){
        [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate"] forState:UIControlStateNormal];
        [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate_selected"] forState:UIControlStateHighlighted];
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
        [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love_selected"] forState:UIControlStateHighlighted];
        
        
    }else{
        
        [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate"] forState:UIControlStateNormal];
        [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate_selected"] forState:UIControlStateHighlighted];
        //        [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love"] forState:UIControlStateNormal];
        //        [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love_selected"] forState:UIControlStateHighlighted];
    }
    
    
    [tabV addSubview:tabVV];
    [tabV addSubview:sendBtn];
    [tabV addSubview:loveBtn];
    [tabV addSubview:hateBtn];
    [tabV addSubview:imageView1];
    [tabV addSubview:imageView2];
    //如果当前的宠聊号和用户ID一样，就会隐藏下面的工具栏。
    NSString *tempUserID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
    if([tempUserID isEqualToString:[data objectForKey:NEAR_DEFAIL_USERID]]){
        
        tabV.hidden = YES;
    }
    
    
    
    
    //======================添加筛选页面
    fliterView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    
    //删选页面的暗色背景
    UIImageView *fliterBg =[[UIImageView alloc] initWithFrame:CGRectInset(fliterView.frame, 0.0f, 0.0f)];
    [fliterBg setImage:[self setImageFromColor:[UIColor blackColor]]];
    fliterBg.alpha =0.8f;
    
    //拉黑，拉黑并举报都要放在这个view上
    UIImageView *centerView1 =[[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 185.0f, 290.0f, 85.0f)];
    centerView1.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    
    centerView1.layer.cornerRadius = 5;
    centerView1.layer.masksToBounds = YES;
    centerView1.userInteractionEnabled =YES;
    
    UIButton *pullBlackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [pullBlackBtn addTarget:self action:@selector(pullBlackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pullBlackBtn setTitle:@"拉黑" forState:UIControlStateNormal];
    [pullBlackBtn setTitleColor:[UIHelper colorWithHexString:@"#fc595a"] forState:UIControlStateNormal];
    pullBlackBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pullBlackBtn setFrame:CGRectMake(0.0f, 0.0f, 290.0f, 42.5f)];
    
    
    UIButton *pullBlackAndReportBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [pullBlackAndReportBtn addTarget:self action:@selector(pullBlackAndReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pullBlackAndReportBtn setTitle:@"拉黑并举报" forState:UIControlStateNormal];
    [pullBlackAndReportBtn setTitleColor:[UIHelper colorWithHexString:@"#fc595a"] forState:UIControlStateNormal];
    pullBlackAndReportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pullBlackAndReportBtn setFrame:CGRectMake(0.0f, 43.5f, 290.0f, 42.5f)];
    
    
    UIView *lineView1 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 42.5f, 290.0f, 1.0f)];
    lineView1.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    
    
    
    //取消放在这个view上
    UIImageView *centerView2 =[[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 283.0f, 290.0f, 42.5f)];
    centerView2.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    centerView2.layer.cornerRadius = 5;
    centerView2.layer.masksToBounds = YES;
    centerView2.userInteractionEnabled =YES;
    
    UIButton *cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIHelper colorWithHexString:@"#499ed7"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setFrame:CGRectMake(0.0f, 0.0f, 290.0f, 42.5f)];
    
    
    [centerView1 addSubview:pullBlackBtn];
    [centerView1 addSubview:pullBlackAndReportBtn];
    [centerView1 addSubview:lineView1];
    [centerView2 addSubview:cancelBtn];
    
    [fliterView addSubview:fliterBg];
    [fliterView addSubview:centerView1];
    [fliterView addSubview:centerView2];
    
    
    //=============举报
    fliterViewTwo =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    
    //删选页面的暗色背景
    UIImageView *fliterBgTwo =[[UIImageView alloc] initWithFrame:CGRectInset(fliterViewTwo.frame, 0.0f, 0.0f)];
    [fliterBgTwo setImage:[self setImageFromColor:[UIColor blackColor]]];
    fliterBgTwo.userInteractionEnabled = YES;
    fliterBgTwo.alpha =0.8f;
    
    UIImageView *centerView3 =[[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 185.0f, 290.0f, 200.0f)];
    centerView3.userInteractionEnabled = YES;
    centerView3.layer.cornerRadius = 5;
    centerView3.layer.masksToBounds = YES;
    centerView3.backgroundColor = [UIHelper colorWithHexString:@"#e8edee"];
    
    
    UILabel *reportLabel = [[UILabel alloc]init];
    reportLabel.textColor = [UIHelper colorWithHexString:@"#858585"];
    reportLabel.font = [UIFont systemFontOfSize:14];
    reportLabel.text = @"举报内容";
    reportLabel.frame = CGRectMake(12, 11.75, 100, 14);
    
    
    UIImageView *cancelImageView = [[UIImageView alloc]init];
    cancelImageView.image = [UIHelper imageName:@"near_cancelReport"];
    cancelImageView.backgroundColor = [UIColor clearColor];
    cancelImageView.userInteractionEnabled = YES;
    cancelImageView.frame = CGRectMake(259, 9.25, 19, 19);
    
    UIButton *cancelReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelReportBtn addTarget:self action:@selector(cancelReportBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    cancelReportBtn.userInteractionEnabled = YES;
    cancelReportBtn.frame = CGRectMake(230, 0,60,37.5);
    
    
    UIImageView *reportFielfBg = [[UIImageView alloc]init];
    reportFielfBg.image = [UIHelper imageName:@"fliter_alert_bg"];
    reportFielfBg.backgroundColor = [UIColor clearColor];
    reportFielfBg.userInteractionEnabled = YES;
    reportFielfBg.layer.cornerRadius = 5;
    reportFielfBg.layer.masksToBounds = YES;
    reportFielfBg.frame = CGRectMake(12, 37.5, 266, 102);
    
    reportFieldLabel = [[UILabel alloc]init];
    reportFieldLabel.textColor = [UIHelper colorWithHexString:@"#7e7e7e"];
    reportFieldLabel.font = [UIFont systemFontOfSize:14];
    reportFieldLabel.text = @"请认真输入举报理由";
    reportFieldLabel.userInteractionEnabled = YES;
    reportFieldLabel.frame = CGRectMake(25, 37.5, 240, 14);
    
    reportField = [[UITextView alloc]init];
    reportField.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    reportField.userInteractionEnabled = YES;
    reportField.textColor = [UIColor blackColor];
    reportField.text = @"请认真输入举报理由";
    reportField.delegate = self;
    reportField.layer.cornerRadius = 5;
    reportField.layer.masksToBounds = YES;
    reportField.frame = CGRectMake(25, 37.5, 240, 102);
    
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(12, 150, 266,40);
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    reportBtn.backgroundColor = [UIHelper colorWithHexString:@"#fb5959"];
    [reportBtn addTarget:self action:@selector(reportBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    reportBtn.layer.cornerRadius = 5;
    reportBtn.layer.masksToBounds = YES;
    reportBtn.userInteractionEnabled = YES;
    
    
    [centerView3 addSubview:reportLabel];
    [centerView3 addSubview:cancelReportBtn];
    [centerView3 addSubview:cancelImageView];
    [centerView3 addSubview:reportFielfBg];
    [centerView3 addSubview:reportField];
    //    [centerView3 addSubview:reportFieldLabel];
    
    
    [centerView3 addSubview:reportBtn];
    
    [fliterViewTwo addSubview:fliterBgTwo];
    [fliterViewTwo addSubview:centerView3];
    
    
    
    
    
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    reportField.text = @"";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -60.0f , ScreenWidth, ScreenHeight);
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0.0f , ScreenWidth, ScreenHeight);
    [UIView commitAnimations];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


//获取视频的第一帧图片
- (UIImage*)getVideoPreViewImage
{
    NSURL *videoPath = [NSURL URLWithString:[vedioDic objectForKey:NEAR_DETAIL_VEDIO_URL]];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    if(img == nil){
        return nil;
    }
    vedioView.vedioPetIconV.image = img;
    vedioView.vedioPetIconV.frame = CGRectMake(83, 32, 144, 192);
    return img;
}

#pragma mark -
#pragma mark -拉黑并举报点击事件
//拉黑并举报
- (void)reportBtnPressed{
    NSLog(@"举报");
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *userInfo = @{@"blockUserID":ownerID,
                               @"comment":reportField.text};
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [request setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient]detailReportUser:request completion:^(NSDictionary *results, NSError *error) {
        if(results){
            NSLog(@"%@",results);
            if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                [Common showAlert:@"举报成功"];
                isHaveBlock = @"1";
                
                sendBtn.alpha = 1.0f;
                hateBtn.alpha = 1.0f;
                imageView1.alpha = 1.0f;
                imageView2.alpha = 1.0f;
                loveBtn.alpha = 1.0f;
                tabVV.alpha = 1.0f;
                tabV.alpha = 1.0;
                [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate"] forState:UIControlStateNormal];
                [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate_selected"] forState:UIControlStateHighlighted];
                //20140809  拉黑并举报，取消关注，变为陌生人
                
                if([isHaveFocus isEqualToString:@"1"] ){
                    [self addLoveBtnPressed];//取消关注
                    
                }
                listView.relationDetailLbl.text = @"陌生人";
                
                
                
            }else{
//                [Common showAlert:[results objectForKey:HTTP_ERRORMSG]];
                [Common showAlert:@"举报失败！"];
            }
        }else{
            NSLog(@"%@",error);
            [Common showAlert:@"举报失败！"];
        }
    }];
    fliterView.hidden = YES;
    fliterViewTwo.hidden = YES;
    [reportField resignFirstResponder];
    
}


//取消举报
- (void)cancelReportBtnPressed{
    
    fliterView.hidden = YES;
    fliterViewTwo.hidden = YES;
    [reportField resignFirstResponder];
    sendBtn.alpha = 1.0f;
    hateBtn.alpha = 1.0f;
    imageView1.alpha = 1.0f;
    imageView2.alpha = 1.0f;
    loveBtn.alpha = 1.0f;
    tabVV.alpha = 1.0f;
    tabV.alpha = 1.0f;
}

#pragma mark - 拉黑点击事件
//拉黑-------关系也变为陌生人
- (void)pullBlackBtnPressed:(UIButton *)sender{
    NSLog(@"拉黑");
    fliterView.hidden = YES;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
    if([userId isEqualToString:ownerID])
    {
        [Common showAlert:@"不能拉黑自己"];
        return;
    }
    
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *userInfo = @{@"blockUserID":ownerID};
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [request setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient]blockUser:request completion:^(NSDictionary *results, NSError *error) {
        if(results){
            NSLog(@"%@",results);
            //            [Common showAlert:@"拉黑成功"];
            //显示图片为已拉黑
            sendBtn.alpha = 1.0f;
            hateBtn.alpha = 1.0f;
            imageView1.alpha = 1.0f;
            imageView2.alpha = 1.0f;
            loveBtn.alpha = 1.0f;
            tabVV.alpha = 1.0f;
            tabV.alpha = 1.0;
            [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate"] forState:UIControlStateNormal];
            [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate_selected"] forState:UIControlStateHighlighted];
            isHaveBlock = @"1";
            isHaveFriend = @"0";
            if([isHaveFocus isEqualToString:@"1"]){
                [self addLoveBtnPressed];//取消关注
                
            }
            listView.relationDetailLbl.text = @"陌生人";
           
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    
}

- (void)pullBlackAndReportBtn:(UIButton *)sender{
    NSLog(@"拉黑并举报");
    fliterView.hidden = YES;
    fliterViewTwo.hidden = NO;
    
}


- (void)cancelBtnPressed:(UIButton *)sender{
    NSLog(@"取消");
    sendBtn.alpha = 1.0f;
    hateBtn.alpha = 1.0f;
    imageView1.alpha = 1.0f;
    imageView2.alpha = 1.0f;
    loveBtn.alpha = 1.0f;
    tabVV.alpha = 1.0f;
    tabV.alpha = 1.0f;
    fliterView.hidden = YES;
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
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 174.0f) data:arr AndType:NO];
    [photoSV layoutSubviews];
    [sv addSubview:photoSV];
    [sv bringSubviewToFront:actionView];
}

- (void)typeBtnPressedActionUp {
    
    [photoSV removeFromSuperview];
    NSArray *arr =[data objectForKey:NEAR_DETAIL_IMAGE_LIST];
    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 97.0f) data:arr AndType:YES];
    [photoSV layoutSubviews];
    [sv addSubview:photoSV];
    [sv bringSubviewToFront:actionView];
}

- (void)otherPetBtnPressed:(id)sender {
    UIButton *button =(UIButton *)sender;
    
    PENearDetailViewController *ndCtr =[[PENearDetailViewController alloc] initWithNibName:@"PENearDetailViewController" bundle:nil];
    ndCtr.title =self.title;
    ndCtr.petID =[NSString stringWithFormat:@"%ld", (long)button.tag];
    ndCtr.ownerID =self.ownerID;
    [[self navigationController] pushViewController:ndCtr animated:YES];
    
}

- (void)petIconPressed:(UITapGestureRecognizer *)gesture {
    [lineView setFrame:CGRectMake(50.0f, 60.0f, 1.0f, 14.0f)];
}

- (void)ownerIconPressed:(UITapGestureRecognizer *)gesture {
    [lineView setFrame:CGRectMake(282.0f, 60.0f, 1.0f, 14.0f)];
}




#pragma mark - BUTTON PRESSED
//播放视频按钮点击事件：进入播放视频界面
- (void)playVedioBtnPressed{
    NSString *videoUrl = [vedioDic objectForKey:NEAR_DETAIL_VEDIO_URL];
    if(videoUrl == nil || [videoUrl isEqualToString:@""]){
        return;
    }
    NSURL *url= [NSURL URLWithString:videoUrl];
    MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self.navigationController presentViewController:playerView animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - 进入视频列表
//进入视频列表界面
- (void)arrowBtnPressed{
    
    if(vedioDic.count == 0){
        return;
    }//20140809
    
    PENearVedioListViewController *vedioListView = [[PENearVedioListViewController alloc]init];
    NSString *tempUserId = [data objectForKey:NEAR_DEFAIL_USERID];
    vedioListView.videoListTableView.tempUserID =tempUserId;
    vedioListView.navTag = 1;
    [self.navigationController pushViewController:vedioListView animated:YES];
}

//添加关注-不能关注自己
//1.首先判断要是否登录
//2.添加好友成功后，只显示发送消息
- (void)addLoveBtnPressed{
    
    //应该带一个是否被关注的标示符
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *userInfo = @{@"focusUserID":ownerID};
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [request setObject:userInfo forKey:@"userInfo"];
    
    
    if( [isHaveFocus isEqualToString:@"1"]){
        
        [[PENetWorkingManager sharedClient]cancelFocus:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                if([[results objectForKey:HTTP_RESULTS] isEqualToString:@"0"]){
                    NSLog(@"************Cancel Focus Success ");
                    //                    [Common showAlert:@"取消关注成功"];
                    [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
                    
                    isHaveFocus = @"0";
                    if([isHaveBlock isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"陌生人";
                    }else{
                    if([isHaveFocused isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"粉丝";
                    }else{
                    if(![isHaveFriend isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"陌生人";
                      }
                     }
                   }
                    
                    
                }else{
                    NSLog(@"%@",[results objectForKey:HTTP_ERRORMSG]);
                    [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love"] forState:UIControlStateNormal];
                }
                
            }else{
                NSLog(@"%@",error);
                [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love"] forState:UIControlStateNormal];
                
            }
        }];
        
        
        
        
    }else{
        
        if(isLogin == NO){
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"你还没有登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            [alter show];
            return;
        }
        
        //如果已经被拉黑，无法添加关注
        if([isHaveBlock isEqualToString:@"1"]){
            [Common showAlert:@"取消拉黑后才能关注!"];
            return;
        }
        
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
        if([userId isEqualToString:ownerID])
        {
            [Common showAlert:@"不能关注自己"];
            return;
        }
        
        [[PENetWorkingManager sharedClient]addFocus:request completion:^(NSDictionary *results, NSError *error) {
            if(results)
            {
                NSLog(@"%@",results);
                NSString *result = [results objectForKey:@"result"];
                if([result isEqualToString:@"0"])
                {
                    [Common showAlert:@"添加关注成功"];
                    
                    [loveBtn setImage:[UIHelper imageName:@"nearDetail_cancel_love"] forState:UIControlStateNormal];
                    isHaveFocus = @"1";
                    if([isHaveFocused isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"好友";
                    }else{
                     if(![isHaveFriend isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"关注";
                      }
                    }
                    
                    
                    
                }else {
                    [Common showAlert:@"添加关注失败"];
                    [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
                    if([isHaveFocused isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"粉丝";
                    }else{
                    if(![isHaveFriend isEqualToString:@"1"]){
                        listView.relationDetailLbl.text = @"陌生人";
                      }
                    }
                }
                
            }
            else{
                NSLog(@"%@",error);
                [loveBtn setImage:[UIHelper imageName:@"nearDetail_add_love"] forState:UIControlStateNormal];
            }
        }];
        
        
    }
    
}



//发送消息，进入聊天界面
- (void)sendMessageBtnPressed:(id)sender {
    
    if(isLogin == NO){
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"你还没有登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alter show];
        return;
    }
    
    if([isHaveBlock isEqualToString:@"1"]){
        
        [Common showAlert:@"取消拉黑后才能发送消息!"];
        return;
        
    }
    
    PEChatViewController *cCtr =[[PEChatViewController alloc] init];
    cCtr.title =self.title;
    cCtr.type =chatType_Single;
    cCtr.toJID =[NSString stringWithFormat:@"%@@%@", ownerID, xmppDomain];
    cCtr.toName =self.title;
    
    [self.navigationController pushViewController:cCtr animated:YES];
    
    
    
}

//拉黑------
- (void)hateBtnPressed:(id)sender {
    
    if(isLogin == NO){
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"你还没有登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alter show];
        return;
        
    }
    //未举报拉黑时
    if([isHaveBlock isEqualToString:@"0"])
    {
        //    sheet.hidden = NO;
        sendBtn.alpha = 0.0f;
        hateBtn.alpha = 0.0f;
        imageView1.alpha = 0.0f;
        imageView2.alpha = 0.0f;
        loveBtn.alpha = 0.0f;
        tabVV.alpha = 0.0f;
        tabV.alpha = 0.0f;
        //    [sheet showInView:self.view];
        
        fliterView.hidden = NO;
        
    }
    else
    {   //已经举报拉黑,取消拉黑
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"blockUserID":ownerID};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        [[PENetWorkingManager sharedClient]cancelblockUser:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS] isEqualToString:@"0"]){
                    //                  [Common showAlert:@"取消拉黑成功"];
                    [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate"] forState:UIControlStateNormal];
                    [hateBtn setImage:[UIHelper imageName:@"nearDetail_hate_selected"] forState:UIControlStateHighlighted];
                    isHaveBlock = @"0";
                    
                }else{
//                    [Common showAlert:[results objectForKey:HTTP_ERRORMSG]];
                    [Common showAlert:@"取消拉黑失败！"];
                }
                
            }else{
                NSLog(@"%@",error);
                [Common showAlert:@"取消拉黑失败！"];
            }
        }];
    }
    
}
#pragma mark -
#pragma mark - UIACTIONSHEETDELEGATE
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
        if([userId isEqualToString:ownerID])
        {
            [Common showAlert:@"不能拉黑自己"];
            return;
        }
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"blockUserID":ownerID};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        
        [[PENetWorkingManager sharedClient]blockUser:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSLog(@"%@",results);
                //                    [Common showAlert:@"拉黑成功"];
                //显示图片为已拉黑
                sendBtn.alpha = 1.0f;
                hateBtn.alpha = 1.0f;
                imageView1.alpha = 1.0f;
                imageView2.alpha = 1.0f;
                loveBtn.alpha = 1.0f;
                tabVV.alpha = 1.0f;
                tabV.alpha = 1.0;
                [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate"] forState:UIControlStateNormal];
                [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate_selected"] forState:UIControlStateHighlighted];
                isHaveBlock = @"1";
                
            }else{
                NSLog(@"%@",error);
            }
        }];
        
        //举报
    }else if(buttonIndex == 1){
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"blockUserID":ownerID,
                                   @"comment":@"你好坏喔！"};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        
        [[PENetWorkingManager sharedClient]detailReportUser:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                    [Common showAlert:@"举报成功"];
                    isHaveBlock = @"1";
                    
                    sendBtn.alpha = 1.0f;
                    hateBtn.alpha = 1.0f;
                    imageView1.alpha = 1.0f;
                    imageView2.alpha = 1.0f;
                    loveBtn.alpha = 1.0f;
                    tabVV.alpha = 1.0f;
                    tabV.alpha = 1.0;
                    [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate"] forState:UIControlStateNormal];
                    [hateBtn setImage:[UIHelper imageName:@"nearDetail_cancelHate_selected"] forState:UIControlStateHighlighted];
                    
                    
                }else{
//                    [Common showAlert:[results objectForKey:HTTP_ERRORMSG]];
                    [Common showAlert:@"举报失败！"];
                }
            }else{
                NSLog(@"%@",error);
                [Common showAlert:@"举报失败！"];
            }
        }];
        
        
        //取消
    }else{
        sendBtn.alpha = 1.0f;
        hateBtn.alpha = 1.0f;
        imageView1.alpha = 1.0f;
        imageView2.alpha = 1.0f;
        loveBtn.alpha = 1.0f;
        tabVV.alpha = 1.0f;
        tabV.alpha = 1.0f;
    }
}

#pragma mark -
#pragma mark - 最新动态点击事件
//===============最新动态点击事件
- (void)didSelectAtNews {
    if(newsDic.count == 0){
        return;
    }//20140809
    PEDisNewsViewController *nCtr = [[PEDisNewsViewController alloc]init];
    NSString *tempUserId = [data objectForKey:NEAR_DEFAIL_USERID];
    nCtr.userID =tempUserId;
    nCtr.navTag = 1;//20140809
    [self.navigationController pushViewController:nCtr animated:YES];
    
}

#pragma mark -
#pragma mark - 宠聊喊话点击事件
//宠聊喊话点击事件
- (void)didSelectAtShout {
    if(shoutDic.count == 0){
        return;
    }//20140809
    PEDisShoutViewController *sCtr = [[PEDisShoutViewController alloc]init];
    NSString *tempUserId = [data objectForKey:NEAR_DEFAIL_USERID];
    sCtr.userID = tempUserId;
    sCtr.navTag = 1;//控制导航右侧的按钮 //20140809
    [self.navigationController pushViewController:sCtr animated:YES];
}

- (void)didSelectAtGroup:(int)gID {
    NSArray *arr =[data objectForKey:NEAR_DETAIL_GROUP_LIST];
    
    //进入群组详情页面
    PEGroupDetailViewController *groupDetailView = [[PEGroupDetailViewController alloc]init];
    groupDetailView.groupID =[arr[gID] objectForKey:NEAR_DETAIL_GROUP_ID];
    groupDetailView.groupName =[arr[gID] objectForKey:NEAR_DETAIL_GROUP_NAME];
    [self.navigationController pushViewController:groupDetailView animated:YES];
}


#pragma mark - ALTERCIEWDELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        PELoginViewController *loginView = [[PELoginViewController alloc]init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

#pragma mark -
#pragma mark CUSTOM PICTURE
//纯色图片
- (UIImage *)setImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
