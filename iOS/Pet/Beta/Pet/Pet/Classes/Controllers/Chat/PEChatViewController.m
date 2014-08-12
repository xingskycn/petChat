//
//  PEChatViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEChatViewController.h"
#import "PELoginViewController.h"
#import "UIHelper.h"

typedef enum {
    type_chat =0,
    type_setting
}LOGINTYPE;

@interface PEChatViewController ()

@end

@implementation PEChatViewController

@synthesize toRoomJID, type;
@synthesize toName, toJID;
@synthesize myTableView, toolView, textField, faceView, plusView, scrollView, pageControl, sheet;
@synthesize xmpp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        toRoomJID =[[NSString alloc] init];
        
        toJID =[[NSString alloc] init];
        toName =[[NSString alloc] init];
        
        xmpp =[PEXMPP sharedInstance];
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
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=self.title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    [self performSelector:@selector(makeView)];
    [myTableView setupData];
    
//   注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    sheet =[[UIActionSheet alloc]initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"现在拍摄", @"相册", nil];
    
    if (type ==chatType_Room) {
        [xmpp addGroup:toName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeView{
    //添加背景
    UIImageView *bgView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight-64)];
    [bgView setImage:[UIHelper imageName:@"chat_bg"]];
    [self.view addSubview:bgView];
    
    //构建一个表格，
    myTableView = [[PETableView alloc] initWithFrame:CGRectMake(0, 64.0, ScreenWidth, ScreenHeight-64 -50) style:UITableViewStylePlain];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    if (type ==chatType_Single) {
        myTableView.toJID =toJID;
    }else {
        myTableView.toRoomJID =toRoomJID;
    }
    myTableView.chatType =type;
    [self.view addSubview:myTableView];
    
    //构造一个工具条
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, 320, 50)];
    toolView.backgroundColor = [UIColor colorWithPatternImage:[UIHelper imageName:@"chat_tools"]];
    [self.view addSubview:toolView];
    
    //加入输入框
    textField = [[UITextField alloc] initWithFrame:CGRectMake(88, 10, 190, 30)];
    textField.delegate = self;
    textField.text = @"";
    textField.borderStyle = UITextBorderStyleNone;
    [toolView addSubview:textField];
    
    //加入按钮
//    UIButton* resButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [resButton setBackgroundImage:[UIImage imageNamed:@"001"] forState:UIControlStateNormal];
//    resButton.frame = CGRectMake(5, 5, 30, 30);
//    [resButton addTarget:self action:@selector(resButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:resButton];
    
    UIButton* faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setImage:[UIHelper imageName:@"chat_face_btn"] forState:UIControlStateNormal];
    faceButton.frame = CGRectMake(5, 5, 38, 40);
    [faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:faceButton];
    
    UIButton* plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setImage:[UIHelper imageName:@"chat_plus_btn"] forState:UIControlStateNormal];
    plusButton.frame = CGRectMake(45, 5, 38, 40);
    [plusButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:plusButton];
    
    UIButton* voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setImage:[UIHelper imageName:@"chat_voice_btn"] forState:UIControlStateNormal];
    voiceButton.frame = CGRectMake(ScreenWidth -38 -2, 5, 38, 40);
    [voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:voiceButton];
    
    //建立一个faceView
//    faceView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 320, 225)];
//    faceView.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
//    [self.view addSubview:faceView];
    faceView =[[PEFaceView alloc] initWithFrame:CGRectMake(0.0f, ScreenHeight, ScreenWidth, 225.0f)];
    faceView.faceViewDelegate =self;
    [self.view addSubview:faceView];
    
    //在faceView上添加一个ScrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 225)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES; //设置分页浏览
    scrollView.showsHorizontalScrollIndicator = NO; //隐藏进度条
    scrollView.contentSize = CGSizeMake(320 * 5, 200); //设置contentSize
//    [faceView addSubview:scrollView];
    
    //循环添加face
    
    for (int k =0; k<5; k++) {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 6; j++) {
                int num = j + 6 * i;
                NSString* name = [NSString stringWithFormat:@"%03d.png",num +100*k];
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = num +100 *k;
                if (num >17) {
                    break;
                }
                
                [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(320*k +10 + 50 * j, 5 + 55 * i, 48, 48);
                [scrollView addSubview:button];
            }
        }
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, 320, 20)];
    [pageControl setNumberOfPages:2];
