//
//  PEDisNewsViewController.h
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
#import "PEDisNewsTableView.h"
@interface PEDisNewsViewController : UIViewController<PEDisNewsTableViewDelegate,PefmdbDelegate,UIScrollViewDelegate,UITextFieldDelegate>//后面是数据库的委托


@property(nonatomic,retain)UIBarButtonItem *photoBtn;
@property(nonatomic,retain)PEDisNewsTableView * myTableView;
@property(nonatomic,retain)NSMutableArray *tableDataArray;

@property(nonatomic, retain)NSString *userID;
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
@property(retain, nonatomic)UITextField*newsResponeCommenTxtField;
@property(nonatomic,retain)NSString *newsCommentsID;
//表情button
@property(nonatomic,retain)UIButton *faceButton;

//shoutId;选中行点击评论按钮获取shoutIds
@property(nonatomic,retain)NSString *tempPid;

//是否显示键盘标示 默认为NO
@property BOOL isShowKeyBord;

//是否显示表情的标示
@property BOOL isFace;


@property(nonatomic,assign)NSInteger replyCellIndex;
@property(nonatomic,assign)NSInteger replyCommentIndex;
@property(nonatomic,assign)NSInteger navTag;



@end
