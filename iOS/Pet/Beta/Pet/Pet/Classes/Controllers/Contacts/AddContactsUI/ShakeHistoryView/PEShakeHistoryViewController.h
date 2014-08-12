//
//  PEShakeHistoryViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-24.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PEShakeHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UIButton *backBtn;
@property(nonatomic,retain)NSMutableArray *dataArray;

@end
