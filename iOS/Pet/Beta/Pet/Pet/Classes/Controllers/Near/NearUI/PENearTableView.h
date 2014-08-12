//
//  PENearTableView.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEFMDBManager.h"

@protocol PENearTableViewDelegate <NSObject>

- (void)didSelectTable:(NSDictionary *)data;

@end

@interface PENearTableView : UITableView <EGORefreshTableDelegate, UITableViewDataSource, UITableViewDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property (nonatomic, assign) id <PENearTableViewDelegate> nearTableViewDelegate;

@property (nonatomic, retain) NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data;


- (void)setDataInTable:(NSString *)type;
@end
