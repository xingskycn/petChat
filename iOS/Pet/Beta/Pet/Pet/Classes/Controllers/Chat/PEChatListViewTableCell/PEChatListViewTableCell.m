//
//  PEChatListViewTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-7-14.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEChatListViewTableCell.h"
#import "UIHelper.h"
@implementation PEChatListViewTableCell
@synthesize userHeadImageView,userNameLabel,userSignLabel,userTimeLabel,gapLineImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initChatTableCell];
    }
    return self;
}

- (void)initChatTableCell{
    userHeadImageView = [[UIImageView alloc]init];
    userHeadImageView.backgroundColor = [UIColor clearColor];
    userHeadImageView.frame = CGRectMake(12, 10, 50, 50);
    [self addSubview:userHeadImageView];
    
    userNameLabel = [[UILabel alloc]init];
    userNameLabel.textColor = [UIHelper colorWithHexString:@"#1a2223"];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    userNameLabel.frame = CGRectMake(71, 16, 180, 14);
    [self addSubview:userNameLabel];
    
    userSignLabel = [[UILabel alloc]init];
    userSignLabel.textColor = [UIHelper colorWithHexString:@"#939595"];
    userSignLabel.font = [UIFont systemFontOfSize:12.5];
    userSignLabel.frame = CGRectMake(71, 40.5, 120, 13);
    [self addSubview:userSignLabel];
    
    
    userTimeLabel = [[UILabel alloc]init];
    userTimeLabel.textColor = [UIHelper colorWithHexString:@"#6eb3bc"];
    userTimeLabel.font = [UIFont systemFontOfSize:11.5];
    userTimeLabel.frame = CGRectMake(ScreenWidth-65, 18, 90, 12);
    [self addSubview:userTimeLabel];
    
    gapLineImageView = [[UIImageView alloc]init];
    gapLineImageView.backgroundColor = [UIColor clearColor];
    gapLineImageView.image = [UIHelper imageName:@"chat_list_fengexian"];
    gapLineImageView.frame = CGRectMake(10,69.5, 300, 0.5);
    [self addSubview:gapLineImageView];
    
   
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
