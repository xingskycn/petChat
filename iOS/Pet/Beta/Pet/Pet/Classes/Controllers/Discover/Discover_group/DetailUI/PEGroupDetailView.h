//
//  PEGroupDetailView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEGroupDetailView : UIView

@property(nonatomic,retain)UILabel *groupIdNameLabel;
@property(nonatomic,retain)UILabel *groupIDLabel;//显示ID
@property(nonatomic,retain)UIImageView *gapLineView1;

@property(nonatomic,retain)UILabel *siteNameLabel;
@property(nonatomic,retain)UILabel *siteLabel;//显示地点
@property(nonatomic,retain)UIImageView *gapLineView2;
@property(nonatomic,retain)UIImageView *arrowImageView2;

@property(nonatomic,retain)UILabel *distanceNameLabel;
@property(nonatomic,retain)UILabel *distanceLabel;//显示距离
@property(nonatomic,retain)UIImageView *gapLineView3;

@property(nonatomic,retain)UILabel *groupSpaceLabel;
@property(nonatomic,retain)UILabel *groupNewsCountLabel;//消息数量 125
@property(nonatomic,retain)UIImageView *newsOwnerImageView;//显示发消息者头像
@property(nonatomic,retain)UILabel *newsTitleLabel;//消息标题
@property(nonatomic,retain)UILabel *newsContentLabel;//消息内容
@property(nonatomic,retain)UIImageView *gapLineView4;
@property(nonatomic,retain)UIImageView *arrowImageView4;

@property(nonatomic,retain)NSArray *members;
@property(nonatomic,retain)UILabel *groupMemberlabel;
@property(nonatomic,retain)UILabel *groupMemberCountLabel;//群成员人数 26
@property(nonatomic,retain)UIImageView *memberImageView1;//群主头像
@property(nonatomic,retain)UIImageView *ownerTopBgImageView;//王冠
@property(nonatomic,retain)UIImageView *memberImageView2;//群成员头像
@property(nonatomic,retain)UIImageView *memberImageView3;
@property(nonatomic,retain)UIImageView *memberImageView4;
@property(nonatomic,retain)UILabel *memberNameLabel1;//成员名字
@property(nonatomic,retain)UILabel *memberNameLabel2;
@property(nonatomic,retain)UILabel *memberNameLabel3;
@property(nonatomic,retain)UILabel *memberNameLabel4;
@property(nonatomic,retain)UIImageView *gapLineView5;
@property(nonatomic,retain)UIImageView *arrowImageView5;

@property(nonatomic,retain)UILabel *groupIntroduceLabel;
@property(nonatomic,retain)UILabel *groupDescriptionLabel;//群介绍
@property(nonatomic,retain)UIImageView *gapLineView6;

@property(nonatomic,retain)UILabel *groupRankLabel;
@property(nonatomic,retain)UIImageView *rankImageView;//群等级图片
@property(nonatomic,retain)UILabel *groupRankCountLabel;//显示群等级
@property(nonatomic,retain)UILabel *groupRankDescriptionLabel;//普通30人群
@property(nonatomic,retain)UIImageView *gapLineView7;

@property(nonatomic,retain)UILabel *crateDateLabel;
@property(nonatomic,retain)UILabel *dateLabel;//创建日期
@property(nonatomic,retain)UIImageView *arrowImageView8;

@property(nonatomic,retain)UIButton *groupMemberButton;//群成员button

@property(nonatomic,retain)UILabel *groupNewsLabel;//群组动态
@property(nonatomic,retain)UIButton *groupNewsButton;
@property(nonatomic,retain)UIImageView *gapLineView8;

//需要重写初始化方法来传值：

@end
