//
//  PEDisNewsViewController.m
//  Pet
//
//  Created by Wu Evan on 6/22/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEDisNewsViewController.h"
#import "PEScrollPhotoViewController.h"
#import "PESendNewsViewController.h"
#import "PENearDetailViewController.h"
@interface PEDisNewsViewController ()

@end

@implementation PEDisNewsViewController
@synthesize userID;
@synthesize myTableView;
@synthesize tableDataArray;
@synthesize toolView,faceView,scrollView,pageControl;
@synthesize commenTxtField;
@synthesize faceButton,tempPid;
@synthesize newsResponeCommenTxtField,newsCommentsID;
@synthesize replyCellIndex,replyCommentIndex;
@synthesize photoBtn,navTag;
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
        
        userID =[[NSString alloc] init];
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
    titleLabel.text=NSLocalizedString(DISCOVER_NEWS, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    //设置back按钮 by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
//   self.navigation.navigaionBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
//self.navigationController.navigationItem.backBarButtonItem.tintColor =[UIColor whiteColor];

    //添加tableView
    [self addDataView];
    
    //键盘这一快
    [self performSelector:@selector(makeView)];
    
    
    //设置上传按钮
    if( navTag == 0){
      photoBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"news_navBarRightItem"] style:UIBarButtonItemStyleBordered target:self action:@selector(passPhoto:)];
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

- (void)ChangeNav{
    
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]];
    [myTableView  refreshDataRequest];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]];
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

    
    //建立一个faceView
    faceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 320, 175)];
    faceView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:faceView];
    
    //加入输入框
    commenTxtField = [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 298, 30)];//265
    commenTxtField.delegate = self;
    commenTxtField.text = @"";
    commenTxtField.borderStyle = UITextBorderStyleRoundedRect;
    
    commenTxtField.returnKeyType =UIReturnKeyGo;//键盘的return形式
    commenTxtField.alpha = 1.0f;
    [toolView addSubview:commenTxtField];
    
    
    //回复评论输入框
    newsResponeCommenTxtField = [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 298, 30)];//265
    newsResponeCommenTxtField.delegate = self;
    newsResponeCommenTxtField.font = [UIFont systemFontOfSize:12.5];
    newsResponeCommenTxtField.borderStyle = UITextBorderStyleRoundedRect;
    newsResponeCommenTxtField.returnKeyType =UIReturnKeyGo;//键盘的return形式
    newsResponeCommenTxtField.alpha = 0.0f;
    [toolView addSubview:newsResponeCommenTxtField];
    
//    //加上表情face
//    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [faceButton setImage:[UIHelper imageName:@"chat_face_btn"] forState:UIControlStateNormal];
//    faceButton.frame = CGRectMake(276, 5, 38, 40);
//    [faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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

}

#pragma mark - 
#pragma mark - 添加TableView
- (void)addDataView {
    self.myTableView =[[PEDisNewsTableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight -64)];
    myTableView.tempUSerID =userID;
    myTableView.tag =203;
    myTableView.backgroundColor =[UIColor clearColor];
    myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    //委托给当前视图对象
    myTableView.newsTableViewDelegate =self;
    //添加类型按钮
    [myTableView startNearRequest];
    [self.view addSubview:myTableView];
//    [myTableView refreshDataRequest];
    [myTableView reloadData];
}

//表情button点击事件
- (void)faceButtonClick:(id)Button{
    if (self.isFace) {//隐藏faceView
        [commenTxtField resignFirstResponder];//交出第一响应者的身份，隐藏键盘
        [newsResponeCommenTxtField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64);
        toolView.frame = CGRectMake(0, ScreenHeight, 320, 50);
        faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);//隐藏faceView
        [UIView commitAnimations];
        //        [toolView setHidden:YES];
    } else {//出现faceView
        [commenTxtField resignFirstResponder];//不会出现键盘
        [newsResponeCommenTxtField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        faceView.frame = CGRectMake(0, ScreenHeight - 175 , 320, 175);//出现faceView
        myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 -50 -175);
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
    newsResponeCommenTxtField.text = [NSString stringWithFormat:@"%@<%03ld>",commenTxtField.text,(long)button.tag];
}

//相机按钮点击事件
- (void)passPhoto:(UIButton *)sender{
    
    PESendNewsViewController *sendNewsView = [[PESendNewsViewController alloc]init];
    [self.navigationController pushViewController:sendNewsView animated:YES];
    
    
}

#pragma mark -
#pragma mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)pkscrollView{
    [pageControl setCurrentPage:(scrollView.contentOffset.x / 320)];
}


