//
//  PEShakeNewView.h
//  Pet
//
//  Created by Wu Evan on 7/23/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEShakeNewView : UIView

@property (nonatomic, retain) NSDictionary *dataDic;

@property (nonatomic, retain) UIImageView *ownerIcon;
@property (nonatomic, retain) UIImageView *petSex;
@property (nonatomic, retain) UIImageView *ownerSex;
@property (nonatomic, retain) UILabel *nameLbl;
@property (nonatomic, retain) UILabel *distanceLbl;

- (id)initWithFrame:(CGRect)frame AndData:(NSDictionary *)friendData;

//设置数据
- (void)setUIWithData:(NSDictionary *)data;
@end
