//
//  PEDisShoutViewController.h
//  Pet
//
//  Created by Wu Evan on 6/22/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewController.h"
#import "UIHelper.h"//Image管理
#import "PENetWorkingManager.h"//网络请求管理
#import "PEMobile.h"     //设备信息管理
#import "PEFMDBManager.h"//database管理
#import "PEDisShoutTableView.h"
@interface PEDisShoutViewController : UIViewController<PENearTableViewDelegate,PefmdbDelegate,PEDisShoutViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>//后面是数据库的委托


@property(nonatomic,retain)PEDisShoutTableView * myTableView;
@property(nonatomic,retain)NSMutableArray *tableDataArray;
//toolView
@property(nonatomic,retain)UIView *toolView;
//表情
@property (nonatomic,retain)UIView* faceView;
//scroolView
@property (retain, nonatomic) UIScrollView* scrollView;
//pageControl
@property (retain, nonatomic) UIPageControl* pageControl;
//评论框
@property(retain, nonatomic)UITextField* commenTxtField;
//回复评论框
@property(retain, nonatomic)UITextField*responeCommenTxtField;
//表情button
@property(nonatomic,retain)UIButton *faceButton;
@property(nonatomic,retain)UIImageView *upImageView;
@property(nonatomic,retain)UIImageView *centerImageView;
@property(nonatomic,retain)UIImageView *downImageView;


@property(nonatomic,retain)NSString *shoutType;


@property(nonatomic,retain)NSString *tempPid;//shoutId;选中行点击评论按钮获取shoutIds
@property(nonatomic,retain)NSString *shoutCommentId;//品论的是哪一行
@property(nonatomic,retain)NSString *shoutComments;//哪条评论
@property(nonatomic,assign)NSInteger navTag;
@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *petID;

@property BOOL isShowKeyBord;//是否显示键盘标示 默认为NO
@property BOOL isFace;//是否显示表情的标示
@end
