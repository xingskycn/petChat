//
//  PEClubDeatilViewController.h
//  Pet
//
//  Created by Wu Evan on 7/9/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewController.h"
#import "PEPhotoScrollView.h"
#import "PEClubDetailView.h"

@interface PEClubDeatilViewController : UIViewController
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)NSArray *memberImages;
@property(nonatomic,retain)NSArray *petImages;
@property (nonatomic, retain)NSString *clubID;
@property (nonatomic, retain)NSString *clubName;
//黑色图片区域
//中间白色区域
//
@property (nonatomic, retain) PEPhotoScrollView *photoSV;
@property(nonatomic,retain)PEClubDetailView *groupDetailView;
@property (nonatomic, retain) UIView *actionView;

//底层的scrollView
@property (nonatomic, retain) UIScrollView *sv;
//最下面的添加关注
@property (nonatomic, retain) UIView *tabV;

@property (nonatomic, retain) UIButton *typeBtn;
@property (nonatomic)BOOL isUp;

@end
