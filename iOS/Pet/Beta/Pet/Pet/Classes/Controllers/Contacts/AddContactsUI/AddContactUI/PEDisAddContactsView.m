//
//  PEDisAddContactsView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEDisAddContactsView.h"
#import "UIHelper.h"

@implementation PEDisAddContactsView
@synthesize iconImageView1,iconImageView2,iconImageView3,iconImageView4;
@synthesize Label1,Label2,Label3,Label4;
@synthesize bgImageView;
@synthesize button1,button2,button3,button4;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

/**
 **第一版本去掉了创建俱乐部，通过通讯录查找好友
 **修改时注意：背景高度，Icon位置，label位置，箭头位置和个数，button位置
 **/
-(void)setupUI
{
    bgImageView = [[UIImageView alloc]init];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIHelper imageName:@"Contact_searchButtomBg"];
    bgImageView.frame = CGRectMake(0, 0, 320, 80);//160
    [self addSubview:bgImageView];
    
    iconImageView1 = [[UIImageView alloc]init];
    iconImageView1.backgroundColor = [UIColor clearColor];
    iconImageView1.image =[UIHelper imageName:@"Contact_yao"];
    iconImageView1.frame = CGRectMake(15, 8.5, 23, 23);
    [self addSubview:iconImageView1];
    
    iconImageView2 = [[UIImageView alloc]init];
    iconImageView2.backgroundColor = [UIColor clearColor];
    iconImageView2.image =[UIHelper imageName:@"Contact_createContacts"];
    iconImageView2.frame = CGRectMake(15, 48.5, 23, 23);
//    [self addSubview:iconImageView2];
    
    iconImageView3 = [[UIImageView alloc]init];
    iconImageView3.backgroundColor = [UIColor clearColor];
    iconImageView3.image =[UIHelper imageName:@"Contact_createGroup"];
    iconImageView3.frame = CGRectMake(15, 48.5, 23, 23);//15, 88.5, 23, 23
    [self addSubview:iconImageView3];
    
    iconImageView4 = [[UIImageView alloc]init];
    iconImageView4.backgroundColor = [UIColor clearColor];
    iconImageView4.image =[UIHelper imageName:@"Contact_createClub"];
    iconImageView4.frame = CGRectMake(15, 128.5, 23, 23);
//    [self addSubview:iconImageView4];
    
    Label1 = [[UILabel alloc]init];
    Label1.textColor = [UIHelper colorWithHexString:@"#063741"];
    Label1.font = [UIFont systemFontOfSize:15];
    Label1.text = @"摇一摇";
    Label1.frame = CGRectMake(46, 12.5, 100, 15);
    [self addSubview:Label1];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 320, 40);
    [self addSubview:button1];
    
    Label2 = [[UILabel alloc]init];
    Label2.textColor = [UIHelper colorWithHexString:@"#063741"];
    Label2.font = [UIFont systemFontOfSize:15];
    Label2.text = @"通过通讯录找好友";
    Label2.frame = CGRectMake(46, 52.5, 120, 15);
//    [self addSubview:Label2];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 40, 320, 40);
//    [self addSubview:button2];
    
    Label3 = [[UILabel alloc]init];
    Label3.textColor = [UIHelper colorWithHexString:@"#063741"];
    Label3.font = [UIFont systemFontOfSize:15];
    Label3.text = @"创建群组";
    Label3.frame = CGRectMake(46, 52.5,100, 15);//46, 92.5,100, 15
    [self addSubview:Label3];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0, 40, 320, 40);//0 80, 320, 40
    [self addSubview:button3];
    
    Label4 = [[UILabel alloc]init];
    Label4.textColor = [UIHelper colorWithHexString:@"#063741"];
    Label4.font = [UIFont systemFontOfSize:15];
    Label4.text = @"创建俱乐部";
    Label4.frame = CGRectMake(46, 132.5, 100, 15);
//    [self addSubview:Label4];
    
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(0, 120, 320, 40);
//    [self addSubview:button4];
    
    //添加箭头
    for(int i=0;i <2;i++){//i<4
        UIImageView *gaplineView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, 40*i+13.25f, 8.0f, 13.5f)];
        [gaplineView setImage:[UIHelper imageName:@"edit_arrow_right"]];
        [self addSubview:gaplineView];
    }
    
    //添加分隔线
    for (int i =0; i <2; i++) {//i<4
        UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 40 + 40.0f*i, 300, 0.5f)];
        [lineView setImage:[UIHelper imageName:@"Contact_gapLine"]];
        [self addSubview:lineView];
    }
    

}

@end
