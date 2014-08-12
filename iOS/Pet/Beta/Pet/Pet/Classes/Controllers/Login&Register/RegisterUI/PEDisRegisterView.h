//
//  PEDisRegisterView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-10.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDisRegisterView : UIView

@property(nonatomic,retain)UILabel *loginInfoLabel;
@property(nonatomic,retain)UITextField *mobileOrMailField;
@property(nonatomic,retain)UITextField *accountOrPwdField;
@property(nonatomic,retain)UITextField *inputConfirmCodeField;
@property(nonatomic,retain)UIButton *sendConfirmCodeBtn;
@property(nonatomic,retain)UIImageView *bgForConfirmCodeBtn;
@property(nonatomic,retain)UILabel *haveSendConfirmCodeLabel;
@property(nonatomic,retain)UILabel *phoneNumberLabel;
@property(nonatomic,retain)UILabel *senConfirmCodeLabel;
@property(nonatomic,retain)UIImageView *bgForConfirmCodeField;
@property(nonatomic,retain)UIView *bgView;
@end