//    [faceView addSubview:pageControl];
    
    //建立plusView
    plusView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, ScreenHeight, ScreenWidth, 109.5f)];
    plusView.backgroundColor =[UIHelper colorWithHexString:@"#ffffff"];
    [self.view addSubview:plusView];
    
    //添加图片按钮
    UIButton *plusPicBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [plusPicBtn setImage:[UIHelper imageName:@"chat_plus_picture_btn"] forState:UIControlStateNormal];
    [plusPicBtn setFrame:CGRectMake(11.5f, 13.0f, 63.0f, 63.0f)];
    [plusPicBtn addTarget:self action:@selector(picBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //添加图片标签
    UILabel *picLbl =[[UILabel alloc] initWithFrame:CGRectMake(11.5f, 82.0f, 63.0f, 12.0f)];
    picLbl.font =[UIFont systemFontOfSize:12.0f];
    picLbl.textAlignment =NSTextAlignmentCenter;
    picLbl.textColor =[UIHelper colorWithHexString:@"#acb2b7"];
    picLbl.text =NSLocalizedString(CHAT_PICBTN_TITLE, nil);
    //添加照片按钮
    UIButton *plusPhotoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [plusPhotoBtn setImage:[UIHelper imageName:@"chat_plus_photo_btn"] forState:UIControlStateNormal];
    [plusPhotoBtn setFrame:CGRectMake(89.5f, 13.0f, 63.0f, 63.0f)];
    [plusPhotoBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //添加照片标签
    UILabel *photoLbl =[[UILabel alloc] initWithFrame:CGRectMake(89.5f, 82.0f, 63.0f, 12.0f)];
    photoLbl.font =[UIFont systemFontOfSize:12.0f];
    photoLbl.textAlignment =NSTextAlignmentCenter;
    photoLbl.textColor =[UIHelper colorWithHexString:@"#acb2b7"];
    photoLbl.text =NSLocalizedString(CHAT_PHOTOBTN_TITLE, nil);
    //添加视频按钮
    UIButton *plusVedioBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [plusVedioBtn setImage:[UIHelper imageName:@"chat_plus_vedio_btn"] forState:UIControlStateNormal];
    [plusVedioBtn setFrame:CGRectMake(167.5f, 13.0f, 63.0f, 63.0f)];
    [plusVedioBtn addTarget:self action:@selector(vedioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //添加视频标签
    UILabel *vedioLbl =[[UILabel alloc] initWithFrame:CGRectMake(167.5f, 82.0f, 63.0f, 12.0f)];
    vedioLbl.font =[UIFont systemFontOfSize:12.0f];
    vedioLbl.textAlignment =NSTextAlignmentCenter;
    vedioLbl.textColor =[UIHelper colorWithHexString:@"#acb2b7"];
    vedioLbl.text =NSLocalizedString(CHAT_VEDIOBTN_TITLE, nil);
    //添加位置按钮
    UIButton *plusLocBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [plusLocBtn setImage:[UIHelper imageName:@"chat_plus_location_btn"] forState:UIControlStateNormal];
    [plusLocBtn setFrame:CGRectMake(245.5f, 13.0f, 63.0f, 63.0f)];
    [plusLocBtn addTarget:self action:@selector(locationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //添加位置标签
    UILabel *locLbl =[[UILabel alloc] initWithFrame:CGRectMake(245.5f, 82.0f, 63.0f, 12.0f)];
    locLbl.font =[UIFont systemFontOfSize:12.0f];
    locLbl.textAlignment =NSTextAlignmentCenter;
    locLbl.textColor =[UIHelper colorWithHexString:@"#acb2b7"];
    locLbl.text =NSLocalizedString(CHAT_LOCBTN_TITLE, nil);
    
    //设置plusView
    [plusView addSubview:plusPicBtn];
    [plusView addSubview:plusPhotoBtn];
//    [plusView addSubview:plusVedioBtn];
//    [plusView addSubview:plusLocBtn];
    [plusView addSubview:picLbl];
    [plusView addSubview:photoLbl];
//    [plusView addSubview:vedioLbl];
//    [plusView addSubview:locLbl];
    
    //添加点击事件
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [myTableView addGestureRecognizer:tapRecognizer];
}

- (void)faceChoose:(id)sender{
    UIButton* button = (UIButton*)sender;
    textField.text = [NSString stringWithFormat:@"%@</%03ld>",textField.text,(long)button.tag];
}

- (void)scrollViewDidScroll:(UIScrollView *)pkscrollView{
    [pageControl setCurrentPage:(scrollView.contentOffset.x / 320)];
}

- (void)faceButtonClick:(id)Button{
    self.isFace =YES;
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    faceView.frame = CGRectMake(0, ScreenHeight - 225 , 320, 225);
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 -225 -50);
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-50 - 225 , 320, 50);
    plusView.frame = CGRectMake(0.0f, ScreenHeight, ScreenWidth, 109.5f);
    [UIView commitAnimations];
}

- (void)plusButtonClick:(id)Button{
    self.isPlus =YES;
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-64 - 109.5 -50 );
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-50 - 109.5 , 320, 50);
    plusView.frame = CGRectMake(0.0f, ScreenHeight -109.5 , ScreenWidth, 109.5f);
    [UIView commitAnimations];
}

- (void)voiceButtonClick:(id)Button{
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64  -50);
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-50, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
    plusView.frame = CGRectMake(0.0f, ScreenHeight, ScreenWidth, 109.5f);
    [UIView commitAnimations];
}


//- (void)resButtonClick:(id)sender{
//    [textField resignFirstResponder];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64  -50);
//    toolView.frame = CGRectMake(0, ScreenHeight-50, 320, 50);
//    faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
//    plusView.frame = CGRectMake(0.0f, ScreenHeight, ScreenWidth, 109.5f);
//    [UIView commitAnimations];
//}

- (void)didDeleteButton:(UIButton *)sender {
    if (textField.text.length !=0) {
        
        textField.text =[textField.text substringToIndex:textField.text.length-1];
    }
}

- (void)didSendButton:(UIButton *)sender {
    if (textField.text.length !=0) {
        [myTableView addTextContent:textField.text WithIsRoomChat:YES];
        textField.text = @"";
        
    }
}

//发送内容

- (BOOL)textFieldShouldReturn:(UITextField *)pktextField{
    if (pktextField.text.length !=0) {
        [myTableView addTextContent:textField.text WithIsRoomChat:YES];
        textField.text = @"";

    }
    return YES;
}


//键盘控制

- (void)keyWillShow:(NSNotification*)notification{
    //获得键盘的高
    if (self.isFace) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
        [UIView commitAnimations];
        self.isFace =!self.isFace;
    }
    
    if (self.isPlus) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        plusView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 109.5f);

        [UIView commitAnimations];
        self.isPlus =!self.isPlus;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = rect.size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight-size.height -64 -50);
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-size.height -50, 320, 50);
    
    [UIView commitAnimations];

}

