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

@protocol ContactTableViewDelegate <NSObject>

- (void)didSelectContactTable:(NSDictionary *)data;

@end


@interface PEContactTableView : UITableView <EGORefreshTableDelegate, UITableViewDataSource, UITableViewDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property(nonatomic,assign)int searchTag;

@property (nonatomic, assign) id <ContactTableViewDelegate> contactTableViewDelegate;

@property (nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic,retain)NSDictionary *searchPetIdDic;
@property(nonatomic,retain)NSDictionary *searchDic;

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)data;

- (void)setDataInTable:(NSString *)type;
- (void)startNearRequest;
- (void)refreshDataRequest;
@end
