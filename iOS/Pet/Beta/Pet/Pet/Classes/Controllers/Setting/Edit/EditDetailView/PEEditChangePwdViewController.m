//
//  PEEditChangePwdViewController.m
//  Pet
//
//  Created by Wu Evan on 8/7/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEEditChangePwdViewController.h"

@interface PEEditChangePwdViewController ()

@end

@implementation PEEditChangePwdViewController

@synthesize myNewPasswordText, myOldPasswordText, myConfirmPasswordText;

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
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"root_nav_top_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    if (self.title.length !=0) {
        titleLabel.text=self.title;
    } else {
        titleLabel.text=@"更改名称";
    }
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    UIBarButtonItem *saveInfoBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBtnPressed)];
    saveInfoBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveInfoBtn;
    
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    //旧密码
    myOldPasswordText = [[UITextField alloc]init];
    myOldPasswordText.frame = CGRectMake(10, 76, 300, 32);
    myOldPasswordText.placeholder = @"请输入旧密码";
    myOldPasswordText.font = [UIFont systemFontOfSize:15];
    myOldPasswordText.textColor = [UIColor blackColor];
    myOldPasswordText.secureTextEntry =YES;
    myOldPasswordText.delegate = self;
    [self.view addSubview:myOldPasswordText];
    
    UIView *gapLine1 = [[UIView alloc]init];
    gapLine1.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    gapLine1.frame = CGRectMake(10, 108, 300, 1);
    [self.view addSubview:gapLine1];
    
    //新密码
    myNewPasswordText = [[UITextField alloc]init];
    myNewPasswordText.frame = CGRectMake(10, 120, 300, 32);
    myNewPasswordText.placeholder = @"请输入新密码";
    myNewPasswordText.font = [UIFont systemFontOfSize:15];
    myNewPasswordText.textColor = [UIColor blackColor];
    myNewPasswordText.secureTextEntry =YES;
    myNewPasswordText.delegate = self;
    [self.view addSubview:myNewPasswordText];
    
    UIView *gapLine2 = [[UIView alloc]init];
    gapLine2.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    gapLine2.frame = CGRectMake(10, 152, 300, 1);
    [self.view addSubview:gapLine2];
    
    //确认密码
    myConfirmPasswordText = [[UITextField alloc]init];
    myConfirmPasswordText.frame = CGRectMake(10, 164, 300, 32);
    myConfirmPasswordText.placeholder = @"再次确认新密码";
    myConfirmPasswordText.font = [UIFont systemFontOfSize:15];
    myConfirmPasswordText.textColor = [UIColor blackColor];
    myConfirmPasswordText.secureTextEntry =YES;
    myConfirmPasswordText.delegate = self;
    [self.view addSubview:myConfirmPasswordText];
    
    UIView *gapLine3 = [[UIView alloc]init];
    gapLine3.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    gapLine3.frame = CGRectMake(10, 196, 300, 1);
    [self.view addSubview:gapLine3];
    
    [myOldPasswordText becomeFirstResponder];
}

- (void)sendBtnPressed {
    if (![myOldPasswordText.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]]) {
        [Common showAlert:@"旧密码输入错误！"];
        return;
    }
    if (myNewPasswordText.text.length >=6 && [myNewPasswordText.text isEqualToString:myConfirmPasswordText.text]) {
        if([Common regexer:myNewPasswordText.text rx_matchesPattern:@"\\s{1,}"]) {
            [Common showAlert:@"密码中不能包含非法字符!"];
        }else {
            NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
            NSDictionary *userInfo =@{@"userOldPW": [Common md5:myOldPasswordText.text],
                                      @"userNewPW": [Common md5:myNewPasswordText.text],
                                      @"userID": [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_ID]
                                      };
            NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            
            [[PENetWorkingManager sharedClient] editChangeUserPassword:request completion:^(NSDictionary *results, NSError *error) {
                if (results) {
                    //                NSLog(@"%@", results);
                    [Common showAlert:@"修改成功！"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    //                NSLog(@"%@", error);
                    [Common showAlert:@"修改失败！"];
                }
            }];
            
        }
        
        
    }else if (myNewPasswordText.text.length <6) {
        [Common showAlert:@"密码请大于6位"];
    }else {
        [Common showAlert:@"两次密码请输入一致"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField ==myOldPasswordText) {
        [myNewPasswordText becomeFirstResponder];
    }else if (textField ==myNewPasswordText){
        [myConfirmPasswordText becomeFirstResponder];
    }else {
        [myConfirmPasswordText resignFirstResponder];
    }
    return YES;
}

@end
