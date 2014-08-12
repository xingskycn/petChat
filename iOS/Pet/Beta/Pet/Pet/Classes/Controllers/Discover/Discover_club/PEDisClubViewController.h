//
//  PEDisClubViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-6-28.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PENearViewController.h"

@interface PEDisClubViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *grouptableView;
@property (retain, nonatomic)NSMutableArray *sortArray;
@property (retain, nonatomic)NSMutableArray *detailArray;

@property (assign)BOOL isOpen;//控制是展开还是收起来
@property (nonatomic,retain)NSIndexPath *selectIndex;//选中的是哪行


@end
