//
//  PEGroupNewsTableView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupNewsTableView.h"
#import "UIHelper.h"
#import "PEGroupNewsTableCell.h"
static int pageIndex = 0;
@implementation PEGroupNewsTableView
@synthesize dataArray;
- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataArray =[NSMutableArray arrayWithArray:data];
        self.delegate =self;
        self.dataSource =self;
        
        [self createHeaderView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startNearRequest) name:NOTIFICATION_GETINFO_SUCC object:nil];
        
    }
    
    return self;
}

- (void)startNearRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    
    [[PENetWorkingManager sharedClient] nearDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************Near Request Success***************");
            //            NSLog(@"%@", results);
            dataArray =nil;
            dataArray =[[NSMutableArray alloc] init];
            NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
            
            [[PEFMDBManager sharedManager] eraseTable:DB_NEARTABLE_NAME];
            for (int i =0; i<data.count; i++) {
                
                if ([[PEFMDBManager sharedManager] addDataToNearTable:data[i]]) {
                    NSLog(@"***********DATABASE ADD SUCCESS %d*************", i);
                } else {
                    NSLog(@"***********DATABASE ADD FAILURE %d*************", i);
                }
                
                int x =arc4random() %45 +7;
                NSMutableDictionary *mData =[[NSMutableDictionary alloc] initWithDictionary:data[i]];
                [mData setObject:[NSNumber numberWithInt:x] forKey:DB_COLUMN_NEAR_HEIGHTCUT];
                
                [dataArray addObject:mData];
            }
            [self refreshView];
        }else {
            NSLog(@"%@", error);
            [self refreshView];
        }
    }];
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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_FLITERED]) {
        
        [[PENetWorkingManager sharedClient] nearDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Request Success***************");
                //                NSLog(@"%@", results);
                dataArray =nil;
                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
                    if ([[PEFMDBManager sharedManager] addDataToNearTable:data[i]]) {
                        NSLog(@"***********DATABASE ADD SUCCESS %d*************", i);
                    } else {
                        NSLog(@"***********DATABASE ADD FAILURE %d*************", i);
                    }
                    [dataArray addObject:data[i]];
                }
                [self refreshView];
            }else {
                NSLog(@"%@", error);
                [self refreshView];
            }
        }];
    } else {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERDEFAULT] isEqualToString:FLITER_MALE]) {
            
            //设置筛选信息
            NSDictionary *sex =@{FLITER_PETSEX:@"公"};
            [requestDict setObject:sex forKey:@"filtersInfo"];
            
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    //                    NSLog(@"%@", results);
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
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERDEFAULT] isEqualToString:FLITER_FEMALE]){
            //设置筛选信息
            NSDictionary *sex =@{FLITER_PETSEX:@"母"};
            [requestDict setObject:sex forKey:@"filtersInfo"];
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    //                    NSLog(@"%@", results);
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
        }else {
            //设置筛选信息
            NSDictionary *fliter =@{FLITER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_TYPE],
                                    FLITER_SUBTYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_SUBTYPE],
                                    FLITER_PETSEX:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETSEX],
                                    FLITER_PETTIME:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETTIME],
                                    FLITER_PETAGE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETAGE],
                                    FLITER_USERAGE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERAGE],
                                    FLITER_USERSEX:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERSEX],
                                    FLITER_USERSTAR:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERSTAR],
                                    FLITER_WANT_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_WANT_TYPE]
                                    };
            [requestDict setObject:fliter forKey:@"filtersInfo"];
            
            [[PENetWorkingManager sharedClient] nearDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
                    //                    NSLog(@"%@", results);
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_FLITERED]) {
        
        [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"*************Near Next Request Success***************");
                //                NSLog(@"%@", results);
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
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERDEFAULT] isEqualToString:FLITER_MALE]) {
            //设置筛选信息
            NSDictionary *sex =@{FLITER_PETSEX:@"公"};
            [requestDict setObject:sex forKey:@"filtersInfo"];
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Next Request Success***************");
                    //                    NSLog(@"%@", results);
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self getNextPageView];
                }else {
                    NSLog(@"%@", error);
                    [self getNextPageView];
                }
            }];
            
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERDEFAULT] isEqualToString:FLITER_FEMALE]){
            //设置筛选信息
            NSDictionary *sex =@{FLITER_PETSEX:@"母"};
            [requestDict setObject:sex forKey:@"filtersInfo"];
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Next Request Success***************");
                    //                    NSLog(@"%@", results);
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self getNextPageView];
                }else {
                    NSLog(@"%@", error);
                    [self getNextPageView];
                }
            }];
        }else {
            //设置筛选信息
            NSDictionary *fliter =@{FLITER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_TYPE],
                                    FLITER_SUBTYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_SUBTYPE],
                                    FLITER_PETSEX:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETSEX],
                                    FLITER_PETTIME:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETTIME],
                                    FLITER_PETAGE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_PETAGE],
                                    FLITER_USERAGE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERAGE],
                                    FLITER_USERSEX:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERSEX],
                                    FLITER_USERSTAR:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_USERSTAR],
                                    FLITER_WANT_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:FLITER_WANT_TYPE]
                                    };
            [requestDict setObject:fliter forKey:@"filtersInfo"];
            
            [[PENetWorkingManager sharedClient] nearDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Next Request Success***************");
                    //                    NSLog(@"%@", results);
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        [dataArray addObject:data[i]];
                    }
                    [self getNextPageView];
                }else {
                    NSLog(@"%@", error);
                    [self getNextPageView];
                }
            }];
        }
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
    [self setFooterView];
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
        [self refreshDataRequest];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        //        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
        [self getNextRequest];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID =@"PEGroupNewsTableCell";
    PEGroupNewsTableCell *cell =(PEGroupNewsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        NSArray *array =[[NSBundle mainBundle] loadNibNamed:@"PEGroupNewsTableCell" owner:self options:nil];
        cell =[array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    [cell setHighlighted:NO animated:NO];
    
    //    NSDictionary *dataDict =[dataArray objectAtIndex:indexPath.row];
    
    cell.petNameLbl.text = @"JoJo";
    cell.petSortLbl.text =@"苏格兰折耳";
    cell.petForward = @"公";
    cell.ownerNameLbl.text = @"小唐宁";
    cell.petImgContent.image = [UIHelper imageName:@"cacheImage"];
    cell.petSex = @"母";
    cell.petSort = @"2";
    cell.distanceLabel.text = @"14.2km";
    cell.timeLabel.text = @"10分钟前";

    
    
    
    return cell;
}




@end
