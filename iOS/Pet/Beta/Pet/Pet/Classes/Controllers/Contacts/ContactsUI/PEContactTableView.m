//
//  PENearTableView.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEContactTableView.h"
#import "PEContactViewTableCell.h"
#import "Common.h"
#import "PENearDetailViewController.h"
static int pageIndex =0;

@implementation PEContactTableView

@synthesize dataArray;
@synthesize contactTableViewDelegate;
@synthesize searchTag;
@synthesize searchPetIdDic,searchDic;
- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataArray =[NSMutableArray arrayWithArray:data];
        self.delegate =self;
        self.dataSource =self;
        searchDic = [[NSDictionary alloc]init];
        
//        [self createHeaderView]; //by wu
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];

        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTag1:) name:@"friendBtnPressed" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTag2:) name:@"foucusBtnPressed" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTag3:) name:@"fansBtnPressed" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serachUserByName:) name:@"searchByName" object:nil];
        
        bool n = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED];
        if(n ==YES){
            searchTag = 101;
        }
      NSLog(@"searchTag = %d",searchTag);
        
    }
    
    return self;
}

#pragma mark -
#pragma mark - ISPUREINT
//判断输入的是否是纯数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}




- (void)changeTag1:(NSNotification *)note{
    NSString *tagString = note.object;
    searchTag = tagString.intValue;
    bool n = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED];
    if(n ==YES){
        [self startNearRequest];
    }
    NSLog(@"searchTag = %d",searchTag);
    
}

- (void)changeTag2:(NSNotification *)note{
    NSString *tagString = note.object;
    searchTag = tagString.intValue;
    bool n = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED];
    if(n ==YES){
        [self startNearRequest];
    }
    NSLog(@"searchTag = %d",searchTag);
}

- (void)changeTag3:(NSNotification *)note{
    NSString *tagString = note.object;
    searchTag = tagString.intValue;
    bool n = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED];
    if(n ==YES){
        [self startNearRequest];
    }
    NSLog(@"searchTag = %d",searchTag);
}

/**
 *搜索：searchTag = 101,好友
       searchTag = 102 ,关注
       searchTag = 103,粉丝
 */
