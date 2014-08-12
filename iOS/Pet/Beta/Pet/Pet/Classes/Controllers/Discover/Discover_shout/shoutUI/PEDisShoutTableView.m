//
//  PEDisShoutTableView.m
//  Pet
//
//  Created by WuJunqiu on 14-6-28.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisShoutTableView.h"
#import "PEShoutTableViewCell.h"
#import "UIHelper.h"
//页面刷新标志
static int pageIndex =0;

@implementation PEDisShoutTableView


@synthesize shoutType;
@synthesize dataArray,replyArray,replyDataArray;
@synthesize shoutDelegte;
@synthesize alert;
@synthesize commentHeight,commentY,totalHeight;
@synthesize replyCount;
@synthesize newsImageListArray,tempReplyCount,newsCount;
@synthesize tempUserID;
- (id)initWithFrame:(CGRect)frame  Type:(NSString *)type  AndUserID:(NSString *)tempID//// AndData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        shoutType =[[NSString alloc] init];
        shoutType = type;
//        shoutType =type;
        tempUserID = [[NSString alloc]init];
        tempUserID = tempID;
        dataArray = [[NSMutableArray alloc]init];
        
        replyArray = [[NSMutableArray alloc]init];
        replyDataArray = [[NSMutableArray alloc]init];
        newsImageListArray = [[NSMutableArray alloc]init];
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate =   self;
        self.dataSource = self;
        
        //创建刷新时的表头
        [self createHeaderView];
        //刷新完成
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        //开始网络请求
        [self startNearRequest];
    }
    return self;
}


/**
 **页面一进来，就开始加载数据 pageIndex给后台用的参数
 */
- (void)startNearRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *tid =@{@"id":shoutType};//================自己要设置的参数字典  7-10
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};

    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:tid forKey:DISCOVER_SHOUT_TYPE];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    [[PENetWorkingManager sharedClient] discoverShout:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************Near Request Success***************");
            NSLog(@"%@", results);
            dataArray =nil;
            dataArray =[[NSMutableArray alloc] init];
            NSMutableArray *data =[results objectForKey:REQUEST_NEAR_DATA];//================取返回数值的key 7-10
            for (int i =0; i<data.count; i++) {
                [dataArray addObject:[data objectAtIndex:i]];
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
    NSDictionary *tid =@{@"id":shoutType};//================自己要设置的参数字典  7-10
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:tid forKey:DISCOVER_SHOUT_TYPE];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient] discoverShout:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************Near Request Success***************");
            NSLog(@"%@", results);
            dataArray =nil;
            dataArray =[[NSMutableArray alloc] init];
            NSMutableArray *data =[results objectForKey:REQUEST_NEAR_DATA];//================取返回数值的key 7-10
            for (int i =0; i<data.count; i++) {
                [dataArray addObject:[data objectAtIndex:i]];
            }
            [self refreshView];
        }else {
            NSLog(@"%@", error);
            [self refreshView];
        }
    }];
    

}


- (void)getNextRequest {
    pageIndex++;
    
    //设置page
    NSDictionary *tid =@{@"id":shoutType};
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:tid forKey:DISCOVER_SHOUT_TYPE];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    [[PENetWorkingManager sharedClient] discoverShout:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************Near Request Success***************");
            NSLog(@"%@", results);
            NSMutableArray *data =[results objectForKey:REQUEST_NEAR_DATA];
            
            for (int i =0; i<data.count; i++) {
                [dataArray addObject:[data objectAtIndex:i]];
            }
            [self getNextPageView];
        }else {
            NSLog(@"%@", error);
            [self getNextPageView];
        }
    }];
    

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
        [self getNextRequest];//如果是下拉刷新，调用加载更多方法
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
//分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//每个区域行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"================cell行数%d",dataArray.count);
    return dataArray.count;
}

