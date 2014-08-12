//
//  PESettingEditTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PESettingEditTableCellOne.h"
#import "UIHelper.h"
@implementation PESettingEditTableCellOne
@synthesize petDataIcon,petLabel,petButton,deleteButton,gapView,arrowImageView,nameLabel;
@synthesize backGroundView,gapLineView;
@synthesize lineImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initEditCell];// Initialization code
//        self.backgroundColor = [UIHelper colorWithHexString:@"#f5f5f5"];
    }
    return self;
}

//初始化cell
-(void)initEditCell
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePetName:) name:@"changePetNameSuccess" object:nil];
    
    //=============该cell的背景图片
    
    backGroundView = [[UIImageView alloc]init];
    backGroundView.backgroundColor = [UIColor clearColor];
    backGroundView.frame = CGRectMake(0, 0, ScreenWidth, 43.5);
    [self addSubview:backGroundView];
    
    //cell之间的绿色连线
    lineImageView = [[UIImageView alloc]init];
    lineImageView.frame = CGRectMake(16, 0, 0.5, 43);
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image =[UIHelper imageName:@"edit_line_ vertical"];
    [self addSubview:lineImageView];
    

    //宠物2
    petDataIcon = [[UIImageView alloc]init];
    petDataIcon.backgroundColor = [UIColor clearColor];
    petDataIcon.image = [UIHelper imageName:@"edit_pet_info_small"];
    petDataIcon.frame = CGRectMake(31.5, 13.25f, 12.5, 16);
    [self addSubview:petDataIcon];
    
    //标题label
    petLabel = [[UILabel alloc]init];
    petLabel.textColor = [UIHelper colorWithHexString:@"#51b5c5"];
    petLabel.font = [UIFont systemFontOfSize:14];
    petLabel.text = @"宠物1";
    petLabel.frame = CGRectMake(46,14.75f,40,14);//388
    [self addSubview:petLabel];
    
    //名字label
    nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = @"JoJo";
    nameLabel.frame = CGRectMake(petLabel.frame.origin.x+40+11,15.25f,60,13);//388
    [self addSubview:nameLabel];
    
    //两个视图之间的间隔条
    gapView = [[UIView alloc]initWithFrame:CGRectMake(petLabel.frame.origin.x+40+128, 15.25f, 1, 13)];
    gapView.backgroundColor = [UIHelper colorWithHexString:@"#dcdcdc"];
    [self addSubview:gapView];
    
    //删除按钮
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIHelper imageName:@"edit_delete"] forState:UIControlStateNormal];
    deleteButton.frame = CGRectMake(ScreenWidth-31.5-28-40.5, 15.0f, 44.5, 13.5);
    [self addSubview:deleteButton];
    


    //箭头
    arrowImageView = [[UIImageView alloc]init];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.frame = CGRectMake(ScreenWidth-31.5, 15.75, 20.5, 12);
    [self addSubview:arrowImageView];
    
    //两个分区之间的绿色间隔线
    gapLineView = [[UIView alloc]init];
    gapLineView.frame = CGRectMake(96, 43, 224, 0.5);
    gapLineView.backgroundColor = [UIHelper colorWithHexString:@"#61becd"];
    [self addSubview:gapLineView];
  
    
}

//点击伸开和收起来的时候换图片：箭头，背景图，位置图标
- (void)changeArrowWithUp:(BOOL)up
{
    if (!up) {
        self.arrowImageView.image = [UIHelper imageName:@"edit_arrowImageDown"];
 
    }else
    {
        self.arrowImageView.image = [UIHelper imageName:@"edit_arrowImageUp"];
    }
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

//宠物名修改成功
- (void)changePetName:(NSNotification *)note{
    nameLabel.text =[note object];
}

@end
