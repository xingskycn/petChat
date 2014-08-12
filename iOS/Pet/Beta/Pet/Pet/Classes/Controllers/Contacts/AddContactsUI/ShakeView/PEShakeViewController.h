//
//  PEShakeViewController.h
//  Pet
//
//  Created by Wu Evan on 7/23/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEShakeNewView.h"

@interface PEShakeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic)UIImageView *dogBody;
@property (retain, nonatomic)UIImageView *dogTail;
@property (retain, nonatomic)UIImageView *shakeImageV;
@property (retain, nonatomic)UIImageView *searchIcon;

@property (retain, nonatomic)UILabel *infoLabel;

@property BOOL isAnimating;

@property PEShakeNewView *resultView;
@property (retain, nonatomic)UIImageView *btnImgeView ;
@property (retain, nonatomic)UILabel *shakeHistoryLabel;
@property (retain, nonatomic)UIButton *shakeHistoryBtn;
@property(nonatomic,retain)UITableView *myTableView;

@property(nonatomic,retain)NSDictionary *dic;
@property(nonatomic,retain)NSMutableArray *dataArray;
@end
