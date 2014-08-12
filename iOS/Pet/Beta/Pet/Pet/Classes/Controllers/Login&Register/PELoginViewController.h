//
//  PELoginViewController.h
//  Pet
//
//  Created by Wu Evan on 6/17/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PENearViewController.h"

@interface PELoginViewController :UIViewController <UITextFieldDelegate>

@property int type;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *accountBgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBgView;

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


- (IBAction)LoginBtnPressed:(id)sender;
-(IBAction)registerBtnPressed:(id)sender;
@end
