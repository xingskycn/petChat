//
//  PEDisVedioListTableCell.h
//  Pet
//
//  Created by WuJunqiu on 14-7-18.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "img.h"
//定义委托
//1.cell上的图片点击 2.评论按钮点击事件
@protocol VideoCellButtonClickDelegate <NSObject>

@optional
- (void)newsCellButtonClick:(NSInteger)index Section:(int)indexSec;
- (void)markButtonClick;
- (void)playVedioClick:(NSString *)videoString;

@end

@interface PEDisVedioListTableCell : UITableViewCell<PEImageDelegate>

@property int cID;
@property (nonatomic, retain)NSString *pid;
@property (nonatomic, retain)UIImageView *friendAvatarImageView;//好友头像
@property (nonatomic, retain)UIButton *passPhotoImageView;//上传的照片1
@property (nonatomic, retain)UIButton *passPhotoImageViewTwo;//上传的照片2
@property (nonatomic, retain)UIImageView *bgImageViewUp;//白色背景气泡向上
@property (nonatomic, retain)UIImageView *bgImageViewCenter;//白色背景气泡中
@property (nonatomic, retain)UIImageView *bgImageViewDown;//白色背景气泡下
@property (nonatomic, retain)UIImageView *friendLineImageViewOne;//好友头像之间的连线1
@property (nonatomic, retain)UIImageView *friendLineImageViewTwo;//好友头像之间的连线2
@property (nonatomic, retain)UIImageView *friendSexImageView;//好友的性别

@property (nonatomic,retain)UIView *rightView;//右边封装的界面视图（高度是可变的）

@property(nonatomic,retain)UILabel *friendNameLabel;//好友名字
@property(nonatomic,retain)UILabel *friendAgeLabel;//好友年龄
@property(nonatomic,retain)UILabel *signNameLabel;//个性签名
@property(nonatomic,retain)UILabel *distanceLabel;//距离label
@property(nonatomic,retain)UILabel *datalabel;//距离label
@property(nonatomic,retain)UILabel *timeLabel;//时间
@property(nonatomic,retain)UILabel *favCountLable;//点赞数
@property(nonatomic,retain)UILabel *markCountLabel;//评论数
@property(nonatomic,retain)UIButton *favButton;//点赞
@property(nonatomic,retain)UIImageView *favImageView;
@property(nonatomic,retain)UIButton *markButton;//评论
@property(nonatomic,retain)UIImageView *markImageView;

@property(nonatomic,retain)UIButton *shareBtn;//分享
@property(nonatomic,retain)UILabel *shareCountLabel;//分享数
@property(nonatomic,retain)UIImageView *shareIamgeView;//分享视图
@property(nonatomic,retain)UIImageView *playImageView;//播放按钮视图
@property(nonatomic,retain)UIButton *playBtn;//播放按钮

@property(nonatomic,retain)img *photosImageView;//显示的图片
@property(nonatomic,retain)NSMutableArray *photosArray;

@property(nonatomic,retain)UIImageView *personBgImageView;//背景主题
@property(nonatomic,retain)UIImageView *personImageView;//个人头像
@property(nonatomic,retain)UIImageView *personImageShadowView;//个人头像阴影

@property(nonatomic,retain)UIView *one;//距离和日期之间的间隔条

//by wu
@property(nonatomic,retain)NSString *friendNameString;
@property(nonatomic,retain)NSString *friendSignString;


//创建委托对象
@property (nonatomic, weak) id <VideoCellButtonClickDelegate> newsCellButtonClickDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndData:(NSMutableArray *)dataArray AndString:(NSString *)signString;

-(void)setSexImageViewForString:(NSString *)string;
-(void)setBackgroundImagViewHeight:(float)height;
- (void)setNameAndAgeLocatonWith:(NSString *)nameString Sign:(NSString *)signString AndAgreeStatus:(NSString *)agreeStatus AndArray:(NSMutableArray *)imageListArray;


@end
