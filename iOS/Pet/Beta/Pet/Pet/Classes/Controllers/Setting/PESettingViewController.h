//
//  PESettingViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PENearViewController.h"
#import "PEXMPP.h"

@interface PESettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *headBgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondBgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdBgView;
@property (weak, nonatomic) IBOutlet UIImageView *endBgView;


@property (weak, nonatomic) IBOutlet UIImageView *headIconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headArrowView;

@property (weak, nonatomic) IBOutlet UIImageView *vipInfoIcon;
@property (weak, nonatomic) IBOutlet UILabel *vipInfoLbl;
@property (weak, nonatomic) IBOutlet UIImageView *vipInfoArrowView;
@property (weak, nonatomic) IBOutlet UIImageView *secondLineView;
@property (weak, nonatomic) IBOutlet UIImageView *bindIcon;
@property (weak, nonatomic) IBOutlet UILabel *bindLbl;
@property (weak, nonatomic) IBOutlet UIImageView *bindArrowView;

@property (weak, nonatomic) IBOutlet UIImageView *messageIcon;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UIImageView *messageArrowView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdOneLineView;
@property (weak, nonatomic) IBOutlet UIImageView *privacyIcon;
@property (weak, nonatomic) IBOutlet UILabel *privacyLbl;
@property (weak, nonatomic) IBOutlet UIImageView *privacyArrowView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdTwoLineView;
@property (weak, nonatomic) IBOutlet UIImageView *generalIcon;
@property (weak, nonatomic) IBOutlet UILabel *generalLbl;
@property (weak, nonatomic) IBOutlet UIImageView *generalArrowView;

@property (weak, nonatomic) IBOutlet UIImageView *emoIcon;
@property (weak, nonatomic) IBOutlet UILabel *emoLbl;
@property (weak, nonatomic) IBOutlet UIImageView *emoArrowView;

@property(nonatomic,retain)NSDictionary *dic;


- (IBAction)editBtnPressed:(id)sender;
- (IBAction)cellBtnPressed:(id)sender;

- (IBAction)generalBtnPressed:(id)sender;

- (IBAction)messageBtnPressed:(id)sender;
- (IBAction)privacyBtnPressed:(id)sender;
@end
