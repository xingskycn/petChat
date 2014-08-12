//
//  PENearDetailNewsView.h
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol NearDetailNewsDelegate <NSObject>

- (void)didSelectAtNews;

@end


@interface PENearDetailNewsView : UIView

@property (retain, nonatomic) UILabel *newsNumLbl;

@property (retain, nonatomic) UIImageView *newsPetIconV;

@property (retain, nonatomic) UILabel *newsTitleLbl;

@property (retain, nonatomic) UILabel *newsDistanceLbl;
@property (retain, nonatomic) UILabel *newsTimeLbl;
@property (retain, nonatomic)UIImageView *arrowImgV;

@property (retain, nonatomic) id<NearDetailNewsDelegate> nearDetailNewsDelegate;

@end
