//
//  PEDisRegisterForPetViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-11.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisRegisterForPetViewController.h"
#import "PEDisRegisterForOwnerViewController.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PEModel.h"
#import "Common.h"
@interface PEDisRegisterForPetViewController ()

@end

@implementation PEDisRegisterForPetViewController
{
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
}
@synthesize petSmallNameField,pointImageViewForSelected,petBirthdayField,pointImageViewForSelectedTwo;
@synthesize petSortField,petVarietyField,emailAdress;
@synthesize passWordString,phoneNumberString;
@synthesize pickerArray,data,midArray,subData,subArray;
@synthesize petSelectSex,petImage;
@synthesize isMiddle;
@synthesize passPhotoBtn;
@synthesize sheet;
@synthesize petSortID,petVarietyID;
@synthesize yearArray,monthArray,dayArray,datePicker;
@synthesize bgForNextBtn,nextStepBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pickerArray = [[NSMutableArray alloc]init]; // Custom initialization
        data = [[NSMutableArray alloc]init];
        midArray = [[NSMutableArray alloc]init];
        subData = [[NSMutableArray alloc]init];
        subArray = [[NSMutableArray alloc]init];
        
        
        yearArray = [[NSMutableArray alloc]init];
        monthArray = [[NSMutableArray alloc]init];
        dayArray = [[NSMutableArray alloc]init];

 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(REGISTER_VIEW_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    

    //时间选择的最大值为今天
    //最小值1914
    NSString *tempAgeString =@"19140101";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    //将字符串转化成NSDate类型
    NSDate *tempAgeDate =[formatter dateFromString:tempAgeString];
    NSDate *date = [NSDate date];
    datePicker.maximumDate = date;
    datePicker.minimumDate = tempAgeDate;
    

    
    [self setupUI];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI{
    
    //顶部底下背景
    UIImageView *bgForHeader = [[UIImageView alloc]init];
    bgForHeader.backgroundColor = [UIColor clearColor];
    bgForHeader.image = [UIHelper imageName:@"register_bgForHeader"];
    bgForHeader.frame = CGRectMake(0, 64, ScreenWidth, 11);
    [self.view addSubview:bgForHeader];
    
    //底下大背景
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgView.alpha = 0.6;
    bgView.frame = CGRectMake(0, 75, ScreenWidth, 401);
    [self.view addSubview:bgView];
    
    
    //宠物信息
    UILabel *petInfomationLabel = [[UILabel alloc]init];
    petInfomationLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    petInfomationLabel.font = [UIFont systemFontOfSize:14];
    petInfomationLabel.text = @"宠物信息";
    petInfomationLabel.frame = CGRectMake(10, 83.5, 100, 14);
    [self.view addSubview:petInfomationLabel];
    
    //第一个分割线
    UIView *gapViewOne = [[UIView alloc]init];
    gapViewOne.backgroundColor = [UIHelper colorWithHexString:@"#9fccd5"];
    gapViewOne.frame = CGRectMake(10, 108, 300, 1);
    [self.view addSubview:gapViewOne];
    
    //宠物信息必填
    UILabel *petMustInfoLabel = [[UILabel alloc]init];
    petMustInfoLabel.textColor = [UIHelper colorWithHexString:@"#eb6100"];
    petMustInfoLabel.font = [UIFont systemFontOfSize:11.5];
    petMustInfoLabel.text = @"宠物信息必填";
    petMustInfoLabel.frame = CGRectMake(20, 121, 70, 12);
    [self.view addSubview:petMustInfoLabel];
    
    //上传宠物头像背景
    UIImageView *bgForPassPhoto = [[UIImageView alloc]init];
    bgForPassPhoto.layer.cornerRadius = 5;
    bgForPassPhoto.layer.masksToBounds = YES;
    bgForPassPhoto.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPassPhoto.frame = CGRectMake(110, 121,100, 100);
    [self.view addSubview:bgForPassPhoto];
    
    //照相机Icon
    UIImageView *passPhotoBtnImageView = [[UIImageView alloc]init];
    passPhotoBtnImageView.backgroundColor = [UIColor clearColor];
    passPhotoBtnImageView.image = [UIHelper imageName:@"register_camerPhoto"];
    passPhotoBtnImageView.frame = CGRectMake(142.5, 158, 35, 26);
    [self.view addSubview:passPhotoBtnImageView];
    
    //上传宠物头像
    UILabel *passPetPhotoLabel = [[UILabel alloc]init];
    passPetPhotoLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
    passPetPhotoLabel.font = [UIFont systemFontOfSize:11.5];
    passPetPhotoLabel.text = @"上传宠物头像";
    passPetPhotoLabel.frame = CGRectMake(125, 201, 70, 12);
    [self.view addSubview:passPetPhotoLabel];
    
    
    //上传照相button
    passPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passPhotoBtn.frame =CGRectMake(110, 121,100, 100);
    [passPhotoBtn addTarget:self action:@selector(passPhotoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passPhotoBtn];

    
    //宠物小名背景
    UIImageView *bgForPetSmallNameField = [[UIImageView alloc]init];
    bgForPetSmallNameField.layer.cornerRadius = 5;
    bgForPetSmallNameField.layer.masksToBounds = YES;
    bgForPetSmallNameField.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetSmallNameField.frame = CGRectMake(20, 240, 280, 40);
    bgForPetSmallNameField.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetSmallNameField];
    
    
    //========================宠物小名textField
    petSmallNameField = [[UITextField alloc]init];
    petSmallNameField.textColor = [UIColor blackColor];
    UIColor *color = [UIHelper colorWithHexString:@"#a3a3a3"];
    petSmallNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"宠物小名(不超过10个字符)"
                                                                              attributes:@{NSForegroundColorAttributeName: color}];
    petSmallNameField.font = [UIFont systemFontOfSize:14];
    petSmallNameField.frame = CGRectMake(43.5, 253, 256.5, 14);
    petSmallNameField.delegate = self;
    [self.view addSubview:petSmallNameField];
    
    //宠物种类背景
    UIImageView *bgForPetSort = [[UIImageView alloc]init];
    bgForPetSort.layer.cornerRadius = 5;
    bgForPetSort.layer.masksToBounds = YES;
    bgForPetSort.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetSort.frame = CGRectMake(20, 301, 130, 40);
    bgForPetSort.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetSort];
    
    //宠物种类
    UILabel *petSortLabel = [[UILabel alloc]init];
    petSortLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    petSortLabel.font = [UIFont systemFontOfSize:11.5];
    petSortLabel.text = @"宠物种类";
    petSortLabel.frame = CGRectMake(56, 315, 60, 12);
