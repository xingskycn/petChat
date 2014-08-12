//
//  PECreateDetailViewController.h
//  Pet
//
//  Created by Wu Evan on 7/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEEditPhotoScrollView.h"

@interface PECreateDetailViewController : UIViewController <PEEditScrollerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) PEEditPhotoScrollView *photoSV;

@property (nonatomic, retain) NSString *groupSite;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *groupInfo;

@property (nonatomic, retain) UITextField *nameText;
@property (nonatomic, retain) UITextView *infoText;
@property (nonatomic, retain) UILabel *infoLbl;

@property (nonatomic, retain) UIButton *createBtn;
@end
