//
//  PEDisVedioListTableView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-18.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "PEScrollPhotoViewController.h"
#import "PEDisVedioListTableCell.h"

@protocol PEVideoTableViewDelegate <NSObject>
//选中某一行的方法
- (void)didSelectNewsTable:(NSInteger)index;
//cell上面的图片button点击
-(void)cellButtonClick:(PEScrollPhotoViewController *) pSV;
//cell上面的评论按钮
-(void)newsMarkButtonClick:(NSString *)pid;
//cell上面的点赞按钮
-(void)newsFavButtonClick:(NSString *)pid AndString:(NSString *)agreeStaus;

- (void)videoPlayBtnClick:(NSString *)videoString;
- (void)videoFriendAvaterBtnPressed:(NSDictionary *)dic;

//cell上面的回复按钮
- (void)newsResponseToComment:(NSString *)indexPathrow AndCount:(NSInteger)count AndResponseName:(NSString *)responseName AndComentContent:(NSString *)content AndCellIndex:(NSInteger)cellIndex;
@end

@interface PEDisVedioListTableView : UITableView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,VideoCellButtonClickDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot  20140809 关于foot的都不用
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}
@property(nonatomic,retain)UIImageView *personBgImageView;//背景主题
@property(nonatomic,retain)UIImageView *personImageView;//个人头像
@property(nonatomic,retain)UIImageView *personImageShadowView;//个人头像阴影


@property (nonatomic, assign) id <PEVideoTableViewDelegate> newsTableViewDelegate;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSDictionary *dataDict;


@property float newsCommentHeight;
@property float newsCommentY;
@property float newsTotalHeight;
@property int newsCount;
@property(nonatomic,assign)int newsReplyCount;
@property(nonatomic,assign)int tempReplyCount;
@property(nonatomic,assign)int  newsAgreeCount;


@property(nonatomic,retain)NSMutableArray *newsReplyArray;
@property(nonatomic,retain)NSMutableArray *newsImageListArray;
@property(nonatomic,retain)NSString *tempUserID;

//重写初始化方法
- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data;

- (void)refreshDataRequest;
- (void)startNearRequest;
@end
