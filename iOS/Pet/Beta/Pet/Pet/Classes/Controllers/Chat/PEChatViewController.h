//
//  PEChatViewController.h
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PETableView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PEFaceView.h"
#import "PEXMPP.h"

@interface PEChatViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FaceViewDeleaget>

@property int type;
@property (nonatomic, retain) NSString *toRoomJID;

@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSString *toJID;
@property (retain, nonatomic) PETableView* myTableView;
@property (retain, nonatomic) UIView* toolView;
@property (retain, nonatomic) UITextField *textField;
@property (retain, nonatomic) PEFaceView *faceView;
@property (retain, nonatomic) UIView* plusView;
@property (retain, nonatomic) UIScrollView* scrollView;
@property (retain, nonatomic) UIPageControl* pageControl;

@property (retain, nonatomic) UIActionSheet *sheet;


@property (nonatomic, retain) PEXMPP *xmpp;

@property BOOL isFace;
@property BOOL isPlus;
@end
