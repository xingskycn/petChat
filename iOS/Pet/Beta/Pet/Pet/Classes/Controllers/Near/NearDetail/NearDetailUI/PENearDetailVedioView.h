//
//  PENearDetailVedioView.h
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PENearDetailVedioView : UIView
@property (retain, nonatomic) UIImageView *bgView;

@property (retain, nonatomic) UILabel *vedioNumLbl;

@property (retain, nonatomic) UIImageView *vedioPetIconV;
@property (retain, nonatomic) UIImageView *playImageView;

@property (retain, nonatomic) UILabel *vedioTitleLbl;
@property (retain,nonatomic) UIButton *playVedioBtn;
@property (retain,nonatomic) UIButton *arrowBtn;//进入视频列表界面
@end
