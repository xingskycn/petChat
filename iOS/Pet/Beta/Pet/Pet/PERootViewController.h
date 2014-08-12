//
//  PERootViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EAIntroView.h>
#import "UIHelper.h"

#import "PENearViewController.h"
#import "PEDiscoverViewController.h"
#import "PEChatListViewController.h"
#import "PEContactsViewController.h"
#import "PESettingViewController.h"
#import "PESettingEditViewController.h"
#import "PEMerchantsViewController.h"

#import "PENearDetailViewController.h"
#import "PEFliterViewController.h"
#import "PEContactsViewController.h"
#import "PEAddContactsViewController.h"
#import "PEGeneralViewController.h"
@interface PERootViewController : UITabBarController <EAIntroDelegate, NearViewDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) UIView *tabbarView;
@property (retain, nonatomic) UIImageView *sliderView;

@property(nonatomic,assign)BOOL isLogin;

@end
