//
//  PEContactsViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEContactsViewController.h"
#import "PENearDetailViewController.h"
#import "PEAddContactsViewController.h"
//#import "PEContactsGroupViewController.h"
#import "Common.h"
#import "PENetWorkingManager.h"
#import "PENearDetailViewController.h"
#import "PEContactsGroupViewController.h"
#import "PELoginViewController.h"
#import "PEDisGroupCellTwo.h"
#import "PEDisContactsTableCell.h"
#import "PEDisContactsCreateGroupViewController.h"

#import "PEChatViewController.h"

typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;
@interface PEContactsViewController ()

@end

@implementation PEContactsViewController
@synthesize contactsGroupTable,isOpen,selectIndex,groupDataArray;
@synthesize dataArray;
@synthesize contactTable;
@synthesize friendBtn, focusBtn, funsBtn, groupBtn;
@synthesize selectedView, searchText;
@synthesize searchInfoLabel,searchField;
@synthesize dataDic,searchBarBg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        groupDataArray = [[NSMutableArray alloc]init];
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
    
    
    UIImageView *bgHead = [[UIImageView alloc]initWithImage:[UIHelper imageName:@"contact_top_bg"]];//contact_top_bg
    [bgHead setFrame:CGRectMake(0, 0, 320, 105.5)];
    [self.view addSubview:bgHead];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoDetailView:) name:@"searchByUserID" object:nil];

    //check database
    PEFMDBManager *manager =[PEFMDBManager sharedManager];
    manager.peFMDBDelegate =self;
    [manager selectAllDataFromNearTable];
    
    [self setupUI];
    
}

- (void)gotoDetailView:(NSNotification *)note{
    
    NSDictionary *results = note.object;
    NSString *tempPetId = [results objectForKey:DB_COLUMN_NEAR_PETID];
    NSString *tempUserName = [results objectForKey:DB_COLUMN_NEAR_USERNAME];
    NSString *tempUserId = [results objectForKey:@"userID"];
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    detailView.title = tempUserName;
    detailView.petID = tempPetId;
    detailView.ownerID = tempUserId;
    [self.navigationController pushViewController:detailView animated:YES];
    
}

//群组的UI
- (void)setupUI{
    
    contactsGroupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 105.5f, ScreenWidth, ScreenHeight -105.5f -49) style:UITableViewStylePlain];//y = 105.5f +40.0f  ScreenHeight -105.5f -49 - 40
    contactsGroupTable.backgroundColor = [UIColor clearColor];
    contactsGroupTable.separatorColor=[UIColor clearColor];
    contactsGroupTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactsGroupTable.dataSource = self;
    contactsGroupTable.delegate = self;
    contactsGroupTable.sectionFooterHeight = 0;
    contactsGroupTable.sectionHeaderHeight = 0;
    contactsGroupTable.alpha = 0.0f;
    [self.view addSubview:contactsGroupTable];
    self.isOpen = NO;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [contactTable startNearRequest];
  
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED]) {
        [contactsGroupTable setHidden:NO];
        //群组及时刷新
        [self kindBtnPressed:groupBtn];
        
        
    }else {
        [contactsGroupTable setHidden:YES];
    }
}

//20140809 在通讯录进入详情操作，回来刷新数据
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [contactTable refreshDataRequest];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    searchField.text = @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        
        PELoginViewController *loginView = [[PELoginViewController alloc]init];
        loginView.type =type_chat;
        [self.navigationController pushViewController:loginView animated:YES];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectContactTable:(NSDictionary *)data {
    NSLog(@"*****Pressed*******");
    PENearDetailViewController *ndCtr =[[PENearDetailViewController alloc] initWithNibName:@"PENearDetailViewController" bundle:nil];
    ndCtr.title =[data objectForKey:DB_COLUMN_NEAR_USERNAME];
    ndCtr.petID =[data objectForKey:DB_COLUMN_NEAR_PETID];
    ndCtr.ownerID =[data objectForKey:DB_COLUMN_NEAR_USERID];
    //    ndCtr.ownerID =[data objectForKey:db_]
    [[self navigationController] pushViewController:ndCtr animated:YES];
}

