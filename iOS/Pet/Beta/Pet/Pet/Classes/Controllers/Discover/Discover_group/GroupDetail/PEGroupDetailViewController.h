//
//  PEGroupDetailViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PENearViewController.h"
#import "PEPhotoScrollView.h"
#import "PEGroupDetailView.h"
@interface PEGroupDetailViewController : PENearViewController <UIAlertViewDelegate>
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)NSArray *memberImages;
@property(nonatomic,retain)NSArray *petImages;
@property (nonatomic, retain)NSString *groupID;
@property (nonatomic, retain)NSString *groupName;
//黑色图片区域
//中间白色区域
//
@property (nonatomic, retain) PEPhotoScrollView *photoSV;
@property(nonatomic,retain)PEGroupDetailView *groupDetailView;
@property (nonatomic, retain) UIView *actionView;

//底层的scrollView
@property (nonatomic, retain) UIScrollView *sv;
//最下面的添加关注
@property (nonatomic, retain) UIView *tabV;

@property (nonatomic, retain) UIButton *typeBtn;
@property (nonatomic)BOOL isUp;


@end
