//
//  PEMemberContentView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PEMemberContentView : UIView
@property (retain, nonatomic) UIImageView *imageV;
@property (retain, nonatomic) UIImageView *petImgContent;
@property (retain, nonatomic) UIImageView *petSortV;
@property (retain, nonatomic) UIImageView *petAgeV;


@property (retain, nonatomic) UILabel *petNameLbl;
@property (retain, nonatomic) UILabel *petSortLbl;
@property (retain, nonatomic) UILabel *petAgeLbl;
@property (retain, nonatomic) UILabel *petSignLbl;

@property (retain, nonatomic) UILabel *ownerNameLbl;
@property (retain, nonatomic) UIImageView *ownerSexV;
@property (retain, nonatomic) UILabel *ownerAgeLbl;
@property (retain, nonatomic) UIImageView *ownerAgeV;

@property (retain, nonatomic) UIImageView *detailView;
@property (retain, nonatomic) UIImageView *ownerImageContent;

@property (retain, nonatomic) NSString *petSort;
@property (retain, nonatomic) NSString *petSex;
@property (retain, nonatomic) NSString *ownerSex;
@property (retain, nonatomic) NSString *ownerBirth;

@property(retain,nonatomic)UIImageView *ownHeadIconImageView;//群主头部王冠
@property(retain,nonatomic)UIImageView *ownerImage;
@property(retain,nonatomic)UIButton *gotoDetailBtn;

//by wu
@property (nonatomic, retain) NSString *petForward;
@property (retain, nonatomic) UIImageView *petForwardImageV; //名字后面的Icon
@property (retain, nonatomic) UIView *headLineView;//头像之间的连线
@property(nonatomic,retain)NSDictionary *dic;


- (id)initWithFrame:(CGRect)frame AndData:(NSDictionary *)dataDic;

@end
