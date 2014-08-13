//
//  PENearVedioListViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-18.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PEDisVedioListTableView.h"
@interface PENearVedioListViewController : UIViewController<PEVideoTableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>

@property(nonatomic,retain)PEDisVedioListTableView *videoListTableView;
@property(nonatomic,retain)NSMutableArray *tableDataArray;

@property(nonatomic,retain)NSURL *videoURL;
@property (nonatomic) BOOL hasMp4;
@property (retain, nonatomic)NSString *mp4Path;
@property (nonatomic) BOOL hasVedio;
@property (retain, nonatomic)UIAlertView *alertView;



@property(nonatomic,retain)UIView *toolView;
@property (nonatomic,retain)UIView* faceView;
@property (retain, nonatomic) UIScrollView* scrollView;
@property (retain, nonatomic) UIPageControl* pageControl;
@property(retain, nonatomic)UITextField* commenTxtField;
@property(retain, nonatomic)UITextField*newsResponeCommenTxtField;
@property(nonatomic,retain)NSString *newsCommentsID;
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
@property(nonatomic,retain)NSString *userID;


@end
