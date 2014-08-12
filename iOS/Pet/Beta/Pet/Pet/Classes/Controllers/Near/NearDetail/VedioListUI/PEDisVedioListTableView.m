//
//  PEDisVedioListTableView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-18.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisVedioListTableView.h"
#import "PEMobile.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PEDisVedioListTableCell.h"
//页面刷新标志
static int pageIndex =0;
@implementation PEDisVedioListTableView
@synthesize dataArray, dataDict;
@synthesize newsTableViewDelegate;
@synthesize personBgImageView,personImageView,personImageShadowView;
@synthesize newsCommentHeight,newsCommentY,newsReplyCount,newsTotalHeight,newsCount;
@synthesize newsReplyArray,tempReplyCount,newsAgreeCount;
@synthesize newsImageListArray,tempUserID;
- (id)initWithFrame:(CGRect)frame //AndData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataArray =[[NSMutableArray alloc]init];
        dataDict =[[NSDictionary alloc]init];
        newsImageListArray = [[NSMutableArray alloc]init];
        
        tempUserID = [[NSString alloc]init];
        self.delegate =self;
        self.dataSource =self;
        
        [self createHeaderView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        
        
      
    }
    return self;
}




/**
 **页面一进来，就开始加载数据,现在在模拟器上crash就是因为PEMobile试图获取当前的经纬度
 */
- (void)startNearRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    

    [[PENetWorkingManager sharedClient] getVideoList:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************VideoList StartRequest Success***************");
            NSLog(@"%@", results);
            dataArray =nil;
            dataArray =[[NSMutableArray alloc] init];
            int count =[[results objectForKey:REQUEST_COUNT_DATA] intValue];
            NSArray *data =[[[results objectForKey:REQUEST_VIDEOLIST_DATA] objectAtIndex:0]objectForKey:DISCOVER_NEWS_DETAIL];
            dataDict =results;
            for (int i =0; i<count; i++) {//count
                [dataArray addObject:data[i]];
            }
            [self refreshView];
        }else {
            NSLog(@"%@", error);
            [self refreshView];
        }
    }];
}


//重新刷新
- (void)refreshDataRequest {
    pageIndex =0;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient] getVideoList:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************VideoList RefreshRequest Success***************");
            NSLog(@"%@", results);
            dataArray =nil;
            dataArray =[[NSMutableArray alloc] init];
            int count =[[results objectForKey:REQUEST_COUNT_DATA] intValue];
            NSArray *data =[[[results objectForKey:REQUEST_VIDEOLIST_DATA] objectAtIndex:0]objectForKey:DISCOVER_NEWS_DETAIL];
            dataDict =results;
            for (int i =0; i<count; i++) {//count
                [dataArray addObject:data[i]];
            }
            [self refreshView];
        }else {
            NSLog(@"%@", error);
            [self refreshView];
        }
    }];
}

