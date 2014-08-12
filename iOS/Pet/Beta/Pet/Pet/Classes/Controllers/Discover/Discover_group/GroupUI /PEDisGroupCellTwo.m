//
//  PEDisGameCellTwo.m
//  Pet
//
//  Created by WuJunqiu on 14-6-28.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisGroupCellTwo.h"
#import "UIHelper.h"
@implementation PEDisGroupCellTwo
@synthesize groupPetHeadImageView,groupStarImageview,groupCellGapLine;
@synthesize groupNameLabel,groupPeopleCountlabel,groupSignLable;
@synthesize groupBgImageView;
@synthesize groupRankLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCellTwo];
         self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)initCellTwo
{
    //群展开背景图片 透明度为%60的白色背景
    groupBgImageView = [[UIImageView alloc]init];
    UIImage *bgImage = [UIHelper imageName:@"club_disPlayBgImage"];
    groupBgImageView.image = bgImage;
    groupBgImageView.frame = CGRectMake(0, 0, 320, 74);
    groupBgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:groupBgImageView];
    
    //宠物头像
    groupPetHeadImageView = [[UIImageView alloc]init];
    UIImage *petImage = [UIHelper imageName:@"club_petHeadImage"];
    groupPetHeadImageView.image = petImage;
    groupPetHeadImageView.frame = CGRectMake(12, 12, 50, 50);
    groupPetHeadImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:groupPetHeadImageView];
    
    //群组名字
    groupNameLabel = [[UILabel alloc]init];
    groupNameLabel.textAlignment = NSTextAlignmentLeft;
    groupNameLabel.textColor = [UIHelper colorWithHexString:@"#0b5c6c"];
    groupNameLabel.font =[UIFont systemFontOfSize:14];
    CGSize sizeGN = [groupNameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    groupNameLabel.frame = CGRectMake(68, 13, 200, 13);
    groupNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:groupNameLabel];
    
    //群组人数
    groupPeopleCountlabel = [[UILabel alloc]init];
    groupPeopleCountlabel.textAlignment = NSTextAlignmentLeft;
    groupPeopleCountlabel.textColor = [UIHelper colorWithHexString:@"#5c8995"];
    groupPeopleCountlabel.font =[UIFont systemFontOfSize:11];
    groupPeopleCountlabel.frame = CGRectMake(68, 31, 100, 11);
    groupPeopleCountlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:groupPeopleCountlabel];
    
    //群签名
    groupSignLable = [[UILabel alloc]init];
    groupSignLable.textAlignment = NSTextAlignmentLeft;
    groupSignLable.textColor = [UIHelper colorWithHexString:@"#7c9fa9"];
    groupSignLable.font =[UIFont systemFontOfSize:11];
    groupSignLable.frame = CGRectMake(68, 50, 240, 15);
    groupSignLable.backgroundColor = [UIColor clearColor];
    [self addSubview:groupSignLable];
    
    //群星级图片
    groupStarImageview = [[UIImageView alloc]init];
    UIImage *starImage = [UIHelper imageName:@"club_starIcon"];
    groupStarImageview.image = starImage;
    groupStarImageview.frame = CGRectMake(290, 12, 12.5, 15.5);
    groupStarImageview.backgroundColor = [UIColor clearColor];
    [self addSubview:groupStarImageview];
    
    //群星级显示label-显示星级里面的数字
    groupRankLabel = [[UILabel alloc]init];
    groupRankLabel.textAlignment = NSTextAlignmentCenter;
    groupRankLabel.textColor = [UIColor whiteColor];
    groupRankLabel.font =[UIFont systemFontOfSize:8];
    groupRankLabel.frame = CGRectMake(290, 13, 12.5, 8);
    groupRankLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:groupRankLabel];
    
    
    //cell间隔条 245*0.5 蓝颜色的线
    groupCellGapLine = [[UIImageView alloc]init];
    UIImage *cellGapLineImage = [UIHelper imageName:@"club_cellGapLine"];
    groupCellGapLine.image = cellGapLineImage;
    groupCellGapLine.frame = CGRectMake(68, 73.5, 240, 0.5);
    groupCellGapLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:groupCellGapLine];
    
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