//动态行高：固定部分186.0f+回复内容的高度
//每增加一条评论，行高变化40px；背景白色图片要拉伸；朋友之间的头像连线需要变长；确保两个cell之间的间隔为10.5个像素
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //遍历数组，哪一行有评论 ，它的高度就变化41
    //没有评论时的基本高度，基本高度为由签名的文本高度决定
    replyCount = 0;
    NSDictionary *petData = [dataArray objectAtIndex:indexPath.row];
   
    NSString *tempSignString = [petData objectForKey:DISCOVER_SHOUT_DETAIL];
    CGSize sizeSN = [tempSignString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    NSMutableArray *imageUrlListArray = [petData objectForKey:DISCOVER_NEWS_NEWSIMAGE_LIST];
    NSMutableArray *imageDataArray = [[NSMutableArray alloc]init];
    [imageDataArray removeAllObjects];
    for(int i=0;i<imageUrlListArray.count;i++){
        [imageDataArray addObject:[imageUrlListArray[i] objectForKey:@"url"]];
    }

    int shoutImagRowCount = (imageDataArray.count+1)/3;
    
    float height;
    
    if(imageDataArray.count == 0){
        height = 31+sizeSN.height+9.5+20.5+7+12;
    }else if (imageDataArray.count == 1){
        
        height =31+sizeSN.height+9.5+78+20.5+7+12;
    }else{
        
        height =31+sizeSN.height+9.5+78*shoutImagRowCount+20.5+7+12;
    }
    
    //commenArray有几个为字典的元素
    NSMutableArray *commentArray = [[NSMutableArray alloc]init];
    commentArray =[petData objectForKey:@"comments"];
    if(commentArray.count >0){
        for (int i = 0;i<commentArray.count;i++){
         
          NSMutableArray *replyCommentArray = [[commentArray objectAtIndex:i]objectForKey:@"reList"];

            //注意：count值的叠加
            replyCount +=replyCommentArray.count;
      }
   }
    
    NSInteger n = commentArray.count;
  
   //添加view的起始位置+添加n个view的高度+cell间隔
    height += 40*(n+replyCount)+14.5;
    
    NSLog(@"当前cell高度%f",height);
    
    return height;//确保两个cell之间的间隔为10.5
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //数据源
    NSDictionary *cellData =[dataArray objectAtIndex:indexPath.row];
    //将图片数组传回去,创建相应的图片视图
    NSMutableArray *imageUrlListArray = [cellData objectForKey:DISCOVER_NEWS_NEWSIMAGE_LIST];
    [newsImageListArray removeAllObjects];
    for(int i=0;i<imageUrlListArray.count;i++){
        [newsImageListArray addObject:[imageUrlListArray[i] objectForKey:@"url"]];
    }

    NSString *tempSignString = [cellData objectForKey:DISCOVER_SHOUT_DETAIL];
   
    PEShoutTableViewCell *cell = [[PEShoutTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PEShoutTableViewCell" AndData:newsImageListArray AndString:tempSignString];
    //将图片点击事件的委托交到当前视图对象
    cell.newsCellButtonClickDelegate = self;

    if(indexPath.row == 0){
        //没有线
        cell.friendLineImageViewTwo.hidden = YES;
    }else
    {
        cell.friendLineImageViewTwo.hidden = NO;
     
    }if(dataArray.count == 1)//如果只有一行
    {
        cell.friendLineImageViewOne.hidden = YES;
    }
    else{
        cell.friendLineImageViewOne.hidden = NO;
    }
    
    [cell.markButton addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favButton addTarget:self action:@selector(praiseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.favButton.tag = indexPath.row+ButtonBaseTag;
    cell.markButton.tag = indexPath.row+ButtonBaseTag;

    NSString *tempNameString = [cellData objectForKey:DISCOVER_SHOUT_PETNAME];
    
    
    NSString *ageString = [cellData objectForKey:DIVCOVER_SHOUT_PETBIRTHDAY];
    NSString *distanceString = [cellData objectForKey:DISCOVER_SHOUT_TIME];
    NSString *dateString = [cellData objectForKey:DISCOVER_SHOUT_DATE];
    //传值，自适应高度
    [cell setNameAndAgeLocatonWith:tempNameString Age:ageString Sign:tempSignString Distance:distanceString Date:dateString];
    

    //传性别和是否被我点赞过
    NSString *sexString = [cellData objectForKey:DISCOVER_SHOUT_PETSEX];
    NSString *agreeString = [cellData objectForKey:DISCOVER_SHOUT_AGREESTATUS];
    [cell setSexImageViewForString:sexString AndAgreeStatus:agreeString];
    
    cell.distanceLabel.text  = [NSString stringWithFormat:@"%@km",distanceString];
    //显示日期
    
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    if(dateArray.count>=3){
    NSString *monthString = [dateArray objectAtIndex:1];
    NSString *dayString =[dateArray objectAtIndex:2];
        cell.datalabel.text = [NSString stringWithFormat:@"%@-%@",monthString,dayString];
    }else{
        cell.datalabel.text = @"刚刚";
    }

    //显示点赞数
    cell.favCountLable.text =[cellData objectForKey:DISCOVER_SHOUT_AGREE];
    cell.pid =[cellData objectForKey:DISCOVER_SHOUT_ID];
   
    [cell.friendAvatarImageView setImageWithURL:[NSURL URLWithString:[cellData objectForKey:DISCOVER_SHOUT_IMAGE]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted = NO;

    CGSize sizeSN = [tempSignString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];

    
    //开始设置评论和回复的view
    //基本高度为由签名的文本高度决定
    int shoutNewsRow = (newsImageListArray.count+1)/3;
    float height = height = 31+sizeSN.height+9.5+20.5+12+7; ;
    if(newsImageListArray.count == 0){
        height = 31+sizeSN.height+9.5+20.5+12+7;
    }else if (newsImageListArray.count ==1){
        
        height = 31+sizeSN.height+9.5+78+20.5+12+7;
        
    }else{
        height =31+sizeSN.height+9.5+78*shoutNewsRow+20.5+12+7;
        
    }
    
    //取出字典
    NSDictionary *petData = [dataArray objectAtIndex:indexPath.row];
    //取出评论回复数组:回复人的名字+回复内容
    NSMutableArray *commentArray =[petData objectForKey:@"comments"];
    tempReplyCount = 0;
    if(commentArray.count >0){
      for(int i = 0;i<commentArray.count;i++)
       {
         NSMutableArray *array= [[commentArray objectAtIndex:i] objectForKey:@"reList"];
         if(array.count >0 ){
             
             replyArray =nil;
             replyArray = [[NSMutableArray alloc]init];
             for (int j =0; j<array.count; j++){
            [replyArray addObject:[array objectAtIndex:j]];
                
        }
              tempReplyCount +=array.count;
      }
        
     }
   } //显示评论数
     cell.markCountLabel.text = [NSString stringWithFormat:@"%d",tempReplyCount+commentArray.count];//显示评论和回复
     commentY = height;
     totalHeight = height;
     newsCount = 0;
    for (int i =0; i <commentArray.count; i++)//添加的view个数为 评书数+所有回复数
    {
        //从评论数组里取出字典
        NSDictionary *commentDict =[commentArray objectAtIndex:i];
        //字典里需要设置的数据
        NSString *contentString =[commentDict objectForKey:@"content"];
        NSString *replyTimeString =[commentDict objectForKey:@"time"];
        replyArray = [commentDict objectForKey:@"reList"];
        //每有一条评论或者回复，就会添加这个view:宽高给定值40
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(54, commentY, 254, 40)];
       
        view.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
        //没用一条评论或者回复，就会添加这个button
        UIButton *responseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [responseBtn addTarget:self action:@selector(responseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        responseBtn.frame = CGRectMake(54, commentY, 254, 40);
        responseBtn.tag = 10000*(indexPath.row +1)+100*(i+1);//可以取出第几行的第几条评论
        //评论人头像
        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 30, 30)];
        [headImageView setImageWithURL:[NSURL URLWithString:[commentDict objectForKey:DISCOVER_SHOUT_COMMNETUSERIMAGE]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
        NSLog(@"%@",[commentDict objectForKey:DISCOVER_SHOUT_COMMNETUSERIMAGE]);
        headImageView.layer.cornerRadius = 15;
        headImageView.clipsToBounds = YES;
        //名字
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 150, 13)];
        nameLabel.textColor =[UIColor colorWithRed:157./255. green:199./255. blue:206./255. alpha:1.0];
        nameLabel.font =[UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIHelper colorWithHexString:@"#36828b"];
        nameLabel.textAlignment =NSTextAlignmentLeft;
        NSString *commentNameString = [commentDict objectForKey:DISCOVER_SHOUT_SHOUTCOMMENTNAME];
        nameLabel.text = commentNameString;
        //内容
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 23, 205, 12)];
        contentLabel.textColor =[UIHelper colorWithHexString:@"#6f6f6f"];
        contentLabel.font =[UIFont systemFontOfSize:10];
        contentLabel.textAlignment =NSTextAlignmentLeft;
        contentLabel.text = contentString;
        //回复时间
        UILabel *replyTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(198, 8, 45, 10)];
        replyTimeLabel.textColor =[UIHelper colorWithHexString:@"#8e8e8e"];
        replyTimeLabel.font =[UIFont systemFontOfSize:10];
        replyTimeLabel.textAlignment =NSTextAlignmentRight;
        if([replyTimeString intValue] >=1440){
            int n = [replyTimeString intValue]/1440;
            replyTimeLabel.text = [NSString stringWithFormat:@"%d天前",n];
        }else if([replyTimeString intValue]>=60){
            int n = [replyTimeString intValue]/60;
            
            replyTimeLabel.text = [NSString stringWithFormat:@"%d小时前",n];
        }else if([replyTimeString intValue]>0){
            replyTimeLabel.text = [NSString stringWithFormat:@"%@分钟前",replyTimeString];;
        }else{
            
            replyTimeLabel.text =@"刚刚";
        }
      
        UIImageView *lineImgeView = [[UIImageView alloc]init];
        lineImgeView.image = [UIHelper imageName:@"shout_lineImage"];
        lineImgeView.frame = CGRectMake(14, 39.5, 232, 0.5);
        
        [view addSubview:headImageView];
        [view addSubview:nameLabel];
        [view addSubview:contentLabel];
        [view addSubview:replyTimeLabel];
        [view addSubview:lineImgeView];
        [cell addSubview:view];
        //评论view上面的button
        [cell addSubview:responseBtn];
         commentY = commentY +40;
        totalHeight = totalHeight +40;
        [cell setBackgroundImagViewHeight:totalHeight];

        for (int j = 0; j<replyArray.count; j++){
            
            
            NSDictionary *replyCommentDic= [replyArray objectAtIndex:j];
            
            //每有一条评论或者回复，就会添加这个view:宽高给定值40
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(54, totalHeight, 254, 40)];
            view.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
            //没用一条评论或者回复，就会添加这个button
            UIButton *responseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [responseBtn addTarget:self action:@selector(responseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            responseBtn.frame = CGRectMake(54, totalHeight, 254, 40);
            responseBtn.tag = 10000*(indexPath.row +1) +100*(i+1)+newsCount;
            //回复人头像
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 30, 30)];
            [headImageView setImageWithURL:[NSURL URLWithString:[replyCommentDic objectForKey:DISCOVER_SHOUT_REPLYUSERIMAGE]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
            headImageView.layer.cornerRadius = 15;
            headImageView.clipsToBounds = YES;
            
            //名字
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 150, 13)];
            nameLabel.textColor =[UIColor colorWithRed:157./255. green:199./255. blue:206./255. alpha:1.0];
            nameLabel.font =[UIFont systemFontOfSize:12];
            nameLabel.textColor = [UIHelper colorWithHexString:@"#36828b"];
            nameLabel.textAlignment =NSTextAlignmentLeft;
            nameLabel.text = [replyCommentDic objectForKey:@"userName"];
            //内容
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 23, 205, 12)];
            contentLabel.textColor =[UIHelper colorWithHexString:@"#6f6f6f"];
            contentLabel.font =[UIFont systemFontOfSize:10];
            contentLabel.textAlignment =NSTextAlignmentLeft;
            NSString *replyString = [[replyArray objectAtIndex:j] objectForKey:@"comment"];
            contentLabel.text = [NSString stringWithFormat:@"%@回复%@:%@",[replyCommentDic objectForKey:@"userName"],commentNameString,replyString] ;
          
            //回复时间
            UILabel *replyTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(198, 8, 45, 10)];
            replyTimeLabel.textColor =[UIHelper colorWithHexString:@"#8e8e8e"];
            replyTimeLabel.font =[UIFont systemFontOfSize:10];
            replyTimeLabel.textAlignment =NSTextAlignmentRight;
            NSString *tempreplyTime  = [replyCommentDic objectForKey:@"time"];
            if([tempreplyTime intValue] >=1440){
                int n = [tempreplyTime intValue]/1440;
                replyTimeLabel.text = [NSString stringWithFormat:@"%d天前",n];
            }else if([tempreplyTime intValue]>=60){
                int n = [tempreplyTime intValue]/60;
                
                replyTimeLabel.text = [NSString stringWithFormat:@"%d小时前",n];
            }else if([tempreplyTime intValue]>0){
                replyTimeLabel.text = [NSString stringWithFormat:@"%@分钟前",tempreplyTime];
            }else{
                replyTimeLabel.text = @"刚刚";
            }
            
            UIImageView *lineImgeView = [[UIImageView alloc]init];
            lineImgeView.image = [UIHelper imageName:@"shout_lineImage"];
            lineImgeView.frame = CGRectMake(14, 39.5, 232, 0.5);
            
            [view addSubview:headImageView];
            [view addSubview:nameLabel];
            [view addSubview:contentLabel];
            [view addSubview:replyTimeLabel];
            [view addSubview:lineImgeView];
            [cell addSubview:view];
            [cell addSubview:responseBtn];
            totalHeight = totalHeight+40;
            
            height +=40;
            //这是到达回复最后一条的高度
            //每加一次view，线条的高度
            //将cell里面的白色背景图拉长：增加一条，背景就增长
           [cell setBackgroundImagViewHeight:totalHeight];
        }
        commentY = commentY +replyArray.count *40;
       
        //这是到达回复最后一条的高度
        //每加一次view，线条的高度
        //将cell里面的白色背景图拉长：增加一条，背景就增长
