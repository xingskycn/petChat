//
//  PEEditOtherView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEEditOtherView.h"
#import "UIHelper.h"
@implementation PEEditOtherView
@synthesize moreLabel,connectLabel,otherlabel;
@synthesize moreInfoLabel,iconImageView1,iconImageView2;
@synthesize otherLineImageView,otherLineImageCircle;
@synthesize changePwdLbl;
@synthesize moreBtn, changeBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI]; // Initialization code
    }
    return self;
}

-(void)setupUI
{
    //其他资料Icon
    UIImageView *moreInfoImageView = [[UIImageView alloc]init];
    moreInfoImageView.image = [UIHelper imageName:@"edit_other_info"];
    moreInfoImageView.backgroundColor = [UIColor clearColor];
    moreInfoImageView.frame = CGRectMake(6.0f, 0.0f, 21.0f, 21.0f);
    [self addSubview:moreInfoImageView];
    
    //其他资料label
    otherlabel = [[UILabel alloc]init];
    otherlabel.textColor =[UIHelper colorWithHexString:@"#51b5c5"];
    otherlabel.font =[UIFont systemFontOfSize:11.0f];
    otherlabel.text =@"其他资料";
    otherlabel.frame = CGRectMake(32.0f, 5.0f, 200.0f, 11.0f);
    [self addSubview:otherlabel];
    
    //更多说明
    moreLabel = [[UILabel alloc]init];
    moreLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    moreLabel.font = [UIFont systemFontOfSize:13];
    moreLabel.text = @"更多说明";
    CGSize sizePS = [moreLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    moreLabel.frame = CGRectMake(22.0, 40, sizePS.width, sizePS.height);
    [self addSubview:moreLabel];
    
    //输入更多说明
    moreInfoLabel = [[UILabel alloc]init];
    moreInfoLabel.textColor = [UIHelper colorWithHexString:@"#c2c2c2"];
    moreInfoLabel.font = [UIFont systemFontOfSize:13];
    moreInfoLabel.text = @"输入更多说明";
    CGSize sizeMF = [connectLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    moreInfoLabel.frame = CGRectMake(92.0, 40, 250, 13);
    [self addSubview:moreInfoLabel];
    
    

    
    //箭头
    UIImageView *aorrow1 =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 40, 8.0f, 13.5f)];
    [aorrow1 setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:aorrow1];
    
//    //社交网络
//    connectLabel = [[UILabel alloc]init];
//    connectLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
//    connectLabel.font = [UIFont systemFontOfSize:13];
//    connectLabel.text = @"社交网络";
//    CGSize sizeCL = [connectLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
//    connectLabel.frame = CGRectMake(22.0, 80, sizeCL.width, sizeCL.height);
//    [self addSubview:connectLabel];
//    
//    //箭头
//    UIImageView *aorrow2 =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 81, 8.0f, 13.5f)];
//    [aorrow2 setImage:[UIHelper imageName:@"edit_arrow_right"]];
//    [self addSubview:aorrow2];
//    
//
//    
//    //微博，人人
//    iconImageView1 = [[UIImageView alloc]init];
//    iconImageView1.image = [UIHelper imageName:@"edit_tencent_icon"];
//    iconImageView1.backgroundColor = [UIColor clearColor];
//    iconImageView1.frame = CGRectMake(95, 78, 16, 16);
//    [self addSubview:iconImageView1];
//    
//    
//    iconImageView2 = [[UIImageView alloc]init];
//    iconImageView2.image = [UIHelper imageName:@"edit_renren_icon"];
//    iconImageView2.backgroundColor = [UIColor clearColor];
//    iconImageView2.frame = CGRectMake(124, 78, 16, 16);
//    [self addSubview:iconImageView2];

    for(int i = 0;i<2;i++){
        UIImageView *gaplineView =[[UIImageView alloc] initWithFrame:CGRectMake(92.0f, 67+ 40.0f*i, 228.0f, 1.0f)];//446
        [gaplineView setImage:[UIHelper imageName:@"edit_line"]];
        [self addSubview:gaplineView];
    }
    
    //箭头
    UIImageView *aorrow3 =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 81, 8.0f, 13.5f)];
    [aorrow3 setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:aorrow3];
    
    
    changePwdLbl = [[UILabel alloc]init];
    changePwdLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    changePwdLbl.font = [UIFont systemFontOfSize:13];
    changePwdLbl.text = @"更改密码";
    CGSize sizeCPL = [changePwdLbl.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    changePwdLbl.frame = CGRectMake(22.0, 80, sizeCPL.width, sizeCPL.height);
    [self addSubview:changePwdLbl];
    
    //微博，人人
//    iconImageView1 = [[UIImageView alloc]init];
//    iconImageView1.image = [UIHelper imageName:@"edit_tencent_icon"];
//    iconImageView1.backgroundColor = [UIColor clearColor];
//    iconImageView1.frame = CGRectMake(95, 78, 16, 16);
//    [self addSubview:iconImageView1];
    
    
    //绿色连线
    otherLineImageView = [[UIImageView alloc]init];
    otherLineImageView.image = [UIHelper imageName:@"edit_line_ vertical"];
    otherLineImageView.frame = CGRectMake(16, 16, 0.5, 105);
    otherLineImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:otherLineImageView];
    
    //绿色连线结尾的点
    otherLineImageCircle = [[UIImageView alloc]init];
    otherLineImageCircle.image = [UIHelper imageName:@"edit_line_verticalCircle"];
    otherLineImageCircle.frame = CGRectMake(14, 121, 4.5, 4.5);
    otherLineImageCircle.backgroundColor = [UIColor clearColor];
    [self addSubview:otherLineImageCircle];
    
    
    //透明按钮
    moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(92.0f, 27.0, 228.0f, 40.0f)];
    [moreBtn addTarget:self action:@selector(moreBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    
    changeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake(92.0f, 67.0, 228.0f, 40.0f)];
    [changeBtn addTarget:self action:@selector(changeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)moreBtnPressed:(UIButton *)sender {
    [delegate didMoreBtn:sender];
}

- (void)changeBtnPressed:(UIButton *)sender {
    [delegate didChangeBtn:sender];
}

@end
