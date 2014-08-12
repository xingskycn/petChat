//
//  PEDisRegisterForOwnerViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-11.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDisRegisterForOwnerViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,retain)UITextField *ownerNameField;
@property(nonatomic,retain)UIImageView *pointImageViewForSelected;
@property(nonatomic,retain)UIImageView *pointImageViewForSelectedTwo;
@property(nonatomic,retain)UITextField *ownerBirthdayField;
@property(nonatomic,retain)UIButton *passPhotoBtn;
@property(nonatomic,retain)UIActionSheet *sheet;
@property(nonatomic,retain)UIImageView *bgForNextBtn;
@property(nonatomic,retain)UIButton *completeBtn;

@property(weak,nonatomic)IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;


//用于最终注册的信息
@property(nonatomic,retain)NSString *phoneNumber;
@property(nonatomic,retain)NSString *emailAddress;
@property(nonatomic,retain)NSString *passWord;
@property(nonatomic,retain)UIImage *petIcon;
@property(nonatomic,retain)NSString *petSmallName;
@property(nonatomic,retain)NSString *petSort;
@property(nonatomic,retain)NSString *petVariety;
@property(nonatomic,retain)NSString *petSex;
@property(nonatomic,retain)NSString *petBirthday;
@property(nonatomic,retain)UIImage *ownerIcon;
@property(nonatomic,retain)NSString *ownerSex;
@property(nonatomic,retain)NSString *ownerBirthday;
@property(nonatomic,retain)NSString *ownerName;

- (IBAction)doneBtnPressed:(id)sender;
@end
