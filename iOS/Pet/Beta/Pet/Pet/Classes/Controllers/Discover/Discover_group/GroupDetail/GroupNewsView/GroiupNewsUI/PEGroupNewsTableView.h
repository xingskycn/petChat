//
//  PEGroupNewsTableView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEFMDBManager.h"
@interface PEGroupNewsTableView : UITableView<EGORefreshTableDelegate, UITableViewDataSource, UITableViewDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property (nonatomic, retain) NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data;
@end
