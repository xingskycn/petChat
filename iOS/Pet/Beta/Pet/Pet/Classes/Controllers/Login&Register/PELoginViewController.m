//
//  PELoginViewController.m
//  Pet
//
//  Created by Wu Evan on 6/17/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PELoginViewController.h"
#import "UIHelper.h"
#import "Animations.h"
#import "Common.h"
#import "PERegisterViewController.h"
#import "PEChatListViewController.h"
#import "PENetWorkingManager.h"
#import "PEMobile.h"
#import "PEXMPP.h"

@interface PELoginViewController ()

@end

@implementation PELoginViewController

@synthesize bgView, logoView, accountBgView, passwordBgView;
@synthesize loginBtn, registerBtn, forgetBtn;
@synthesize accountText, passwordText;

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden =YES;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [bgView setImage:[UIHelper imageName:@"login_bg"]];//背景
    [logoView setImage:[UIHelper imageName:@"login_logo"]];//
    [accountBgView setImage:[UIHelper imageName:@"login_account_bg"]];
    accountBgView.alpha = 0.8;
    [passwordBgView setImage:[UIHelper imageName:@"login_password_bg"]];
    passwordBgView.alpha = 0.8;
    
    accountText.placeholder =NSLocalizedString(ACCOUNT_TEXT, nil);
    accountText.delegate = self;
    passwordText.placeholder =NSLocalizedString(PASSWORD_TEXT, nil);
    passwordText.delegate = self;
    
    
    //登录按钮
    [loginBtn setBackgroundImage:[UIHelper imageName:@"login_btn"] forState:UIControlStateNormal];
    [loginBtn setTitle:NSLocalizedString(LOGIN_BTN_TITLE, nil) forState:UIControlStateNormal];
    loginBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"1fe3b6"];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];

    
    [registerBtn setBackgroundImage:[UIHelper imageName:@"login_register_btn"] forState:UIControlStateNormal];
    [registerBtn setTitle:NSLocalizedString(REGISTER_BTN_TITLE, nil) forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"ffffff"];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //忘记密码
    [forgetBtn setTitle:NSLocalizedString(FORGET_BTN_TITLE, nil) forState:UIControlStateNormal];
    forgetBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"ffffff"];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    forgetBtn.hidden = YES;
    
    //适配
    if (IS_IPhone_5) {
        [registerBtn setFrame:CGRectMake(213.0f, 455.0f, 87.0f, 37.0f)];
        [forgetBtn setFrame:CGRectMake(19.0f, 455.0f, 71.0f, 37.0f)];
    } else {
        [registerBtn setFrame:CGRectMake(213.0f, 390.0f, 87.0f, 37.0f)];
        [forgetBtn setFrame:CGRectMake(19.0f, 390.0f, 71.0f, 37.0f)];
    }
}

