//
//  PERootViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PERootViewController.h"
#import "PELoginViewController.h"

typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;
@interface PERootViewController ()

@end

@implementation PERootViewController
@synthesize isLogin;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     near view navigation setting
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginoutSucc) name:@"LoginOut Succ" object:nil];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(NEAR_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *fliterBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(NEAR_FLITER_TITLE, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fliterBtnPressed:)];
    self.navigationItem.leftBarButtonItem =fliterBtn;
    
    //添加类型按钮
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST]) {
        UIBarButtonItem *typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_water_btn"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =typeBtn;
        
    } else {
        UIBarButtonItem *typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_list_btn"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =typeBtn;
        
    }
    
    
    [self _initViewController];
    [self _initTabbarView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HAS_USED]) {
        [self showIntroWithCrossDissolve];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_USED];
    }
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CREATE INTRO VIEW
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"PetChat 01";
//    page1.desc = @"Hello PetChat!";
    page1.bgImage = [UIImage imageNamed:@"ad1.png"];
    
    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"PetChat 02";
//    page2.desc = @"Hello PetChat!";
    page2.bgImage = [UIImage imageNamed:@"ad2.png"];
    
    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"PetChat 03";
//    page3.desc = @"Hello PetChat!";
    page3.bgImage = [UIImage imageNamed:@"ad3.png"];
    
    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"PetChat 04";
//    page4.desc = @"Hello PetChat!";
    page4.bgImage = [UIImage imageNamed:@"ad4.png"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    [intro.skipButton setHidden:YES];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

#pragma mark -- 创建试图控制器
-(void)_initViewController{
    PENearViewController *v1=[[PENearViewController alloc] initWithNibName:@"PENearViewController" bundle:nil];
    PEContactsViewController *v2=[[PEContactsViewController alloc] initWithNibName:@"PEContactsViewController" bundle:nil];
    PEDiscoverViewController *v3=[[PEDiscoverViewController alloc] initWithNibName:@"PEDiscoverViewController" bundle:nil];
    PEChatListViewController *v4=[[PEChatListViewController alloc] initWithNibName:@"PEChatListViewController" bundle:nil];
    PESettingEditViewController *v5=[[PESettingEditViewController alloc] initWithNibName:@"PESettingEditViewController" bundle:nil];
    
    v1.nearViewDelegate =self;//将委托交给当前控制器
    
    NSMutableArray *viewControllers=[NSMutableArray arrayWithCapacity:6];
    NSArray*views=@[v1,v2,v3,v4,v5];
    for (UIViewController *viewController in views) {
        [viewControllers addObject:viewController];
        
    }
    self.viewControllers = viewControllers;
}

//创建自定义tabBar--下面的工具栏
- (void)_initTabbarView {
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
    _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIHelper imageName:@"root_tabber_bttom_bg"]];
    
    [self.view addSubview:_tabbarView];
    
    
    NSArray *backgroud = @[@"root_tabber_near_btn",@"root_tabber_constact_btn",@"root_tabber_discover_btn",@"root_tabber_chat_btn",@"root_tabber_setting_btn"];
    
    NSArray *selectedBackground = @[@"root_tabber_near_btn_selected",@"root_tabber_constact_btn_selected",@"root_tabber_discover_btn_selected",@"root_tabber_chat_btn_selected",@"root_tabber_setting_btn_selected"];
    
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *selectedImage = selectedBackground[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIHelper imageName:backImage] forState:UIControlStateNormal];
        [button setImage:[UIHelper imageName:selectedImage] forState:UIControlStateSelected];
        button.frame = CGRectMake(i*64, 0, 64, 49);
        button.tag = i+101;
        if (i ==0) {
            button.selected =YES;
        }
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    
}