//    [self.view addSubview:petSortLabel];
    
    //=====================宠物种类textField
    petSortField = [[UITextField alloc]init];
    petSortField.textColor = [UIColor blackColor];
    petSortField.font = [UIFont systemFontOfSize:11.5];
    UIColor *colorSort = [UIHelper colorWithHexString:@"#727f81"];
    petSortField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"宠物种类"
                                                                              attributes:@{NSForegroundColorAttributeName: colorSort}];

    petSortField.frame = CGRectMake(56, 315, 74, 12);
    petSortField.tag = 200;
    petSortField.delegate = self;
    [self.view addSubview:petSortField];
    
    petSortField.inputView = self.selectPicker;
    petSortField.inputAccessoryView = self.doneToolbar;
    self.selectPicker.delegate = self;
    self.selectPicker.dataSource = self;
    self.subPicker.dataSource = self;
    self.subPicker.delegate = self;
    
    
    
    //宠物种类三角箭头
    UIImageView *bgForPetSortArrow = [[UIImageView alloc]init];
    bgForPetSortArrow.backgroundColor = [UIColor clearColor];
    bgForPetSortArrow.frame = CGRectMake(124.5, 320, 12.5, 7);
    bgForPetSortArrow.userInteractionEnabled = YES;
    bgForPetSortArrow.image = [UIHelper imageName:@"register_selectBg"];
    [self.view addSubview:bgForPetSortArrow];
    
    //宠物种类选择按钮
    UIButton *petSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    petSortBtn.frame = CGRectMake(20, 295, 130, 50);//20, 301, 130, 40
