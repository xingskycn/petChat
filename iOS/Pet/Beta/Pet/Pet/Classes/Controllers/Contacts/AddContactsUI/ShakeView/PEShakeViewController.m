//
//  PEShakeViewController.m
//  Pet
//
//  Created by Wu Evan on 7/23/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEShakeViewController.h"
#import "UIHelper.h"
#import "Animations.h"
#import "PEShakeHistoryViewController.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEShakeHistoryTableCell.h"
#import "PENearDetailViewController.h"
@interface PEShakeViewController ()

@end

@implementation PEShakeViewController

@synthesize dogBody, dogTail;
@synthesize shakeImageV, searchIcon, infoLabel;
@synthesize resultView, isAnimating;
@synthesize btnImgeView,shakeHistoryLabel,shakeHistoryBtn;
@synthesize dic;
@synthesize myTableView,dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dic = [[NSDictionary alloc]init];// Custom initialization
        dataArray = [[NSMutableArray alloc]init];
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
    
    UIImageView *bgBV =[[UIImageView alloc]initWithImage:[UIHelper setImageFromColor:[UIColor blackColor]]];
    [bgBV setFrame:CGRectMake(0.0f, 64.0f, 320.0f, 504.0f)];
    [bgBV setAlpha:0.8f];
    [self.view addSubview:bgBV];
    
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(FIND_CONTACT_SHAKE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.backBarButtonItem = backItem;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [myTableView setFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 106)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupUI {
    dogBody =[[UIImageView alloc] initWithFrame:CGRectMake(113.5f, 189.0f, 84.5f, 163.5f)];
    [dogBody setImage:[UIHelper imageName:@"shake_dog_body"]];
    
    dogTail =[[UIImageView alloc] initWithFrame:CGRectMake(187.0f, 295.0f, 19.0f, 36.0f)];
    [dogTail setImage:[UIHelper imageName:@"shake_dog_tail"]];
    
    shakeImageV =[[UIImageView alloc] initWithFrame:CGRectMake(64.0f, 226.5f, 182.5f, 106.0f)];
    [shakeImageV setImage:[UIHelper imageName:@"shake_dog_shaking"]];
    
    infoLabel =[[UILabel alloc] initWithFrame:CGRectMake(71.0f, 420.0f, 249.0f, 15.0f)];
    infoLabel.textColor =[UIColor whiteColor];
    infoLabel.font =[UIFont systemFontOfSize:15.0f];
    infoLabel.text =@"摇一摇搜索您附近的萌宠";
    
    searchIcon =[[UIImageView alloc] initWithFrame:CGRectMake(40.5f, 414.0f, 25.0f, 25.0f)];
    [searchIcon setImage:[UIHelper imageName:@"shake_searching"]];
    searchIcon.hidden =YES;
    
    //摇完结果的view
    resultView =[[PEShakeNewView alloc] initWithFrame:CGRectMake(45.0f, ScreenHeight, 230.0f, 70.0f) AndData:nil];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 106) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    
    //摇到的历史上面的箭头
    btnImgeView = [[UIImageView alloc]init];
    btnImgeView.backgroundColor = [UIColor clearColor];
    btnImgeView.image = [UIHelper imageName:@"shake_arrow_up"];
    btnImgeView.frame = CGRectMake(147.5, 512, 25.5, 7.5);
    
    
    //摇到的历史
    shakeHistoryLabel = [[UILabel alloc]init];
    shakeHistoryLabel.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
    shakeHistoryLabel.font = [UIFont systemFontOfSize:14];
    shakeHistoryLabel.text = @"摇到的历史";
    shakeHistoryLabel.frame = CGRectMake(123, 531.5, 74, 14);
    
    //摇到历史点击按钮
    shakeHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shakeHistoryBtn.frame = CGRectMake(0, 512, 320, 40);
    [shakeHistoryBtn addTarget:self action:@selector(shakeHistoryBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.view addSubview:dogTail];
    [self.view addSubview:dogBody];
    [self.view addSubview:shakeImageV];
    [self.view addSubview:infoLabel];
    [self.view addSubview:searchIcon];
//    [self.view addSubview:resultView];
    [self.view addSubview:myTableView];
    [self.view addSubview:shakeHistoryLabel];
    [self.view addSubview:shakeHistoryBtn];
    //动画停止显示下面的摇到的历史
    [self.view addSubview:btnImgeView];

}

//摇到的历史按钮点击事件
- (void)shakeHistoryBtnPressed{
    
    PEShakeHistoryViewController *shakeHistoryView = [[PEShakeHistoryViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shakeHistoryView];
    //导航背景已换
    [nav.navigationBar setBackgroundImage:[UIHelper imageName:@"root_nav_top_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
    //设置back按钮,这样下一界面的back会更换字体 by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    nav.navigationItem.backBarButtonItem = backItem;
    [nav.navigationBar setTintColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]];
    [nav.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:shakeHistoryView animated:YES];
    
    
}

//摇一摇动画
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion==UIEventSubtypeMotionShake) {
        [self startAnimation];
    }
}

- (void)startAnimation {
    if (!isAnimating) {
        isAnimating =YES;
        //移除resultView
        [resultView setFrame:CGRectMake(45.0f, ScreenHeight, 230.0f, 70.0f)];
        [myTableView setFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 106)];
        searchIcon.hidden =NO;
        
        
        // 真实一点的摇动动画
        //修改label内容
        infoLabel.text =@"正在搜寻同一时刻摇晃手机的人";
        
        //loading图标旋转
        CABasicAnimation* rotate;
        rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotate.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotate.duration = 1.5f;
        rotate.cumulative = YES;
        rotate.repeatCount = CGFLOAT_MAX;
        [searchIcon.layer addAnimation:rotate forKey:@"searchIcon"];
        searchIcon.alpha = 1.0;
        
        //摇尾巴
        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置抖动幅度
        shake.fromValue = [NSNumber numberWithFloat:-0.5];
        shake.toValue = [NSNumber numberWithFloat:+0.5];
        shake.duration = 0.15f;
        shake.autoreverses = YES; //是否重复
        shake.repeatCount = CGFLOAT_MAX;
        dogTail.layer.anchorPoint =CGPointMake(0, 1);
        dogTail.center =CGPointMake(187.0f, 331.0f);
        [dogTail.layer addAnimation:shake forKey:@"dogTail"];
        dogTail.alpha = 1.0;
        
        //摇动的时候触发的api
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        NSLog(@"*******************");
        [[PENetWorkingManager sharedClient]shakeList:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
//                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                    [self performSelector:@selector(stop) withObject:nil afterDelay:2.0f];
                    return ;
                  }
                dic = nil;
                dic = [[NSDictionary alloc]init];
                self.dic = results;

                [myTableView reloadData];
                NSLog(@"%@",dic);
                [self performSelector:@selector(stop) withObject:nil afterDelay:2.0f];
              
            }else{
                NSLog(@"%@",error);
                [Common showAlert:@"没有搜索到同一时刻摇晃的人，请重新摇！"];
                
            }
        }];
        
        //波纹晃动
        //    CABasicAnimation* shaking = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        //    //设置抖动幅度
        //    shaking.fromValue = [NSNumber numberWithFloat:+10.0f];
        //    shaking.toValue = [NSNumber numberWithFloat:-10.0f];
        //    shaking.duration = 0.1;
        //    shaking.autoreverses = YES; //是否重复
        //    shaking.repeatCount = 4;
        //    [shakeImageV.layer addAnimation:shaking forKey:@"shakeView"];
        //    shakeImageV.alpha = 1.0;
        //    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
    }
}

