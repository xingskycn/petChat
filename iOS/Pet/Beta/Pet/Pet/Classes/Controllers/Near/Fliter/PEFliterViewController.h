//
//  PEFliterViewController.h
//  Pet
//
//  Created by Wu Evan on 6/18/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FliterViewDelegate <NSObject>

- (void)didFliterView;

@end

@interface PEFliterViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) id<FliterViewDelegate> fliterViewDelegate;

@property int type;

@property (nonatomic, retain) NSArray *kindArray;
@property (nonatomic, retain) NSArray *midKindArray;
@property (nonatomic, retain) NSArray *smallKindArray;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UIImageView *firstBgView;

@property (weak, nonatomic) IBOutlet UILabel *petSortLbl;
@property (weak, nonatomic) IBOutlet UITextField *KindText;
@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UITextField *sortText;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;

@property (weak, nonatomic) IBOutlet UILabel *petSexLbl;
@property (weak, nonatomic) IBOutlet UIImageView *maleBtnIcon;
@property (weak, nonatomic) IBOutlet UIImageView *femaleBtnIcon;

@property (weak, nonatomic) IBOutlet UIButton *sexAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexMaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexFemaleBtn;

//======宠物状态
@property (weak, nonatomic) IBOutlet UILabel *forwardLbl;
@property (weak, nonatomic) IBOutlet UIButton *forwardAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardMarrayBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardAdeptBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardSaveBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *time15mBtn;
@property (weak, nonatomic) IBOutlet UIButton *time1hBtn;
@property (weak, nonatomic) IBOutlet UIButton *time1dBtn;
@property (weak, nonatomic) IBOutlet UIButton *time2dBtn;

@property (weak, nonatomic) IBOutlet UILabel *vipLbl;//会员专有选项
@property (nonatomic,retain) UIImageView *vipView;


@property (weak, nonatomic) IBOutlet UILabel *petAgeLbl;
@property (weak, nonatomic) IBOutlet UITextField *petAgeDetail;
@property (weak, nonatomic) IBOutlet UIImageView *petAgeArrowView;

@property (weak, nonatomic) IBOutlet UILabel *ownerSexLbl;
@property (weak, nonatomic) IBOutlet UIImageView *ownerMaleIcon;
@property (weak, nonatomic) IBOutlet UIButton *ownerMaleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ownerFemaleIcon;
@property (weak, nonatomic) IBOutlet UIButton *ownerFemaleBtn;

@property (weak, nonatomic) IBOutlet UILabel *ownerAgeLbl;
@property (weak, nonatomic) IBOutlet UITextField *ownerAgeDetail;
@property (weak, nonatomic) IBOutlet UIImageView *ownerAgeArrowView;

@property (weak, nonatomic) IBOutlet UILabel *ownerStarLbl;
@property (weak, nonatomic) IBOutlet UITextField *ownerStarDetail;
@property (weak, nonatomic) IBOutlet UIImageView *ownerStarArrowView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;


@property (retain, nonatomic) NSArray *pickerArray;
@property (retain, nonatomic) NSArray *midArray;
@property (retain, nonatomic) NSArray *subArray;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSArray *subData;
@property BOOL isMiddle;
@property (retain, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *subPicker;
@property (retain, nonatomic) IBOutlet UIToolbar *doneToolbar;

//by wu
@property (retain, nonatomic) UIView *gapLineView;
@property (weak, nonatomic) IBOutlet UIImageView *gapLineImageView;

- (IBAction)petSexBtnPressed:(id)sender;

- (IBAction)timeBtnPressed:(id)sender;

- (IBAction)forwardBtnPressed:(id)sender;
- (IBAction)ownerSexBtnPressed:(id)sender;

- (IBAction)sureBtnPressed:(id)sender;
- (IBAction)doneBtnPressed:(id)sender;

- (IBAction)cancelBtnPressed:(id)sender;

@end
