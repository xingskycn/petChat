//
//  PEDisGroupMemberListingViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisGroupMemberListingViewController.h"
#import "PENearViewTableCell.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#include "UIHelper.h"
#import "PENearDetailViewController.h"
@interface PEDisGroupMemberListingViewController ()

@end

@implementation PEDisGroupMemberListingViewController
@synthesize ownerListArray,managerListArray,memberListArray;
@synthesize ownerListTable,mangerListTable,memberListTable;
@synthesize sv,headerView1,memberDetailView1;
@synthesize headerView2,headerView3,memberDetailView2,memberDetailView3;
@synthesize tempGroupID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        ownerListArray = [[NSMutableArray alloc]init];
        managerListArray = [[NSMutableArray alloc]init];
        memberListArray = [[NSMutableArray alloc]init];
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
    titleLabel.text = @"群成员列表";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    //by wu
    //底下的ScrollView
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight- 64)];
    sv.bounces =NO;
    sv.showsVerticalScrollIndicator =NO;
    sv.showsHorizontalScrollIndicator =NO;
    

    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *userInfo = @{@"groupID":tempGroupID};
    NSMutableDictionary *requst = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [requst setObject:userInfo forKey:@"groupInfo"];
    
    [[PENetWorkingManager sharedClient]groupMemberList:requst completion:^(NSDictionary *results, NSError *error) {
        if(results){
            NSLog(@"%@",results);
            ownerListArray = [results objectForKey:@"ownerList"];
            managerListArray = [results objectForKey:@"managerList"];
            memberListArray = [results objectForKey:@"memberList"];
            NSLog(@"%d",ownerListArray.count);
            NSLog(@"%d",managerListArray.count);
            NSLog(@"%d",memberListArray.count);
            [self setupUI];
        }else{
            
            NSLog(@"%@",error);
        }
    }];
    
}

