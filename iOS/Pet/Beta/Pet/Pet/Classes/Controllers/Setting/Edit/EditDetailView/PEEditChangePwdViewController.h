//
//  PEEditChangePwdViewController.h
//  Pet
//
//  Created by Wu Evan on 8/7/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"

@interface PEEditChangePwdViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain)UITextField *myOldPasswordText;
@property (nonatomic,retain)UITextField *myNewPasswordText;
@property (nonatomic,retain)UITextField *myConfirmPasswordText;

@end