//动画停止
- (void)stop {
    isAnimating =NO;
    
    infoLabel.text =@"";
    [dogTail.layer removeAnimationForKey:@"dogTail"];
    [searchIcon.layer removeAnimationForKey:@"searchIcon"];
    searchIcon.hidden =YES;
    
    //没搜到好友，不显示reslutView
    //搜寻到好友,显示resultView
    if(dic.count>0)
    {
//      [resultView setUIWithData:dic];
//      [Animations fadeIn:resultView andAnimationDuration:0.5f andWait:0.0f];
//      [Animations moveUp:resultView andAnimationDuration:0.5f andWait:0.0f andLength:ScreenHeight-363.0f];
        
      [Animations fadeIn:myTableView andAnimationDuration:0.5f andWait:0.0f];
      [Animations moveUp:myTableView andAnimationDuration:0.5f andWait:0.0f andLength:ScreenHeight-363.0f];
    }
    


}


#pragma mark - TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID =@"ShakeHistory";
    PEShakeHistoryTableCell *cell =(PEShakeHistoryTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        NSArray *array =[[NSBundle mainBundle] loadNibNamed:@"PEShakeHistoryTableCell" owner:self options:nil];
        cell =[array objectAtIndex:0];
    }
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setHighlighted:NO animated:NO];
//    NSDictionary *dataDict =[dataArray objectAtIndex:indexPath.row];
    cell.petNameLbl.text = [dic objectForKey:NEAR_DETAIL_PET_NAME];
    //宠物年龄显示进行处理
    //宠物年龄显示进行处理
    NSString *ageString = [dic objectForKey:DB_COLUMN_NEAR_PETBIRTHDAY];
    if([ageString isEqualToString:@""] ||ageString == nil){
        cell.petAgeLbl.text = @"0月";
    }else{
        NSString *tempAgeString =[ageString stringByReplacingOccurrencesOfString:@"-" withString:@""];
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
        int month =[tempConponent month] - [conponent month];
        
        if(year >0){
            cell.petAgeLbl.text =[NSString stringWithFormat:@"%d岁",year];
        }else{
            cell.petAgeLbl.text =[NSString stringWithFormat:@"%d月",month];
            
        }
    }
    cell.petSortLbl.text = [dic objectForKey:@"subName"];
    [cell.petImgContent setImageWithURL:[NSURL URLWithString:[dic objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    
    //by wu
    cell.petForward = [dic objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
    cell.petSignLbl.text =[dic objectForKey:DB_COLUMN_NEAR_USERSIGN];
    cell.ownerNameLbl.text =[dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    [cell.ownerImageContent setImageWithURL:[NSURL URLWithString:[dic objectForKey:DB_COLUMN_NEAR_USERIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    cell.petSort =[dic objectForKey:DB_COLUMN_NEAR_PETTYPE];
    cell.petSex =[dic objectForKey:DB_COLUMN_NEAR_PETSEX];
    cell.ownerSex =[dic objectForKey:DB_COLUMN_NEAR_USERSEX];
    cell.ownerBirth =[dic objectForKey:DB_COLUMN_NEAR_USERBIRTHDAY];
    cell.headLineView.hidden = YES;
    return cell;
}

#pragma mark -TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSString *tempPetID = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempOwnerId = [dic objectForKey:DB_COLUMN_NEAR_USERID];
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetID;
    detailView.ownerID = tempOwnerId;
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    
    
    
}



@end
