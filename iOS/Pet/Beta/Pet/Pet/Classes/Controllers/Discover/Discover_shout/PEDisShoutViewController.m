//
//  PEDisShoutViewController.m
//  Pet
//
//  Created by Wu Evan on 6/22/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEDisShoutViewController.h"
#import "PEDisGroupViewController.h"
#import "Common.h"
#import "PEShoutSendNewsViewController.h"
#import "PELoginViewController.h"
#import "PENearDetailViewController.h"
typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;
@interface PEDisShoutViewController ()

@end

@implementation PEDisShoutViewController

@synthesize shoutType;
@synthesize myTableView;
@synthesize tableDataArray;
@synthesize toolView,faceView,scrollView,pageControl;
@synthesize commenTxtField,responeCommenTxtField;
@synthesize upImageView,centerImageView,downImageView;
@synthesize faceButton,tempPid;
@synthesize shoutCommentId,shoutComments,navTag;
@synthesize userID,userName,petID;
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
        
        shoutType =[[NSString alloc] init];
        userID = [[NSString alloc] init];
        
//        myTableView =[[PEDisShoutTableView alloc]initWithFrame:CGRectMake(0.0f, 70.0f, ScreenWidth, ScreenHeight -64-6) AndData:nil Type:shoutType];
//        myTableView =[[PEDisShoutTableView alloc]initWithFrame:CGRectMake(0.0f, 70.0f, ScreenWidth, ScreenHeight -64-6)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(DISCOVER_SHOUT, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    //设置back按钮，它的下一级back会改变  by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    //数据源  一共造了15个数据
    self.tableDataArray = [[NSMutableArray alloc]init];
    //添加tableView视图
    [self addDataView];
    
     [self performSelector:@selector(makeView)];
    
    //数据库单例方法
//    PEFMDBManager *manager =[PEFMDBManager sharedManager];
//    manager.nearDataDelegate =self;
//    [manager selectAllDataFromNearTable];
    
    //设置上传图片按钮
    if(navTag == 0 ){
    UIBarButtonItem *photoBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"news_navBarRightItem"] style:UIBarButtonItemStyleBordered target:self action:@selector(passPhoto:)];
    photoBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =photoBtn;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    //将状态条修改为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide:) name:UIKeyboardWillHideNotification object:nil];//Done的事件
}

//相机按钮点击事件
- (void)passPhoto:(UIButton *)sender{
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogined ==NO){
    
        [Common showAlert:@"发送喊话需要先登录!"];
        return;
    }
    PEShoutSendNewsViewController *sendNewsView = [[PEShoutSendNewsViewController alloc]init];
    [self.navigationController pushViewController:sendNewsView animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [myTableView refreshDataRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建下面的toolView
- (void)makeView
{
    
    //构造一个工具条
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 320, 50)];
     //toolView.backgroundColor = [UIColor colorWithPatternImage:[UIHelper imageName:@"chat_tools"]];
    toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolView];
//    [toolView setHidden:YES];
    
    //建立一个faceView
    faceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 320, 175)];
    faceView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:faceView];

    
    //评论输入框
    commenTxtField = [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 298, 30)];//265
    commenTxtField.delegate = self;
    commenTxtField.font = [UIFont systemFontOfSize:12.5];
    commenTxtField.borderStyle = UITextBorderStyleRoundedRect;
    commenTxtField.returnKeyType =UIReturnKeyGo;//键盘的return形式
    commenTxtField.alpha = 1.0f;
    [toolView addSubview:commenTxtField];
    

    //回复评论输入框
    responeCommenTxtField = [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 298, 30)];//265
    responeCommenTxtField.delegate = self;
    responeCommenTxtField.font = [UIFont systemFontOfSize:12.5];
    responeCommenTxtField.borderStyle = UITextBorderStyleRoundedRect;
    responeCommenTxtField.returnKeyType =UIReturnKeyGo;//键盘的return形式
    responeCommenTxtField.alpha = 0.0f;
    [toolView addSubview:responeCommenTxtField];
    
    //加上表情face
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setImage:[UIHelper imageName:@"chat_face_btn"] forState:UIControlStateNormal];
    faceButton.frame = CGRectMake(276, 5, 38, 40);
    [faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:faceButton];
    
    //在faceView上添加一个ScrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES; //设置分页浏览
    scrollView.showsHorizontalScrollIndicator = NO; //隐藏进度条
    scrollView.contentSize = CGSizeMake(320 * 2, 175); //设置contentSize
    [faceView addSubview:scrollView];
    
    
    //循环添加face
    for (int i = 0; i < 4; i++) {//控制行数
        for (int j = 0; j < 6; j++) {//控制每行的高度
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num;
            if (num >17) {
                break;//第一个page的最后一个表情索引为16
            }
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(10 + 50 * j, 5 + 55 * i, 48, 48);
            [scrollView addSubview:button];
        }
    }
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"1%02d.png",num];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(320+10 + 50 * j, 5 + 55 * i, 48, 48);
            [scrollView addSubview:button];
        }
    }
    
    
    //pageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, 320, 20)];
    [pageControl setNumberOfPages:2];
    [faceView addSubview:pageControl];

    
    
    UIImage *bgImageUp = [UIHelper imageName:@"shout_textFieldUpImage"];
    upImageView = [[UIImageView alloc]init];
    upImageView.image = bgImageUp;
    upImageView.frame = CGRectMake(11, 10, 298, 18);//175.5
    //[toolView addSubview:upImageView];
   
    UIImage *bgImageCenter = [UIHelper imageName:@"shout_textFieldCenterImage"];
    centerImageView = [[UIImageView alloc]init];
    centerImageView.image = bgImageCenter;
    centerImageView.frame = CGRectMake(11, 28, 298, 7);//175.5
    //[toolView addSubview:centerImageView];
    
    UIImage *bgImageDown = [UIHelper imageName:@"shout_textFieldownmage"];
    downImageView = [[UIImageView alloc]init];
    downImageView.image = bgImageDown;
    downImageView.frame = CGRectMake(11, 35, 298, 5);//175.5
    //[toolView addSubview:downImageView];
    
}

