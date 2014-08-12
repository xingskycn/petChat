//
//  PEDisRegisterView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-10.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisRegisterView.h"
#import "UIHelper.h"
@implementation PEDisRegisterView
@synthesize loginInfoLabel,mobileOrMailField,accountOrPwdField;
@synthesize inputConfirmCodeField,sendConfirmCodeBtn;
@synthesize bgForConfirmCodeBtn;
@synthesize haveSendConfirmCodeLabel,phoneNumberLabel;
@synthesize senConfirmCodeLabel,bgForConfirmCodeField;
@synthesize bgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    
    //底下白色大背景
    bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgView.alpha = 0.6;
    bgView.frame = CGRectMake(0, 0, ScreenWidth, 245);//0, 0, ScreenWidth, 295
    [self addSubview:bgView];
    
    
    
    loginInfoLabel = [[UILabel alloc]init];
    loginInfoLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    loginInfoLabel.font = [UIFont systemFontOfSize:14];
    loginInfoLabel.text = @"登录信息";
    loginInfoLabel.frame = CGRectMake(10, 8.5, 100, 14);
    [self addSubview:loginInfoLabel];
    
    UIImageView *bgForMoblieField = [[UIImageView alloc]init];
    bgForMoblieField.layer.cornerRadius = 5;
    bgForMoblieField.layer.masksToBounds = YES;
    bgForMoblieField.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForMoblieField.frame = CGRectMake(20, 34.5, 280, 40);
    bgForMoblieField.userInteractionEnabled = YES;
    [self addSubview:bgForMoblieField];
    
    //手机邮箱
    mobileOrMailField = [[UITextField alloc]init];
    mobileOrMailField.textColor = [UIColor blackColor];
    mobileOrMailField.font = [UIFont systemFontOfSize:14];
    UIColor *color = [UIHelper colorWithHexString:@"#a3a3a3"];
    mobileOrMailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写您的手机/邮箱"
                                                                       attributes:@{NSForegroundColorAttributeName: color}];
    mobileOrMailField.frame = CGRectMake(40, 47.5, 260, 14);
    [self addSubview:mobileOrMailField];
    
    UIView *gapViewOne = [[UIView alloc]init];
    gapViewOne.backgroundColor = [UIHelper colorWithHexString:@"#9fccd5"];
    gapViewOne.frame = CGRectMake(10, 85, 300, 1);
    [self addSubview:gapViewOne];
    
    UIImageView *bgForAccountField = [[UIImageView alloc]init];
    bgForAccountField.layer.cornerRadius = 5;
    bgForAccountField.layer.masksToBounds = YES;
    bgForAccountField.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    bgForAccountField.frame = CGRectMake(20, 96, 280, 40);
    bgForAccountField.userInteractionEnabled = YES;
    [self addSubview:bgForAccountField];
    
    //账号密码
    accountOrPwdField = [[UITextField alloc]init];
    accountOrPwdField.textColor = [UIColor blackColor];
    accountOrPwdField.font = [UIFont systemFontOfSize:14];
    accountOrPwdField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"填写账号密码(不少于6个字符)" attributes:@{NSForegroundColorAttributeName:color}];
    accountOrPwdField.secureTextEntry = YES;
    accountOrPwdField.frame = CGRectMake(40, 110, 260, 14);
    [self addSubview:accountOrPwdField];
    
    UILabel *remainInfoLabel = [[UILabel alloc]init];
    remainInfoLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    remainInfoLabel.font = [UIFont systemFontOfSize:11.5];
    remainInfoLabel.numberOfLines = 0;
    remainInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    remainInfoLabel.text = @"为保护您的账号安全，请勿设置过于简单的密码，宠遇不会在任何地方泄露您的手机和邮箱";
    CGSize sizeRI = [remainInfoLabel.text sizeWithFont:[UIFont systemFontOfSize:11.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    remainInfoLabel.frame = CGRectMake(20, 148.5, 280, sizeRI.height);
    remainInfoLabel.alpha = 1.0f;
    [self addSubview:remainInfoLabel];
    
    UIView *gapViewTwo = [[UIView alloc]init];
    gapViewTwo.backgroundColor = [UIHelper colorWithHexString:@"#9fccd5"];
    gapViewTwo.frame = CGRectMake(10, 187, 300, 1);
    gapViewTwo.alpha = 1.0f;
    [self addSubview:gapViewTwo];
    
    
    //输入验证码的背景
    bgForConfirmCodeField = [[UIImageView alloc]init];
    bgForConfirmCodeField.layer.cornerRadius = 5;
    bgForConfirmCodeField.layer.masksToBounds = YES;
    bgForConfirmCodeField.backgroundColor = [UIHelper colorWithHexString:@"#d2d2cf"];
    bgForConfirmCodeField.frame = CGRectMake(20, 200, 130, 40);
    bgForConfirmCodeField.userInteractionEnabled = YES;
    bgForAccountField.alpha = 1.0f;
//    [self addSubview:bgForConfirmCodeField];
    
    
    //发送验证码的背景
    bgForConfirmCodeBtn = [[UIImageView alloc]init];
    bgForConfirmCodeBtn.layer.cornerRadius = 5;
    bgForConfirmCodeBtn.layer.masksToBounds = YES;
    bgForConfirmCodeBtn.backgroundColor = [UIHelper colorWithHexString:@"#d2d2cf"];
    bgForConfirmCodeBtn.frame = CGRectMake(170, 200, 130, 40);
    bgForConfirmCodeBtn.userInteractionEnabled = YES;
    bgForConfirmCodeBtn.alpha = 1.0f;
//    [self addSubview:bgForConfirmCodeBtn];
    
    
    senConfirmCodeLabel = [[UILabel alloc]init];
    senConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"#a3a3a3"];
//    senConfirmCodeLabel.textColor = [UIColor redColor];
    senConfirmCodeLabel.font = [UIFont systemFontOfSize:14];
    senConfirmCodeLabel.text = @"发送验证码";
    CGSize sizeSC = [senConfirmCodeLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat x  = (130-sizeSC.width)/2;
    CGFloat y  = (40-sizeSC.height)/2;
    senConfirmCodeLabel.frame = CGRectMake(x+170, y+200, sizeSC.width, sizeSC.height);
    senConfirmCodeLabel.alpha = 1.0f;
//    [self addSubview:senConfirmCodeLabel];
    
    
    //发送验证码的button
    sendConfirmCodeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendConfirmCodeBtn.frame = CGRectMake(170, 200, 130, 40);
    sendConfirmCodeBtn.alpha = 1.0f;
//    [self addSubview:sendConfirmCodeBtn];
    
    
    //输入验证码文本框
    inputConfirmCodeField = [[UITextField alloc]init];
    inputConfirmCodeField.textColor = [UIColor blackColor];
    inputConfirmCodeField.font = [UIFont systemFontOfSize:14];
    
    inputConfirmCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入验证码"
                                                                              attributes:@{NSForegroundColorAttributeName: color}];
    CGSize sizeIC = [@"输入验证码" sizeWithFont:[UIFont systemFontOfSize:11.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    inputConfirmCodeField.frame = CGRectMake(47,y+200, sizeSC.width, sizeSC.height);
    inputConfirmCodeField.alpha = 1.0f;
//    [self addSubview:inputConfirmCodeField];
    
    //验证码已经发送到label
    haveSendConfirmCodeLabel = [[UILabel alloc]init];
    haveSendConfirmCodeLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    haveSendConfirmCodeLabel.font = [UIFont systemFontOfSize:11.5];
    haveSendConfirmCodeLabel.frame = CGRectMake(20, 251, 0, 0);
//    [self addSubview:haveSendConfirmCodeLabel];
    
    //(+86) 111111111111
    phoneNumberLabel = [[UILabel alloc]init];
    phoneNumberLabel.textColor = [UIHelper colorWithHexString:@"#ff5900"];
    phoneNumberLabel.font = [UIFont systemFontOfSize:11.5];
//    [self addSubview:phoneNumberLabel];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
