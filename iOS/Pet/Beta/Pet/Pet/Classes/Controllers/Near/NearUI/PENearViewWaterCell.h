//
//  PENearViewWaterCell.h
//  Pet
//
//  Created by Evan Wu on 6/11/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "TMQuiltViewCell.h"

@interface PENearViewWaterCell : TMQuiltViewCell

@property (nonatomic, retain) UIImageView *petImageV;
@property (nonatomic, retain) UIImageView *petTopBg;
@property (nonatomic, retain) UIImageView *petIconBg;
@property (nonatomic, retain) UIImageView *petIconBgContent;
@property (nonatomic, retain) UIImageView *petInfoBg;
@property (nonatomic, retain) UIImageView *petSortImageV;
@property (nonatomic, retain) UIImageView *petForwardImageV;
@property (nonatomic, retain) UIImageView *petForwardImageV2;
@property (nonatomic, retain) UIImageView *petForwardImageV3;
@property (nonatomic, retain) UIImageView *petForwardImageV4;

@property (nonatomic, retain) UILabel *petAgeLbl;
@property (nonatomic, retain) UILabel *petNameLbl;
@property (nonatomic, retain) UILabel *petSortLbl;

@property (nonatomic, retain) UIImageView *ownerImageBg;
@property (nonatomic, retain) UIImageView *ownerIconBg;
@property (nonatomic, retain) UIImageView *ownerIconBgContent;
@property (nonatomic, retain) UIImageView *ownerAgeBg;

@property (nonatomic, retain) UILabel *ownerNameLbl;
@property (nonatomic, retain) UILabel *ownerAgeLbl;
@property (nonatomic, retain) UILabel *ownerSignLbl;

@property (nonatomic, retain) NSString *petSex;
@property (nonatomic, retain) NSString *ownerSex;
@property (nonatomic, retain) NSString *ownerBirth;
@property (nonatomic, retain) NSString *petSort;
@property (nonatomic, retain) NSString *petForward;
@property (nonatomic, retain) NSString *petForward2;
@property (nonatomic, retain) NSString *petForward3;
@property (nonatomic, retain) NSString *petForward4;
//by wu
@property (nonatomic, retain) NSString *petName;
@property (nonatomic, retain) NSString *ownerDistance;
@property (nonatomic, retain) NSString *ownerStaus;
@property (nonatomic, retain) NSString *ownerName;
//by wu
@property(nonatomic,retain) UILabel *distanceLabel; //距离label
@property(nonatomic,retain) UILabel *timeLabel;    //时间label
@property(nonatomic,retain) UIView *view;

@property int heightCut;
@end
