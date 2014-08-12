//
//  PEEditOwnerView.h
//  Pet
//
//  Created by Wu Evan on 7/7/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PEEditOwnerView : UIView



@property (nonatomic,retain)UIImageView *petDataIcon;//我的宠物资料前面ICon
@property (nonatomic,retain)UILabel *petInfoLabel;//我的宠物资料
@property (nonatomic,retain)UIImageView *lineImageView;//连线

@property (nonatomic,retain)UILabel *nameDetail;
@property (nonatomic,retain)UILabel *ageDetail;
@property (nonatomic,retain)UILabel *starDetail;
@property (nonatomic,retain)UILabel *signDetail;
@property(nonatomic,retain)NSDictionary *dic;

//UIBUTTON
@property(nonatomic,retain)UIButton *nameBtn;
@property(nonatomic,retain)UIButton *ageBtn;
@property(nonatomic,retain)UIButton *signBtn;

@property(nonatomic,retain)UIButton *nameBtn2;
@property(nonatomic,retain)UITextField *ageTextField;
@property(nonatomic,retain)UIButton *signBtn2;


@end
