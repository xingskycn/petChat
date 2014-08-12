//
//  PESettingEditTableCellOne.h
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PESettingEditTableCellOne : UITableViewCell
@property (nonatomic,retain)UIImageView *petDataIcon;//我的宠物资料前面ICon
@property(nonatomic,retain)UILabel *petLabel;//宠物1
@property(nonatomic,retain)UILabel *nameLabel;//JOJO

@property(nonatomic,retain)UIButton *petButton;
@property(nonatomic,retain)UIButton *deleteButton;
@property(nonatomic,retain)UIView *gapView;

@property(nonatomic,retain)UIImageView *arrowImageView;
@property(nonatomic,retain)UIImageView *backGroundView;//背景
@property(nonatomic,retain)UIView *gapLineView;//绿线
@property(nonatomic,retain)UIImageView *lineImageView;//连线


//改变箭头方向 
- (void)changeArrowWithUp:(BOOL)up;

@end