//    [self.view addSubview:petSortBtn];
    [petSortBtn addTarget:self action:@selector(petSortBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //宠物品种背景
    UIImageView *bgForPetVariety = [[UIImageView alloc]init];
    bgForPetVariety.layer.cornerRadius = 5;
    bgForPetVariety.layer.masksToBounds = YES;
    bgForPetVariety.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetVariety.frame = CGRectMake(170, 301, 130, 40);
    bgForPetVariety.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetVariety];
    
    //宠物品种
    UILabel *petVarietyLabel = [[UILabel alloc]init];
    petVarietyLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    petVarietyLabel.font = [UIFont systemFontOfSize:11.5];
    petVarietyLabel.text = @"宠物品种";
    petVarietyLabel.frame = CGRectMake(206, 315, 60, 12);
//    [self.view addSubview:petVarietyLabel];
    
    //==============================宠物品种textField
    petVarietyField = [[UITextField alloc]init];
    petVarietyField.textColor = [UIColor blackColor];
    petVarietyField.textAlignment = NSTextAlignmentLeft;
    petVarietyField.font = [UIFont systemFontOfSize:11.5];
    UIColor *colorVariety = [UIHelper colorWithHexString:@"#727f81"];
    petVarietyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"宠物品种"
                                                                         attributes:@{NSForegroundColorAttributeName: colorVariety}];
    petVarietyField.frame = CGRectMake(206, 315, 74, 12);
    petVarietyField.tag = 201;
    petVarietyField.delegate = self;
    [self.view addSubview:petVarietyField];
    petVarietyField.inputView = self.subPicker;
    petVarietyField.inputAccessoryView = self.doneToolbar;
 
    
    //宠物品种三角箭头
    UIImageView *bgForPetVarietyArrow = [[UIImageView alloc]init];
    bgForPetVarietyArrow.backgroundColor = [UIColor clearColor];
    bgForPetVarietyArrow.frame = CGRectMake(274, 320, 12.5, 7);
    bgForPetVarietyArrow.userInteractionEnabled = YES;
    bgForPetVarietyArrow.image = [UIHelper imageName:@"register_selectBg"];
    [self.view addSubview:bgForPetVarietyArrow];
    
    
    //宠物品种选择按钮
    UIButton *petVarietyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    petVarietyBtn.frame = CGRectMake(170, 290, 130, 50);
    [petVarietyBtn addTarget:self action:@selector(petVarietyBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:petVarietyBtn];
    
    //男生点选框
    UIImageView *pointImageViewForMale = [[UIImageView alloc]init];
    pointImageViewForMale.backgroundColor = [UIColor clearColor];
    pointImageViewForMale.image = [UIHelper imageName:@"register_ponitUnSelected"];
    pointImageViewForMale.frame = CGRectMake(20, 364, 25.5, 26);
    [self.view addSubview:pointImageViewForMale];
    
    //点选款选中默认在男生这里
    pointImageViewForSelected = [[UIImageView alloc]init];
    pointImageViewForSelected.backgroundColor = [UIColor clearColor];
    pointImageViewForSelected.image = [UIHelper imageName:@"register_pointSelected"];
    pointImageViewForSelected.frame = CGRectMake(20, 364, 25.5, 26);
    pointImageViewForSelected.alpha = 1.0;
    [self.view addSubview:pointImageViewForSelected];
    petSelectSex = @"公";
    
    //选择男孩性别点击button
    UIButton *selectSexMaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectSexMaleBtn.frame =CGRectMake(0, 361, 93.5, 32);
    [selectSexMaleBtn addTarget:self action:@selector(selectSexMaleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectSexMaleBtn];
    
    //男士箭头图片
    UIImageView *maleImageView = [[UIImageView alloc]init];
    maleImageView.backgroundColor = [UIColor clearColor];
    maleImageView.image = [UIHelper imageName:@"register_male"];
    maleImageView.frame = CGRectMake(59, 367.5, 22, 22);
    [self.view addSubview:maleImageView];
    
    //男士
    UILabel *malelabel = [[UILabel alloc]init];
    malelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    malelabel.font = [UIFont systemFontOfSize:13.5];
    malelabel.text = @"男生";
    malelabel.frame = CGRectMake(86.5, 370, 30, 14);
    [self.view addSubview:malelabel];
    
    //女生点选框
    UIImageView *pointImageViewForFemale = [[UIImageView alloc]init];
    pointImageViewForFemale.backgroundColor = [UIColor clearColor];
    pointImageViewForFemale.image = [UIHelper imageName:@"register_ponitUnSelected"];
    pointImageViewForFemale.frame = CGRectMake(195, 364, 25.5, 26);
    [self.view addSubview:pointImageViewForFemale];
    
    //点选款选中---女生
    pointImageViewForSelectedTwo = [[UIImageView alloc]init];
    pointImageViewForSelectedTwo.backgroundColor = [UIColor clearColor];
    pointImageViewForSelectedTwo.image = [UIHelper imageName:@"register_pointSelected"];
    pointImageViewForSelectedTwo.frame = CGRectMake(195, 364, 25.5, 26);
    pointImageViewForSelectedTwo.alpha = 0.0;
    [self.view addSubview:pointImageViewForSelectedTwo];
    
    //选择女孩性别点击button
    UIButton *selectSexFemaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectSexFemaleBtn.frame =CGRectMake(195, 361, 120, 32);
    [selectSexFemaleBtn addTarget:self action:@selector(selectSexFemaleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectSexFemaleBtn];
    
    //女士箭头图片
    UIImageView *femaleImageView = [[UIImageView alloc]init];
    femaleImageView.backgroundColor = [UIColor clearColor];
    femaleImageView.image = [UIHelper imageName:@"register_female"];
    femaleImageView.frame = CGRectMake(233.5, 367.5, 22, 22);
    [self.view addSubview:femaleImageView];
    
    //女士
    UILabel *femalelabel = [[UILabel alloc]init];
    femalelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    femalelabel.font = [UIFont systemFontOfSize:13.5];
    femalelabel.text = @"女生";
    femalelabel.frame = CGRectMake(260.5, 370, 30, 14);
    [self.view addSubview:femalelabel];
    
    
    //宠物生日背景
    UIImageView *bgForPetBirthday = [[UIImageView alloc]init];
    bgForPetBirthday.layer.cornerRadius = 5;
    bgForPetBirthday.layer.masksToBounds = YES;
    bgForPetBirthday.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetBirthday.frame = CGRectMake(20, 410, 280, 40);
    bgForPetBirthday.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetBirthday];
    
    //====================================宠物生日文本框
    petBirthdayField = [[UITextField alloc]init];
    petBirthdayField.textColor = [UIColor blackColor];
    petBirthdayField.font = [UIFont systemFontOfSize:14];
    UIColor *colorBirth = [UIHelper colorWithHexString:@"#a3a3a3"];
    petBirthdayField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"宠物生日"
                                                                            attributes:@{NSForegroundColorAttributeName: colorBirth}];
    petBirthdayField.placeholder = @"宠物生日";
    petBirthdayField.frame = CGRectMake(43.5, 423.5, 256.5, 14);
    petBirthdayField.delegate = self;
    petBirthdayField.tag = 202;
    [self.view addSubview:petBirthdayField];
    petBirthdayField.inputView =self.datePicker;
    petBirthdayField.inputAccessoryView = self.doneToolbar;
    
    
    //下一部按钮背景
    bgForNextBtn = [[UIImageView alloc]init];
    bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
    bgForNextBtn.layer.cornerRadius = 5;
    bgForNextBtn.layer.masksToBounds = YES;
    bgForNextBtn.frame = CGRectMake(20, 505, 280, 40);
    bgForNextBtn.userInteractionEnabled = YES;
    [self.view addSubview:bgForNextBtn];
    
    //下一部按钮
    nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
    nextStepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStepBtn.frame = CGRectMake(20, 505, 280, 40);
    [nextStepBtn addTarget:self action:@selector(nextStepBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    

    
    sheet =[[UIActionSheet alloc]initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"现在拍摄", @"相册", nil];
    
 

    
    //走网络接口
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    [[PENetWorkingManager sharedClient] fliterDataDataRequest:appInfo completion:^(NSDictionary *results, NSError *error) {
        if (results){
            NSLog(@"%@",results);
            self.data = [results objectForKey:REQUEST_FLITER_DATA];
        }else {
            NSLog(@"%@",error);
        }
    }];

}

#pragma mark -Button Pressed
- (void)nextStepBtnPressed{
    //宠物小名   宠物种类   宠物品种  宠物生日
    NSString *petNameString = petSmallNameField.text;
    NSString *petBirthday = petBirthdayField.text;
    
    //宠物小名字数限制提示
    if(petSmallNameField.text.length >10){
        [Common showAlert:@"宠物小名不能超过10个字符!"];
        return;
    }
    
    if(petImage && petSmallNameField.text && ![petSmallNameField.text isEqualToString:@"宠物小名"]&&![petSmallNameField.text isEqualToString:@""] && petSortField.text && ![petSortField.text  isEqualToString:@"宠物种类"] &&![petSortField.text  isEqualToString:@""] &&petVarietyField.text && ![petVarietyField.text isEqualToString:@"宠物品种"] &&![petVarietyField.text isEqualToString:@""]&& petSelectSex &&petBirthdayField.text && ![petBirthdayField.text isEqualToString:@"宠物生日"] &&![petBirthdayField.text isEqualToString:@""] )
    {
    
       //传值：
        PEDisRegisterForOwnerViewController *ownerView = [[PEDisRegisterForOwnerViewController alloc]init];
   
        ownerView.phoneNumber = phoneNumberString;
        ownerView.emailAddress = emailAdress;
        ownerView.passWord = passWordString;
        ownerView.petIcon = petImage;
        ownerView.petSmallName = petNameString;
        ownerView.petSort =petSortID;
        ownerView.petVariety = petVarietyID;
        ownerView.petBirthday = petBirthday;
        ownerView.petSex = petSelectSex;
        [self.navigationController pushViewController:ownerView animated:YES];
    }else
    {
        [Common commonAlertShowWithTitle:@"请完善宠物信息！" Message:nil];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1) {
        [self getPhoto];
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
    }
    
}

- (void)passPhotoBtnPressed{
    NSLog(@"上传主人头像");

    [sheet showInView:self.view];

    
}

//拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许使用相机");
    }
}