//        [cell setBackgroundImagViewHeight:totalHeight];
        
    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"================================table: %d", indexPath.row);
    //点击cell某一行的时候把委托交给别人
    [self.shoutDelegte selectRowAtIndex:indexPath.row];
    
}

#pragma mark -回复按钮点击事件
//回复评论 第几行，第几条评论
- (void)responseBtnPressed:(UIButton *)button{
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogin == NO){
        
        [Common showAlert:@"请先登录"];
        return;
    }
    
    NSInteger tag = button.tag;
    NSInteger indexPathRow = tag/10000-1;//取cell的索引值
    NSInteger commentIndex = (tag-10000*(indexPathRow+1))/100-1;//取cell的第几条评论
    NSInteger replayIndex = tag -10000*(indexPathRow+1)-100*(commentIndex+1);
    
    NSDictionary *cellData =[dataArray objectAtIndex:indexPathRow];
    NSMutableArray *commentArray =[cellData objectForKey:@"comments"];
    
    NSDictionary *commentDict =[commentArray objectAtIndex:commentIndex];
    NSString *tempComentFriendName = [commentDict objectForKey:DISCOVER_SHOUT_SHOUTCOMMENTNAME];
    NSString *tempContent = [commentDict objectForKey:@"content"];
    NSString *shoutCommentID = [commentDict objectForKey:@"shoutCommentID"];
  
    NSLog(@"回复的是第 %d 行的第 %d 条评论",indexPathRow,commentIndex);
    [shoutDelegte responseToComment:shoutCommentID   AndCount:commentIndex AndResponseName:tempComentFriendName AndComentContent:tempContent];

    
    //将cell的shoutCommentsID传过去,该cell的第几条评论，该条评论人得名字传出去

    
    
    
}

