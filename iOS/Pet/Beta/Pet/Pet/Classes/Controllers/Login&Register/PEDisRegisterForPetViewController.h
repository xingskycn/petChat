//
//  PEDisRegisterForPetViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-11.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDisRegisterForPetViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,retain)UITextField *petSmallNameField;
@property(nonatomic,retain)UITextField *petBirthdayField;
@property(nonatomic,retain)UITextField *petSortField;
@property(nonatomic,retain)UITextField *petVarietyField;
@property(nonatomic,retain)UIImageView *pointImageViewForSelected;
@property(nonatomic,retain)UIImageView *pointImageViewForSelectedTwo;
@property(nonatomic,retain)UIButton *passPhotoBtn;
@property (retain, nonatomic)UIActionSheet *sheet;
@property (retain, nonatomic)UIImageView *bgForNextBtn;
@property (retain, nonatomic)UIButton *nextStepBtn;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property(nonatomic,retain)NSMutableArray *yearArray;
@property(nonatomic,retain)NSMutableArray *monthArray;
@property(nonatomic,retain)NSMutableArray *dayArray;

//用于页面间传值
//1.电话号码或者邮箱
@property(nonatomic,retain)NSString *phoneNumberString;

//2.密码
@property(nonatomic,retain)NSString *passWordString;

//3.宠物性别
@property(nonatomic,retain)NSString *petSelectSex;

//4.宠物图片
@property(nonatomic,retain)UIImage *petImage;

//5.宠物种类id
@property(nonatomic,retain)NSString *petSortID;

//6.宠物品种ID
@property(nonatomic,retain)NSString *petVarietyID;

//7.邮箱地址
@property(nonatomic,retain)NSString *emailAdress;



@property(nonatomic,retain)NSMutableArray *pickerArray;
@property (nonatomic, retain)NSMutableArray *data;
@property(nonatomic,retain)NSMutableArray *midArray;
@property(nonatomic,retain)NSMutableArray *subData;
@property(nonatomic,retain)NSMutableArray *subArray;
@property BOOL isMiddle;
@property int type;
@property (nonatomic, retain)IBOutlet UIPickerView *selectPicker;//宠物种类
@property (nonatomic, retain)IBOutlet UIPickerView *subPicker;//宠物品种
@property (nonatomic, retain)IBOutlet UIToolbar *doneToolbar;//

- (IBAction)doneBtnPressed:(id)sender;

@end
