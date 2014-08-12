//
//  PEDisClubViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-6-28.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisClubViewController.h"
#import "PENetWorkingManager.h"
#import "PEDisGroupCellTwo.h"
#import "PEDisGroupCellOne.h"
#import "PEClubDeatilViewController.h"
@interface PEDisClubViewController ()

@end

@implementation PEDisClubViewController
@synthesize grouptableView;
@synthesize sortArray,detailArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sortArray =[[NSMutableArray alloc]init];
        detailArray =[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(DISCOVER_CLUB, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
    grouptableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    grouptableView.backgroundColor = [UIColor clearColor];
    grouptableView.separatorColor=[UIColor clearColor];
    grouptableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    grouptableView.dataSource = self;
    grouptableView.delegate = self;
    //grouptableView.alpha = 0.6;
    grouptableView.sectionFooterHeight = 0;
    grouptableView.sectionHeaderHeight = 0;
    [self.view addSubview:grouptableView];
    
    self.isOpen = NO;

    //将状态条修改为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    
    [[PENetWorkingManager sharedClient] discoverClub:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            sortArray =[results objectForKey:DISCOVER_CLUB_DATA];
            [grouptableView reloadData];
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
            return [[[sortArray objectAtIndex:section]objectForKey:DISCOVER_CLUB_LIST]count]+1;//往里面插入数组长度
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
            // 这种方式，将会查找响应的xib文件，将不会调用initWithStyle方法
            cell = [[PEDisGroupCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        //取数组出来显示内容
        //展开列表开始赋值
        if (indexPath.row >0) {
            NSMutableArray *tempArray = [[sortArray objectAtIndex:indexPath.section]objectForKey:DISCOVER_CLUB_LIST];
            NSMutableDictionary *tempDic = [tempArray objectAtIndex:indexPath.row-1];
            
            cell.groupNameLabel.text = [tempDic objectForKey:DISCOVER_CLUB_NAME];
            cell.groupPeopleCountlabel.text = [tempDic objectForKey:DISCOVER_CLUB_SIZE];
            cell.groupSignLable.text = [tempDic objectForKey:DISCOVER_CLUB_DES];
            NSString *groupRank = [tempDic objectForKey:DISCOVER_CLUB_RANK];
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
        cell.groupNameLabel.text = [dic objectForKey:DISCOVER_CLUB_TYPENAME];//群类型
        cell.distanceLable.text = [NSString stringWithFormat:@"%@m", [dic objectForKey:DISCOVER_CLUB_LOCATION]];//距离
        
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
        
        //取二级cell里面的内容：1 2 3 4 5
//        NSDictionary *dic = [sortArray objectAtIndex:indexPath.section];
//        NSArray *list = [dic objectForKey:@"list"];
//        NSString *item = [list objectAtIndex:indexPath.row-1];
        
        NSMutableArray *tempArray = [[sortArray objectAtIndex:indexPath.section]objectForKey:DISCOVER_CLUB_LIST];
        NSMutableDictionary *tempDic = [tempArray objectAtIndex:indexPath.row-1];
        NSLog(@"%@", tempDic);
        //进入群组详情页面
        PEClubDeatilViewController *cDetailView = [[PEClubDeatilViewController alloc]init];
        cDetailView.clubID =[tempDic objectForKey:DISCOVER_CLUBDETAIL_ID];
        cDetailView.clubName =[tempDic objectForKey:DISCOVER_CLUB_NAME];
        [self.navigationController pushViewController:cDetailView animated:YES];
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
    int contentCount = [[[sortArray objectAtIndex:section] objectForKey:DISCOVER_CLUB_LIST] count];
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
@end
