//
//  PEDiscoverViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEBaseViewController.h"

@interface PEDiscoverViewController :UIViewController<UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,retain)NSString *shoutType;


@property(nonatomic, retain) UIView *fliterView;
@end
