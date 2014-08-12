//
//  PEChatListViewTableCell.h
//  Pet
//
//  Created by WuJunqiu on 14-7-14.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEChatListViewTableCell : UITableViewCell

@property(nonatomic,retain)UIImageView *userHeadImageView;
@property(nonatomic,retain)UIImageView *gapLineImageView;
@property(nonatomic,retain)UILabel *userNameLabel;
@property(nonatomic,retain)UILabel *userSignLabel;
@property(nonatomic,retain)UILabel *userTimeLabel;

@end
