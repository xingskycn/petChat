//
//  PEGroupNewsTableCell.h
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEGroupNewsTableCell : UITableViewCell

@property (retain, nonatomic) UIImageView *imageV;
@property (retain, nonatomic) UIImageView *petImgContent;
@property (retain, nonatomic) UIImageView *petSortV;
@property (retain, nonatomic) UILabel *petNameLbl;
@property (retain, nonatomic) UILabel *petSortLbl;
@property (retain, nonatomic) UILabel *ownerNameLbl;
@property (retain, nonatomic) UIImageView *detailView;
@property (retain, nonatomic) UIImageView *ownerImageContent;
@property (retain, nonatomic) NSString *petSort;
@property (retain, nonatomic) NSString *petSex;
@property (nonatomic, retain) NSString *petForward;
@property (retain, nonatomic) UIView *headLineView;//头像之间的连线

@property(retain,nonatomic)UIView *gapLineView;


@property(nonatomic,retain)UILabel *groupTitleLabel;//协会
@property(nonatomic,retain)UILabel *groupNewsLabel;//群成员退出群组
@property (retain, nonatomic) UILabel *distanceLabel;
@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UIView *gapLine;//时间距离分割线

@end
