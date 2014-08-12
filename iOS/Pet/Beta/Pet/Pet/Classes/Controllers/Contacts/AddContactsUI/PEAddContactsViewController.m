//
//  PEAddContactsViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEAddContactsViewController.h"
#import "UIHelper.h"
#import "Common.h"
#import "PENearDetailViewController.h"
#import "PEFindContactsFriendsViewController.h"
#import "PEShakeViewController.h"
#import "PEDisContactsCreateGroupViewController.h"
#import "PEShakeHistoryTableCell.h"
@interface PEAddContactsViewController ()

@end

@implementation PEAddContactsViewController

@synthesize bgImageViewForHead,searchForAddLabel;
@synthesize bgImageViewForSearchInfo,bgForSearchBar;
@synthesize searchTextField,searchButton;
@synthesize bgForSearchButton,bgForSearchButtonPreesed;
@synthesize addContactsView;
@synthesize dic,dataArray,myTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataArray = [[NSMutableArray alloc]init];// Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=self.title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    //搜索号码添加好友下面的背景
    bgImageViewForHead = [[UIImageView alloc]init];
    bgImageViewForHead.frame = CGRectMake(0, 64, 320, 30);
    UIImage *bgImage = [UIHelper imageName:@"club_openSelectedTitle"];
    bgImageViewForHead.image= bgImage;
    bgImageViewForHead.backgroundColor = [UIColor clearColor];
    // [self.view addSubview:bgImageViewForHead];
    
    searchForAddLabel = [[UILabel alloc]init];
    searchForAddLabel.textColor = [UIHelper colorWithHexString:@"ffffff"];
    searchForAddLabel.font =[UIFont systemFontOfSize:11.5];
    searchForAddLabel.text = @"搜索号码或用户名添加好友";
    searchForAddLabel.frame = CGRectMake(6, 77, 150, 12);
    [self.view addSubview:searchForAddLabel];
    
    
    //搜索背景图
    bgImageViewForSearchInfo = [[UIImageView alloc]init];
    bgImageViewForSearchInfo.frame = CGRectMake(0, 94, 320, 111);
    bgImageViewForSearchInfo.image= [UIHelper imageName:@"Contact_searchFriendHead"];
    bgImageViewForSearchInfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgImageViewForSearchInfo];
    
    
    bgForSearchBar = [[UIImageView alloc]init];
    bgForSearchBar.frame = CGRectMake(10, 104, 300, 31);
    bgForSearchBar.image= [UIHelper imageName:@"Contact_addFriendBg"];
    bgForSearchBar.backgroundColor = [UIColor clearColor];
    bgForSearchBar.userInteractionEnabled = YES;
    [self.view addSubview:bgForSearchBar];
    
    searchTextField = [[UITextField alloc]init];
    searchTextField.textColor = [UIColor blackColor];
    UIColor *color = [UIHelper colorWithHexString:@"#dae0e3"];
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入宠聊号或用户名搜素"
                                                                            attributes:@{NSForegroundColorAttributeName: color}];
    searchTextField.frame =CGRectMake(35.5, 0, 269.5, 31);
    searchTextField.delegate = self;
    [bgForSearchBar addSubview:searchTextField];
    
    
    
    //搜素按钮
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(10, 150, 300, 43);
    [searchButton setImage:[UIHelper imageName:@"Contact_searchButton"] forState:UIControlStateNormal];
    [searchButton setImage:[UIHelper imageName:@"Contact_searchButtonPress"] forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    searchButton.alpha = 1.0f;
    [self.view addSubview:searchButton];
    
    //下面部分视图
    addContactsView = [[PEDisAddContactsView alloc]init];
    addContactsView.frame = CGRectMake(0, 215, 320, 160);
    [addContactsView.button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [addContactsView.button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [addContactsView.button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [addContactsView.button4 addTarget:self action:@selector(button4Pressed) forControlEvents:UIControlEventTouchUpInside];
    addContactsView.alpha = 1.0f;
    [self.view addSubview:addContactsView];
    
    //搜素显示列表
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140, ScreenWidth, ScreenHeight-140) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.alpha = 0.0f;
    
    
    
    
}
#pragma mark -TEXTFIELDDELEGATE
//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    CGRect frame = [textField convertRect:textField.frame toView:bgForSearchBar];
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
     NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTextField resignFirstResponder];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    addContactsView.alpha = 1.0f;
    searchButton.alpha = 1.0f;
    bgImageViewForSearchInfo.frame = CGRectMake(0, 94, 320,111);
    myTableView.alpha = 0.0f;
}

