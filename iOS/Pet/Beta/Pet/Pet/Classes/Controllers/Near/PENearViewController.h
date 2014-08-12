//
//  PENearViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PEMobile.h"
#import "PEFMDBManager.h"

#import "TMQuiltView.h"
#import "PENearTableView.h"
#import "PENearTMQuiltView.h"

@protocol NearViewDelegate <NSObject>

- (void)fliterBtnClick;
- (void)didTypedBtn;

@end

@interface PENearViewController : UIViewController<PENearWaterViewDelegate, PENearTableViewDelegate, PefmdbDelegate>

@property (nonatomic, retain) PENearTableView *myTable;
@property (nonatomic, retain) PENearTMQuiltView *myWater;

@property (nonatomic, retain) NSMutableArray *tableData;

@property (nonatomic, retain) UIView *fliterView;

@property (nonatomic, assign) id<NearViewDelegate> nearViewDelegate;
@end
