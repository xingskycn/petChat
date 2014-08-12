//
//  PEDisRegisterForOwnerViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-11.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisRegisterForOwnerViewController.h"
#import "UIHelper.h"
#import "PEMobile.h"
#import "Common.h"
#import "PENetWorkingManager.h"
@interface PEDisRegisterForOwnerViewController ()

@end

@implementation PEDisRegisterForOwnerViewController
@synthesize ownerNameField,pointImageViewForSelected,ownerBirthdayField,pointImageViewForSelectedTwo;
//所有用于注册的值：12个参数
@synthesize phoneNumber,passWord,petIcon,petSmallName,petSort,petSex,petVariety,petBirthday;
@synthesize ownerBirthday,ownerIcon,ownerName,ownerSex,emailAddress;
@synthesize passPhotoBtn;
@synthesize sheet,bgForNextBtn,datePicker,completeBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    bgView.frame = CGRectMake(0, 75, ScreenWidth, 367);
    [self.view addSubview:bgView];
    
    
    //主人信息
    UILabel *petInfomationLabel = [[UILabel alloc]init];
    petInfomationLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    petInfomationLabel.font = [UIFont systemFontOfSize:14];
    petInfomationLabel.text = @"主人信息";
    petInfomationLabel.frame = CGRectMake(10, 83.5, 100, 14);
    [self.view addSubview:petInfomationLabel];
    
    //第一个分割线
    UIView *gapViewOne = [[UIView alloc]init];
    gapViewOne.backgroundColor = [UIHelper colorWithHexString:@"#9fccd5"];
    gapViewOne.frame = CGRectMake(10, 108, 300, 1);
    [self.view addSubview:gapViewOne];
    
    //上传主人像背景
    UIImageView *bgForPassPhoto = [[UIImageView alloc]init];