//判断输入的是否是纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark-
#pragma mark - BUTTON PRESSED
-(void)searchButtonPressed
{
    NSString *infoString = searchTextField.text;
//    BOOL isPureInt = [self isPureInt:infoString];
    BOOL isPureInt = [Common regexer:infoString rx_matchesPattern:@"^[0-9]*$"];
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
    NSDictionary *userInfo = @{@"userID":userId};
    if(isPureInt == YES && infoString.length != 0)
    {
        //用户不能查找自己
        if([infoString isEqualToString:userId])
        {
            [Common showAlert:@"你输入的是自己的宠聊号"];
            return;
        }
        NSDictionary *petInfo = @{@"petOwnerID":infoString};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        [request setObject:petInfo forKey:@"petInfo"];
        [[PENetWorkingManager sharedClient]addFriendsBySearch:request completion:^(NSDictionary *results, NSError *error) {
            if(results)
            {
                NSLog(@"%@",results);
                NSString *result = [results objectForKey:@"result"];
                self.dic = results;//数据源
                if([result isEqualToString:@"1"])
                {
                    [Common showAlert:@"未找到该用户"];
                }else
                {
                    //================进入详情界面
                    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]initWithNibName:@"PENearDetailViewController" bundle:nil];
                    detailView.title = [results objectForKey:DB_COLUMN_NEAR_USERNAME];
                    detailView.ownerID = infoString;
                    detailView.petID = [results objectForKey:DB_COLUMN_NEAR_PETID];
                    [self.navigationController pushViewController:detailView animated:YES];
                }
                
            }
            else
            {
                NSLog(@"%@",error);
            }
        }];
    }else if(infoString.length >0) {//如果不是纯数字，按名字进行搜索,列表形式呈现
        
        NSDictionary *petInfo = @{@"petOwnerID":infoString};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        [request setObject:petInfo forKey:@"petInfo"];
        [[PENetWorkingManager sharedClient]addFriendsBySearch:request completion:^(NSDictionary *results, NSError *error) {
            if(results)
            {
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"1"]){
                    [Common showAlert:@"请重新输入用户信息!"];
                    return ;
                }
                NSArray *tempArray = [results objectForKey:@"petList"];
                if(tempArray.count ==0){
                    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"不存在该用户，请重新搜索" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    
                }
                addContactsView.alpha = 0.0f;
                searchButton.alpha = 0.0f;
                bgImageViewForSearchInfo.frame = CGRectMake(0, 94, 320, 48);
                myTableView.alpha = 1.0f;
                [dataArray removeAllObjects];
                NSArray *array = [results objectForKey:@"petList"];
                for(int i = 0;i<array.count;i++){
                    [dataArray addObject:array[i]];
                }
                [myTableView reloadData];
                [self.view addSubview:myTableView];
                
            }
            else
            {
                NSLog(@"%@",error);
            }
        }];
        
    }
}

-(void)button1Pressed
{
    NSLog(@"摇一摇");
    PEShakeViewController *sCtr=[[PEShakeViewController alloc] init];
    [self.navigationController pushViewController:sCtr animated:YES];
}
-(void)button2Pressed
{
    NSLog(@"通过通讯录查找");
    PEFindContactsFriendsViewController *findfriensView = [[PEFindContactsFriendsViewController alloc]init];
    [self.navigationController pushViewController:findfriensView animated:YES];
    
}
-(void)button3Pressed
{
    NSLog(@"创建群组");
    PEDisContactsCreateGroupViewController *cCtr =[[PEDisContactsCreateGroupViewController alloc] init];
    [self.navigationController pushViewController:cCtr animated:YES];
}
-(void)button4Pressed
{
    NSLog(@"创建俱乐部");
    
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
    
    NSDictionary *tempDic = [dataArray objectAtIndex:indexPath.row];
    NSString *tempPetId = [tempDic objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [tempDic objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempUserId = [tempDic objectForKey:DB_COLUMN_NEAR_USERID];
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
    
}


#pragma mark - 
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        searchTextField.text = @"";
        addContactsView.alpha = 1.0f;
        searchButton.alpha = 1.0f;
        bgImageViewForSearchInfo.frame = CGRectMake(0, 94, 320, 111);
        myTableView.alpha = 0.0f;
    }
    
    
}

@end
