//
//  PEDisContactsTableCell.h
//  Pet
//
//  Created by WuJunqiu on 14-7-23.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
//表头部分的cell
@interface PEDisContactsTableCell : UITableViewCell

@property(nonatomic,retain)UIImageView *iconImageView;
@property(nonatomic,retain)UILabel *groupNameLabel;
@property(nonatomic,retain)UILabel *groupPeopleCountLabel;
@property(nonatomic,retain)UIImageView *arrowImageView;
@property(nonatomic,retain)UIImageView *lineImageView;
@property(nonatomic,retain)UIImageView *bgImageView;
@property(nonatomic,retain)UILabel *createLabel;
@property(nonatomic,retain)UIButton *createGroupBtn;

@end
