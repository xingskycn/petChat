//
//  PENearDetailShoutView.h
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NearDetailShoutDelegate <NSObject>

- (void)didSelectAtShout;

@end

@interface PENearDetailShoutView : UIView

@property (retain, nonatomic) UILabel *shoutNumLbl;

@property (retain, nonatomic) UIImageView *shoutPetIconV;

@property (retain, nonatomic) UILabel *shoutTitleLbl;

@property (retain, nonatomic) UILabel *shoutDistanceLbl;
@property (retain, nonatomic) UILabel *shoutTimeLbl;
@property (retain, nonatomic)UIImageView *arrowImgV;

@property (retain, nonatomic) id<NearDetailShoutDelegate> nearDetailShoutDelegate;

@end
