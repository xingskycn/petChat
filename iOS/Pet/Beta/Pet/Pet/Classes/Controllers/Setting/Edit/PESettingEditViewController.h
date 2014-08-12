//
//  PESettingEditViewController.h
//  Pet
//
//  Created by Wu Evan on 7/4/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewController.h"
#import "PEEditScrollView.h"
#import "PEEditPhotoScrollView.h"
#import "PEEditOwnerView.h"
#import "PEEditOtherView.h"
#import "PEPhotoScrollView.h"
#import "PESettingEditTableCellTwo.h"
@interface PESettingEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,EditDoneDelegate,PEEditScrollerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, PEOtherDelegate>

@property (nonatomic, retain) NSDictionary *editPetInfo;

@property (nonatomic, retain) UIImageView *topView;
@property (nonatomic, retain) UIImageView *petIcon;
@property (nonatomic, retain) UIImageView *ownerIcon;
@property (nonatomic, retain) UILabel *photoInfoLbl;
@property (nonatomic, retain) UIImageView *lineView;
@property (nonatomic, retain) UILabel *petNameLabel;
@property (nonatomic, retain) UILabel *ownerNameLabel;
@property (nonatomic, retain) UILabel *changeImageLabel;
@property (nonatomic, retain) UIView *actionView;

@property (nonatomic, retain) UIScrollView *sv;
@property (nonatomic, retain) PEEditPhotoScrollView *photoSV;
@property(nonatomic,retain)UIActionSheet *sheet;
@property(nonatomic,retain)NSMutableArray *arr;
@property(nonatomic,retain)NSMutableArray *passPhotoArray;
@property(nonatomic,retain)NSString *petImageIDString;
//@property(nonatomic,retain)PEEditScrollView *photoSV;
//@property (nonatomic, retain) PEPhotoScrollView *photoSV;
@property (nonatomic, retain) PEEditOwnerView *ownerV;
@property (nonatomic, retain) PEEditOtherView *otherView;

@property(nonatomic,retain)UITableView *grouptableView;
@property (retain, nonatomic)NSMutableArray *sortArray;
@property (assign)BOOL isOpen;//控制是展开还是收起来
@property (nonatomic,retain)NSIndexPath *selectIndex;//选中的是哪行

@property(nonatomic,retain)UIButton *addNewPetButton;
@property(nonatomic,retain)UILabel *addNewPetLabel;//添加新宠物
@property(nonatomic,retain)UIImageView *infoLineImageView;
@property(nonatomic,retain)UIView *spaceView;

@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)NSDictionary *dataDic;
@property(nonatomic,assign)int selectSection;//标示点击的是第几个cell
@property(nonatomic, assign)BOOL isDatePicked;

//请求保存信息部分部分
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *petSexString;
@property(nonatomic,retain)NSString *petWantedTypeString;
@property(nonatomic,retain)NSMutableArray *infomationDetailArray;
@property(nonatomic,assign)NSInteger currentTag;//标记textfield
@property(nonatomic,retain)UIButton *exitBtn;

@property (retain, nonatomic) IBOutlet UIToolbar *doneToolbar;


@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIPickerView *selctPicker;

@property (strong, nonatomic) IBOutlet UIPickerView *subPicker;
- (IBAction)doneBtnPressed:(id)sender;

@end