//更多
- (void)getNextRequest {
    pageIndex++;
    
    //设置page
    NSDictionary *page =@{@"page":[NSString stringWithFormat:@"%d", pageIndex]};
    NSDictionary *userInfo = @{@"userID":tempUserID};
    //获取app info
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    
    //设置上传参数
    NSMutableDictionary *requestDict =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [requestDict setObject:page forKey:@"pageInfo"];
    [requestDict setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient] getVideoList:requestDict completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"*************VideoList NextRequest Success***************");
            NSLog(@"%@", results);
            int count =[[results objectForKey:REQUEST_COUNT_DATA] intValue];
            NSArray *data =[[[results objectForKey:REQUEST_VIDEOLIST_DATA] objectAtIndex:0]objectForKey:DISCOVER_NEWS_DETAIL];
            dataDict =results;
            for (int i =0; i<count; i++) {//count
                [dataArray addObject:data[i]];
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
//    [self setFooterView]; 20140809
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
//        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
//        [self setFooterView];
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
//分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //dataArray.count+1
    //暂时不能用dataArray，应为显示的数据格式完全不一样
    return dataArray.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float result = 0.0;
    if(indexPath.row == 0){
        result = 150.0;
    }
    else{
        //没有评论时的基本高度，基本高度为由签名的文本高度决定:在没有评论的情况下，高度应该为192
        //遍历数组，哪一行有评论 ，它的高度就变化41
        //没有评论时的基本高度，基本高度为由签名的文本高度以及图片的高度来决定
        newsReplyCount = 0;//关键
        NSDictionary *petData = [dataArray objectAtIndex:indexPath.row-1];
        NSString *tempSignString = [petData objectForKey:VIDEO_LIST_USERSIGN];
        CGSize sizeSN = [tempSignString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        
        NSMutableArray *imageUrlListArray = [petData objectForKey:VIDEO_LIST_VEDEOLIST_INFO];
        NSMutableArray *imageDataArray = [[NSMutableArray alloc]init];
        [imageDataArray removeAllObjects];
        for(int i=0;i<imageUrlListArray.count;i++){
            [imageDataArray addObject:[imageUrlListArray[i] objectForKey:@"url"]];
        }
        [imageDataArray addObject:[petData objectForKey:VIDEO_LIST_VIDEO_URL]];
       
        int imagRowCount = (imageDataArray.count+1)/3;
        
        float height ;
        if(imageDataArray.count == 0){
            
            height =31+sizeSN.height+9.5+20.5+7+12;
        }else if (imageDataArray.count == 1){
            height =31+sizeSN.height+9.5+78+20.5+7+12;
            
        }else{
            
            height =31+sizeSN.height+9.5+78*imagRowCount+20.5+7+12;
        }
        
        //        if([tempSignString isEqualToString:@""] || tempSignString == nil){
        //            sizeSN.height = 17;
        //        }
        //        float height = 164+sizeSN.height;
        //commenArray有几个为字典的元素
        NSMutableArray *commentArray = [[NSMutableArray alloc]init];
        commentArray = [petData objectForKey:@"comments"];
        if(commentArray.count >0){
            for (int i = 0;i<commentArray.count;i++){
                
                NSMutableArray *replyCommentArray = [[commentArray objectAtIndex:i]objectForKey:@"reList"];
                //注意：count值的叠加
                newsReplyCount +=replyCommentArray.count;
            }
        }
        
        int n = commentArray.count;
        
        height +=40*(n+newsReplyCount)+10.5;//175.5+
        
        result = height;
        
    }
//    NSLog(@"当前cell高度%f",result);
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
        //主题图片上的名字label
        UILabel *ownerNameLable = [[UILabel alloc]init];
        ownerNameLable.font = [UIFont systemFontOfSize:16];
        //给用户名label赋值：服务端
        ownerNameLable.text = [dataDict objectForKey:DISCOVER_NEWS_TEMPUSERNAME];//缺少外层的userName
        ownerNameLable.textColor = [UIHelper colorWithHexString:@"ffffff"];
        CGSize ownerLableSize = [ownerNameLable.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        ownerNameLable.frame = CGRectMake(ScreenWidth-79-7-ownerLableSize.width, 87, ownerLableSize.width, 16);
        //朋友圈主题图片
        personBgImageView = [[UIImageView alloc]init];
        UIImage *personBgImage =[UIHelper imageName:@"news_personBg"];//主题图片：猫
        personBgImageView.frame = CGRectMake(0, 0, 320, 114);
        personBgImageView.image = personBgImage;
        //用户个人图片阴影最外边的圆圈
        UIImageView* personImageViewShadowTwo = [[UIImageView alloc]init];
        UIImage *personImageBgTwo =[UIHelper imageName:@"news_personImageBgTwo"];//70*70
        personImageViewShadowTwo.frame = CGRectMake(ScreenWidth-9-70, 70, 70, 70);
        personImageViewShadowTwo.image = personImageBgTwo;
        //===================用户个人图片-----需要网络赋值的图片
        personImageView = [[UIImageView alloc]init];
        [personImageView setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:VIDEO_LIST_USER_IMAGE]] placeholderImage:[UIHelper imageName:@"news_personImage"]];
        personImageView.frame = CGRectInset(personImageViewShadowTwo.frame, 3.0f, 3.0f);
        personImageView.layer.cornerRadius =32.0f;
        personImageView.clipsToBounds =YES;
        //用户个人头像下面部分的横向阴影
        personImageShadowView = [[UIImageView alloc]init];
        UIImage *personShadowImage =[UIHelper imageName:@"news_personImageShadow"];
        personImageShadowView.frame = CGRectMake(0, 114-26, ScreenWidth, 26);
        personImageShadowView.image = personShadowImage;
        
        [cell addSubview:personBgImageView];//朋友圈主题图片
        [cell addSubview:personImageShadowView];//个人头像下面部分的横向阴影
        [cell addSubview:personImageViewShadowTwo];//用户头像的大背景圆圈 70*70
        [cell addSubview:ownerNameLable];
        [cell addSubview:personImageView];
        cell.backgroundColor =[UIColor clearColor];
        cell.highlighted = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        //========数据源
        NSDictionary *cellDataDict =[dataArray objectAtIndex:indexPath.row -1];
        //将图片数组传回去,创建相应的图片视图
        NSMutableArray *imageUrlListArray = [cellDataDict objectForKey:VIDEO_LIST_VEDEOLIST_INFO];
        [newsImageListArray removeAllObjects];
        for(int i=0;i<imageUrlListArray.count;i++){
            [newsImageListArray addObject:[imageUrlListArray[i] objectForKey:@"url"]];
        }
         [newsImageListArray addObject:[cellDataDict objectForKey:VIDEO_LIST_VIDEO_URL]];
         NSLog(@"当前行数的视频数组长度为%ld",newsImageListArray.count);
         NSString *signString =[cellDataDict objectForKey:VIDEO_LIST_USERSIGN];
        
        PEDisVedioListTableCell *cell = [[PEDisVedioListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PEDisNewsViewTableCell" AndData:newsImageListArray AndString:signString];
        
        //个性签名label赋值
        cell.signNameLabel.text = signString;
        CGSize sizeSN = [signString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        
//        int h = newsImageListArray.count;
//        //显示的图片
//        if(h >=2)
//        {
//            
//            for(int i = 0;i< h;i++)
//            {
//                int m = i/3;//行数,从1开始
//                int n = i%3;//该行有多少个
//                
//                
//                UIButton *playVedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                playVedioBtn.frame = CGRectMake(62.5+83*n, 40.5+sizeSN.height+83*m, 78, 78);
//                [playVedioBtn addTarget:self action:@selector(playVedioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//                playVedioBtn.tag = i + 1000*indexPath.row;
//                
//                UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectInset(playVedioBtn.bounds, 24.25f, 24.25f)];
//                imgV.image =[UIHelper imageName:@"vedio_play"];
//                imgV.userInteractionEnabled =YES;
//                [playVedioBtn addSubview:imgV];
//                 [cell addSubview:playVedioBtn];
//                
//            }
//
//            
//        }
//        else if (h == 1)
//        {
//            UIButton *playVedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            playVedioBtn.frame = CGRectMake(62.5, 40.5+sizeSN.height, 78, 78);
//            [playVedioBtn addTarget:self action:@selector(playVedioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            playVedioBtn.tag = 0+1000*indexPath.row;
//            UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectInset(playVedioBtn.bounds, 24.25f, 24.25f)];
//            imgV.image =[UIHelper imageName:@"vedio_play"];
//            imgV.userInteractionEnabled =YES;
//            [playVedioBtn addSubview:imgV];
//            [cell addSubview:playVedioBtn];
//            
//        }
//        else if (h == 0){
//            //没有图片的时候，所有控件的高度减小84
//            NSLog(@"当前数组长度为空");
//
//        }

        
        cell.cID =indexPath.row;
        cell.newsCellButtonClickDelegate =self;
        
        if(indexPath.row == 1){
            UIImage *image = nil;
            cell.friendLineImageViewTwo.image = image;
            cell.friendLineImageViewTwo.hidden = YES;
        }else{
            cell.friendLineImageViewTwo.hidden = NO;
            UIImage *lineImage = [UIHelper imageName:@"news_friendLine"];
            cell.friendLineImageViewTwo.image = lineImage;
        }
        
        
        [cell.friendAvatarImageView setImageWithURL:[NSURL URLWithString:[cellDataDict objectForKey:VIDEO_LIST_USER_IMAGE]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
        
        NSString *nameString = [cellDataDict objectForKey:VIDIO_LIST_USER_NAME];
        NSString *agreeString = [cellDataDict objectForKey:VIDEO_LIST_AGREESTATUS];
        
        //传好友名字和个性签名,以及是否被赞过
        [cell setNameAndAgeLocatonWith:nameString Sign:signString AndAgreeStatus:agreeString AndArray:newsImageListArray];
        //时间显示
        NSString *time = [cellDataDict objectForKey:VIDEO_LIST_VIDEO_TIME];
        if([time intValue] >1440){
            int i = [time intValue]/1440;
            cell.timeLabel.text = [NSString stringWithFormat:@"%d天前",i];
        }else if ([time intValue] >60) {
            int i = [time intValue]/60;
            cell.timeLabel.text = [NSString stringWithFormat:@"%d小时前",i];
        }else if ([time intValue] >0){
            int i = time.intValue;
            cell.timeLabel.text = [NSString stringWithFormat:@"%d分钟前",i];
        }else if([time intValue] == 0){
            cell.timeLabel.text = @"刚刚";
        }
        newsAgreeCount = [[cellDataDict objectForKey:VIDEO_LIST_AGREE_COUNT]intValue];
        cell.favCountLable.text = [NSString stringWithFormat:@"%d",newsAgreeCount];
        cell.pid =[cellDataDict objectForKey:VIDEO_LIST_VIDEO_ID];
        
        [cell.favButton addTarget:self action:@selector(newsFavButtonIsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.markButton addTarget:self action:@selector(newsMarkButtonIsPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //便于点赞和评论时取出标识符
        cell.favButton .tag = indexPath.row -ButtonBaseTag;
        cell.markButton.tag = indexPath.row -ButtonBaseTag;
        
        cell.backgroundColor =[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.highlighted = NO;
        [cell setHighlighted:NO animated:NO];
        //开始设置评论和回复的view
        //基本高度为由签名的文本高度决定
        //获取到无评论回复的高度
        int imageCountRow = (newsImageListArray.count+1)/3;
        float height ;
        if(newsImageListArray.count == 0){
            height = 31+sizeSN.height+9.5+20.5+12+7;
        }else if (newsImageListArray.count == 1){
            height = 31+sizeSN.height+9.5+78+20.5+12+7;
            
        }else{
            height =31+sizeSN.height+9.5+78*imageCountRow+20.5+12+7;
            
        }

        newsCommentY = height;
        newsTotalHeight = height;
        //取出评论回复数组:回复人的名字+回复内容
        tempReplyCount = 0;
        NSMutableArray *commentArray =[cellDataDict objectForKey:@"comments"];
        if(commentArray.count >0){
            for(int i = 0;i<commentArray.count;i++)
            {
                NSMutableArray *array= [[commentArray objectAtIndex:i] objectForKey:@"reList"];
                if(array.count >0 )
                {
                    newsReplyArray =nil;
                    newsReplyArray = [[NSMutableArray alloc]init];
                    for (int j =0; j<array.count; j++){
                        [newsReplyArray addObject:[array objectAtIndex:j]];
                    }
                    tempReplyCount +=array.count;
                    
                }else{
                    
                    
                    
                }
                
            }
        }
        
        cell.markCountLabel.text = [NSString stringWithFormat:@"%ld",tempReplyCount+commentArray.count];//显示评论和回复
        newsCount = 0;
        /************************************开始显示评论和回复*********************************************/
        for (int i =0; i <commentArray.count; i++){
            //从评论数组里取出字典
            NSDictionary *commentDict =[commentArray objectAtIndex:i];
            //字典里需要设置的数据
            NSString *contentString =[commentDict objectForKey:@"content"];
            NSString *replyTimeString =[commentDict objectForKey:@"time"];
            newsReplyArray = [commentDict objectForKey:@"reList"];
            //每有一条评论或者回复，就会添加这个view:宽高给定值40
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(54, newsCommentY, 254, 40)];
            view.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
            
            //没用一条评论或者回复，就会添加这个button
            UIButton *responseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [responseBtn addTarget:self action:@selector(responseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            responseBtn.frame = CGRectMake(54, newsCommentY, 254, 40);
            responseBtn.tag = 10000*(indexPath.row +1)+100*(i+1);//可以取出第几行的第几条评论
            
             //头像
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 30, 30)];
            [headImageView setImageWithURL:[NSURL URLWithString:[commentDict objectForKey:VIDEO_LIST_COMMENTS]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
            //名字
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 100, 13)];
            nameLabel.textColor =[UIColor colorWithRed:157./255. green:199./255. blue:206./255. alpha:1.0];
            nameLabel.font =[UIFont systemFontOfSize:12];
            nameLabel.textColor = [UIHelper colorWithHexString:@"#36828b"];
            nameLabel.textAlignment =NSTextAlignmentLeft;
            nameLabel.text = @"小唐宁";
            //内容
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 23, 150, 12)];
            contentLabel.textColor =[UIHelper colorWithHexString:@"#6f6f6f"];
            contentLabel.font =[UIFont systemFontOfSize:10];
            contentLabel.textAlignment =NSTextAlignmentLeft;
            contentLabel.text = contentString;
            //回复时间
            UILabel *replyTimeLabel = [[UILabel alloc]init];
            replyTimeLabel.frame = CGRectMake(204, 8, 38, 10);
            replyTimeLabel.textColor =[UIHelper colorWithHexString:@"#8e8e8e"];
            replyTimeLabel.font =[UIFont systemFontOfSize:10];
            replyTimeLabel.textAlignment =NSTextAlignmentRight;
            if([replyTimeString intValue] >=1440){
                int n = [replyTimeString intValue]/1440;
                replyTimeLabel.text = [NSString stringWithFormat:@"%d天前",n];
            }else if([replyTimeString intValue]>=60){
                int n = [replyTimeString intValue]/60;
                
                replyTimeLabel.text = [NSString stringWithFormat:@"%d小时前",n];
            }else if([replyTimeString intValue]>0) {
                replyTimeLabel.text = [NSString stringWithFormat:@"%@分钟前",replyTimeString];;
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
            //评论view上面的button
            [cell addSubview:responseBtn];
            newsCommentY = newsCommentY +40;
            newsTotalHeight = newsTotalHeight +40;
            [cell setBackgroundImagViewHeight:newsTotalHeight];
            
            for (int j = 0; j<newsReplyArray.count; j++){
                
                NSDictionary *replyCommentDic= [newsReplyArray objectAtIndex:j];
                //每有一条评论或者回复，就会添加这个view:宽高给定值40
                UIView *view =[[UIView alloc]initWithFrame:CGRectMake(54, newsTotalHeight, 254, 40)];
                view.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
                
                
                //没用一条评论或者回复，就会添加这个button
                UIButton *responseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [responseBtn addTarget:self action:@selector(responseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                responseBtn.frame = CGRectMake(54, newsTotalHeight, 254, 40);
                responseBtn.tag = 10000*(indexPath.row +1) +100*(i+1)+newsCount;
                
                
                //头像
                UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 5, 30, 30)];
                [headImageView setImageWithURL:[NSURL URLWithString:[commentDict objectForKey:DISCOVER_SHOUT_COMMENT]] placeholderImage:[UIHelper imageName:@"news_friendAvatar"]];
                //名字
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 100, 13)];
                nameLabel.textColor =[UIColor colorWithRed:157./255. green:199./255. blue:206./255. alpha:1.0];
                nameLabel.font =[UIFont systemFontOfSize:12];
                nameLabel.textColor = [UIHelper colorWithHexString:@"#36828b"];
                nameLabel.textAlignment =NSTextAlignmentLeft;
                nameLabel.text = [replyCommentDic objectForKey:@"userName"];
                //内容
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 23, 150, 12)];
                contentLabel.textColor =[UIHelper colorWithHexString:@"#6f6f6f"];
                contentLabel.font =[UIFont systemFontOfSize:10];
                contentLabel.textAlignment =NSTextAlignmentLeft;
                NSString *replyString = [replyCommentDic objectForKey:@"comment"];
                contentLabel.text = [NSString stringWithFormat:@"%@回复%@:%@",[replyCommentDic objectForKey:@"userName"],@"小唐宁",replyString] ;
                
                //回复时间
                UILabel *replyTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(204, 8, 38, 10)];
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
                }else if([tempreplyTime intValue]>0) {
                    replyTimeLabel.text = [NSString stringWithFormat:@"%@分钟前",tempreplyTime];;
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
                newsTotalHeight = newsTotalHeight+40;
                newsCount +=1;
                height +=40;
                //这是到达回复最后一条的高度
                //每加一次view，线条的高度
                //将cell里面的白色背景图拉长：增加一条，背景就增长
                [cell setBackgroundImagViewHeight:newsTotalHeight];
            }
            newsCommentY = newsCommentY +newsReplyArray.count *40;
        }
        return cell;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSLog(@"table:%ld", indexPath.row);
    //=======点击某一行的时候把委托交给别人
    [self.newsTableViewDelegate didSelectNewsTable:indexPath.row];
}

#pragma mark -
#pragma mark - newsCellButtonClickDelegate

//回复评论 第几行，第几条评论
- (void)responseBtnPressed:(UIButton *)button{

    NSInteger tag = button.tag;
    NSInteger indexPathRow = tag/10000-1;//取cell的索引值
    NSInteger commentIndex = (tag-10000*(indexPathRow+1))/100-1;//取cell的第几条评论
    NSInteger replayIndex = tag -10000*(indexPathRow+1)-100*(commentIndex+1);//取cell的第几条回复
    
    NSDictionary *cellData =[dataArray objectAtIndex:indexPathRow-1];//****注意
    NSMutableArray *commentArray =[cellData objectForKey:@"comments"];
    NSDictionary *commentDict =[commentArray objectAtIndex:commentIndex];
    NSString *tempComentFriendName = [commentDict objectForKey:DISCOVER_NEWS_PETNEWSCOMMENTUSERNAME];
    NSString *tempContent = [commentDict objectForKey:@"content"];
    NSString *shoutCommentID = [commentDict objectForKey:@"petNewsCommentID"];
    NSLog(@"当前我评论的是第%d行，newCommentID = %@",indexPathRow,shoutCommentID);
    NSLog(@"当前是第%ld条评论的第%ld条回复",commentIndex,replayIndex);
    [newsTableViewDelegate newsResponseToComment:shoutCommentID   AndCount:commentIndex AndResponseName:tempComentFriendName AndComentContent:tempContent AndCellIndex:indexPathRow];
    
    
}


#pragma mark -
#pragma mark - NSNotification
//cell上面的图片点击事件
- (void)newsCellButtonClick:(NSInteger)index Section:(int)indexSec {
    
    
    NSDictionary *cellDataDict =[dataArray objectAtIndex:indexSec -1];
    NSArray *strArray =@[[cellDataDict objectForKey:DISCOVER_NEWS_IMAGE], [cellDataDict objectForKey:DISCOVER_NEWS_IMAGE]];
    PEScrollPhotoViewController *sCtr =[[PEScrollPhotoViewController alloc] initWithNibName:@"PEScrollPhotoViewController"
                                                                                     bundle:nil
                                                                                       data:strArray
                                                                                      index:index];
    NSLog(@"我点击的是第d张图片");
    [self.newsTableViewDelegate cellButtonClick:sCtr ];
    
}

#pragma mark - buttonPressed
//点赞button点击事件
- (void)newsFavButtonIsPressed:(UIButton *)sender
{
    NSInteger i = sender.tag + ButtonBaseTag;
    NSDictionary *petData = [dataArray objectAtIndex:i-1];
    NSString *tempPid = [petData objectForKey:VIDEO_LIST_VIDEO_ID];
    NSString *tempAgreeStatus = [petData objectForKey:DISCOVER_SHOUT_AGREESTATUS];
    if([tempAgreeStatus isEqualToString:@"0"])
    {
        return;
    }
    NSLog(@"点赞行的pid为：%@",tempPid);
    [self.newsTableViewDelegate newsFavButtonClick:tempPid AndString:tempAgreeStatus];
}

//评论button点击事件
- (void)newsMarkButtonIsPressed:(UIButton *)sender
{
    
    NSInteger i = sender.tag +ButtonBaseTag;
    NSDictionary *petData = [dataArray objectAtIndex:i-1];
    NSString *tempPid = [petData objectForKey:VIDEO_LIST_VIDEO_ID];
    [self.newsTableViewDelegate newsMarkButtonClick:tempPid];
    NSLog(@"视频列表页面，评论cell的videoID:%@",tempPid);
}


//- (void)playVedioBtnPressed:(UIButton *)sender{
//    
//    int tag = sender.tag/1000 ;
//    NSDictionary *cellDataDict =[dataArray objectAtIndex:tag -1];
//    //将图片数组传回去,创建相应的图片视图
//    NSMutableArray *imageUrlListArray = [cellDataDict objectForKey:VIDEO_LIST_VEDEOLIST_INFO];
//    NSMutableArray *videoListArray = [[NSMutableArray alloc]init];
//    [videoListArray removeAllObjects];
//    for(int i=0;i<imageUrlListArray.count;i++){
//        [videoListArray addObject:[imageUrlListArray[i] objectForKey:@"url"]];
//    }
//    [videoListArray addObject:[cellDataDict objectForKey:VIDEO_LIST_VIDEO_URL]];
//    int videoTag = sender.tag - 1000*tag;
//    
//    NSString *videoString = [videoListArray objectAtIndex:videoTag];
//    [self.newsTableViewDelegate videoPlayBtnClick:videoString];
//    NSLog(@"当前点击播放的视频URL：%@",videoString);
//    
//}

- (void)playVedioClick:(NSString *)videoString {
    [newsTableViewDelegate videoPlayBtnClick:videoString];
}

@end