//-(void)setupUI
//{
//    headerView1 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    headerView1.iconImageView.image = [UIHelper imageName:@"group_master"];
//    headerView1.nameLabel.text = @"群主";
//    headerView1.numberLabel.text =[NSString stringWithFormat:@"%d",ownerListArray.count];
//    [sv addSubview:headerView1];
//    
//    headerView2 =[[PEGroupMemberListView alloc]init];
//    headerView3 =[[PEGroupMemberListView alloc]init];
//    
//    if(ownerListArray.count >0){
//        memberDetailView1 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, 45, 320, 106) AndData:[ownerListArray objectAtIndex:0]];
//        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button1.frame = CGRectMake(0, 0, 320, 106);
//        [button1 addTarget:self action:@selector(ownerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        
//        [memberDetailView1 addSubview:button1];
//        [sv addSubview:memberDetailView1];
//        
//        headerView2.frame = CGRectMake(0, 161, 320, 40);
//    }else{
//        headerView2.frame = CGRectMake(0, 40, 320, 40);
//    }
//    
//   
////    headerView2 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, 161, 320, 40)];
//    headerView2.iconImageView.frame = CGRectMake(12, 8.5, 71.5, 23);
//    headerView2.iconImageView.image = [UIHelper imageName:@"group_manage"];
//    headerView2.nameLabel.text = @"管理员";
//    headerView2.numberLabel.text = [NSString stringWithFormat:@"%d",managerListArray.count];
//    [sv addSubview:headerView2];
//    
//    if(managerListArray.count >0){
//    for (int i = 0; i<managerListArray.count; i++) {
//        memberDetailView2 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, 206+106*i, 320, 106) AndData:[managerListArray objectAtIndex:i]];
//        memberDetailView2.ownHeadIconImageView.hidden = YES;
//        memberDetailView2.ownerImage.image = [UIHelper imageName:@"near_cell_owner_bg"];
//        
//        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button2.frame = CGRectMake(0, 0, 320, 106);
//        [button2 addTarget:self action:@selector(managerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        button2.tag = i-ButtonBaseTag;
//        [memberDetailView2 addSubview:button2];
//        [sv addSubview:memberDetailView2];
//     }
//    }
//    CGFloat h = 206+106*managerListArray.count;
//    if(ownerListArray.count == 0 && managerListArray.count == 0)
//    {
//        headerView3.frame = CGRectMake(0, 80, 320, 40);
//    }
//    else if (ownerListArray.count ==0 && managerListArray.count>0){
//         headerView3.frame = CGRectMake(0, 40+106*managerListArray.count, 320, 40);
//    }
//    else if (ownerListArray.count >0 && managerListArray.count >0){
//        
//        headerView3.frame =CGRectMake(0, h+10, 320, 40);
//    }
//    
//    
////    headerView3 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, h+10, 320, 40)];
//    headerView3.iconImageView.image = [UIHelper imageName:@"group_member"];
//    headerView3.nameLabel.text = @"成员";
//    headerView3.numberLabel.text = [NSString stringWithFormat:@"%ld",memberListArray.count];
//    [sv addSubview:headerView3];
//    
//    h = h+50;
//    
//    if(memberListArray.count>0){
//    for(int i = 0; i<memberListArray.count;i++){
//        memberDetailView3 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, h+106*i, 320, 106) AndData:[memberListArray objectAtIndex:i]];
//        memberDetailView3.ownHeadIconImageView.hidden = YES;
//        memberDetailView3.ownerImage.image = [UIHelper imageName:@"near_cell_owner_bg"];
//        
//        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button3.frame = CGRectMake(0, 0, 320, 106);
//        [button3 addTarget:self action:@selector(memberBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        button3.tag = i-ButtonBaseTag;
//        [memberDetailView3 addSubview:button3];
//        
//        [sv addSubview:memberDetailView3];
//     }
//    }
//    
//    
//    float height = 120+121*(ownerListArray.count +managerListArray.count+memberListArray.count);
//     sv.contentSize =CGSizeMake(ScreenWidth, height);
//    [self.view addSubview:sv];
//    
//}

