//
//  PECreateDetailViewController.m
//  Pet
//
//  Created by Wu Evan on 7/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PECreateDetailViewController.h"

@interface PECreateDetailViewController ()

@end

@implementation PECreateDetailViewController

@synthesize photoSV;
@synthesize groupInfo, groupName, groupSite;
@synthesize nameText, infoText, infoLbl, createBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        groupSite =[[NSString alloc] init];
        groupName =[[NSString alloc] init];
        groupInfo =[[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createGroupSucc) name:CREATE_GROUP_SUCC object:nil];
    
    //修改背景
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    //修改标题
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(CONSTACT_CREATE_GROUP_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //设置UI
    [self setupUI];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    photoSV.esDelegate =self;
    nameText.delegate =self;
    infoText.delegate =self;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    photoSV.esDelegate =nil;
    nameText.delegate =nil;
    infoText.delegate =nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupUI {
    //设置照片
    photoSV = [[PEEditPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, 97.0f) AndData:[[NSArray alloc] init] AndImageIDData:nil];
    
    //设置透明背景
    UIImageView *alphaBg =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 161.0f, ScreenWidth, 255.0f)];
    [alphaBg setBackgroundColor:[UIHelper colorWithHexString:@"#ffffff"]];
    alphaBg.alpha =0.6f;
    
    //设置群地点
    UILabel *site =[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 186.0f, 60.0f, 40.0f)];
    site.textColor =[UIHelper colorWithHexString:@"#727f81"];
    site.font =[UIFont systemFontOfSize:14.0f];
    site.text =@"群地点";
    
    UIImageView *siteBg =[[UIImageView alloc] initWithFrame:CGRectMake(80.0f, 186.0f, 228.0f, 40.0f)];
    [siteBg setBackgroundColor:[UIColor whiteColor]];
    siteBg.layer.cornerRadius =5.0f;
    siteBg.clipsToBounds =YES;
    
    UILabel *siteText =[[UILabel alloc] initWithFrame:CGRectMake(97.0f, 186.0f, 211.0f, 40.0f)];
    siteText.textColor =[UIHelper colorWithHexString:@"#000000"];
    siteText.font =[UIFont systemFontOfSize:12.0f];
    siteText.text =groupSite;
    
    
    //设置群名称
    UILabel *name =[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 231.5f, 60.0f, 40.0f)];
    name.textColor =[UIHelper colorWithHexString:@"#727f81"];
    name.font =[UIFont systemFontOfSize:14.0f];
    name.text =@"群名称";
    
    UIImageView *nameBg =[[UIImageView alloc] initWithFrame:CGRectMake(80.0f, 231.5f, 228.0f, 40.0f)];
    [nameBg setBackgroundColor:[UIColor whiteColor]];
    nameBg.layer.cornerRadius =5.0f;
    nameBg.clipsToBounds =YES;
    
    nameText =[[UITextField alloc] initWithFrame:CGRectMake(97.0f, 231.5f, 211.0f, 40.0f)];
    nameText.textColor =[UIHelper colorWithHexString:@"#000000"];
    [nameText setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入群名称，最多10个字符"
                                                                       attributes:@{NSForegroundColorAttributeName:[UIHelper colorWithHexString:@"#bcbcbc"]}]];
    nameText.font =[UIFont systemFontOfSize:12.0f];
    
    //设置横线
    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 293.0f, 300.0f, 1.0f)];
    [line setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#9fccd5"]]];
    
    //设置群介绍
    UILabel *info =[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 316.0f, 60.0f, 40.0f)];
    info.textColor =[UIHelper colorWithHexString:@"#727f81"];
    info.font =[UIFont systemFontOfSize:14.0f];
    info.text =@"群介绍";
    
    UIImageView *infoBg =[[UIImageView alloc] initWithFrame:CGRectMake(80.0f, 314.0f, 228.0f, 82.0f)];//80.0f, 316.0f, 228.0f, 75.0f
    [infoBg setBackgroundColor:[UIColor whiteColor]];
    infoBg.layer.cornerRadius =5.0f;
    infoBg.clipsToBounds =YES;
    
    infoText =[[UITextView alloc] initWithFrame:CGRectMake(90.0f, 320.0f, 209.0f, 75.0f)];//90.0f, 320.0f, 211.0f, 75.0f
    infoText.backgroundColor =[UIColor clearColor];
    infoText.textColor =[UIHelper colorWithHexString:@"#000000"];
    infoText.font =[UIFont systemFontOfSize:13.0f];
    
    infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(97.0f, 323.0f, 211.0f, 40.0f)];
    infoLbl.backgroundColor =[UIColor clearColor];
    infoLbl.enabled =NO;
    infoLbl.textColor =[UIHelper colorWithHexString:@"#bcbcbc"];
    infoLbl.font =[UIFont systemFontOfSize:12.0f];
    infoLbl.numberOfLines =0;
    infoLbl.lineBreakMode =NSLineBreakByCharWrapping;
    infoLbl.text =@"请输入加群要求， 或详细的群主题说明，15-300个字符";
    
    //设置创建按钮
    createBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [createBtn setTitle:@"提交创建" forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#ee8d59"]] forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#c4c4c4"]] forState:UIControlStateSelected];
    [createBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    createBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    createBtn.frame = CGRectMake(20, 505, 280, 40);
    [createBtn addTarget:self action:@selector(createBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //添加views
    [self.view addSubview:photoSV];
    [self.view addSubview:alphaBg];
    
    [self.view addSubview:site];
    [self.view addSubview:siteBg];
    [self.view addSubview:siteText];
    
    [self.view addSubview:name];
    [self.view addSubview:nameBg];
    [self.view addSubview:nameText];
    
    [self.view addSubview:line];
    
    [self.view addSubview:info];
    [self.view addSubview:infoBg];
    [self.view addSubview:infoText];
    [self.view addSubview:infoLbl];
    
    [self.view addSubview:createBtn];
}

#pragma mark -
#pragma mark BUTTON ACTION
- (void)hideKeyBoard:(id)sender {
    [nameText resignFirstResponder];
    [infoText resignFirstResponder];
}

- (void)createBtnPressed {
    if (nameText.text !=0 && infoText.text !=0) {
//        [[PEXMPP sharedInstance] createGroup:nameText.text];
        
        //创建群组
        NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
        NSDictionary *chatInfo =@{@"name": nameText.text,
                                  @"jid": [NSString stringWithFormat:@"%@@%@", nameText.text, xmppDomain],
                                  @"description": infoText.text,
                                  @"site": groupSite};
        NSArray *photo =[[NSArray alloc] init];
        
        NSMutableDictionary *request =[[NSMutableDictionary alloc] initWithDictionary:appInfo];
        [request setObject:chatInfo forKey:REQUEST_KEY_CREATE_GROUP_INFO];
        
        [[PENetWorkingManager sharedClient] newRoom:request data:photo completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                [Common showAlert:@"创建成功, 请等待审核"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                
                [Common showAlert:@"创建失败，请稍后再试"];
            }
        }];
        
    } else {
        [Common showAlert:@"请填写完整信息"];
    }
}

- (void)createGroupSucc {
    [[PEXMPP sharedInstance].room changeNickname:nameText.text];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark EditScrollerView Delegate
/**
 *添加图片
 */
- (void)addBtnSelected {
    [Common showAlert:@"添加群组图片（开发中）"];
}

#pragma mark -
#pragma mark KeyBoard Notification
- (void)keyWillShow:(NSNotification*)notification{
    
}

- (void)keyWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [self.view setFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [nameText resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(nameText.text.length > 10){
        [Common showAlert:@"不能超过10字"];
        return;
    }
    
}


#pragma mark -
#pragma mark UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    infoLbl.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [self.view setFrame:CGRectMake(0.0f, -85.0f, ScreenWidth, ScreenHeight)];
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView
{
    infoText.text =  textView.text;
    if (textView.text.length == 0) {
        infoLbl.text = @"请输入加群要求， 或详细的群主题说明，15-300个字符";
    }else {
        infoLbl.text = @"";

    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    
    if([text length]>0) {
        return [[textView text] length]<300;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    infoText.text =  textView.text;
    if (textView.text.length == 0) {
        infoLbl.text = @"请输入加群要求， 或详细的群主题说明，15-300个字符";
    }else{
        infoLbl.text = @"";
        if(infoText.text.length <15){
            [Common showAlert:@"至少15个字"];
        }
        if(infoText.text.length >300){
            [Common showAlert:@"最多300个字"];
        }
    }
}
@end
