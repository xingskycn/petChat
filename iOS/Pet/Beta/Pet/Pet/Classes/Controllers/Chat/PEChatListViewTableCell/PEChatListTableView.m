//
//  PEChatListTableView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-14.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEChatListTableView.h"
#import "PEChatListViewTableCell.h"
#import "UIHelper.h"
//页面刷新标志
static int pageIndex =0;

@implementation PEChatListTableView
@synthesize dataArray;
@synthesize chatTableListDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRosterSucc:) name:CHAT_ROSTER_RECEIVE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDatafromDB) name:@"newMessage" object:nil];
        
        dataArray = [[NSArray alloc] init]; // Initialization code
        
        self.delegate = self;
        self.dataSource = self;
        
        //创建刷新时的表头
        [self createHeaderView];
        
        //刷新完成
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        //开始网络请求
//        [self startNearRequest];
        
        [self loadDatafromDB];
    }
    return self;
}

/**
 **页面一进来，就开始加载数据 pageIndex给后台用的参数 （从数据库加载）
 */

- (void)loadDatafromDB {
    NSString *tableName =[NSString stringWithFormat:@"%@%@", DB_MSG_NEW, [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]];
    
    PEFMDBManager *dbManager =[PEFMDBManager sharedManager];
    dbManager.peFMDBDelegate = self;
    [dbManager check];
    if (![dbManager isTableExisted:tableName]) {
        //创建表
        NSArray *cArray =@[DB_COLUMN_MSG_DATE,
                           DB_COLUMN_MSG_FROM,
                           DB_COLUMN_MSG_TYPE,
                           DB_COLUMN_MSG_NICKNAME
                           ];
        [dbManager creatNewTableWithTableName:tableName AndColumns:cArray];
    }
    
    [dbManager selectNewMessageListFromTable:tableName];
}

- (void)refreshDataRequest {
    [self loadDatafromDB];
}

#pragma mark -
#pragma mark methods for creating and removing the header view
//创建刷新时的表头
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
//    [self setFooterView];
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
        [self refreshDataRequest];//如果是下拉刷新，调用刷新方法
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        //        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
//        [self getNextRequest];//如果是下拉刷新，调用加载更多方法
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDict =dataArray[indexPath.row];
    static NSString *cellID = @"chatList";
    PEChatListViewTableCell *cell = (PEChatListViewTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil){
        cell = [[PEChatListViewTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userHeadImageView.image = [UIHelper imageName:@"chatList_userHeadImg2"];
//    cell.userNameLabel.text = @"上海宠物交流群";
    
    //设置时间
    NSString *timeStr =[dataDict objectForKey:DB_COLUMN_MSG_DATE];
    NSDateFormatter *formatTime =[[NSDateFormatter alloc] init];
    [formatTime setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *dataDate= [formatTime dateFromString:timeStr];
    
    [formatTime setDateFormat:@"MM-dd HH:mm"];
    
    cell.userTimeLabel.text = [formatTime stringFromDate:dataDate];
    cell.userSignLabel.text = @"";
    if (![[dataDict objectForKey:DB_COLUMN_MSG_TYPE] intValue]) {
        cell.userNameLabel.text = [dataDict objectForKey:DB_COLUMN_MSG_NICKNAME];
    } else {
        cell.userNameLabel.text =@"上海仲昕信息科技有限公司";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [chatTableListDelegate didSelectAtChatListTable:dataArray[indexPath.row]];
}

#pragma mark - Roster Delegate
- (void)getRosterSucc:(NSNotification*) notification {
    NSArray * rosterArray = [notification object];
    dataArray =rosterArray;
    [self refreshView];
}


#pragma mark - fmdb Delegate
- (void)selectMessageListSucc:(NSArray *)data {
    dataArray =data;
    [self performSelector:@selector(refreshView) withObject:self afterDelay:2.0f];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
