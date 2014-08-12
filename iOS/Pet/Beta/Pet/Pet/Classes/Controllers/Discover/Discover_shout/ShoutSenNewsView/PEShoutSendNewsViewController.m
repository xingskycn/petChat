//
//  PEShoutSendNewsViewController.m
//  Pet
//
//  Created by WuJunqiu on 14-7-31.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEShoutSendNewsViewController.h"
#import "UIHelper.h"
@interface PEShoutSendNewsViewController ()

@end

@implementation PEShoutSendNewsViewController
@synthesize senNewsView, sheet, sheet2, dataArray, type, newsType,newsTypeString, videoURL,hasMp4,mp4Path,hasVedio,alertView;
@synthesize sendBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc]init];
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
    titleLabel.text=NSLocalizedString(DISCOVER_SHOUTE_SENDNEWS_TITLE, nil);;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    sendBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBtnPressed)];
    sendBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = sendBtn;
    
    senNewsView = [[PESendNewsView alloc]initWithFrame:CGRectMake(0, 64, 320, ScreenHeight-64)];
    senNewsView.delegate = self;
    newsType =[[NSString alloc] init];
    newsTypeString = [[NSString alloc]init];
    [self.view addSubview:senNewsView];
    
    sheet =[[UIActionSheet alloc]initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"现在拍摄视频", @"现在拍摄照片", @"选取已有的", nil];
    sheet2 =[[UIActionSheet alloc]initWithTitle:nil
                                       delegate:self
                              cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                              otherButtonTitles:@"品种", @"养护", @"健康", @"繁殖", @"训练", @"美容", nil];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -
#pragma mark - UIBUTTON
//发送按钮点击事件
- (void)sendBtnPressed{
    sendBtn.enabled =NO;
    [self sendNews];
}

#pragma mark -
#pragma mark -SendNewsDelegate
- (void)shoutSortClick{
    [sheet2 showInView:self.view];
}
- (void)mySiteClick{
    
    [Common showAlert:@"您的位置（正在开发中）"];
    
}
- (void)synSendClick{
    
    [Common showAlert:@"同步发送（正在开发中）"];
    
}

//添加按钮点击事件
- (void)addBtnClick {
    if (dataArray.count<1) {
        
        [sheet showInView:self.view];
    }else {
        [Common showAlert:@"亲，当前只能添加一张图片或一个视频!"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//上传照片按钮点击事件
- (void)passPhotoBtnPressed{
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet ==sheet) {
        if (buttonIndex == 0) {
            type =@"vedio";
            [self takeVedio];
        }else if (buttonIndex == 1) {
            type =@"photo";
            [self takePhoto];
        }else if(buttonIndex == 2) {
            type =@"photo";
            [self getPhoto];
        }else if (buttonIndex == 3) {
            NSLog(@"取消");
            
        }
    } else {
        if (buttonIndex == 0) {
            newsTypeString =@"品种";
            newsType = @"1";
        }else if (buttonIndex == 1) {
            newsTypeString =@"养护";
            newsType = @"2";
        }else if(buttonIndex == 2) {
            newsTypeString =@"健康";
            newsType = @"3";
        }else if (buttonIndex == 3) {
            newsTypeString =@"繁殖";
            newsType = @"4";
        }else if (buttonIndex == 4) {
            newsTypeString =@"训练";
            newsType = @"5";
        }else if (buttonIndex == 5) {
            newsTypeString =@"美容";
            newsType = @"6";
        }else {
            NSLog(@"取消");
            newsTypeString = @"动态类别";
            newsType = @"";
        }
        senNewsView.shoutLabel.text =newsTypeString;
    }
    
}

//拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许使用相机");
    }
}

//访问相册
- (void)getPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许访问相册");
    }
}


- (void)pickImageEnd:(UIImage *)img {
    NSDictionary *dict =@{@"type":@"image", @"image":img};
    [dataArray addObject:dict];
    [senNewsView endOfAddAction:dict];
}

//转码完成
- (void) convertFinish {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    hasMp4 =YES;
    
    NSDictionary *dict =@{@"type":@"vedio", @"url":mp4Path};
    [dataArray addObject:dict];
    [senNewsView endOfAddAction:dict];
}

#pragma mark - uiimagePickerDelaget
//取出相册的某张图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([type isEqualToString:@"vedio"]) {
        hasVedio =NO;
        hasMp4 =NO;
        
        videoURL = info[UIImagePickerControllerMediaURL];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        hasVedio = YES;
        [self encodeVedio];
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        //宠物头像赋值
        [self pickImageEnd:image];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BUTTON PRESEED
//===========拍摄视频按钮点击事件
- (void)takeVedio{
    
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


//发送消息按钮点击
- (void)sendNews {
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    //输入的想对朋友说些什么的内容
    if(senNewsView.myTextView.text.length ==0){
        [Common showAlert:@"发送喊话内容不能为空喔！"];
        return;
    }
    
    NSString *tempSignString = senNewsView.tempwordslabel.text ;
    int  signStringValue = [[tempSignString substringWithRange:NSMakeRange(0,3)]intValue];
    if(signStringValue >120){
        [Common showAlert:@"喊话内容最多120个字！"];
        //        sendNewsView.tempwordslabel.text = @"120/120字";
        return;
    }
    

    NSDictionary *contentInfo =@{@"content": senNewsView.myTextView.text};
    NSDictionary *typeInfo =@{@"type": newsType};//newsType
    
    NSMutableDictionary *request =[[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [request setObject:contentInfo forKey:@"content"];
    [request setObject:typeInfo forKey:@"type"];
    
    if(dataArray.count == 0){
        [Common showAlert:@"需要添加图片才能发送喔！"];
        return;
    }
    
    if([newsType isEqualToString:@""] || newsType == nil ){
        [Common showAlert:@"需要选择喊话的类别！"];
    }
    
    //注：dataArray里存放的就是添加的视频或图片字典
    //会根据type判断是视频还是字典
    [[PENetWorkingManager sharedClient] sendShout:request data:dataArray completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@",results);
            sendBtn.enabled = NO;
            if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
//                [self.navigationController popViewControllerAnimated:YES];
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
//                [Common showAlert:@"发送成功"];
                
                sendBtn.enabled =YES;
            }
        } else {
            
            NSLog(@"%@",error);
            [Common showAlert:@"发送喊话失败！"];
            sendBtn.enabled =YES;
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