#pragma mark -
#pragma mark - UITextfieldDelegate
//评论 以及 对评论进行回复
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     NSString *tempShoutId=tempPid;
     NSDictionary *appInfo =[[PEMobile sharedManager]getAppInfo];
    
    //评论
    if(textField ==commenTxtField){
    if (commenTxtField.text.length !=0) {
        NSDictionary *commentInfo =@{@"petNewsID": tempShoutId, @"comments": commenTxtField.text};
        NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
        [request setObject:commentInfo forKey:HTTP_DISCOVER_NEWSCOMMENT];
        
        [[PENetWorkingManager sharedClient] discoverNewsComment:request completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                //评论成功，网络刷新数据
                [myTableView refreshDataRequest];
            }else {
                NSLog(@"%@", error);
            }
        }];
     }
        commenTxtField.text =@"";
    }else{//对评论进行回复
     
        if(newsResponeCommenTxtField.text.length !=0){
        NSString *tempInfoString = newsResponeCommenTxtField.text;
        NSDictionary *userInfo = @{@"petNewsComments":tempInfoString,
                                   @"petNewsCommentsReID":@"0",
                                   @"petNewsCommentsID":newsCommentsID};
        NSMutableDictionary *requst = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [requst setObject:userInfo forKey:@"shoutCommentsReInfo"];
        
        [[PENetWorkingManager sharedClient]newsResponseToComment:requst completion:^(NSDictionary *results, NSError *error) {
            if(results){
                //回复评论成功
                NSLog(@"%@",results);
                [myTableView refreshDataRequest];
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                [dic setObject:tempInfoString forKey:@"comment"];
//                [dic setObject:@"2014-07-29 11:57:36" forKey:@"time"];
//                [dic setObject:@"15686" forKey:@"userID"];
//                [dic setObject:@"Evan Wu" forKey:@"userName"];
//               
//                NSMutableDictionary *result = [NSMutableDictionary dictionary];
//                [result setObject:dic forKey:@"replyDic"];
//                [result setObject:[NSNumber numberWithInteger:replyCellIndex] forKey:@"cellIndex"];
//                [result setObject:[NSNumber numberWithInteger:replyCommentIndex] forKey:@"cellCommentIndex"];
//                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"replyCommentSuccess" object:result];
                
                
            }else{
                NSLog(@"%@",error);
            }
        }];
       }
        newsResponeCommenTxtField.text = @"";
        
    }
    
    [textField resignFirstResponder];
    return YES;
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
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 );
    toolView.frame = CGRectMake(0, ScreenHeight, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark-  NewstableViewDelegate
//对评论进行回复
- (void)newsResponseToComment:(NSString *)indexPathrow AndCount:(NSInteger)count AndResponseName:(NSString *)responseName AndComentContent:(NSString *)content AndCellIndex:(NSInteger)cellIndex
{
    
    [newsResponeCommenTxtField becomeFirstResponder];//显示键盘
    newsResponeCommenTxtField.alpha = 1.0f;
    commenTxtField.alpha = 0.0f;
    UIColor *color = [UIHelper colorWithHexString:@"#b8b8b8"];
    NSString *tempString = [NSString stringWithFormat:@"回复%@:",responseName];
    newsResponeCommenTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:tempString
                                                                                  attributes:@{NSForegroundColorAttributeName: color}];
    newsCommentsID = indexPathrow;//关键是那一行的newsCommentID
    self.isShowKeyBord =!self.isShowKeyBord;
    
    //当前回复的cell行数
    replyCellIndex = cellIndex;
    //当前回复的评论的索引
    replyCommentIndex = count;
    
}


//列表形式下的tableViewCell点击需要实现的方法:PENewsViewTableView
- (void)didSelectNewsTable:(NSInteger)index {
    NSLog(@"didTable: %d", index);
 
}

//图片按钮点击
-(void)cellButtonClick:(PEScrollPhotoViewController *)pSV
{
    [self.navigationController pushViewController:pSV animated:YES];

}

//点赞按钮点击事件
-(void)newsFavButtonClick:(NSString *)pid AndString:(NSString *)agreeStaus
{
    NSString *tempString= pid;
    commenTxtField.alpha = 0.0f;
    newsResponeCommenTxtField.alpha = 0.0f;
    NSLog(@"当前点赞的pid值为：%@",tempString);
    NSDictionary *appInfo =[[PEMobile sharedManager]getAppInfo];
    NSDictionary *idInfo =@{@"petNewsID":tempString};
    
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:idInfo forKey:HTTP_DISCOVER_NEWSAGREE];
    
    NSString *tempAgreeStatus = agreeStaus;
    
    if([tempAgreeStatus isEqualToString:@"0"])
    {
        return;
    }
    [[PENetWorkingManager sharedClient] discoverNewsAgree:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {//点赞成功
            [myTableView refreshDataRequest];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"favActionSuccess" object:nil];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

//评论按钮点击事件
-(void)newsMarkButtonClick:(NSString *)pid
{
    tempPid = pid;
    commenTxtField.alpha = 1.0f;
    newsResponeCommenTxtField.alpha = 0.0f;
    [commenTxtField becomeFirstResponder];
}

//播放视频
- (void)newsPlayVideoAction:(NSString *)videoUrl{
    
    NSURL *url= [NSURL URLWithString:videoUrl];
    MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self.navigationController presentViewController:playerView animated:YES completion:nil];
}

//好友头像点击事件
- (void)newsFriendAvaterBtnPressed:(NSDictionary *)dic{
    //    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    //    NSString *tempPetId = [dic objectForKey:DB_COLUMN_NEAR_PETID];
    //    NSString *tempUserName = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    //    NSString *tempUserId = [dic objectForKey:DB_COLUMN_NEAR_USERID];
    
    PENearDetailViewController *detailView = [[PENearDetailViewController alloc]init];
    if(navTag == 0){
    detailView.title = [dic objectForKey:DB_COLUMN_NEAR_USERNAME];
    detailView.petID = @"24155";
    detailView.ownerID = @"15678";
    }else{
        detailView.petID = @"24155";
        detailView.ownerID = userID;
    }
    [self.navigationController pushViewController:detailView animated:YES];
    
}

@end
