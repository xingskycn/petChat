//
//  PENearVedioListViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-18.
//  Copyright (c) 2014年 Pet. All rights reserved.
//


#import "PENearVedioListViewController.h"
#import "UIHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "Common.h"
@interface PENearVedioListViewController ()

@end

@implementation PENearVedioListViewController
@synthesize videoListTableView,tableDataArray,videoURL,hasMp4,mp4Path,hasVedio,alertView;
@synthesize toolView,faceView,scrollView,pageControl;
@synthesize commenTxtField;
@synthesize faceButton,tempPid;
@synthesize newsResponeCommenTxtField,newsCommentsID;
@synthesize replyCellIndex,replyCommentIndex;
@synthesize navTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
       
        videoListTableView =[[PEDisVedioListTableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight -64)];
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
    titleLabel.text=NSLocalizedString(VEDIO_LIST_TITLE, nil);
    //    titleLabel.text=self.title;
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
    
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    if(isLogined == YES){
        
    }
    //拍摄视频按钮
    if(navTag == 0){
    UIBarButtonItem *vedioBtn =[[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStyleBordered target:self action:@selector(vedioBtnPressed:)];
       vedioBtn.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem =vedioBtn;
    }else{
        
      self.navigationItem.rightBarButtonItem =nil;
    }
    
//    //拍摄视频按钮
//    UIBarButtonItem *vedioBtn =[[UIBarButtonItem alloc]initWithImage:[UIHelper imageName:@"vedio_camer"] style:UIBarButtonItemStyleBordered target:self action:@selector(vedioBtnPressed:)];
//    vedioBtn.tintColor =[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem =vedioBtn;
    //添加tableView
    [self addDataView];
    
    //键盘这一快
    [self performSelector:@selector(makeView)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide:) name:UIKeyboardWillHideNotification object:nil];//Done的事件
}

- (void)addDataView {
    videoListTableView.tag =203;
    videoListTableView.backgroundColor =[UIColor clearColor];
    videoListTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    videoListTableView.newsTableViewDelegate = self;
    //添加类型按钮
    [videoListTableView startNearRequest];
    [self.view addSubview:videoListTableView];
    [videoListTableView reloadData];

    
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
    
    //加上表情face
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


//表情button点击事件
- (void)faceButtonClick:(id)Button{
    if (self.isFace) {//隐藏faceView
        [commenTxtField resignFirstResponder];//交出第一响应者的身份，隐藏键盘
        [newsResponeCommenTxtField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        videoListTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64);
        toolView.frame = CGRectMake(0, ScreenHeight, 320, 50);
        faceView.frame = CGRectMake(0, ScreenHeight, 320, 175);//隐藏faceView
        [UIView commitAnimations];
        
    } else {//出现faceView
        [commenTxtField resignFirstResponder];//不会出现键盘
        [newsResponeCommenTxtField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        faceView.frame = CGRectMake(0, ScreenHeight - 175 , 320, 175);//出现faceView
        videoListTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 -50 -175);
        toolView.frame = CGRectMake(0, ScreenHeight-50 - 175, 320, 50);//出现toolView,这个时候是被faceView的175高度顶起
        [UIView commitAnimations];
        
    }
    self.isFace =!self.isFace;
}

//表情的选择
- (void)faceChoose:(id)sender{
    UIButton* button = (UIButton*)sender;
    commenTxtField.text = [NSString stringWithFormat:@"%@<%03ld>",commenTxtField.text,(long)button.tag];
    newsResponeCommenTxtField.text = [NSString stringWithFormat:@"%@<%03ld>",commenTxtField.text,(long)button.tag];
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
                    [videoListTableView refreshDataRequest];
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
                    [videoListTableView refreshDataRequest];  
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
    videoListTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64-size.height);
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
    videoListTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 );
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

//播放视频点击委托事件
- (void)videoPlayBtnClick:(NSString *)videoString{
    
    NSURL *url= [NSURL URLWithString:videoString];
    MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self.navigationController presentViewController:playerView animated:YES completion:nil];
    
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
//    NSLog(@"当前点赞的pid值为：%@",tempString);
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
            [videoListTableView refreshDataRequest];
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

#pragma mark -
#pragma mark - BUTTON PRESEED
//===========拍摄视频按钮点击事件
- (void)vedioBtnPressed:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        [self.navigationController presentViewController:pickerView animated:YES completion:nil];
        pickerView.videoMaximumDuration = 20;
        pickerView.delegate = self;
    } else {
        NSLog(@"请允许使用相机");
    }
    
    
}

#pragma mark - encodeing video
//===============上传视频之前需要转码
- (void)encodeVedio {
    if (!hasVedio)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                         message:@"Please record a video first"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        
    {
        alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Waiting.."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(alertView.frame),
                                    CGRectGetHeight(alertView.frame));
        [alertView addSubview:activity];
        [activity startAnimating];
        [alertView show];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetLowQuality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: mp4Path];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [alertView dismissWithClickedButtonIndex:0 animated:NO];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [alertView dismissWithClickedButtonIndex:0
                                                    animated:YES];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
        }];
    }
}

//转码完成
- (void) convertFinish
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    hasMp4 =YES;
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *vedioInfo = @{@"videoName":@"15679_test"};
    NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:vedioInfo forKey:@"videoInfo"];
    
    if(hasMp4){
        [[PENetWorkingManager sharedClient]upLoadVedio:request video:mp4Path videoName:@"15679_test" completion:^(NSDictionary *results, NSError *error) {
            if (results) {
                [Common commonAlertShowWithTitle:@"上传成功" Message:nil];
                NSLog(@"**************上传成功**************");
            }else {
                [Common commonAlertShowWithTitle:@"上传失败" Message:nil];
                NSLog(@"**************上传失败**************\n %@", error);
            }
        }];
    } else {
        NSLog(@"**********mp4不存在***********");
    }
}

#pragma mark - VedioListDelegate
- (void)playVedio:(NSString *)urlString{
    
    NSString *tempUrlString = urlString;
    NSLog(@"==================%@",tempUrlString);
    
    //1.播放本地的视频url初始化方法
//    NSURL *theURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"watching" ofType:@"mov"]];
    //取网络视频url链接的初始化方法
    NSURL *url = [NSURL URLWithString:tempUrlString];
    MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    //调整屏幕尺寸的
    //    MPMoviePlayerController*player=[playerView moviePlayer];
    //    player.scalingMode=MPMovieScalingModeFill;
    //    player.controlStyle=MPMovieControlStyleFullscreen;
    //    [player play];
    [self.navigationController presentViewController:playerView animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - UIImagePickerDelaget
//==================委托事件
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    hasVedio =NO;
    hasMp4 =NO;
    
    videoURL = info[UIImagePickerControllerMediaURL];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    hasVedio = YES;
    [self encodeVedio];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