//登录按钮点击事件:登录成功，进入聊天聊表界面
- (IBAction)LoginBtnPressed:(id)sender {
    [accountText resignFirstResponder];
    [passwordText resignFirstResponder];
    NSString *accountString = accountText.text;
    NSString *passwordString = passwordText.text;
    NSString *emailString = accountText.text;
    
    if(accountString.length == 0){
        [Common commonAlertShowWithTitle:@"请输入账号!" Message:nil];
        return;
    }
    
    NSRange range = [accountString rangeOfString:@"@"];
    //如果是邮箱
    if(range.location !=NSNotFound)
    {
        if([Common regexer:emailString rx_matchesPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"])
        {
            if(passwordString.length == 0){
                [Common commonAlertShowWithTitle:@"请输入密码!" Message:nil];
                return;
            }
            
            if(passwordString.length<6 &&passwordString.length>0){
                [Common commonAlertShowWithTitle:@"密码输入错误!请重试!" Message:nil];
                return;
            }
        
           NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
           NSDictionary *userInfo = @{@"mobileNumber":@"",
                                   @"password":[Common md5:passwordString],//密码做简单的md5加密
                                   @"emailAddress":emailString,
                                   };
          NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
          [request setObject:userInfo forKey:LOGIN_INFO_KEY];
        
          [[PENetWorkingManager sharedClient]login:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSLog(@"%@",results);
                if ([[results objectForKey:@"result"] isEqualToString:@"0"]) {
                    //修改IS_LOGINED的值
                    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
                    [nd setBool:YES forKey:IS_LOGINED];
                    [nd synchronize];
                    
                    //登录成功保存userId
                    NSString *userID = [results objectForKey:USER_INFO_ID];
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:userID forKey:USER_INFO_ID];
                    [ud setObject:accountString forKey:MAILACCOUNT];
                    [ud setObject:@"" forKey:CELLACCOUNT];
                    [ud setObject:passwordString forKey:PASSWORD];
                    [ud synchronize];
                    
                    NSLog(@"登录成功");
                    //登录成功设置导航隐藏为no
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                    [[PEXMPP sharedInstance] login];
                    self.navigationController.navigationBarHidden =NO;
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                }else {
//                    [Common showAlert:[results objectForKey:@"errMsg"]];
                    [Common commonAlertShowWithTitle:@"登录失败！" Message:nil];
                }
            }else{
                NSLog(@"%@",error);
                [Common commonAlertShowWithTitle:@"登录失败！" Message:nil];

            }
        }];
        
        }
        else{//如果邮箱输入错误
            
            [Common commonAlertShowWithTitle:@"请输入正确的邮箱号！" Message:nil];
            
        }
    }else
    {
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"mobileNumber":accountString,
                                   @"password":[Common md5:passwordString],//密码做简单的md5加密
                                   @"emailAddress":@"",
                                   };
        NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
        [request setObject:userInfo forKey:LOGIN_INFO_KEY];
        NSLog(@"%@", request);
        //电话号码输入正确的情况下才能走登录api
        if ([Common regexer:accountText.text rx_matchesPattern:CELL_NUMBER_REGEX]) {
            
            if(passwordString.length ==0){
                [Common commonAlertShowWithTitle:@"请输入密码!" Message:nil];
                return;
            }
     
           if(passwordString.length<6 && passwordString.length>0){
                [Common commonAlertShowWithTitle:@"密码输入错误!请重试!" Message:nil];
                return;
            }
            
            [[PENetWorkingManager sharedClient]login:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    if ([[results objectForKey:@"result"] isEqualToString:@"0"]) {
                        //修改IS_LOGINED的值
                        NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
                        [nd setBool:YES forKey:IS_LOGINED];
                        
                        //登录成功保存userId
                        NSString *userID = [results objectForKey:USER_INFO_ID];
                        NSString *userName = [results objectForKey:USER_INFO_NAME];
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        [ud setObject:userID forKey:USER_INFO_ID];
                        [ud setObject:accountString forKey:CELLACCOUNT];
                        [ud setObject:@"" forKey:MAILACCOUNT];
                        [ud setObject:passwordString forKey:PASSWORD];
                        [ud setObject:userName forKey:USER_INFO_NAME];
                        
                        NSLog(@"登录成功");
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                        [[PEXMPP sharedInstance] login];
                        self.navigationController.navigationBarHidden =NO;
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
//                        [Common showAlert:[results objectForKey:@"errMsg"]];
                        [Common commonAlertShowWithTitle:@"登录失败!" Message:nil];
                    }
                }else{
                    NSLog(@"%@",error);
                    [Common commonAlertShowWithTitle:@"登录失败!" Message:nil];
                }
            }];
            
            
        } else {
            [Common commonAlertShowWithTitle:@"请输入正确的电话!" Message:nil];
        }
        
        
    }
    
}


//注册按钮点击事件
- (IBAction)registerBtnPressed:(id)sender{
    PERegisterViewController *registerView = [[PERegisterViewController alloc]initWithNibName:@"PERegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
}


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        [accountText resignFirstResponder];
        [passwordText resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, -30.0f , ScreenWidth, ScreenHeight);
        [UIView commitAnimations];
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, 0.0f , ScreenWidth, ScreenHeight);
        [UIView commitAnimations];
    
}








@end
