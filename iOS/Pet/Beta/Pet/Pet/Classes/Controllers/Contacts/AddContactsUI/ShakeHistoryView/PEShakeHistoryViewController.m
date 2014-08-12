//
//  PEShakeHistoryViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-24.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEShakeHistoryViewController.h"
#import "UIHelper.h"
#import "PEShakeHistoryTableCell.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PENearDetailViewController.h"
@interface PEShakeHistoryViewController ()

@end

@implementation PEShakeHistoryViewController
@synthesize myTableView,backBtn;
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];


    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(SHAKE_HISTORY_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearBtnPressed)];
    self.navigationItem.rightBarButtonItem = clearBtn;

    
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    
    [[PENetWorkingManager sharedClient]shakeHistoryList:request completion:^(NSDictionary *results, NSError *error) {
        if(results){
            [dataArray removeAllObjects];
            NSArray *data =[results objectForKey:NEAR_DETAIL_DATA];
            NSLog(@"%@",results);
            for (int i =0; i<data.count; i++) {
                [dataArray addObject:data[i]];
            }
            [myTableView reloadData];
    
        }else{
            
            NSLog(@"%@",error);
        }
    }];
    
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

- (void)setupUI{
    
    UIImageView *btnImgeView = [[UIImageView alloc]init];
    btnImgeView.backgroundColor = [UIColor clearColor];
    btnImgeView.image = [UIHelper imageName:@"shake_arrow_down"];
    btnImgeView.frame = CGRectMake(154.25, 68.25, 11.5, 10.5);
//  [self.view addSubview:btnImgeView];
    
    //返回摇一摇
    UILabel *shakeHistoryLabel = [[UILabel alloc]init];
    shakeHistoryLabel.textColor = [UIColor whiteColor];
    shakeHistoryLabel.font = [UIFont systemFontOfSize:14];
    shakeHistoryLabel.text = @"返回摇一摇";
    shakeHistoryLabel.frame = CGRectMake(123, 73.5, 74, 14);
    [self.view addSubview:shakeHistoryLabel];
    
    
    //返回摇一摇下面的箭头
    btnImgeView = [[UIImageView alloc]init];
    btnImgeView.backgroundColor = [UIColor clearColor];
    btnImgeView.image = [UIHelper imageName:@"shake_arrow_down"];
    btnImgeView.frame = CGRectMake(147.5, 98.5, 25.5, 7.5);
    [self.view addSubview:btnImgeView];
    
    
    //返回上一页面
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 64, 320, 51.5);
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115.5, ScreenWidth, ScreenHeight-115.5) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    
}
#pragma mark - 
#pragma mark - BUTTON PRESSED
//向下箭头点击事件
- (void)backBtnPressed{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   

}

//清空按钮点击事件
- (void)clearBtnPressed{
    
    NSLog(@"清空");
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [[PENetWorkingManager sharedClient]shakeHistoryListClear:request completion:^(NSDictionary *results, NSError *error) {
        if(results){
            
            NSLog(@"%@",results);
            if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                
                [dataArray removeAllObjects];
                [myTableView reloadData];
            }
            
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    
    
    
}

#pragma mark - 
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count;
    
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
    [cell setHighlighted:NO animated:NO];
    NSDictionary *dataDict =[dataArray objectAtIndex:indexPath.row];
    cell.petNameLbl.text = [dataDict objectForKey:NEAR_DETAIL_PET_NAME];
    //宠物年龄显示进行处理
    //宠物年龄显示进行处理
    NSString *ageString = [dataDict objectForKey:DB_COLUMN_NEAR_PETBIRTHDAY];
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
    cell.petSortLbl.text = [dataDict objectForKey:@"subName"];
    [cell.petImgContent setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    
    //by wu
    cell.petForward = [dataDict objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
    cell.petSignLbl.text =[dataDict objectForKey:DB_COLUMN_NEAR_USERSIGN];
    cell.ownerNameLbl.text =[dataDict objectForKey:DB_COLUMN_NEAR_USERNAME];
    [cell.ownerImageContent setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    cell.petSort =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETTYPE]];
    cell.petSex =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETSEX]];
    cell.ownerSex =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERSEX]];
    cell.ownerBirth =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERBIRTHDAY]];
    if(indexPath.row == 0){
        cell.headLineView .hidden = YES;
    }
    return cell;
}

#pragma mark -TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    NSString *tempPetId = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempUserId = [dic objectForKey:DB_COLUMN_NEAR_USERID];
    
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
    
    
    
 
}


@end