#pragma mark - ADD MYTABLEVIEW
- (void)addDataView {
//    myTableView =[[PEDisShoutTableView alloc]initWithFrame:CGRectMake(0.0f, 70.0f, ScreenWidth, ScreenHeight -64-6) AndData:nil Type:shoutType];
    myTableView =[[PEDisShoutTableView alloc]initWithFrame:CGRectMake(0.0f, 70.0f, ScreenWidth, ScreenHeight -64-6) Type:shoutType AndUserID:userID];
    myTableView.tag =203;
    myTableView.backgroundColor =[UIColor clearColor];
    myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    //委托给当前视图对象
    myTableView.shoutDelegte =self;
//    myTableView.tempUserID = userID;
//    myTableView.shoutType = shoutType;
    //添加类型按钮
    [self.view addSubview:myTableView];
    [myTableView reloadData];
    
    
}

#pragma mark -
#pragma TABLEVIEW DELEGATE
//列表形式下的tableViewCell点击需要实现的方法:PENewsViewTableView
- (void)didSelectNewsTable:(NSInteger)index {
    NSLog(@"hehe didTable: %ld", index);
    
}


#pragma mark -
#pragma TABLEVIEW DELEGATE


//选择了第几行的事件
-(void)selectRowAtIndex:(NSInteger)cellIndex{
    NSLog(@"选择了第%ld行",cellIndex);
  
}

//cell上的图片button点击
-(void)shoutCellButtonClick
{
    NSLog(@"点击了视图上的图片");
    
}

//对评论进行回复
- (void)responseToComment:(NSString *)indexPathrow AndCount:(NSInteger)count AndResponseName:(NSString *)responseName AndComentContent:(NSString *)content
{
    
    [responeCommenTxtField becomeFirstResponder];//显示键盘
    responeCommenTxtField.alpha = 1.0f;
    commenTxtField.alpha = 0.0f;
    UIColor *color = [UIHelper colorWithHexString:@"#b8b8b8"];
    NSString *tempString = [NSString stringWithFormat:@"回复%@:",responseName];
    responeCommenTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:tempString
                                                                            attributes:@{NSForegroundColorAttributeName: color}];
   
    //对评论进行回复的关键

    shoutComments = content;
    shoutCommentId = indexPathrow;
    
    self.isShowKeyBord =!self.isShowKeyBord;
  
}