-(void)setupUI
{
    headerView1 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView1.iconImageView.image = [UIHelper imageName:@"group_master"];
    headerView1.nameLabel.text = @"群主";
    headerView1.numberLabel.text = @"1";
    [sv addSubview:headerView1];
    
    headerView2 =[[PEGroupMemberListView alloc]init];//管理员
    headerView3 =[[PEGroupMemberListView alloc]init];//成员
    
    if(ownerListArray.count >0)
    {
        memberDetailView1 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, 45, 320, 106) AndData:[ownerListArray objectAtIndex:0]];
        [sv addSubview:memberDetailView1];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 0, 320, 106);
       [button1 addTarget:self action:@selector(ownerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
       [memberDetailView1 addSubview:button1];
       [sv addSubview:memberDetailView1];
        
        headerView2.frame = CGRectMake(0, 161, 320, 40);
    }else{
        headerView2.frame = CGRectMake(0, 40, 320, 40);
    }
    //    headerView2 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, 161, 320, 40)];
    headerView2.iconImageView.frame = CGRectMake(12, 8.5, 71.5, 23);
    headerView2.iconImageView.image = [UIHelper imageName:@"group_manage"];
    headerView2.nameLabel.text = @"管理员";
    headerView2.numberLabel.text = [NSString stringWithFormat:@"%d",managerListArray.count];
    [sv addSubview:headerView2];
    
    if(managerListArray.count >0 && ownerListArray.count >0){
        for (int i = 0; i<managerListArray.count; i++) {
            memberDetailView2 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, 206+106*i, 320, 106) AndData:[managerListArray objectAtIndex:i]];
            memberDetailView2.ownHeadIconImageView.hidden = YES;
            memberDetailView2.ownerImage.image = [UIHelper imageName:@"near_cell_owner_bg"];
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(0, 0, 320, 106);
            [button2 addTarget:self action:@selector(managerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            button2.tag = i-ButtonBaseTag;
            [memberDetailView2 addSubview:button2];
            
            [sv addSubview:memberDetailView2];
        }
    }else if (managerListArray.count >0 && ownerListArray.count == 0){
        for (int i = 0; i<managerListArray.count; i++) {
            memberDetailView2 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, 100+106*i, 320, 106) AndData:[managerListArray objectAtIndex:i]];
            memberDetailView2.ownHeadIconImageView.hidden = YES;
            memberDetailView2.ownerImage.image = [UIHelper imageName:@"near_cell_owner_bg"];
            
            UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
            button3.frame = CGRectMake(0, 0, 320, 106);
            [button3 addTarget:self action:@selector(memberBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            button3.tag = i-ButtonBaseTag;
            [memberDetailView3 addSubview:button3];
            [sv addSubview:memberDetailView2];
        }
        
        
        
    }
    
    
    //重点是管理员UI的部署，取决于群主和管理员数组的长度（正常情况下，一个群有且只有一个群主）
    float h =0;
    if(ownerListArray.count == 0 && managerListArray.count == 0)
    {
        h = 80;
        headerView3.frame = CGRectMake(0, 80, 320, 40);
    }else if(ownerListArray.count == 0 && managerListArray.count >0){
        
        h = 100+106*managerListArray.count;
        headerView3.frame = CGRectMake(0, 100+106*managerListArray.count, 320, 40);
    }else if (ownerListArray.count >0 && managerListArray.count >0){
        h = 206+106*managerListArray.count;
        headerView3.frame = CGRectMake(0, h+10, 320, 40);
    }
    
    //    float h = 206+106*managerListArray.count;
    //    headerView3 =[[PEGroupMemberListView alloc]initWithFrame:CGRectMake(0, h+10, 320, 40)];
    headerView3.iconImageView.image = [UIHelper imageName:@"group_member"];
    headerView3.nameLabel.text = @"成员";
    headerView3.numberLabel.text = [NSString stringWithFormat:@"%ld",memberListArray.count];
    [sv addSubview:headerView3];
    
    h = h+50;
    
    if(memberListArray.count>0){
        for(int i = 0; i<memberListArray.count;i++){
            memberDetailView3 = [[PEMemberContentView alloc]initWithFrame:CGRectMake(0, h+106*i, 320, 106) AndData:[memberListArray objectAtIndex:i]];
            memberDetailView3.ownHeadIconImageView.hidden = YES;
            memberDetailView3.ownerImage.image = [UIHelper imageName:@"near_cell_owner_bg"];
            [sv addSubview:memberDetailView3];
        }
    }
    
    
    float height = 120+121*(ownerListArray.count +managerListArray.count+memberListArray.count);
    sv.contentSize =CGSizeMake(ScreenWidth, height);
    [self.view addSubview:sv];
    
}

//群主
- (void)ownerBtnPressed{
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    NSDictionary *dic = [ownerListArray objectAtIndex:0];
    NSString *tempUserName = [dic objectForKey:@"userName"];
    NSString *tempPetId = [dic objectForKey:@"petID"];
    NSString *tempUserId = [dic objectForKey:@"userID"];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
}

//管理员
- (void)managerBtnPressed:(UIButton *)sender{
    
    NSInteger tag = sender.tag +ButtonBaseTag;
    
    NSDictionary *dic = [managerListArray objectAtIndex:tag];
    NSString *tempPetId = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempUserId = [dic objectForKey:@"userID"];
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
    
}


//成员
- (void)memberBtnPressed:(UIButton *)sender{
    
    NSInteger tag = sender.tag +ButtonBaseTag;
    
    NSDictionary *dic = [memberListArray objectAtIndex:tag];
    NSString *tempPetId = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempUserId = [dic objectForKey:@"userID"];
    
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