//访问相册
- (void)getPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许访问相册");
    }
}


- (void)selectSexMaleBtnPressed{
    pointImageViewForSelectedTwo.alpha = 0.0;
    pointImageViewForSelected.alpha = 1.0;
    petSelectSex = @"公";
    
}

- (void)selectSexFemaleBtnPressed{
    pointImageViewForSelectedTwo.alpha = 1.0;
    pointImageViewForSelected.alpha = 0.0;
    petSelectSex = @"母";
    
}

- (void)petVarietyBtnPressed{
   NSLog(@"宠物品种");
}

- (void)petSortBtnPressed{
    NSLog(@"宠物种类");
}

- (IBAction)doneBtnPressed:(id)sender{
    [petSortField endEditing:YES];
    [petVarietyField endEditing:YES];
    [petBirthdayField endEditing:YES];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [petSmallNameField resignFirstResponder];
    [petBirthdayField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [petSmallNameField resignFirstResponder];
    [petBirthdayField resignFirstResponder];
}

//textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSMutableArray *pickArr=[[NSMutableArray alloc]init];
    NSMutableArray *pickMidArr=[[NSMutableArray alloc]init];
    self.type = textField.tag;
    switch (textField.tag) {
        case 200:{
                for (int i =0; i<data.count; i++) {
                //数据源，数组里添加元素
                NSString *kind =[data[i] objectForKey:FLITER_SORT_NAME];
                [pickArr addObject:kind];
            }
            self.pickerArray = pickArr;
            [self.selectPicker reloadAllComponents];
            break;
        }
        case 201:{
            if (self.isMiddle) {

                self.midArray =self.subData;
            } else {
                [pickMidArr addObject:@"全部"];
                self.midArray =pickMidArr;
            }
            if (!self.isMiddle) {
                self.subArray =self.subData;
            }else {
                self.subArray =[[self.midArray objectAtIndex:0] objectForKey:FLITER_SORT_SUB_LIST];
            }
            [self.subPicker reloadAllComponents];
            break;
        }
        //取dataPicker里面的数据
        case 202:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0, -100.0f , ScreenWidth, ScreenHeight);
            [UIView commitAnimations];
        }
            
        default:
            break;
    }


}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //给宠物生日赋值
    if(textField == petBirthdayField){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [UIView commitAnimations];
        
        NSDate *date = [datePicker date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        // Get Current  Month
        [formatter setDateFormat:@"MM"];
        NSString * currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        // Get Current  Date
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        petBirthdayField.text = [NSString stringWithFormat:@"%@-%@-%@",currentyearString,currentMonthString,currentDateString];
    }
    if(textField == petSmallNameField){
      //宠物小名字数限制提示
        if(textField.text.length >10){
        [Common showAlert:@"宠物小名不超过10个字符!"];
        return;
     }
    }

    if(petImage && petSmallNameField.text && ![petSmallNameField.text isEqualToString:@"宠物小名"]&&![petSmallNameField.text isEqualToString:@""] && petSortField.text && ![petSortField.text  isEqualToString:@"宠物种类"] &&![petSortField.text  isEqualToString:@""] &&petVarietyField.text && ![petVarietyField.text isEqualToString:@"宠物品种"] &&![petVarietyField.text isEqualToString:@""]&& petSelectSex &&petBirthdayField.text && ![petBirthdayField.text isEqualToString:@"宠物生日"] &&![petBirthdayField.text isEqualToString:@""] )
    {
        
        bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#ee8d59"];
        [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    }
    else
    {
        bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
        [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
  
    }
    
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pickerController setting
//有几个分区
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView == self.selectPicker)
    {
        return 1;
    }
    else if(pickerView == self.subPicker)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

//pickerView的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView ==self.selectPicker) //挑选宠物种类
    {
        return pickerArray.count;
    }
    else
    {
        if(component == 0)
        {//subPicker有两个
            return midArray.count;
        }else
        {
            return [self.subArray count];
        }
    }

}

//pickerView上得某一行标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView ==self.selectPicker)
    {
        return [NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
    }
    else
    {
        if (component ==0)
        {
            if (self.isMiddle)
            {
                return [[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_MID_NAME];
            } else
            {
                return [self.midArray objectAtIndex:row];
            }
        }else
        {
            return [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
        }
        

    }

   
}

//选中pickerView上得某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == self.selectPicker){
        switch (self.type) {
            case 200:
                self.petSortField.text =[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_NAME]];
                //取宠物种类ID
                petSortID = [[self.data objectAtIndex:row]objectForKey:FLITER_SORT_ID];
                 
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
               [self subSortRequest:row];
                break;
            case 201:
                self.petVarietyField.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;

                
            default:
                break;
        }
    }  else
        switch (self.type) {

            case 200:
                self.petSortField.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
               [self subSortRequest:row];
                break;
            case 201:
                if (component ==0) {
                    if (self.isMiddle) {
                        self.subArray =[[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_SUB_LIST];
                    }
                    [self.subPicker reloadAllComponents];
                }else {
                    if (petSortField.text.length !=0 && subArray.count >0) {
                        self.petVarietyField.text =[[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_SUBTYPE];
                        
                        //取宠物品种ID
                        petVarietyID = [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_ID];
                    }
                }
                break;
                
            default:
                break;
        }

    
}





- (void)subSortRequest:(int)row {
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *sortDict =@{@"sortID":[NSString stringWithFormat:@"%d", row +1]};
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:sortDict forKey:FLITER_SORT_INFO];
    
    [[PENetWorkingManager sharedClient] fliterSubDataRequest:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            if ([results objectForKey:REQUEST_FLITER_SUB_DATA]) {
                self.subData =[results objectForKey:REQUEST_FLITER_SUB_DATA];
                self.isMiddle =YES;
            } else {
                self.subData =[results objectForKey:REQUEST_FLITER_DATA];
                self.isMiddle =NO;
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - uiimagePickerDelaget
//取出相册的某张图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(setButton:)
                   withObject:image
                   afterDelay:0.5];
    //宠物头像赋值
    petImage = image;

}

- (void)setButton:(UIImage *)image {

        [passPhotoBtn setImage:image forState:UIControlStateNormal];

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
