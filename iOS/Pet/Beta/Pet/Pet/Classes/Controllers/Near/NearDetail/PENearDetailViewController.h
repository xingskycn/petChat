//
//  PENearDetailViewController.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PENearViewController.h"
#import "PEPhotoScrollView.h"
#import "PENearDetailListView.h"
#import "PENearDetailNewsView.h"
#import "PENearDetailShoutView.h"
#import "PENearDetailVedioView.h"
#import "PENearDetailGroupView.h"
#import "PEMoreInfoView.h"
#import "PEOtherPetView.h"


@interface PENearDetailViewController : UIViewController <NearDetailNewsDelegate, NearDetailShoutDelegate, NearDetailGroupDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextViewDelegate>

@property (nonatomic, retain) NSString *petID;
@property (nonatomic, retain) NSString *ownerID;
@property (nonatomic, retain) NSDictionary *data;


@property (nonatomic, retain) UIScrollView *sv;
@property (nonatomic, retain) UIView *tabV;


@property (nonatomic, retain) UIImageView *topImageBgV;
@property (nonatomic, retain) UIImageView *petIconV;
@property (nonatomic, retain) UIImageView *ownerIconV;
@property (nonatomic, retain) UIImageView *lineView;

@property (nonatomic, retain) UIButton *typeBtn;
@property (nonatomic) BOOL isUp;

@property (nonatomic, retain) UIView *actionView;
//添加关注 发送消息 拉黑
@property (nonatomic, retain)UIButton *sendBtn;
@property (nonatomic, retain)UIButton *loveBtn;
@property (nonatomic, retain)UIButton *hateBtn;
@property (nonatomic, retain)UIImageView *imageView1;
@property (nonatomic, retain)UIImageView *imageView2;
@property (nonatomic, retain)UIImageView *tabVV;
@property (nonatomic,retain)UIActionSheet *sheet;
@property (nonatomic,assign)BOOL isLogin;


@property(nonatomic,retain)NSString *isHaveBlock;//是否已经拉黑
@property (nonatomic,retain)NSString *isHaveFocus;//是否已经关注
@property(nonatomic,retain)NSString *isHaveFriend;//是否是好友
@property(nonatomic,retain)NSString *isHaveFocused;//是否被关注

@property(nonatomic,retain)UIAlertView *reportAlter;
@property (nonatomic, retain) UIView *fliterView;
@property (nonatomic, retain) UIView *fliterViewTwo;
@property (nonatomic, retain)UITextView *reportField;
@property (nonatomic, retain)UILabel *reportFieldLabel;

@property(nonatomic,retain)NSDictionary *vedioDic;
@property(nonatomic,retain)NSDictionary *shoutDic;
@property(nonatomic,retain)NSDictionary *newsDic;
@property(nonatomic,retain)NSDictionary *resultDic;

@property (nonatomic, retain) PEPhotoScrollView *photoSV;
@property (nonatomic, retain) PENearDetailListView *listView;
@property (nonatomic, retain) PENearDetailNewsView *newsView;
@property (nonatomic, retain) PENearDetailShoutView *shoutView;
@property (nonatomic, retain) PENearDetailVedioView *vedioView;
@property (nonatomic, retain) PENearDetailGroupView *roomView;
@property (nonatomic, retain) PENearDetailGroupView *clubView;
@property (nonatomic, retain) PEMoreInfoView *moreView;
@property (nonatomic, retain) PEOtherPetView *otherView;
@end
