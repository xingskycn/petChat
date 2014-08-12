//
//  PEDisGroupViewController.m
//  Pet
//
//  Created by Wu Evan on 6/22/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEDisGroupViewController.h"
#import "PENetWorkingManager.h"
#import "PEDisGroupCellTwo.h"
#import "PEDisGroupCellOne.h"
#import "PEGroupDetailViewController.h"
#import "PESearchViewController.h"
@interface PEDisGroupViewController ()
@end

@implementation PEDisGroupViewController
@synthesize grouptableView;
@synthesize isOpen,selectIndex;
@synthesize sortArray,detailArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"宠聊群组";
        sortArray =[[NSMutableArray alloc]init];
        detailArray =[[NSMutableArray alloc]init];
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
    titleLabel.text=NSLocalizedString(DISCOVER_GROUP, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSearch) name:SEARCH_FINISHED object:nil];
    
    
    grouptableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    grouptableView.backgroundColor = [UIColor clearColor];
    grouptableView.separatorColor=[UIColor clearColor];
    grouptableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    grouptableView.dataSource = self;
    grouptableView.delegate = self;
    
    grouptableView.sectionFooterHeight = 0;
    grouptableView.sectionHeaderHeight = 0;
    //grouptableView.alpha = 0.6;
    [self.view addSubview:grouptableView];
    
    self.isOpen = NO;
    
    //设置搜素按钮
    UIBarButtonItem *searchBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"club_navBarRightItem"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchGroup)];
    searchBtn.tintColor =[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =searchBtn;
    

    //将状态条修改为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置back按钮,这样下一界面的back会更换字体 by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    //self.view.alpha = 0.6;

    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    
    [[PENetWorkingManager sharedClient] discoverGroup:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            sortArray =[results objectForKey:DISCOVER_GROUP_DATA];
            [grouptableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}


//搜素按钮点击事件
-(void)searchGroup
{
    PESearchViewController *sCtr =[[PESearchViewController alloc] init];
    sCtr.title =NSLocalizedString(SEARCH_TITLE, nil);
    [self.navigationController pushViewController:sCtr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Table view data source
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sortArray.count;
}

//每个区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (self.isOpen)
    {
        if(self.selectIndex.section == section)
        {   //根据键“list取出数组”
            return [[[sortArray objectAtIndex:section]objectForKey:DISCOVER_GROUP_LIST]count]+1;//往里面插入数组长度
        }
    }
    return 1;
}

//行高  怎样控制行高？？？
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
            NSMutableArray *tempArray = [[sortArray objectAtIndex:indexPath.section]objectForKey:DISCOVER_GROUP_LIST];
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
        PEDisGroupCellOne *cell = (PEDisGroupCellOne*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PEDisGroupCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor =[UIColor clearColor];
        cell.iconImageView.image = [UIHelper imageName:@"club_titleIcon"];
        
        //======赋值开始
        NSMutableDictionary *dic = [sortArray objectAtIndex:indexPath.section];
        cell.groupNameLabel.text = [dic objectForKey:DISCOVER_GROUP_REGIONNAME];//群类型
        NSString *distanceSting = [dic objectForKey:DISCOVER_GROUP_LOCATION];
        if([distanceSting intValue]>=500){
            int n = [distanceSting intValue]/500;
            cell.distanceLable.text = [NSString stringWithFormat:@"%d公里",n];
        }else{
            cell.distanceLable.text = [NSString stringWithFormat:@"%@m", [dic objectForKey:DISCOVER_GROUP_LOCATION]];//距离
        }
        
        //change cellOne image
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
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
        NSMutableArray *tempArray = [[sortArray objectAtIndex:indexPath.section]objectForKey:DISCOVER_GROUP_LIST];
        NSMutableDictionary *tempDic = [tempArray objectAtIndex:indexPath.row-1];
        NSLog(@"%@", tempDic);
        //进入群组详情页面
        PEGroupDetailViewController *groupDetailView = [[PEGroupDetailViewController alloc]init];
        groupDetailView.groupID =[tempDic objectForKey:DISCOVER_GROUP_ID];
        groupDetailView.groupName =[tempDic objectForKey:DISCOVER_GROUP_NAME];
        [self.navigationController pushViewController:groupDetailView animated:YES];
         

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//选中第一个区域
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    PEDisGroupCellOne *cell = (PEDisGroupCellOne *)[self.grouptableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.grouptableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[sortArray objectAtIndex:section] objectForKey:DISCOVER_GROUP_LIST] count];
    //这是要插入的行数
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
        //添加cell-NSIndexPath
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
    //如果是第一次点击，就会展开
	if (firstDoInsert)
    {   [self.grouptableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    //收起来
	else
    {
        [self.grouptableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.grouptableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.grouptableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.grouptableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - NOTIFICATION SEARCH
- (void)finishSearch {
    //如果都是默认选项，搜索显示全部
    //有条件，按条件搜索
    NSDictionary *appInfo =[[PEMobile sharedManager]getAppInfo];
    
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    
    NSString *groupIDString = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_GROUP_ID];
    if([groupIDString isEqualToString:@""] || groupIDString.length ==0){
        groupIDString = @"不限";
    }
    
    NSString *groupNameString = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_GROUP_NAME];
    NSString *groupTypeString = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_KIND];
    NSString *groupSubTypeString = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_SORT];
    NSString *groupLocationString = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DISTANCE];
    
    if([groupLocationString isEqualToString:@""] || groupLocationString.length == 0){
        groupLocationString = @"不限";
    }
    
    BOOL isDefault = [groupIDString isEqualToString:@"不限"] && [groupNameString isEqualToString:@"不限"] && [groupTypeString isEqualToString:@"全部"] &&[groupSubTypeString isEqualToString:@"全部"] && [groupLocationString isEqualToString:@"不限"];
    
    if(isDefault == NO){
        
        if([groupTypeString isEqualToString:@"全部"]){
            groupTypeString = @"不限";
        }
        
        if([groupSubTypeString isEqualToString:@"全部"]){
            groupSubTypeString = @"不限";
        }
        
     NSDictionary *searchInfo =@{@"groupId": groupIDString,
                                 @"groupName":groupNameString,
                                 @"groupType":groupTypeString,
                                 @"groupSubType":groupSubTypeString,
                                 @"groupLocation":groupLocationString};
    [request setObject:searchInfo forKey:HTTP_DISCOVER_SEARCH];
    [[PENetWorkingManager sharedClient] discoverGroupSearch:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            sortArray =[results objectForKey:DISCOVER_GROUP_DATA];
            [grouptableView reloadData];
            if(sortArray.count ==0){
                [Common showAlert:@"对不起，你搜索的群组不存在"];
            }
        } else {
            NSLog(@"%@", error);
        }
      }];
    }
}

@end
