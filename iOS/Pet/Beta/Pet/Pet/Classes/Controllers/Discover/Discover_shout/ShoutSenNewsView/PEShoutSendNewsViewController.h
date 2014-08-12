//
//  PEShoutSendNewsViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-31.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PESendNewsView.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface PEShoutSendNewsViewController : UIViewController<UIAlertViewDelegate,SendNewsDelegate,SendNewsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *newsType;
@property(nonatomic,retain)NSString *newsTypeString;

@property(nonatomic,retain)NSURL *videoURL;
@property (nonatomic) BOOL hasMp4;
@property (retain, nonatomic)NSString *mp4Path;
@property (nonatomic) BOOL hasVedio;
@property (retain, nonatomic)UIAlertView *alertView;



@property(nonatomic,retain)UIActionSheet *sheet;
@property(nonatomic,retain)UIActionSheet *sheet2;

@property(nonatomic,retain)PESendNewsView *senNewsView;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UIBarButtonItem *sendBtn;
@end
