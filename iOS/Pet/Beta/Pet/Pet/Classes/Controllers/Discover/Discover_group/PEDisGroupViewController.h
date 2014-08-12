//
//  PEDisGroupViewController.h
//  Pet
//
//  Created by Wu Evan on 6/22/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewController.h"
@interface PEDisGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *grouptableView;
@property (retain, nonatomic)NSMutableArray *sortArray;
@property (retain, nonatomic)NSMutableArray *detailArray;
@property (assign)BOOL isOpen;//控制是展开还是收起来
@property (nonatomic,retain)NSIndexPath *selectIndex;//选中的是哪行
@end
