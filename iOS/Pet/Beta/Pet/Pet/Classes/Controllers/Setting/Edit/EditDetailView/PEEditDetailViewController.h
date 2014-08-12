//
//  PEEditDetailViewController.h
//  Pet
//
//  Created by WuJunqiu on 14-7-29.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PESettingEditTableCellTwo.h"
#import "Common.h"

@interface PEEditDetailViewController : UIViewController<EditDoneDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITextField *myTextField;
@property(nonatomic,retain)UILabel *remainLabel;
@property(nonatomic,retain)NSString *infomationString;
@property(nonatomic,retain)NSDictionary *dic;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)NSInteger selectSection;

@end