//    bgForPassPhoto.backgroundColor = [UIColor clearColor];
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
    

    //上传主人头像
    UILabel *passPetPhotoLabel = [[UILabel alloc]init];
    passPetPhotoLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
    passPetPhotoLabel.font = [UIFont systemFontOfSize:11.5];
    passPetPhotoLabel.text = @"上传主人头像";
    passPetPhotoLabel.frame = CGRectMake(125, 201, 70, 12);
    [self.view addSubview:passPetPhotoLabel];
    
    //上传照相button
    passPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passPhotoBtn.frame =CGRectMake(110, 121,100, 100);
    [passPhotoBtn addTarget:self action:@selector(passPhotoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passPhotoBtn];
    
    
    //名称信息必填
    UILabel *petMustInfoLabel = [[UILabel alloc]init];
    petMustInfoLabel.textColor = [UIHelper colorWithHexString:@"#eb6100"];
    petMustInfoLabel.font = [UIFont systemFontOfSize:11.5];
    petMustInfoLabel.text = @"*名称信息必填";
    petMustInfoLabel.frame = CGRectMake(20, 230, 150, 12);
    [self.view addSubview:petMustInfoLabel];
    
    //主人名称背景
    UIImageView *bgForPetSmallNameField = [[UIImageView alloc]init];
    bgForPetSmallNameField.layer.cornerRadius = 5;
    bgForPetSmallNameField.layer.masksToBounds = YES;
    bgForPetSmallNameField.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetSmallNameField.frame = CGRectMake(20, 249, 280, 40);
    bgForPetSmallNameField.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetSmallNameField];
    
    
    //=================================主人名称textField
    ownerNameField = [[UITextField alloc]init];
    ownerNameField.textColor = [UIColor blackColor];
    ownerNameField.font = [UIFont systemFontOfSize:14];
    UIColor *colorOwnerName = [UIHelper colorWithHexString:@"#a3a3a3"];
    ownerNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"主人名称(不超过10个字符)"
                                                                             attributes:@{NSForegroundColorAttributeName: colorOwnerName}];
    ownerNameField.frame = CGRectMake(43.5, 262, 256.5, 14);
    ownerNameField.delegate = self;
    [self.view addSubview:ownerNameField];
    
    //性别设置之后不允许修改
    UILabel *ownerCannotChangeInfoLabel = [[UILabel alloc]init];
    ownerCannotChangeInfoLabel.textColor = [UIHelper colorWithHexString:@"#eb6100"];
    ownerCannotChangeInfoLabel.font = [UIFont systemFontOfSize:11.5];
    ownerCannotChangeInfoLabel.text = @"*性别设置之后不允许修改，请谨慎操作";
    ownerCannotChangeInfoLabel.frame = CGRectMake(20, 308, 200, 12);
    [self.view addSubview:ownerCannotChangeInfoLabel];
    
    //男生点选框
    UIImageView *pointImageViewForMale = [[UIImageView alloc]init];
    pointImageViewForMale.backgroundColor = [UIColor clearColor];
    pointImageViewForMale.image = [UIHelper imageName:@"register_ponitUnSelected"];
    pointImageViewForMale.frame = CGRectMake(20, 328, 25.5, 26);
    [self.view addSubview:pointImageViewForMale];
    
    //选择男孩性别点击button
    UIButton *selectSexMaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectSexMaleBtn.frame =CGRectMake(0, 325, 93.5, 32);
    [selectSexMaleBtn addTarget:self action:@selector(selectSexMaleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectSexMaleBtn];
    
    //点选款选中默认在男生这里，用户性别默认为男
    pointImageViewForSelected = [[UIImageView alloc]init];
    pointImageViewForSelected.backgroundColor = [UIColor clearColor];
    pointImageViewForSelected.image = [UIHelper imageName:@"register_pointSelected"];
    pointImageViewForSelected.frame = CGRectMake(20, 328, 25.5, 26);
    pointImageViewForSelected.alpha = 1.0;
    [self.view addSubview:pointImageViewForSelected];
    ownerSex = @"男士";
    
    //男士箭头图片
    UIImageView *maleImageView = [[UIImageView alloc]init];
    maleImageView.backgroundColor = [UIColor clearColor];
    maleImageView.image = [UIHelper imageName:@"register_male"];
    maleImageView.frame = CGRectMake(59, 332, 22, 22);
    [self.view addSubview:maleImageView];
    
    //男士
    UILabel *malelabel = [[UILabel alloc]init];
    malelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    malelabel.font = [UIFont systemFontOfSize:13.5];
    malelabel.text = @"男";
    malelabel.frame = CGRectMake(86.5, 336, 30, 14);
    [self.view addSubview:malelabel];
    
    //女生点选框
    UIImageView *pointImageViewForFemale = [[UIImageView alloc]init];
    pointImageViewForFemale.backgroundColor = [UIColor clearColor];
    pointImageViewForFemale.image = [UIHelper imageName:@"register_ponitUnSelected"];
    pointImageViewForFemale.frame = CGRectMake(195, 326, 25.5, 26);
    [self.view addSubview:pointImageViewForFemale];
    
    //点选款选中---女生
    pointImageViewForSelectedTwo = [[UIImageView alloc]init];
    pointImageViewForSelectedTwo.backgroundColor = [UIColor clearColor];
    pointImageViewForSelectedTwo.image = [UIHelper imageName:@"register_pointSelected"];
    pointImageViewForSelectedTwo.frame = CGRectMake(195, 326, 25.5, 26);
    pointImageViewForSelectedTwo.alpha = 0.0;
    [self.view addSubview:pointImageViewForSelectedTwo];
    
    //选择女孩性别点击button
    UIButton *selectSexFemaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectSexFemaleBtn.frame =CGRectMake(195, 323, 120, 32);
    [selectSexFemaleBtn addTarget:self action:@selector(selectSexFemaleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectSexFemaleBtn];
    
    //女士箭头图片
    UIImageView *femaleImageView = [[UIImageView alloc]init];
    femaleImageView.backgroundColor = [UIColor clearColor];
    femaleImageView.image = [UIHelper imageName:@"register_female"];
    femaleImageView.frame = CGRectMake(233.5, 332, 22, 22);
    [self.view addSubview:femaleImageView];
    
    //女士
    UILabel *femalelabel = [[UILabel alloc]init];
    femalelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    femalelabel.font = [UIFont systemFontOfSize:13.5];
    femalelabel.text = @"女";
    femalelabel.frame = CGRectMake(260.5, 336, 30, 14);
    [self.view addSubview:femalelabel];
    
    
    //主人生日背景
    UIImageView *bgForPetBirthday = [[UIImageView alloc]init];
    bgForPetBirthday.layer.cornerRadius = 5;
    bgForPetBirthday.layer.masksToBounds = YES;
    bgForPetBirthday.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForPetBirthday.frame = CGRectMake(20, 376, 280, 40);
    bgForPetBirthday.userInteractionEnabled = YES;
    [self.view addSubview:bgForPetBirthday];
    
    //==============================主人生日文本框
    ownerBirthdayField = [[UITextField alloc]init];
    ownerBirthdayField.textColor = [UIColor blackColor];
    ownerBirthdayField.font = [UIFont systemFontOfSize:14];
    UIColor *colorOwnerBirth = [UIHelper colorWithHexString:@"#a3a3a3"];
    ownerBirthdayField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"主人生日"
                                                                               attributes:@{NSForegroundColorAttributeName: colorOwnerBirth}];
    ownerBirthdayField.frame = CGRectMake(43.5, 389, 256.5, 14);
    ownerBirthdayField.delegate = self;
    [self.view addSubview:ownerBirthdayField];
    ownerBirthdayField.inputView = self.datePicker;
    ownerBirthdayField.inputAccessoryView = self.doneToolbar;
    
    
    //完成按钮背景
    bgForNextBtn = [[UIImageView alloc]init];
    bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
    bgForNextBtn.layer.cornerRadius = 5;
    bgForNextBtn.layer.masksToBounds = YES;
    bgForNextBtn.frame = CGRectMake(20, 505, 280, 40);
    bgForNextBtn.userInteractionEnabled = YES;
    [self.view addSubview:bgForNextBtn];
    
    //完成按钮
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
    completeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    completeBtn.frame = CGRectMake(20, 505, 280, 40);
    [completeBtn addTarget:self action:@selector(completeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
    
    sheet =[[UIActionSheet alloc]initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"现在拍摄", @"相册", nil];
    
    
}

#pragma mark -Button Pressed
- (IBAction)doneBtnPressed:(id)sender;
{
    
    [ownerBirthdayField endEditing:YES];
    
}

#pragma mark -完成按钮点击事件
//完成按钮点击事件
- (void)completeBtnPressed{
    
    ownerName = ownerNameField.text;
    ownerBirthday = ownerBirthdayField.text;

    if([ownerName isEqualToString:@""] || ownerName == nil)
    {
        [Common commonAlertShowWithTitle:@"名称信息必填!" Message:nil];
        return;
    }
    
    //宠物小名字数限制提示
    if(ownerNameField.text.length >10){
        [Common showAlert:@"主人名称不能超过10个字符!"];
        return;
    }
    //当主人信息填写完成，才可以走api
    if(ownerIcon && ownerName && ![ownerName isEqualToString:@"主人名称"] && ![ownerName isEqualToString:@""]  && ownerSex && ownerBirthday && ![ownerBirthday isEqualToString:@"主人生日"] &&![ownerBirthday isEqualToString:@""])
    {
    
      //开始
     NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
     //自己需要构建的字典:这里需要多个键值对
      NSDictionary *userInfo =@{@"userName":ownerName,
                              @"userSex":ownerSex,
                              @"userBirthday":ownerBirthday,
                              @"userMobilePhoneNumber": phoneNumber,
                              @"userPW":passWord,
                              @"userEmailAddress":emailAddress
                              };
    
    //petType为宠物种类id,petSubType为宠物品种id
    NSDictionary *petInfo = @{@"petName":petSmallName,
                              @"petSex":petSex,
                              @"petType":petSort,
                              @"petSubType":petVariety,
                              @"petBirthday":petBirthday,
                              @"petNickName":@"萌萌"
                              };
    
    NSMutableDictionary *request =[[NSMutableDictionary alloc] initWithDictionary:appInfo];
   
    [request setObject:userInfo forKey:@"userInfo"];
    [request setObject:petInfo forKey:@"petInfo"];
    
    //需要上传的图片：两张
    UIImage *petImg = petIcon;
    UIImage *userImg = ownerIcon;
    
    //上传两张图片的url
    [[PENetWorkingManager sharedClient]userRigister:request image:petImg userImage:userImg completion:^(NSDictionary *results, NSError *error) {
        if(results){
            NSLog(@"%@",results);
            if ([[results objectForKey:HTTP_RESULTS] isEqualToString:@"0"]) {
                 NSLog(@"*********Register Success********");
                 NSString *userID =[results objectForKey:USER_INFO_ID];
                if (phoneNumber.length !=0) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MAILACCOUNT];
                    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:CELLACCOUNT];
                    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:PASSWORD];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:emailAddress forKey:MAILACCOUNT];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:CELLACCOUNT];
                    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:PASSWORD];
                }
                //将登录状态修改为YES
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IS_LOGINED];
                //保存用户宠聊号
                [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_INFO_ID];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                //立刻保存信息
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self goLogin];
            }else {
                NSLog(@"*********Register Failure********");
                NSLog(@"%@",results);
//                [Common showAlert:[NSString stringWithFormat:@"%@", [results objectForKey:HTTP_ERRORMSG]]];
                [Common showAlert:@"注册失败！"];
            }
        }else {
            NSLog(@"%@",error);
           [Common showAlert:@"注册失败！"];
        }
     }];

    }else{
        [Common commonAlertShowWithTitle:@"请完善主人信息！" Message:nil];
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

//上传照片按钮点击事件
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
        [self presentViewController:picker animated:YES completion:nil];
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
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许访问相册");
    }
}