- (void)selectNearDataSucc:(NSArray *)data {
    //setting data
    self.dataArray = [[NSMutableArray alloc]init];
    for (int i =0; i < data.count; i ++) {
        [dataArray addObject:data[i]];
    }
    
    [self addDataView];
}

#pragma mark - ADD WATER & TABLE VIEW
- (void)addDataView {
    
    //头部下方的分割线 一加上去就出现问题？
    UIImageView *bgV1 =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"contact_top_bg"]];
    [bgV1 setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 105.5f)];
    
    contactTable =[[PEContactTableView alloc]initWithFrame:CGRectMake(0.0f, 105.5f +40.0f, ScreenWidth, ScreenHeight -105.5f -49 -40.0f) AndData:dataArray];//105.5
    contactTable.tag =201;
    contactTable.backgroundColor =[UIColor clearColor];
    contactTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    contactTable.alpha = 1.0f;
    contactTable.contactTableViewDelegate =self;
    
    //联系人分类
    friendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [friendBtn setTag:101];
    [friendBtn setTitle:@"好友" forState:UIControlStateNormal];
    [friendBtn setTitleColor:[UIHelper colorWithHexString:@"#cee4e9"] forState:UIControlStateNormal];
    [friendBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    [friendBtn addTarget:self action:@selector(kindBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn setFrame:CGRectMake(0.0f, 64.0f, 80.0f, 41.0f)];
    friendBtn.selected =YES;
    [self.view addSubview:friendBtn];
    
    focusBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn setTag:102];
    [focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    [focusBtn setTitleColor:[UIHelper colorWithHexString:@"#cee4e9"] forState:UIControlStateNormal];
    [focusBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    [focusBtn addTarget:self action:@selector(kindBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [focusBtn setFrame:CGRectMake(80.0f, 64.0f, 80.0f, 41.0f)];
    [self.view addSubview:focusBtn];
    
    funsBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [funsBtn setTag:103];
    [funsBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    [funsBtn setTitleColor:[UIHelper colorWithHexString:@"#cee4e9"] forState:UIControlStateNormal];
    [funsBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    [funsBtn addTarget:self action:@selector(kindBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [funsBtn setFrame:CGRectMake(160.0f, 64.0f, 80.0f, 41.0f)];
    [self.view addSubview:funsBtn];
    
    groupBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [groupBtn setTag:104];
    [groupBtn setTitle:@"群组" forState:UIControlStateNormal];
    [groupBtn setTitleColor:[UIHelper colorWithHexString:@"#cee4e9"] forState:UIControlStateNormal];
    [groupBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
    [groupBtn addTarget:self action:@selector(kindBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [groupBtn setFrame:CGRectMake(240.0f, 64.0f, 80.0f, 41.0f)];
    [self.view addSubview:groupBtn];
    
    //添加选中标识
    selectedView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 102.0f, 80.0f, 3.0f)];
    [selectedView setImage:[UIHelper imageName:@"contact_yellow_line"]];
    [self.view addSubview:selectedView];
    
    
    //联系人界面的搜索栏
    searchBarBg = [[UIImageView alloc]init];
    searchBarBg.image = [UIHelper imageName:@"Contact_addFriendBg"];
    searchBarBg.frame  =CGRectMake(10, 112.5, 300, 31);
    searchBarBg.userInteractionEnabled = YES;
    [self.view addSubview:searchBarBg];
    
    //输入名字或宠聊号快速查找
    searchInfoLabel = [[UILabel alloc]init];
    searchInfoLabel.textColor = [UIHelper colorWithHexString:@"#bdd0d6"];
    searchInfoLabel.font = [UIFont systemFontOfSize:14.5];
    searchInfoLabel.text = @"输入名字或宠聊号快速查找";
    searchInfoLabel.frame = CGRectMake(37, 8, 263, 15);
    searchInfoLabel.userInteractionEnabled = YES;
//    [searchBarBg addSubview:searchInfoLabel];
    
    //搜索输入框
    searchField = [[UITextField alloc]init];
    searchField.frame = CGRectMake(37, 0, 263, 31);
    searchField.textColor = [UIColor blackColor];
    searchField.font = [UIFont systemFontOfSize:14.5];
    UIColor *color = [UIHelper colorWithHexString:@"#bdd0d6"];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入用户名字或宠聊号快速查找"
                                                                        attributes:@{NSForegroundColorAttributeName: color}];
    searchField.delegate = self;
    searchField.returnKeyType =UIReturnKeyDefault;
    [searchBarBg addSubview:searchField];
    
    //添加按钮
//    UIBarButtonItem *addBtn =[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtnPressed:)];
//    addBtn.tintColor =[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem =addBtn;
    
    [self.view addSubview:contactTable];
    [contactTable reloadData];
}

#pragma mark -
#pragma mark ISPUREINT
//判断输入的是否是纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


#pragma mark -
#pragma mark TEXTFIELDDELEGATE
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogined == NO){
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
        [textField resignFirstResponder];
    }else{
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *infoString = [searchField text];
    if(infoString.length == 0){
        [textField resignFirstResponder];
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchByName" object:infoString];

}

//好友 关注 粉丝三个按钮点击事件，列表呈现不同数据
- (void)kindBtnPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            searchField.text = @"";
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
            if(isLogined == NO){
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alter show];
            }
            
            friendBtn.selected =YES;
            focusBtn.selected =NO;
            funsBtn.selected =NO;
            groupBtn.selected =NO;
            selectedView.frame =CGRectMake(0.0f, 102.0f, 80.0f, 3.0f);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"friendBtnPressed" object:@"101"];
            contactsGroupTable.alpha = 0.0f;
            contactTable.alpha = 1.0f;
            searchBarBg.alpha = 1.0f;
            break;
        }
        case 102:
            
        {
            searchField.text = @"";
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
            if(isLogined == NO){
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alter show];
            }
            friendBtn.selected =NO;
            focusBtn.selected =YES;
            funsBtn.selected =NO;
            groupBtn.selected =NO;
            selectedView.frame =CGRectMake(80.0f, 102.0f, 80.0f, 3.0f);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"foucusBtnPressed" object:@"102"];
            contactsGroupTable.alpha = 0.0f;
            contactTable.alpha = 1.0f;
            searchBarBg.alpha = 1.0f;
            break;
        }
        case 103:
        {
            searchField.text = @"";
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
            if(isLogined == NO){
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alter show];
            }
            friendBtn.selected =NO;
            focusBtn.selected =NO;
            funsBtn.selected =YES;
            groupBtn.selected =NO;
            selectedView.frame =CGRectMake(160.0f, 102.0f, 80.0f, 3.0f);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fansBtnPressed" object:@"103"];
            contactsGroupTable.alpha = 0.0f;
            contactTable.alpha = 1.0f;
            searchBarBg.alpha = 1.0f;
            break;
        }
            
        //联系人群组按钮点击，需要走api
        case 104:{
            
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
            if(isLogined == NO){
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alter show];
            }
            friendBtn.selected =NO;
            focusBtn.selected =NO;
            funsBtn.selected =NO;
            groupBtn.selected =YES;
            selectedView.frame =CGRectMake(240.0f, 102.0f, 80.0f, 3.0f);
            searchBarBg.alpha = 0.0f;
            contactTable.alpha = 0.0f;
            
            //走api
            NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [[PENetWorkingManager sharedClient]contactsGroup:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [groupDataArray removeAllObjects];
                    NSArray *array = [results objectForKey:DISCOVER_GROUP_DATA];
                    for(int i = 0;i<array.count;i++){
                        [groupDataArray addObject:array[i]];
                    }
//                    groupDataArray =[results objectForKey:DISCOVER_GROUP_DATA];
                    [contactsGroupTable reloadData];
                    contactsGroupTable.alpha = 1.0;
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table view data source
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return groupDataArray.count;
}

//每个区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果打开，总行数 = 表头1行+里面一级内容的行数
    if (self.isOpen)
    {
        if(self.selectIndex.section == section)
        {
            NSInteger rowsCount = [(NSArray *)[[groupDataArray objectAtIndex:section] objectForKey:CONTACTS_GROUP_GROUPLIST] count];//往里面插入数组长度;
            return rowsCount+1;
//            return 2;
        }
    }
    
    //不打开的表头行数
    return 1;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 40.0;
    if(self.isOpen)
    {
        if(self.selectIndex.section == indexPath.section)
        {
            if (indexPath.row ==0) {
                return 40.0f;
            } else {
                height = 74.0f;
            }
        }
        
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID=@"Cell2";
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        PEDisGroupCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            
            cell = [[PEDisGroupCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        //取数组出来显示内容
        //展开列表开始赋值
        if (indexPath.row >0) {
            NSMutableArray *tempArray = [[groupDataArray objectAtIndex:indexPath.section]objectForKey:CONTACTS_GROUP_GROUPLIST];
            NSMutableDictionary *tempDic = [tempArray objectAtIndex:indexPath.row-1];
            
            cell.groupNameLabel.text = [tempDic objectForKey:DISCOVER_GROUP_NAME];
            cell.groupPeopleCountlabel.text = [tempDic objectForKey:DISCOVER_GROUP_SIZE];
            cell.groupSignLable.text = [tempDic objectForKey:DISCOVER_GROUP_DES];
            [cell.groupPetHeadImageView setImageWithURL:[NSURL URLWithString:[tempDic objectForKey:DISCOVER_GROUP_IMAGE]] placeholderImage:[UIHelper imageName:@"club_petHeadImage"]];
            
            NSString *groupRank = [tempDic objectForKey:DISCOVER_GROUP_RANK];
            cell.groupRankLabel.text = groupRank;
            if([groupRank intValue]>1)
            {
                cell.groupStarImageview.image = [UIHelper imageName:@"club_starIconTwo"];
            }else
            {
                cell.groupStarImageview.image = [UIHelper imageName:@"club_starIcon"];
                
            }
            
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        
        static NSString *CellIdentifier = @"Cell1";
        //外面一级的cell
        PEDisContactsTableCell *cell = (PEDisContactsTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PEDisContactsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor =[UIColor clearColor];
        cell.iconImageView.image = [UIHelper imageName:@"club_titleIcon"];
        [cell.createGroupBtn addTarget:self action:@selector(createGroupBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        //======赋值开始
        NSDictionary *dic = [groupDataArray objectAtIndex:indexPath.section];
        
        cell.groupNameLabel.text = @"群组";//群类型
        cell.groupPeopleCountLabel.text = [dic objectForKey:CONTACTS_GROUPPEOPLE_COUNT];
        
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)//点击的是外层Title
    {
        //收起来的动画
        if ([indexPath isEqual:self.selectIndex])
        {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }
        else
        {
            //展开动画
            if (!self.selectIndex)
            {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }
            else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }
    else //点击的是里面一级的cell
    {
        
        NSMutableArray *tempArray = [[groupDataArray objectAtIndex:indexPath.section]objectForKey:CONTACTS_GROUP_GROUPLIST];
        NSMutableDictionary *tempDic = [tempArray objectAtIndex:indexPath.row-1];
        
        NSLog(@"%@", tempDic);
        
        //进入群聊界面
        PEChatViewController *cCtr =[[PEChatViewController alloc] init];
        cCtr.title =[tempDic objectForKey:@"groupName"];
        cCtr.type =chatType_Room;
        cCtr.toRoomJID =[NSString stringWithFormat:@"%@@conference.%@", [tempDic objectForKey:@"groupJID"], xmppDomain];
        cCtr.toName =[tempDic objectForKey:@"groupJID"];
        [self.navigationController pushViewController:cCtr animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//选中第一个区域
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.contactsGroupTable beginUpdates];
    
    int section = self.selectIndex.section;
    
   NSMutableArray *array = [[groupDataArray objectAtIndex:section] objectForKey:CONTACTS_GROUP_GROUPLIST];
    int contentCount = array.count;
    
    if (contentCount ==0) {
        return;
    }
    
    //这是要插入的行数
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < 1 + contentCount; i++) {
        //添加cell-NSIndexPath
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
    //如果是第一次点击，就会展开
	if (firstDoInsert)
    {
        [self.contactsGroupTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    //收起来
	else
    {
        [self.contactsGroupTable deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.contactsGroupTable endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.contactsGroupTable indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.contactsGroupTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


//创建群组按钮点击事件
- (void)createGroupBtnPressed{
    NSLog(@"创建群组");
    
    PEDisContactsCreateGroupViewController *cCtr =[[PEDisContactsCreateGroupViewController alloc] init];
    [self.navigationController pushViewController:cCtr animated:YES];
    
}






@end
