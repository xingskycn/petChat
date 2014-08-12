//
//  PESearchViewController.h
//  Pet
//
//  Created by Wu Evan on 7/14/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTagCloudView.h>
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PeModel.h"
#import "Common.h"

@interface PESearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, RTagCloudViewDelegate, RTagCloudViewDatasource>

@property (retain, nonatomic) NSArray *pickerArray;
@property (retain, nonatomic) NSArray *midArray;
@property (retain, nonatomic) NSArray *subArray;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSArray *subData;
@property BOOL isMiddle;
@property int type;
@property (retain, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *subPicker;
@property (retain, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (retain, nonatomic) UITextField *searchText;
@property (retain, nonatomic) UITextField *kindText;
@property (retain, nonatomic) UITextField *sortText;
@property (retain, nonatomic) UITextField *distanceText;

//标签云
@property (retain, nonatomic) NSArray *hotData;
@property (retain, nonatomic) RTagCloudView *cloudView;

- (IBAction)doneBtnPressed:(id)sender;

@end