- (void)serachUserByName:(NSNotification *)note{
    
    NSString *infoString = note.object;
    if(infoString.length == 0){
        [self refreshDataRequest];
    }else{
    
    BOOL isPureInt = [Common regexer:infoString rx_matchesPattern:@"^[0-9]*$"];
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    //如果输入的是纯数字，宠聊号搜索
    if(isPureInt)
    {
        
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
        //用户不能查找自己
        if([infoString isEqualToString:userId])
        {
            [Common showAlert:@"你输入的是自己的宠聊号"];
            return;
        }
        NSDictionary *petInfo = @{@"petOwnerID":infoString};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:petInfo forKey:@"petInfo"];
        //=========关注，好友，粉丝搜索走三条api
        if(searchTag == 101)
        {  //好友
           [[PENetWorkingManager sharedClient]friendsSearch:request completion:^(NSDictionary *results, NSError *error)
           {
             if(results)
             {
                 NSLog(@"%@",results);
                 searchDic = results;
                 if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"])
                 {

                 
                  NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:searchDic];
                  [tempDic setObject:infoString forKey:@"userID"];
                 
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"searchByUserID" object:tempDic];
                 }else{
                     
                     [Common showAlert:@"对不起，没有找到该用户"];
                 }

                 
             }else{
                 NSLog(@"%@",error);
                 
             }

         }];
        }else if (searchTag == 102){
            //关注
            [[PENetWorkingManager sharedClient]focusSearch:request completion:^(NSDictionary *results, NSError *error)
             {
                 if(results)
                 {
                     NSLog(@"%@",results);
                     if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                         
                         searchDic = results;

                         NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:searchDic];
                         [tempDic setObject:infoString forKey:@"userID"];
                         
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"searchByUserID" object:tempDic];
                         
                         
                     }else{
                         [Common showAlert:@"对不起，没有找到该用户"];
                         
                     }
           
                     
                 }else{
                     NSLog(@"%@",error);
                     
                 }

             }];

            
        }else if (searchTag == 103){
            //粉丝
            [[PENetWorkingManager sharedClient]fansSearch:request completion:^(NSDictionary *results, NSError *error)
             {
                 if(results)
                 {
                     NSLog(@"%@",results);
                     searchDic = results;
                     NSLog(@"%@",results);
                     searchDic = results;
                     if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"])
                     {
                         NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:searchDic];
                         [tempDic setObject:infoString forKey:@"userID"];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"searchByUserID" object:tempDic];
                     }else{
                         
                         [Common showAlert:@"对不起，没有找到该用户"];
                     }


                  }else{
                     NSLog(@"%@",error);
                  
                 }

             }];

            
        }
        
    }
    //如果输入的不是纯数字，按名字搜索
    else{
            NSLog(@"按名字搜索");
            NSDictionary *petInfo = @{@"petOwnerID":infoString};
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:petInfo forKey:@"petInfo"];
           if(searchTag == 101)
           {
              [[PENetWorkingManager sharedClient]friendsSearch:request completion:^(NSDictionary *results, NSError *error) {
               if(results){
                NSLog(@"%@",results);
                dataArray =nil;
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                if(data.count == 0){
                    [Common showAlert:@"对不起,你查找的好友不存在"];
                }
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
               [self refreshView];
                
            }else{
                NSLog(@"%@",error);
                [self refreshView];
            }
          }];
        }
       else if (searchTag == 102)
       {
            
            [[PENetWorkingManager sharedClient]focusSearch:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    NSLog(@"%@",results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    if(data.count == 0){
                        [Common showAlert:@"对不起,你查找的好友不存在"];
                    }
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self refreshView];
                    
                }else{
                    NSLog(@"%@",error);
                    [self refreshView];
                }
            }];
            
        }
      else if (searchTag == 103)
      {
            [[PENetWorkingManager sharedClient]fansSearch:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    NSLog(@"%@",results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    if(data.count == 0){
                        [Common showAlert:@"对不起,你查找的好友不存在"];
                    }
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self refreshView];
                    
                }else{
                    NSLog(@"%@",error);
                    [self refreshView];
                }
            }];
            
            
            
        }
        
        
    }
    
   }
    
}

//按type值走不同的api
//默认好友列表
//好友列表  type

//关注列表  type = 102
//粉丝列表  type = 103
- (void)startNearRequest {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED]) {
        pageIndex =0;
        
        //设置page
        NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
        //获取app info
        NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
        
        //设置上传参数
        NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
        [requestDict setObject:page forKey:@"pageInfo"];
        
        //好友列表
        if (searchTag == 101){
            
            NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [[PENetWorkingManager sharedClient] contactList:request completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    NSLog(@"%@", results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self refreshView];
                }else {
                    NSLog(@"%@", error);
                    [self refreshView];
                }
            }];
            
        }else if (searchTag == 102){
            
            
            NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [[PENetWorkingManager sharedClient] contactFoucusList:request completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    NSLog(@"%@", results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self refreshView];
                }else {
                    NSLog(@"%@", error);
                    [self refreshView];
                }
            }];
            
        }else if (searchTag == 103){
            NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [[PENetWorkingManager sharedClient] contactFansFoucusList:request completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    NSLog(@"%@", results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self refreshView];
                }else {
                    NSLog(@"%@", error);
                    [self refreshView];
                }
            }];
            
        }
    } else {
        dataArray =nil;
        dataArray =[[NSMutableArray alloc] init];
        
        [self refreshView];
    }
}

- (void)refreshDataRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    
    //好友列表
    if (searchTag == 101){
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                dataArray =nil;
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }else if (searchTag == 102){
        
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactFoucusList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                dataArray =nil;
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }else if (searchTag == 103){
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactFansFoucusList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                dataArray =nil;
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }
    
    
    
}


- (void)getNextRequest {
    pageIndex++;
  //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    //好友列表
    if (searchTag == 101){
        //需要先登录
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }else if (searchTag == 102){
        
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactFoucusList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }else if (searchTag == 103){
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient] contactFansFoucusList:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                NSLog(@"%@", results);
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
        
    }
    
}

