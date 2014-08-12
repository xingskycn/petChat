//
//  PECreateGroupSiteViewController.h
//  Pet
//
//  Created by Wu Evan on 7/25/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface PECreateGroupSiteViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property BOOL isSetMapSpan;
@property int page;
@property (retain, nonatomic) NSString *key;
@property CLLocationCoordinate2D curLocation;

@property (retain, nonatomic) BMKMapView *baiduMapView;
@property (retain, nonatomic) BMKLocationService *locService;
@property (retain, nonatomic) BMKPoiSearch* poisearch;

@property (retain, nonatomic) UITextField *searchText;

@property (retain, nonatomic) UITableView *placeTable;
@property (retain, nonatomic) NSMutableArray *placeArray;

@end
