//
//  PENearDetailListView.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEOtherPetView.h"

@interface PENearDetailListView : UIView

@property (nonatomic, retain) UIImageView *bgView;

@property (nonatomic, retain) UILabel *petNameLbl;
@property (nonatomic, retain) UIImageView *petForwardV;
@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, retain) UILabel *timeLbl;
@property (nonatomic, retain) UIImageView *petSortV;
@property (nonatomic, retain) UILabel *petSortLbl;
@property (nonatomic, retain) UIImageView *petAgeV;
@property (nonatomic, retain) UILabel *petAgeLbl;
@property (nonatomic, retain) UILabel *ownerNameLbl;
@property (nonatomic, retain) UILabel *ownerChatLabel;//by wu
@property (nonatomic, retain) UILabel *ownerAgeLbl;
@property (nonatomic, retain) UIImageView *ownerSexV;
@property (nonatomic, retain) UILabel *petNumberLbl;
@property (nonatomic, retain) UILabel *ownerSignLbl;
@property (nonatomic, retain) UILabel *petPreferLbl;
@property (nonatomic, retain) UILabel *petSiteLbl;
@property(nonatomic,retain)UILabel *relationDetailLbl;//关系

@property (nonatomic, retain) UILabel *newsNumLbl;
@property (nonatomic, retain) UILabel *newsDetailLbl;
@property (nonatomic, retain) UILabel *newsDistanceLbl;
@property (nonatomic, retain) UILabel *newsTimeLbl;

@property (nonatomic, retain) UILabel *shoutNumLbl;
@property (nonatomic, retain) UILabel *shoutDetailLbl;
@property (nonatomic, retain) UILabel *shoutDistanceLbl;
@property (nonatomic, retain) UILabel *shoutTimeLbl;

@property (nonatomic, retain) UILabel *vedioNumLbl;
@property (nonatomic, retain) UILabel *vedioDetailLbl;

@property (nonatomic, retain) UIScrollView *chatRoomSV;
@property (nonatomic, retain) UIScrollView *chatClubSV;

@property (nonatomic, retain) UILabel *moreInfoLbl;
@property (nonatomic, retain) PEOtherPetView *otherPetV;

@property (retain, nonatomic) NSString *petType;
@property (retain, nonatomic) NSString *petSex;
@property (retain, nonatomic) NSString *ownerSex;
@property (retain, nonatomic) NSString *chateNumber;//宠聊号
@property (nonatomic, retain) NSString *petForward;
@end