//喊话界面点赞按钮点击事件
-(void)praiseButtonClick:(NSString *)pid AndAgreeStatus:(NSString *)agreeStatus
{
    commenTxtField.alpha = 0.0f;
    responeCommenTxtField.alpha = 0.0f;
    
//    bool n = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
//    if(n == NO){
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"登录以后才能评论!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alter show];
//        
//    }
    
    NSString *tempString= pid;
    NSString *tempAgreeStatus = agreeStatus;
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *favInfo =@{@"shoutID": tempString};
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:favInfo forKey:HTTP_DISCOVER_SHOUTINFO];
    if([tempAgreeStatus isEqualToString:@"0"])
    {
        return;
    }
    
    [[PENetWorkingManager sharedClient] discoverShoutAgree:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            [myTableView refreshDataRequest];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

//评论按钮点击事件
-(void)commentButtonClick:(NSString *)pid
{
    tempPid = pid;
    commenTxtField.alpha = 1.0f;
    responeCommenTxtField.alpha = 0.0f;
    [commenTxtField becomeFirstResponder];//显示键盘
    self.isShowKeyBord =!self.isShowKeyBord;
    
}

//宠物头像点击事件
- (void)shoutFriendBtnPressed:(NSDictionary *)dic{
    //    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    //    NSString *tempPetId = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    //    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    //    NSString *tempUserId = [dic objectForKey:DB_COLUMN_NEAR_USERID];
    
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    if(navTag == 0){
    detailView.title = [dic objectForKey:@"petName"];
    detailView.petID = @"24155";
    detailView.ownerID = @"15678";
    }else{
        detailView.petID = petID;
        detailView.ownerID = userID;
        detailView.title = userName;
    }
    [self.navigationController pushViewController:detailView animated:YES];
}

//表情button点击事件
- (void)faceButtonClick:(id)Button{
    if (self.isFace) {//隐藏faceView
        [commenTxtField resignFirstResponder];//交出第一响应者的身份，隐藏键盘
        [responeCommenTxtField resignFirstResponder];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64 );
        toolView.frame = CGRectMake(0, ScreenHeight, 320, 50);
        faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);//隐藏faceView
        [UIView commitAnimations];
//        [toolView setHidden:YES];
    } else {//出现faceView
        [commenTxtField resignFirstResponder];//不会出现键盘
        [responeCommenTxtField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        faceView.frame = CGRectMake(0, ScreenHeight - 175 , 320, 175);//出现faceView
        myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 -50 -175 );
        toolView.frame = CGRectMake(0, ScreenHeight-50 - 175, 320, 50);//出现toolView,这个时候是被faceView的175高度顶起
        [UIView commitAnimations];
//        [toolView setHidden:NO];
    }
    self.isFace =!self.isFace;
}

//表情的选择
- (void)faceChoose:(id)sender{
    UIButton* button = (UIButton*)sender;
    commenTxtField.text = [NSString stringWithFormat:@"%@<%03ld>",commenTxtField.text,(long)button.tag];

}



#pragma mark -
#pragma mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)pkscrollView{
    [pageControl setCurrentPage:(scrollView.contentOffset.x / 320)];
}

#pragma mark -
#pragma mark - UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == commenTxtField){
//        bool n = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
//        if(n == NO){
//            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"登录以后才能评论!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            [alter show];
//            
//        }
    if(commenTxtField.text.length >0)
    {
        NSString *tempShoutId=tempPid;
        NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
        NSDictionary *commentInfo =@{@"shoutID": tempShoutId, @"comments": commenTxtField.text};
        if (commenTxtField.text.length !=0) {
        NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
        [request setObject:commentInfo forKey:HTTP_DISCOVER_COMMENT];
        
        [[PENetWorkingManager sharedClient] discoverShoutComment:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                NSLog(@"%@", results);
                [Common showAlert:@"评论成功"];
                [myTableView refreshDataRequest];
            } else {
                NSLog(@"%@", error);
            }
        }];
     }
    
        commenTxtField.text =@"";
     }
   }
    
    //对评论进行回复的文本框
    else{

//        bool n = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
//        if(n == NO){
//            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"登录以后才能评论!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            [alter show];
//           
//        }
        if(responeCommenTxtField.text.length >0)
        {

             NSString *tempInfoString = [responeCommenTxtField text];
             NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
             NSDictionary *userInfo = @{@"shoutCommentsReID":@"0",
                                   @"shoutCommentsID":shoutCommentId,
                                   @"shoutComments":tempInfoString};
             NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
             [request setObject:userInfo forKey:@"shoutCommentsReInfo"];
        
             [[PENetWorkingManager sharedClient]shoutResponseToComment:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSLog(@"%@",results);
                [myTableView refreshDataRequest];
            }else{
                
                NSLog(@"%@",error);
            }
        }];
        
        }
        responeCommenTxtField.text = @"";
    
    }
    
    [textField resignFirstResponder];
   
    return YES;
}

- (void)shoutVideoPlay:(NSString *)videoUrl{
    
    
    NSURL *url= [NSURL URLWithString:videoUrl];
    MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self.navigationController presentViewController:playerView animated:YES completion:nil];
    
}

#pragma mark -NSNotification
- (void)keyWillShow:(NSNotification*)notification{
    //获得键盘的高
//    [toolView setHidden:NO];
    NSDictionary* userInfo = [notification userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = rect.size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64-size.height);
    toolView.frame = CGRectMake(0, ScreenHeight-size.height-50, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);
    if (self.isFace) {
        self.isFace =!self.isFace;
    }
    [UIView commitAnimations];
}


//键盘上down绑定的事件 ----这个时候toolView都隐藏了，就都不会显示了
- (void)keyWillHide:(NSNotification*)notification{
//    [toolView setHidden:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64);
    toolView.frame = CGRectMake(0, ScreenHeight, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);
    [UIView commitAnimations];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        
        PELoginViewController *loginView = [[PELoginViewController alloc]init];
        loginView.type =type_chat;
        [self.navigationController pushViewController:loginView animated:YES];
        
    }
    
}

@end
