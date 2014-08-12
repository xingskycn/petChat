//
//  PEDisShoutTableView.h
//  Pet
//
//  Created by WuJunqiu on 14-6-28.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEShoutTableViewCell.h"

@protocol PEDisShoutViewDelegate <NSObject>
//选中cell
- (void)selectRowAtIndex:(NSInteger)cellIndex;
//cell的图片button
- (void)shoutCellButtonClick;
//cell上面的评论按钮
- (void)commentButtonClick:(NSString*)pid;
- (void)praiseButtonClick:(NSString *)pid AndAgreeStatus:(NSString *)agreeStatus;
//cell上面的回复按钮
- (void)responseToComment:(NSString *)indexPathrow AndCount:(NSInteger)count AndResponseName:(NSString *)responseName AndComentContent:(NSString *)content;
- (void)shoutVideoPlay:(NSString *)videoUrl;
- (void)shoutFriendBtnPressed:(NSDictionary *)dic;
@end


@interface PEDisShoutTableView : UITableView<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate,ShoutCellButtonClickDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property (nonatomic, retain)NSString *shoutType;

@property (nonatomic, retain)NSMutableArray *dataArray;
@property(nonatomic,assign)id<PEDisShoutViewDelegate>shoutDelegte;

@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSMutableArray *replyArray;//回复数组
@property (nonatomic, retain)NSMutableArray *replyDataArray;//返回cell的高度时用到
@property float commentHeight;
@property float commentY;
@property float totalHeight;

@property(nonatomic,assign)int replyCount;
@property(nonatomic,assign)int tempReplyCount;
@property(nonatomic,assign)int newsCount;
@property(nonatomic,retain)NSMutableArray *newsImageListArray;
@property(nonatomic,retain)NSString *tempUserID;

//重写初始化方法
- (id)initWithFrame:(CGRect)frame Type:(NSString *)type AndUserID:(NSString *)tempID;// AndData:(NSArray *)data
- (void)refreshDataRequest;
- (void)startNearRequest;
@end
