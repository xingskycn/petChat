//
//  PEDisGroupCellOne.m
//  Pet
//
//  Created by WuJunqiu on 14-6-30.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisGroupCellOne.h"
#import "UIHelper.h"
@implementation PEDisGroupCellOne
@synthesize iconImageView,groupNameLabel,distanceImageView,distanceLable,arrowImageView,lineImageView,bgImageView;
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
    groupNameLabel.text = @"创意园";
    groupNameLabel.frame = CGRectMake(35+9.5, 12, 100, 16);
    [self addSubview:groupNameLabel];
    
    //距离图标view
    distanceImageView = [[UIImageView alloc]init];
    distanceImageView.frame = CGRectMake(242, 29/2, 7.5, 11);
    UIImage *headerLocationImage = [UIHelper imageName:@"club__locationImageOne"];
    distanceImageView.image= headerLocationImage;
    distanceImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:distanceImageView];
    
    //显示距离label
    distanceLable = [[UILabel alloc]init];
    distanceLable.textAlignment = NSTextAlignmentLeft;
    distanceLable.textColor = [UIColor whiteColor];
    distanceLable.font =[UIFont systemFontOfSize:12.5];
    distanceLable.text = @"550m";
    distanceLable.frame = CGRectMake(249.5+4, 29/2, 50, 11);//间隔4px
    distanceLable.backgroundColor = [UIColor clearColor];
    [self addSubview:distanceLable];
    
    //箭头图标view
    arrowImageView = [[UIImageView alloc]init];
    arrowImageView.frame = CGRectMake(ScreenWidth-12-11.5, 18, 11.5, 6);
    UIImage *arrowImage = [UIHelper imageName:@"club_UpAccessory"];
    arrowImageView.image= arrowImage;
    arrowImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:arrowImageView];
    
    //间隔条
    lineImageView = [[UIImageView alloc]init];
    lineImageView.frame = CGRectMake(6, 39.5, 308, 0.5);
    UIImage *lineImage = [UIHelper imageName:@"club__unOpneGapLine"];
    lineImageView.image= lineImage;
    lineImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:lineImageView];
    

    
}

//点击伸开和收起来的时候换图片：箭头，背景图，位置图标
- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIHelper imageName:@"club_UpAccessory"];
        bgImageView.image = [UIHelper imageName:@"club_openSelectedTitle"];
        iconImageView.image = [UIHelper imageName:@"club_titleIcon"];
        distanceImageView.image = [UIHelper imageName:@"club__locationImageOne"];
        
        //改显示字体的RGB;
        groupNameLabel.textColor = [UIHelper colorWithHexString:@"#1f8396"];
        distanceLable.textColor = [UIHelper colorWithHexString:@"#1f8396"];
        
       
    }else
    {
        self.arrowImageView.image = [UIHelper imageName:@"club_DownAccessory"];
        bgImageView.image = nil;
        iconImageView.image = [UIHelper imageName:@"club_titleIconTwo"];
        distanceImageView.image = [UIHelper imageName:@"club__locationImageTwo"];
        
        //改显示字体的RGB;
        groupNameLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
        distanceLable.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    }
}
#pragma mark - NSNotification


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
