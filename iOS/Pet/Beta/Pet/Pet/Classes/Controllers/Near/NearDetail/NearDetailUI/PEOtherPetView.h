//
//  PEOtherPetView.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEOtherPetView : UIView

@property (nonatomic, retain) UIImageView *petIconV;

@property (nonatomic, retain) UILabel *petNameLbl;
@property (nonatomic, retain) UIImageView *petSortV;
@property (nonatomic, retain) UILabel *petSortLbl;
@property (nonatomic, retain) UIImageView *petAgeV;
@property (nonatomic, retain) UILabel *petAgeLbl;

@property (nonatomic, retain) NSString *petType;
@property (nonatomic, retain) NSString *petID;

@end
