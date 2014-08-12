//
//  PEEditDetailViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-29.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEEditDetailViewController.h"
#import "UIHelper.h"
@interface PEEditDetailViewController ()

@end

@implementation PEEditDetailViewController
@synthesize myTextField,remainLabel,infomationString;
@synthesize dic,tag,selectSection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dic = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"root_nav_top_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=@"更改名称";
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
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI{
    
    myTextField = [[UITextField alloc]init];
    myTextField.frame = CGRectMake(10, 100, 300, 15);
    myTextField.placeholder = infomationString;
    myTextField.font = [UIFont systemFontOfSize:15];
    myTextField.textColor = [UIColor blackColor];
    myTextField.delegate = self;
    [self.view addSubview:myTextField];
    
    UIView *gapLine = [[UIView alloc]init];
    gapLine.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    gapLine.frame = CGRectMake(10, 126, 300, 1);
    [self.view addSubview:gapLine];
    
    remainLabel = [[UILabel alloc]init];
    remainLabel.textColor = [UIHelper colorWithHexString:@"#aaaaaa"];
    remainLabel.font = [UIFont systemFontOfSize:14];
    remainLabel.frame = CGRectMake(10, 140, 200, 14);
    remainLabel.text = @"输入您更改的名称";
    [self.view addSubview:remainLabel];
    
    [myTextField becomeFirstResponder];
}


- (void)sendBtnPressed{
    
    if (myTextField.text.length >15) {
        [Common showAlert:@"输入的字符应小于15"];
        return ;
    }
    
    if ([Common regexer:myTextField.text rx_matchesPattern:@"\\s{1,}"]) {
        [Common showAlert:@"输入的信息中包含非法字符"];
        return ;
    }
    
    NSString *tempUserID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    
    switch (tag) {
        case 0://=========修改userName
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":myTextField.text,
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":[dic objectForKey:EDIT_INFO_USER_DESCRIPTION]
                                       };
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":[petDic objectForKey:EDIT_INFO_PETSITE],
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserNameSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            

        
            break;
        }
    
            
        case 1://===============修改个人签名
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":myTextField.text,
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":[dic objectForKey:EDIT_INFO_USER_DESCRIPTION]
                                       };
            
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":[petDic objectForKey:EDIT_INFO_PETSITE],
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserSignSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            
            break;
        }
            
        case 2:
            //修改更多说明
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":myTextField.text
                                       };
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":[petDic objectForKey:EDIT_INFO_PETSITE],
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserMoreInfoSuccess" object:myTextField.text];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            
            
            
            break;
        }
            
        case 3://==================修改宠物名字
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":[dic objectForKey:EDIT_INFO_USER_DESCRIPTION]
                                       };
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":myTextField.text,
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":[petDic objectForKey:EDIT_INFO_PETSITE],
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editPetSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePetNameSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            break;
        }
            
            
        case 4://修改宠物爱好
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":[dic objectForKey:EDIT_INFO_USER_DESCRIPTION]
                                       };
            
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":myTextField.text,
                                      @"petSite":[petDic objectForKey:EDIT_INFO_PETSITE],
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editPetSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePetFavSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            break;
        }
            
        case 5:
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"userDescription":[dic objectForKey:EDIT_INFO_USER_DESCRIPTION]
                                       };
            
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":myTextField.text,
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editPetSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePetsiteSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            
            break;
        }
        

            
        case 10:
        {
            NSDictionary *userInfo = @{@"userID":tempUserID,
                                       @"userName":[dic objectForKey:EDIT_INFO_USERNAME],
                                       @"userSign":[dic objectForKey:EDIT_INFO_USER_SIGN],
                                       @"userSex":[dic objectForKey:EDIT_INFO_USER_SEX],
                                       @"userBirthday":[dic objectForKey:EDIT_INFO_USER_BIRTHDAY],
                                       @"descripetion": myTextField.text
                                       };
            
            //按照是第几个宠物来
            NSMutableArray *dataArray = [dic objectForKey:@"petsList"];
            NSMutableDictionary *petDic = [dataArray objectAtIndex:selectSection];
            NSDictionary *petInfo = @{@"petID":[petDic objectForKey:EDIT_INFO_PETID],
                                      @"petName":[petDic objectForKey:EDIT_INFO_PETNAME],
                                      @"petSex":[petDic objectForKey:EDIT_INFO_PET_SEX],
                                      @"petBirthday":[petDic objectForKey:EDIT_INFO_PET_BIRTHDAY],
                                      @"petNickName":[petDic objectForKey:EDIT_INFO_PETNICKNAME],
                                      @"petType":[petDic objectForKey:EDIT_INFO_PETTYPE],
                                      @"petSubType":[petDic objectForKey:EDIT_INFO_PETSUBTYPE],
                                      @"petWantedType":[petDic objectForKey:EDIT_INFO_PETWANTEDTYPE],
                                      @"petFavorite":[petDic objectForKey:EDIT_INFO_PETFAVORITE],
                                      @"petSite":myTextField.text,
                                      };
            
            NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
            [request setObject:userInfo forKey:@"userInfo"];
            [request setObject:petInfo forKey:@"petInfo"];
            
            [[PENetWorkingManager sharedClient]editPetSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
                if(results){
                    
                    NSLog(@"%@",results);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePetsiteSuccess" object:myTextField.text];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    NSLog(@"%@",error);
                }
            }];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [myTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    myTextField.text =  textField.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [myTextField resignFirstResponder];
        return NO;
    }
    
    if([string length]>0) {
        if (myTextField.text.length >15) {
            [Common showAlert:@"字数不能超过15"];
        }
        return [[myTextField text] length]<15;
    }
    return YES;
}

@end