//选择男生按钮点击事件
- (void)selectSexMaleBtnPressed{
    pointImageViewForSelectedTwo.alpha = 0.0;
    pointImageViewForSelected.alpha = 1.0;
    ownerSex = @"男士";

}

//选择女生按钮点击事件
- (void)selectSexFemaleBtnPressed{
    pointImageViewForSelectedTwo.alpha = 1.0;
    pointImageViewForSelected.alpha = 0.0;
    ownerSex = @"女士";

    
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [ownerNameField resignFirstResponder];
    [ownerBirthdayField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [ownerNameField resignFirstResponder];
    [ownerBirthdayField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == ownerBirthdayField)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, -90, ScreenWidth, ScreenHeight);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //给宠物生日赋值
    if(textField == ownerBirthdayField)
    {
        
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
        ownerBirthdayField.text = [NSString stringWithFormat:@"%@-%@-%@",currentyearString,currentMonthString,currentDateString];
    }
    
    if(textField == ownerNameField){
        //宠物小名字数限制提示
        if(textField.text.length >10){
            [Common showAlert:@"主人名称不超过10个字符!"];
            return;
        }
        
    }

    if(ownerIcon && ownerNameField && ![ownerNameField.text isEqualToString:@"主人名称"] && ![ownerNameField.text isEqualToString:@""]  && ownerSex && ownerBirthdayField && ![ownerBirthdayField.text isEqualToString:@"主人生日"] &&![ownerBirthdayField.text isEqualToString:@""])
        {
            bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#ee8d59"];
            [completeBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            
        }else
        {
            bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
            [completeBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ownerIcon = image;
    
}

- (void)setButton:(UIImage *)image {
    
    [passPhotoBtn setImage:image forState:UIControlStateNormal];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LoginMothen

- (void)goLogin {
    //login 请求
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]) {
        NSString *cellStr =[[NSUserDefaults standardUserDefaults] objectForKey:CELLACCOUNT];
        NSString *passwordString =[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
        NSString *mailStr =[[NSUserDefaults standardUserDefaults] objectForKey:MAILACCOUNT];
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"mobileNumber":cellStr,
                                   @"password":[Common md5:passwordString],//密码做简单的md5加密
                                   @"emailAddress":mailStr,
                                   };
        NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
        [request setObject:userInfo forKey:LOGIN_INFO_KEY];
        NSLog(@"%@", request);
        [[PENetWorkingManager sharedClient]login:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                if ([[results objectForKey:@"result"] isEqualToString:@"0"]) {
                    
                    //登录成功保存userId
                    NSString *userID = [results objectForKey:USER_INFO_ID];
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:userID forKey:USER_INFO_ID];
                    [ud setObject:cellStr forKey:CELLACCOUNT];
                    [ud setObject:mailStr forKey:MAILACCOUNT];
                    [ud setObject:passwordString forKey:PASSWORD];
                    //修改IS_LOGINED的值
                    [ud setBool:YES forKey:IS_LOGINED];
                    NSLog(@"登录成功");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                    [[PEXMPP sharedInstance] login];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
//                    [Common showAlert:[results objectForKey:@"errMsg"]];
                    [Common showAlert:@"注册失败，请完善信息！"];
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
}

@end