- (void)refreshFliterDataRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    
    
}

#pragma mark -
#pragma mark methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - super.bounds.size.height,
                                     super.frame.size.width, super.bounds.size.height)];
    _refreshHeaderView.delegate = self;

	[self addSubview:_refreshHeaderView];

    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{

    [self finishReloadingData];
//    [self setFooterView]; //by wu
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{

	//  model should call this when its done loading
	_reloading = NO;

	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }

    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        [self setFooterView];
    }

    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.frame.size.width,
                                              super.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.frame.size.width, super.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self addSubview:_refreshFooterView];
    }

    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{

	//  should be calling your tableviews data source model to reload
	_reloading = YES;

    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
//        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
//        [self refreshDataRequest];//by wu
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
//        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
//        [self getNextRequest];//by wu
    }
    
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    [self reloadData];
    [self testFinishedLoadData];

}
//加载调用的方法
-(void)getNextPageView
{
	[self reloadData];
    [self removeFooterView];
    [self testFinishedLoadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }

	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }

	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{

	[self beginToReloadData:aRefreshPos];

}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{

	return _reloading; // should return if data source model is reloading

}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{

	return [NSDate date]; // should return date data source was last changed

}


#pragma mark - TABLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID =@"NEAR";
    PEContactViewTableCell *cell =(PEContactViewTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        NSArray *array =[[NSBundle mainBundle] loadNibNamed:@"PEContactViewTableCell" owner:self options:nil];
        cell =[array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    [cell setHighlighted:NO animated:NO];
    
    NSDictionary *dataDict =[dataArray objectAtIndex:indexPath.row];
    
    cell.petNameLbl.text =[dataDict objectForKey:DB_COLUMN_NEAR_PETNAME];
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
   
    cell.petSortLbl.text =[dataDict objectForKey:@"subName"];
    [cell.petImgContent setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIImage imageNamed:@"pet.png"]];
    
    //by wu
    cell.petForward = [dataDict objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
    NSString *distanceString = [dataDict objectForKey:DB_COLUMN_NEAR_USERLCATION];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",distanceString];//
    NSString *timeString = [dataDict objectForKey:DB_COLUMN_NEAR_USERLASTLOGIIN];
    if([timeString intValue]>1440){
        int n = [timeString intValue]/1440;
        cell.timeLabel.text = [NSString stringWithFormat:@"%d天前",n];
    }else if([timeString intValue]>60){
        int n = [timeString intValue]/60;
         cell.timeLabel.text = [NSString stringWithFormat:@"%d小时前",n];
    }else {
         cell.timeLabel.text = [NSString stringWithFormat:@"%d小时前",[timeString intValue]];
    }
   
    
    cell.petSignLbl.text =[dataDict objectForKey:DB_COLUMN_NEAR_USERSIGN];
    cell.ownerNameLbl.text =[dataDict objectForKey:DB_COLUMN_NEAR_USERNAME];
    [cell.ownerImageContent setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERIMAGEURL]] placeholderImage:[UIImage imageNamed:@"owner1.png"]];
    
    cell.petSort =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETTYPE]];
    cell.petSex =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_PETSEX]];
    cell.ownerSex =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERSEX]];
    cell.ownerBirth =[NSString stringWithString:[dataDict objectForKey:DB_COLUMN_NEAR_USERBIRTHDAY]];

   
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d",dataArray.count);
    return [dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dataDict =[dataArray objectAtIndex:indexPath.row];
    
    [contactTableViewDelegate didSelectContactTable:dataDict];
}

- (void)setDataInTable:(NSString *)type {
    if ([type isEqualToString:FLITER_ALL]) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_ALL forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FLITERED];
//        [self refreshDataRequest]; //by wu
    } else if ([type isEqualToString:FLITER_MALE]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_MALE forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FLITERED];
//        [self refreshDataRequest];
    } else if ([type isEqualToString:FLITER_FEMALE]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_FEMALE forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FLITERED];
//        [self refreshDataRequest];
    } else if ([type isEqualToString:FLITER_CUSTOM]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_CUSTOM forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FLITERED];
//        [self refreshDataRequest];
    }
}


@end