#pragma mark -
#pragma mark - PEDisShoutDelegate (cellOne里面交出来的)
- (void)shoutPlayVideo:(NSString *)videoUrl{
    
    [shoutDelegte shoutVideoPlay:videoUrl];
}

- (void)newsCellButtonClick:(NSInteger)index
{
    //将cell上的点击事件交出去
    [self.shoutDelegte shoutCellButtonClick];
    
}

//评论按钮点击
- (void)commentBtnPressed:(UIButton *)sender
{
    BOOL  isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogin == NO){
        [Common showAlert:@"登录以后才能评论"];
        return;
     }
    
    NSInteger i = sender.tag-ButtonBaseTag;
    NSDictionary *petData = [dataArray objectAtIndex:i];
    NSString *tempPid = [petData objectForKey:DISCOVER_SHOUT_ID];
    [self.shoutDelegte commentButtonClick:tempPid];
    NSLog(@"正在评论的shoutId为%@",tempPid);
    
}

//点赞按钮触发的事件
- (void)praiseBtnPressed:(UIButton *)sender
{
    BOOL  isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogin == NO){
        [Common showAlert:@"请先登录"];
    }
//    sender.enabled = NO;//20140809
    NSInteger i = sender.tag-ButtonBaseTag;
    NSDictionary *petData = [dataArray objectAtIndex:i];
    NSString *tempPid = [petData objectForKey:DISCOVER_SHOUT_ID];
    NSString *tempAgreeStatus = [petData objectForKey:DISCOVER_SHOUT_AGREESTATUS];
    NSLog(@"当前选项点赞状态值：%@",tempAgreeStatus);
    //如果已经赞过
    if([tempAgreeStatus isEqualToString:@"0"])
    {
        return;
    }
    [self.shoutDelegte praiseButtonClick:tempPid AndAgreeStatus:tempAgreeStatus];
    NSLog(@"aaaaaaaaaaaaa%@",tempPid);
   
}



@end
