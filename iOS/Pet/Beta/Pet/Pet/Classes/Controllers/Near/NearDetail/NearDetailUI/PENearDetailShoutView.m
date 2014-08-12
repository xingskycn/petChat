//
//  PENearDetailShoutView.m
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailShoutView.h"
#import "UIHelper.h"

@implementation PENearDetailShoutView

@synthesize shoutNumLbl, shoutPetIconV, shoutTitleLbl;
@synthesize shoutDistanceLbl, shoutTimeLbl;
@synthesize nearDetailShoutDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor colorWithPatternImage:[UIHelper imageName:@"nearDetail_cell_bg"]];
        shoutNumLbl =[[UILabel alloc] init];
        shoutPetIconV =[[UIImageView alloc] init];
        shoutTitleLbl =[[UILabel alloc] init];
        
        shoutDistanceLbl =[[UILabel alloc] init];
        shoutTimeLbl =[[UILabel alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    
    //宠聊喊话
    UILabel *titleLbl =[[UILabel alloc] init];
    [titleLbl setFont:[UIFont systemFontOfSize:14.5f]];
    titleLbl.text =@"宠聊喊话";
    CGSize siztT =[@"宠聊喊话" sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    titleLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    titleLbl.frame = CGRectMake(13.0f, 9.0f, siztT.width, 13);
    
    //16
    [shoutNumLbl setFont:[UIFont boldSystemFontOfSize:25.0f]];
//    shoutNumLbl.text =@"16";
    CGSize sizeNN =[@"16" sizeWithFont:[UIFont boldSystemFontOfSize:25.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    shoutNumLbl.textColor =[UIHelper colorWithHexString:@"#76d6e9"];
    shoutNumLbl.textAlignment =UITextAlignmentRight;
    shoutNumLbl.frame = CGRectMake(13.0f, 68-sizeNN.height+5, siztT.width, sizeNN.height);
    
    //喊话宠物icon
    [shoutPetIconV setFrame:CGRectMake(shoutNumLbl.frame.size.width + 26.5, 36.f, 31.0f, 31.0f)];
//    [shoutPetIconV setImage:[UIImage imageNamed:@"owner1.png"]];
    
    //箭头
    UIImageView *arrowImgV =[[UIImageView alloc] initWithFrame:CGRectMake(302.0f, 37.0f, 8.0f, 13.5f)];//48
    [arrowImgV setImage:[UIHelper imageName:@"nearDetail_arrow_right"]];
    
    //喊话标题
    [shoutTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
//    shoutTitleLbl.text =@"最近JoJo老是掉毛，求解";
    CGSize sizeNT =[@"最近JoJo老是掉毛，求解" sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    shoutTitleLbl.textAlignment = NSTextAlignmentLeft;
    shoutTitleLbl.textColor = [UIHelper colorWithHexString:@"#7e7e7e"];
    shoutTitleLbl.frame = CGRectMake(shoutNumLbl.frame.size.width + 61.5, 37.0, sizeNT.width, sizeNT.height);//188
    
    //距离 和消息名字间隔8px
    [shoutDistanceLbl setFont:[UIFont systemFontOfSize:11.0f]];
    shoutDistanceLbl.text =@"0.1km";
    CGSize sizeND =[@"0.1km" sizeWithFont:[UIFont systemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    shoutDistanceLbl.textColor =[UIHelper colorWithHexString:@"#b2b2b2"];
    shoutDistanceLbl.textAlignment = NSTextAlignmentRight;
    shoutDistanceLbl.frame = CGRectMake(shoutNumLbl.frame.size.width + 61.5+5, 58.0f, sizeND.width, 12);//63
    
    
    //距离和时间之间一个像素的间隔线 分别间距2px by wu
    UIView *view =[[UIView alloc]init];
    CGRect frame = CGRectMake(shoutNumLbl.frame.size.width + 61.5+5+sizeND.width+3, 58.0f, 0.5, 11);
    view.frame = frame;
    view.backgroundColor =[UIHelper colorWithHexString:@"#dfdfdf"];
    
    
    //时间
    [shoutTimeLbl setFont:[UIFont systemFontOfSize:11.0f]];
    shoutTimeLbl.text =@"3分钟";
    CGSize sizeNTL =[@"3分钟" sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    shoutTimeLbl.textColor =[UIHelper colorWithHexString:@"#b2b2b2"];
    shoutTimeLbl.frame = CGRectMake(view.frame.origin.x+0.5+3, 58.0f, sizeNTL.width, 12);
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(viewPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectInset(self.bounds, 0.0f, 0.0f)];
    
    [self addSubview:titleLbl];
    [self addSubview:shoutNumLbl];
    [self addSubview:shoutPetIconV];
    [self addSubview:shoutTitleLbl];
    [self addSubview:arrowImgV];
    
//    [self addSubview:shoutDistanceLbl];
//    [self addSubview:view];//by wu
//    [self addSubview:shoutTimeLbl];20140808
    [self addSubview:btn];
}

- (void)viewPressed {
    [nearDetailShoutDelegate didSelectAtShout];
}

@end