- (void)keyWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -64 -50);
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-50, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
    plusView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 109.5f);
    [UIView commitAnimations];
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    myTableView.frame = CGRectMake(0, 64, 320, ScreenHeight -50 -64);
    [myTableView scrollToBottom];
    toolView.frame = CGRectMake(0, ScreenHeight-50, 320, 50);
    faceView.frame = CGRectMake(0, ScreenHeight, 320, 225);
    plusView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 109.5f);
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark BUTTON ACTION
- (void)picBtnPressed:(id)sender {
//    [sheet showInView:self.view];
    
    [self getPhoto];
}

- (void)photoBtnPressed:(id)sender {
    [self takePhoto];
}

- (void)locationBtnPressed:(id)sender {
    
}

- (void)vedioBtnPressed:(id)sender {
    
}

#pragma mark -
#pragma mark TAKE PHOTO
//action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1) {
        [self getPhoto];
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
    }
    
}

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许使用相机");
    }
}

- (void)getPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许访问相册");
    }
}

#pragma mark - uiimagePickerDelaget
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(uploadImage:)
               withObject:image
               afterDelay:0.5];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image {
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    
    [[PENetWorkingManager sharedClient] uploadChatImage:request image:image imageName:@"chat.jpg" completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSString *imageurl =[results objectForKey:@"imageUrl"];
            [myTableView addImageContent:imageurl WithIsRoomChat:NO];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didSortButton:(UIButton *)sender {
    switch (sender.tag) {
        case 800:
            [faceView bringSubviewToFront:faceView.face1];
            break;
        case 801:
            [faceView bringSubviewToFront:faceView.face2];
            break;
        case 802:
            [faceView bringSubviewToFront:faceView.face3];
            break;
        case 803:
            [faceView bringSubviewToFront:faceView.face4];
            break;
        case 804:
            [faceView bringSubviewToFront:faceView.face5];
            break;
            
        default:
            break;
    }
}

- (void)didFaceButton:(UIButton *)sender {
    UIButton* button = (UIButton*)sender;
    textField.text = [NSString stringWithFormat:@"%@</f%03ld>",textField.text,(long)button.tag];
}
@end
