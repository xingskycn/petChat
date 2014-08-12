//
//  PERegisterViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-10.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEDisRegisterView.h"
@interface PERegisterViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,retain)PEDisRegisterView *registerView;
@property(nonatomic,retain)UIButton *nextStepBtn;
@property(nonatomic,retain)UIImageView *bgForNextBtn;
@end
