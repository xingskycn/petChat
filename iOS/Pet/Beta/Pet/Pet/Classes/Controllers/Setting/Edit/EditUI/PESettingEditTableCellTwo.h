//
//  PESettingEditTableCellTwo.h
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditDoneDelegate <NSObject>

- (void)endEdit:(NSDictionary *)data;

@end

@interface PESettingEditTableCellTwo : UITableViewCell<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic,retain)NSString *petID;
@property(nonatomic,retain)NSString *petBirthday;
@property(nonatomic,retain)NSString *petWantedTypeString;
@property(nonatomic,retain)NSString *petSexString;
@property(nonatomic,retain)NSString *petType;
@property(nonatomic,retain)NSString *petSubType;

@property (retain, nonatomic) NSArray *midArray;
@property (retain, nonatomic) NSArray *subArray;
@property (retain, nonatomic) NSArray *subData;

@property(nonatomic,retain)UILabel *petNameLabelTwo;//宠物名
@property(nonatomic,retain)UILabel *petSortLabel;
@property(nonatomic,retain)UILabel *petAgeLabel;
@property(nonatomic,retain)UILabel *petStausLabel;
@property(nonatomic,retain)UILabel *petFavLabel;
@property(nonatomic,retain)UILabel *petPlaySpaceLabel;
@property(nonatomic,retain)UIImageView *backGroundView;//背景

//对应显示数据的label
@property(nonatomic,retain)UILabel *petNameLabel;
@property(nonatomic,retain)UIImageView *petSortImageView;
@property(nonatomic,retain)UITextField *sortNameLabel;
@property(nonatomic,retain)UILabel *petAgeLabelTwo;
@property(nonatomic,retain)UILabel *petFavDetailLabel;
@property(nonatomic,retain)UILabel *playSpaceDetailLable;

//宠物性别
@property(nonatomic,retain)UILabel *petSexLabel;
@property(nonatomic,retain)UIImageView *petSexMaleNormalImageView;
@property(nonatomic,retain)UIImageView *petSexMaleSelectedImageView;
@property(nonatomic,retain)UIImageView *petSexFemaleNormalImageView;
@property(nonatomic,retain)UIImageView *petSexFemaleSelectedImageView;
@property(nonatomic,retain)UIButton *maleSexBtn;
@property(nonatomic,retain)UIButton *fmaleSexBtn;
@property(nonatomic,assign)BOOL isMale;//控制性别按钮点击


@property(nonatomic,assign)BOOL isSelected;//控制求相亲按钮点击
@property(nonatomic,retain)UIImageView *stausImageViewNomal1;
@property(nonatomic,retain)UIImageView *stausImageViewNomal2;
@property(nonatomic,retain)UIImageView *stausImageViewNomal3;

@property(nonatomic,retain)UIImageView *stausImageViewSelected1;
@property(nonatomic,retain)UIImageView *stausImageViewSelected2;
@property(nonatomic,retain)UIImageView *stausImageViewSelected3;

@property(nonatomic,retain)UIButton *button1;
@property(nonatomic,retain)UIButton *button2;
@property(nonatomic,retain)UIButton *button3;

@property(nonatomic,retain)UIImageView *forwardImageView1;
@property(nonatomic,retain)UIImageView *forwardImageView2;
@property(nonatomic,retain)UIImageView *forwardImageView3;

@property(nonatomic,retain)UILabel *forwardLabel1;
@property(nonatomic,retain)UILabel *forwardLabel2;
@property(nonatomic,retain)UILabel *forwardLabel3;


@property(nonatomic,retain)UIButton *nameBtn;
@property(nonatomic,retain)UIButton *petFavBtn;
@property(nonatomic,retain)UIButton *petPlaySpaceBtn;
@property(nonatomic,retain)UITextField *petAgeTextField;

@property BOOL isMiddle;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolBar;

@property (strong, nonatomic) IBOutlet UIPickerView *subPicker;

@property(nonatomic,retain)id<EditDoneDelegate>delegate;

- (IBAction)doneToolBtn:(id)sender;

- (void)changeSexImage:(NSString *)sexString AndType:(NSString *)typeString;
- (void)setpetAge;
- (void)subSortRequest;
@end