#pragma mark - 
#pragma mark BUTTON ACTION
//底部工具栏下面的五个按钮点击事件
- (void)selectedTab:(UIButton *)button {
    
//    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
//    if(isLogin == NO){
//        PELoginViewController *lCtr =[[PELoginViewController alloc] init];
//        lCtr.type =type_chat;
//        [self.navigationController pushViewController:lCtr animated:YES];
//        
//        
//    }
    
    //navigation title
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    
    //fliter button
    UIBarButtonItem *fliterBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(NEAR_FLITER_TITLE, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fliterBtnPressed:)];
    
    fliterBtn.tintColor =[UIColor whiteColor];
    
    //type button
    UIBarButtonItem *typeBtn =nil;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST]) {
        typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_water_btn"]
                                                 style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        
    } else {
        typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_list_btn"]
                                                 style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        
    }
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    //add button
    UIBarButtonItem *addBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(CONSTACT_ADD, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addBtnPressed:)];
    
    
    //saveBtn
    UIBarButtonItem *saveBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveBtnPressed:)];
    
    fliterBtn.tintColor =[UIColor whiteColor];
    
    //view setting
    self.selectedIndex = button.tag-101;
    UIButton *btn1 = (UIButton *)[_tabbarView viewWithTag:101];
    UIButton *btn2 = (UIButton *)[_tabbarView viewWithTag:102];
    UIButton *btn3 = (UIButton *)[_tabbarView viewWithTag:103];
    UIButton *btn4 = (UIButton *)[_tabbarView viewWithTag:104];
    UIButton *btn5 = (UIButton *)[_tabbarView viewWithTag:105];
    
    btn1.selected =NO;
    btn2.selected =NO;
    btn3.selected =NO;
    btn4.selected =NO;
    btn5.selected =NO;
    
    button.selected =YES;
    switch (self.selectedIndex) {
        case 0://near界面导航左右按钮
            self.navigationItem.leftBarButtonItem =fliterBtn;
            self.navigationItem.rightBarButtonItem =typeBtn;
            titleLabel.text=NSLocalizedString(NEAR_TITLE, nil);
            self.navigationItem.titleView = titleView;
            break;
        case 1://contacts右边按钮
        {//contacts右边按钮
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
            if(isLogined == NO){
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//                [alter show];
            }
            self.navigationItem.rightBarButtonItem =addBtn;
            titleLabel.text=NSLocalizedString(CONSTACT_TITLE, nil);
            self.navigationItem.titleView = titleView;
            break;
        }
        case 2:
            titleLabel.text=NSLocalizedString(DISCOVER_TITLE, nil);
            self.navigationItem.titleView = titleView;
            break;
        case 3:
            titleLabel.text=NSLocalizedString(CHAT_TITLE, nil);
            self.navigationItem.titleView = titleView;
            break;
        case 4:
            titleLabel.text=NSLocalizedString(SETTING_TITLE, nil);
            self.navigationItem.titleView = titleView;
            self.navigationItem.rightBarButtonItem = saveBtn;
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark NEAR VIEW

- (void)fliterBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_FLITER object:nil];
}

- (void)changeBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_TYPEDBTN object:nil];
}

- (void)didTypedBtn {
    self.navigationItem.rightBarButtonItem =nil;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST]) {
        UIBarButtonItem *typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_water_btn"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =typeBtn;
        
        
    } else {
        UIBarButtonItem *typeBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"navi_list_btn"] style:UIBarButtonItemStyleBordered target:self action:@selector(changeBtnPressed:)];
        typeBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =typeBtn;
    }
}


- (void)saveBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_SAVE object:nil];
}

#pragma mark -
#pragma mark CONTACT VIEW DELEGATE
- (void)addBtnPressed:(id)sender {
    //进入添加好友界面
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    PEAddContactsViewController *addContactView = [[PEAddContactsViewController alloc]initWithNibName:@"PEAddContactsViewController" bundle:nil];
    addContactView.title =NSLocalizedString(CONSTACT_ADDFFRIEND_TITLE, nil);
    if(isLogin){
        [self.navigationController pushViewController:addContactView animated:YES];
    }else{
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
    }
    
}

#pragma mark - INTRO CALLBACK
- (void)introDidFinish {
    //    NSLog(@"Intro callback");
}

#pragma mark - LOGINOUT NOTIFICATION
//============登录成功，默认进入near界面
- (void)loginoutSucc {
    UIButton *btn1 = (UIButton *)[_tabbarView viewWithTag:101];
    [self selectedTab:btn1];
}

#pragma mark -ALTERVIEWDELEGATE

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        
        PELoginViewController *loginView = [[PELoginViewController alloc]init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
    
}


@end
