//
//  PERegisterViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-10.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PERegisterViewController.h"
#import "UIHelper.h"
#import "Common.h"
#import "PEDisRegisterForPetViewController.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
@interface PERegisterViewController ()

@end

@implementation PERegisterViewController
@synthesize registerView,nextStepBtn,bgForNextBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI{
    
    UIImageView *bgForHeader = [[UIImageView alloc]init];
    bgForHeader.backgroundColor = [UIColor clearColor];
    bgForHeader.image = [UIHelper imageName:@"register_bgForHeader"];
    bgForHeader.frame = CGRectMake(0, 64, ScreenWidth, 11);
    [self.view addSubview:bgForHeader];
    
    registerView = [[PEDisRegisterView alloc]init];
    registerView.frame = CGRectMake(0, 75, ScreenWidth, 295);
    registerView.mobileOrMailField.delegate = self;
    registerView.accountOrPwdField.delegate = self;
    registerView.inputConfirmCodeField.delegate = self;
    [registerView.sendConfirmCodeBtn addTarget:self action:@selector(sendConfirmCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerView];
    
    bgForNextBtn = [[UIImageView alloc]init];
    bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
    bgForNextBtn.layer.cornerRadius = 5;
    bgForNextBtn.layer.masksToBounds = YES;
    bgForNextBtn.frame = CGRectMake(20, 505, 280, 40);
    bgForNextBtn.userInteractionEnabled = YES;
    [self.view addSubview:bgForNextBtn];
    
    nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
    nextStepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStepBtn.frame = CGRectMake(20, 505, 280, 40);
    [nextStepBtn addTarget:self action:@selector(nextStepBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    
}

/*
 **注册：当识别为手机登陆的时候，需要发送验证码到手机
 **将手机获取到的验证码填写在文本框上验证通过后，才能点击下一步按钮
 **暂时因为手机验证码没有，验证的api不走
 **在下一步之前先检查该号码或者邮箱是否注册过：返回0，可以继续；返回1，不行已经注册过
 */
#pragma mark - Button Pressed
//下一步按钮点击事件
- (void)nextStepBtnPressed{
    
    //电话或者邮箱  账号和密码  验证码
    NSString *mobileString = [registerView.mobileOrMailField text];
    NSString *accoutPwdString = [registerView.accountOrPwdField text];
    NSString *confirmCodeString = [registerView.inputConfirmCodeField text];//验证码
    
    PEDisRegisterForPetViewController *petView = [[PEDisRegisterForPetViewController alloc]init];
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSRange range = [mobileString rangeOfString:@"@"];
    //如果包含@,判断是否为邮箱
    if(range.location !=NSNotFound)
    {
        //邮箱合法 --------- 邮箱至少为6位
        if ([Common regexer:mobileString rx_matchesPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"])
        {
            //密码长度限制
            if(accoutPwdString.length<6){
                [Common commonAlertShowWithTitle:@"密码的长度必须不少于6个字符" Message:nil];
                return;
            }
            
            NSString *emailString = [registerView.mobileOrMailField text];
            NSDictionary *userInfo = @{@"userMobilePhoneNumber":@"",
                                       @"userEmailAddress":emailString
                                      };
            NSMutableDictionary *request =[[NSMutableDictionary alloc] initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            
            [[PENetWorkingManager sharedClient]confirmUser:request completion:^(NSDictionary *result, NSError *error) {
                if(result)
                {
                    NSLog(@"%@",result);
                    NSString *string = [result objectForKey:@"result"];
                    if([string integerValue]==1)
                    {
                        [Common commonAlertShowWithTitle:@"该邮箱已经被注册！" Message:nil];
                    }
                    else if ([string integerValue]==0)
                    {
                        //进入登录第四步奏:传号码和密码
                        petView.passWordString = accoutPwdString;
                        petView.phoneNumberString = @"";
                        petView.emailAdress = emailString;
                        [self.navigationController pushViewController:petView animated:YES];
                        NSLog(@"输入的是邮箱");
                    }
                }
                else
                {
                    NSLog(@"%@",error);
                }
            }];
        }
        else
        {
            [Common commonAlertShowWithTitle:@"请输入正确的邮箱！" Message:nil];
        }
        
        
    }
    //不包含@
    else
    {
        //首先判断是不是合法的电话号码
        if([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX])
           {
               if(accoutPwdString.length<6){
                   [Common commonAlertShowWithTitle:@"密码长度必须不少于6位" Message:nil];
                   return;
               }
               
               NSDictionary *userInfo = @{@"userMobilePhoneNumber":mobileString,
                                          @"userEmailAddress":@"",
                                          };
               NSMutableDictionary *request =[[NSMutableDictionary alloc] initWithDictionary:appInfo];
               [request setObject:userInfo forKey:@"userInfo"];
               
               [[PENetWorkingManager sharedClient]confirmUser:request completion:^(NSDictionary *result, NSError *error) {
                   if(result)
                   {
                       NSLog(@"%@",result);
                       NSString *string = [result objectForKey:@"result"];
                       if([string integerValue]==1)
                       {
                           [Common commonAlertShowWithTitle:@"该电话已经被注册！" Message:nil];
                       }
                       else if ([string integerValue]==0)
                       {
                           //进入登录第四步奏:传号码和密码
                           petView.passWordString = accoutPwdString;
                           petView.phoneNumberString = mobileString;
                           petView.emailAdress = @"";
                           [self.navigationController pushViewController:petView animated:YES];
                           NSLog(@"输入的是邮箱");
                       }
                   }
                   else
                   {
                       NSLog(@"%@",error);
                   }
               }];

           }
        else
        {
          [Common commonAlertShowWithTitle:@"请输入正确的电话号码！" Message:nil];
        }
        
    }
   
    

    

    
    
    
    
    
    
    
    
    
    
//    NSDictionary *userInfo =@{@"userMobilePhoneNumber":mobileString,
//                              @"userRegisterKey":confirmCodeString,
//                              };

    
    //检验验证码通过后才能进入到下一步的注册信息填写
//    [[PENetWorkingManager sharedClient]confirmConfirmCode:request completion:^(NSDictionary *result, NSError *error) {
//        if(result){
//            NSLog(@"check confirmCode====%@",result);
//            
//            NSString *resultSrting = [result objectForKey:@"result"];
//            
//            NSRange range = [mobileString rangeOfString:@"@"];
//            if(range.location !=NSNotFound){//如果包含@字符，判断是否是邮箱
//                if ([Common isValidateEmail:mobileString]){
//                    //进入登录第四步奏:传号码和密码
//                    petView.passWordString = accoutPwdString;
//                    petView.phoneNumberString = mobileString;
//                    [self.navigationController pushViewController:petView animated:YES];
//                    NSLog(@"输入的是邮箱");
//                }else{
//                    [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的邮箱"];
//                }
//            }else{//如果不包含@，判断是否为电话：电话至少为11位，并且密码不少于6位,验证码不少于6位
//                
//                if([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX] && accoutPwdString.length !=0 &&accoutPwdString.length >=6 && [resultSrting integerValue]==0){
//                    
//                    //进入登录第四步奏:传号码和密码
//                    petView.passWordString = accoutPwdString;
//                    petView.phoneNumberString = mobileString;
//                    [self.navigationController pushViewController:petView animated:YES];
//                    NSLog(@"输入的是电话");
//                }else if([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX] && accoutPwdString.length !=0 &&accoutPwdString.length >=6 && [resultSrting integerValue] == 1){
//                    [Common commonAlertShowWithTitle:@"失败" Message:@"该号码已经注册过"];
//                }else{
//                    [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的电话号码"];
//
//                }
//                
//            }
//
//            
//        }else{
//            NSLog(@"%@",error);
//            [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的验证码"];
//        }
//    }];
    

    
//    NSRange range = [mobileString rangeOfString:@"@"];
//    if(range.location !=NSNotFound){//如果包含@字符，判断是否是邮箱
//        if ([Common isValidateEmail:mobileString]){
//
//            petView.passWordString = accoutPwdString;
//            petView.phoneNumberString = mobileString;
//            [self.navigationController pushViewController:petView animated:YES];
//            NSLog(@"输入的是邮箱");
//        }else{
//            [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的邮箱"];
//        }
//    }else{//如果不包含@，判断是否为电话：电话至少为11位，并且密码不少于6位,验证码不少于6位
//        if([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX] && accoutPwdString.length !=0 &&accoutPwdString.length >=6){
//            
//            //进入登录第四步奏:传号码和密码
//            petView.passWordString = accoutPwdString;
//            petView.phoneNumberString = mobileString;
//            [self.navigationController pushViewController:petView animated:YES];
//            NSLog(@"输入的是电话");
//        }else{
//            [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的电话号码"];
//        }
//        
//    }

//    //填写的手机号合乎规范 密码不为空 验证码至少6位
//    if ([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX] &&accoutString.length !=0 &&confirmCodeString.length >=6){
//        registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"5cbccb"];
//        registerView.senConfirmCodeLabel.text = @"重发验证码（50）";
//        registerView.haveSendConfirmCodeLabel.frame = CGRectMake(20, 251, 94, 12);
//        registerView.haveSendConfirmCodeLabel.text = @"验证码已经发送到";
//        registerView.phoneNumberLabel.frame = CGRectMake(118, 250, 120, 12);
//        registerView.phoneNumberLabel.text = [NSString stringWithFormat:@"(+86) %@",mobileString];
//        NSLog(@"下一步");
//    }else{
////        [Common commonAlertShowWithTitle:@"失败" Message:@"请输入正确的电话号码"];
//    }
   
//    //进入登录第四步奏:传号码和密码
//    PEDisRegisterForPetViewController *petView = [[PEDisRegisterForPetViewController alloc]init];
//    [self.navigationController pushViewController:petView animated:YES];
    
}

//生成验证码
//发送验证码按钮点击事件:点击该按钮后，系统会返回一个验证码到注册的手机号上
- (void)sendConfirmCodeBtnPressed{

    NSString *mobileString = [registerView.mobileOrMailField text];
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *userInfo =@{@"userMobilePhoneNumber":mobileString,
                              };
    
    NSMutableDictionary *request =[[NSMutableDictionary alloc] initWithDictionary:appInfo];
    [request setObject:userInfo forKey:@"userInfo"];
    
    [[PENetWorkingManager sharedClient]sendConfirmCode:request completion:^(NSDictionary *result, NSError *error) {
        if(result){
            NSLog(@"%@",result);
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
//验证码发送成功，会显示提示发送到注册填写的手机号

//    registerView.haveSendConfirmCodeLabel.text = @"验证码已经发送到";
//    registerView.phoneNumberLabel.frame = CGRectMake(118, 250, 120, 12);
//    registerView.phoneNumberLabel.text = [NSString stringWithFormat:@"(+86) %@",mobileString];
    
}

#pragma mark -TextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSString *mobileString = [registerView.mobileOrMailField text];
//    NSString *accoutPwdString = [registerView.accountOrPwdField text];
//    if(mobileString.length>=11){
//        registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"5cbccb"];
//        registerView.senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"ffffff"];
//    }
//    if(mobileString.length<11)
//    {
//        registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"#d2d2cf"];
//        registerView.senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
//    }
//    
//    
//}

//手机和密码文本框编辑完成，发送验证码文本框变亮，提示用户取点击生成验证码
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *mobileString = [registerView.mobileOrMailField text];
    NSString *accoutPwdString = [registerView.accountOrPwdField text];
    
    if(mobileString.length <11 || accoutPwdString.length <6)
    {
        registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"#d2d2cf"];
        registerView.senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
        bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
        [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
    }
    NSRange range = [mobileString rangeOfString:@"@"];
    //没有@字符
    if(range.location ==NSNotFound)
    {
       //如果是电话
       if([Common regexer:mobileString rx_matchesPattern:CELL_NUMBER_REGEX] ){

        registerView.bgForConfirmCodeBtn.alpha = 1.0f;
        registerView.bgForConfirmCodeField.alpha = 1.0f;
        registerView.inputConfirmCodeField.alpha = 1.0f;
        registerView.senConfirmCodeLabel.alpha = 1.0f;
        registerView.sendConfirmCodeBtn.alpha = 1.0f;
        registerView.bgView.frame = CGRectMake(0, 0, ScreenWidth, 295);
        if(accoutPwdString.length >=6 &&mobileString.length >=11){
            registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"5cbccb"];
            registerView.senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"ffffff"];
            bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#ee8d59"];
            [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        }else if(mobileString.length <11 || accoutPwdString.length <=6)
        {
            registerView.bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"#d2d2cf"];
            registerView.senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
            bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
            [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
        }
      }
    }
    //只要包含@字符，就隐藏下面的部分
    else{
        
        registerView.bgForConfirmCodeBtn.alpha = 0.0f;
        registerView.bgForConfirmCodeField.alpha = 0.0f;
        registerView.inputConfirmCodeField.alpha = 0.0f;
        registerView.senConfirmCodeLabel.alpha = 0.0f;
        registerView.sendConfirmCodeBtn.alpha = 0.0f;
        registerView.bgView.frame = CGRectMake(0, 0, ScreenWidth, 200);
        if([Common regexer:mobileString rx_matchesPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] && accoutPwdString.length>=6)
        {
            bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#ee8d59"];
            [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        }else
        {
             bgForNextBtn.backgroundColor = [UIHelper colorWithHexString:@"#b2b2b2"];
            [nextStepBtn setTitleColor:[UIHelper colorWithHexString:@"#898989"] forState:UIControlStateNormal];
        }

        
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [registerView.mobileOrMailField resignFirstResponder];
    [registerView.accountOrPwdField resignFirstResponder];
    [registerView.inputConfirmCodeField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [registerView.mobileOrMailField resignFirstResponder];
    [registerView.accountOrPwdField resignFirstResponder];
    [registerView.inputConfirmCodeField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
