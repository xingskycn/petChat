//
//  PESendNewsViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-29.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PESendNewsView.h"
@interface PESendNewsViewController : UIViewController<UITextViewDelegate,SendNewsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>


@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *newsType;

@property(nonatomic,retain)NSURL *videoURL;
@property (nonatomic) BOOL hasMp4;
@property (retain, nonatomic)NSString *mp4Path;
@property (nonatomic) BOOL hasVedio;
@property (retain, nonatomic)UIAlertView *alertView;

@property (retain, nonatomic)UIBarButtonItem *sendBtn;

@property(nonatomic,retain)UIActionSheet *sheet;
@property(nonatomic,retain)UIActionSheet *sheet2;

@property(nonatomic,retain)PESendNewsView *sendNewsView;

@property(nonatomic,retain)NSMutableArray *dataArray;
@end
