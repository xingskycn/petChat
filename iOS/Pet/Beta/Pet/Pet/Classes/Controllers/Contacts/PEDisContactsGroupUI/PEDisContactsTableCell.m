//
//  PEDisContactsTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-7-23.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisContactsTableCell.h"
#import "UIHelper.h"
@implementation PEDisContactsTableCell
@synthesize iconImageView,groupNameLabel,arrowImageView,lineImageView,bgImageView,createGroupBtn,createLabel,groupPeopleCountLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCellOne];
    }
    return self;
}

-(void)initCellOne
{
    //选中时背景 视图添加顺序导致的问题
    bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, 0, 320, 40);
    //    UIImage *bgImage = [UIHelper imageName:@"club_openSelectedTitle"];
    //    bgImageView.image= bgImage;
    bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgImageView];
    
    //群名字icon,白色
    iconImageView = [[UIImageView alloc]init];
    iconImageView.frame = CGRectMake(12, 8.5, 23, 23);
    UIImage *iconImage = [UIHelper imageName:@"club_titleIconTwo"];
    iconImageView.image= iconImage;
    iconImageView.backgroundColor = [UIColor clearColor];
    //iconimageView.layer.cornerRadius = 11.5;//值越大，弧度越大
    //iconimageView.layer.masksToBounds = YES;
    [self addSubview:iconImageView];
    
    //标题label
    groupNameLabel = [[UILabel alloc]init];
    groupNameLabel.textAlignment = NSTextAlignmentLeft;
    groupNameLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    groupNameLabel.font =[UIFont systemFontOfSize:12.5];
    groupNameLabel.text = @"群组";
    groupNameLabel.frame = CGRectMake(35+9.5, 13.75, 100, 12.5);
    [self addSubview:groupNameLabel];
    
    //群组人数
    groupPeopleCountLabel = [[UILabel alloc]init];
    groupPeopleCountLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    groupPeopleCountLabel.font =[UIFont systemFontOfSize:12.5];
    groupPeopleCountLabel.text = @"(18)";
    groupPeopleCountLabel.frame = CGRectMake(75, 13.75, 35, 12.5);
    [self addSubview:groupPeopleCountLabel];
    
    
    
    
    //显示"创建群组"label
    createLabel = [[UILabel alloc]init];
    createLabel.textAlignment = NSTextAlignmentLeft;
    createLabel.textColor = [UIColor whiteColor];
    createLabel.font =[UIFont systemFontOfSize:12.5];
    createLabel.text = @"创建群组";
    createLabel.frame = CGRectMake(243, 29/2, 50, 12.5);//间隔4px
    createLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:createLabel];
    
    
    //向右箭头图标view
    arrowImageView = [[UIImageView alloc]init];
    arrowImageView.frame = CGRectMake(ScreenWidth-12-7.5, 13.5, 7.5, 13);
    UIImage *arrowImage = [UIHelper imageName:@"Contact_createGroup_rightArrow"];
    arrowImageView.image= arrowImage;
    arrowImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:arrowImageView];
    
    //创建群组button
    createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createGroupBtn.frame = CGRectMake(ScreenWidth-80, 0, 80, 40);
    [self addSubview:createGroupBtn];
    
    //间隔条
    lineImageView = [[UIImageView alloc]init];
    lineImageView.frame = CGRectMake(6, 39.5, 308, 0.5);
    UIImage *lineImage = [UIHelper imageName:@"club__unOpneGapLine"];
    lineImageView.image= lineImage;
    lineImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:lineImageView];
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
