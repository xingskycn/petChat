//
//  PENearTMQuiltView.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "TMQuiltView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"

@protocol PENearWaterViewDelegate <NSObject>

- (void)didSelectWater:(NSDictionary *)dict;

@end
@interface PENearTMQuiltView : TMQuiltView <TMQuiltViewDataSource, TMQuiltViewDelegate, EGORefreshTableDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}


@property (nonatomic, assign) id <PENearWaterViewDelegate> nearWaterViewDelegate;

@property (nonatomic, retain)NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data;

- (void)setDataInTable:(NSString *)type;
@end
