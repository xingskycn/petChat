//
//  PENearTMQuiltView.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearTMQuiltView.h"
#import "PENearViewWaterCell.h"
#import "PEFMDBManager.h"
#import "UIHelper.h"

static int pageIndex =0;

@implementation PENearTMQuiltView

@synthesize dataArray;
@synthesize nearWaterViewDelegate;

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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
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
        [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
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
                    
                    [[PEFMDBManager sharedManager] eraseTable:DB_NEARTABLE_NAME];
                    for (int i =0; i<data.count; i++) {
                        
                        int x =arc4random()%45 +7;
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
                    
                    [[PEFMDBManager sharedManager] eraseTable:DB_NEARTABLE_NAME];
                    for (int i =0; i<data.count; i++) {
                        
                        int x =arc4random()%45 +7;
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
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Request Success***************");
//                    NSLog(@"%@", results);
                    dataArray =nil;
                    dataArray =[[NSMutableArray alloc] init];
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    
                    [[PEFMDBManager sharedManager] eraseTable:DB_NEARTABLE_NAME];
                    for (int i =0; i<data.count; i++) {
                        
                        int x =arc4random()%45 +7;
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
//                dataArray =nil;
//                dataArray =[[NSMutableArray alloc] init];
                NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                for (int i =0; i<data.count; i++) {
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
                        int x =arc4random() %45 +7;
                        NSMutableDictionary *mData =[[NSMutableDictionary alloc] initWithDictionary:data[i]];
                        [mData setObject:[NSNumber numberWithInt:x] forKey:DB_COLUMN_NEAR_HEIGHTCUT];
                        
                        [dataArray addObject:mData];
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
                        int x =arc4random() %45 +7;
                        NSMutableDictionary *mData =[[NSMutableDictionary alloc] initWithDictionary:data[i]];
                        [mData setObject:[NSNumber numberWithInt:x] forKey:DB_COLUMN_NEAR_HEIGHTCUT];
                        
                        [dataArray addObject:mData];
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
            
            [[PENetWorkingManager sharedClient] nearFliterDataRequest:requestDict completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    NSLog(@"*************Near Next Request Success***************");
//                    NSLog(@"%@", results);
                    NSArray *data =[results objectForKey:REQUEST_NEAR_DATA];
                    for (int i =0; i<data.count; i++) {
                        int x =arc4random() %45 +7;
                        NSMutableDictionary *mData =[[NSMutableDictionary alloc] initWithDictionary:data[i]];
                        [mData setObject:[NSNumber numberWithInt:x] forKey:DB_COLUMN_NEAR_HEIGHTCUT];
                        
                        [dataArray addObject:mData];
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


#pragma mark - WATERVIEW DELEGATE
- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
//    return [UIImage imageNamed:[self.dataArray objectAtIndex:indexPath.row]];
    return [UIImage imageNamed:@"pet2.png"];
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    PENearViewWaterCell *cell = (PENearViewWaterCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[PENearViewWaterCell alloc] initWithReuseIdentifier:@"PhotoCell"];
        
    }
//    cell.petImageV.image =[UIImage imageNamed:[dataArray objectAtIndex:indexPath.row]];
    
    
    NSDictionary *data =[dataArray objectAtIndex:indexPath.row];
    
    
    [cell.petImageV setImageWithURL:[NSURL URLWithString:[data objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    [cell.petIconBgContent setImageWithURL:[NSURL URLWithString:[data objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    cell.petForward =[data objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];

    
//    cell.distanceLabel.text = [data objectForKey:DB_COLUMN_NEAR_USERLASTLOGIIN];
    //宠物年龄显示进行处理
    //宠物年龄显示进行处理
    NSString *ageString = [data objectForKey:DB_COLUMN_NEAR_PETBIRTHDAY];
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

    cell.petNameLbl.text =[data objectForKey:DB_COLUMN_NEAR_PETNAME];
    cell.petSortLbl.text =[data objectForKey:DB_COLUMN_NEAR_PETSUBNAME];//7-28
    
    NSString *distanceString = [data objectForKey:DB_COLUMN_NEAR_USERLCATION];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",distanceString];
    NSString *timeString = [data objectForKey:DB_COLUMN_NEAR_USERLASTLOGIIN];
    if([timeString intValue]>1440){
        int n = [timeString intValue]/1440;
        cell.timeLabel.text = [NSString stringWithFormat:@"%d天前",n];
    }else if([timeString intValue]>60){
        int n = [timeString intValue]/60;
        cell.timeLabel.text = [NSString stringWithFormat:@"%d小时前",n];
    }else {
        cell.timeLabel.text = [NSString stringWithFormat:@"%d分钟前",[timeString intValue]];
    }
    
    cell.ownerNameLbl.text =[data objectForKey:DB_COLUMN_NEAR_USERNAME];
    cell.ownerSignLbl.text =[data objectForKey:DB_COLUMN_NEAR_USERSIGN];
    [cell.ownerIconBgContent setImageWithURL:[NSURL URLWithString:[data objectForKey:DB_COLUMN_NEAR_USERIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
    
    cell.petSex =[data objectForKey:DB_COLUMN_NEAR_PETSEX];
    cell.petSort =[data objectForKey:DB_COLUMN_NEAR_PETTYPE];
    cell.ownerSex =[data objectForKey:DB_COLUMN_NEAR_USERSEX];
    cell.ownerBirth =[data objectForKey:DB_COLUMN_NEAR_USERBIRTHDAY];
    
    cell.heightCut =[[data objectForKey:DB_COLUMN_NEAR_HEIGHTCUT] intValue];
    
    [cell layoutSubviews];
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    return 2;
}


//返回cell高度
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [self imageAtIndexPath:indexPath].size.height / [self quiltViewNumberOfColumns:quiltView];
    NSDictionary *data =[dataArray objectAtIndex:indexPath.row];
    return [self imageAtIndexPath:indexPath].size.height + 100.0f -[[data objectForKey:DB_COLUMN_NEAR_HEIGHTCUT] intValue];
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data =[dataArray objectAtIndex:indexPath.row];
    [nearWaterViewDelegate didSelectWater:data];
}

- (void)setDataInTable:(NSString *)type {
    if ([type isEqualToString:FLITER_ALL]) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_ALL forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FLITERED];
        
        [self refreshDataRequest];
    } else if ([type isEqualToString:FLITER_MALE]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_MALE forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FLITERED];
        [self refreshDataRequest];
    } else if ([type isEqualToString:FLITER_FEMALE]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_FEMALE forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FLITERED];
        [self refreshDataRequest];
    } else if ([type isEqualToString:FLITER_CUSTOM]){
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_CUSTOM forKey:FLITER_USERDEFAULT];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FLITERED];
        [self refreshDataRequest];
    }
}

@end
