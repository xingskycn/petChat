//
//  PENearDetailVedioView.m
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailVedioView.h"
#import "UIHelper.h"

@implementation PENearDetailVedioView

@synthesize bgView;
@synthesize vedioNumLbl, vedioPetIconV, vedioTitleLbl,playVedioBtn,arrowBtn;
@synthesize playImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bgView =[[UIImageView alloc] init];
        
        vedioNumLbl =[[UILabel alloc] init];
        vedioPetIconV =[[UIImageView alloc] init];
        vedioTitleLbl =[[UILabel alloc] init];
        playVedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playImageView = [[UIImageView alloc]init];
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
    
    //大白色背景图
    UIImage *bgImg =[UIHelper imageName:@"nearDetail_cell_bg"];
    [bgImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgView setFrame:CGRectInset(self.bounds, 0.0f, 0.0f)];
    [bgView setImage:bgImg];
    
    //视频
    UILabel *titleLbl =[[UILabel alloc] init];
    [titleLbl setFont:[UIFont systemFontOfSize:14.5f]];
    titleLbl.text =@"视频";
    CGSize siztT =[@"视频      " sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    titleLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    titleLbl.frame = CGRectMake(13.0f, 9.0f, siztT.width, siztT.height);
    
    //视频数字 1
    [vedioNumLbl setFont:[UIFont boldSystemFontOfSize:25.0f]];
//    vedioNumLbl.text =@"13";
    CGSize sizeNN =[@"13" sizeWithFont:[UIFont boldSystemFontOfSize:25.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    vedioNumLbl.textColor =[UIHelper colorWithHexString:@"#009cff"];
    vedioNumLbl.textAlignment =NSTextAlignmentRight;
    vedioNumLbl.frame = CGRectMake(13.0f, 84-sizeNN.height+12, siztT.width,sizeNN.height);
    
    //视频icon
    [vedioPetIconV setFrame:CGRectMake(vedioNumLbl.frame.size.width + 26.5, 31.0f, 61.0f, 61.0f)];
//    [vedioPetIconV setImage:[UIHelper imageName:@"Video_test"]]; //nearDetail_vedio_icon_bg 20140809
    playImageView.backgroundColor = [UIColor clearColor];
    playImageView.image = [UIHelper imageName:@"vedio_play"];
    playImageView.userInteractionEnabled = YES;
    playImageView.frame = CGRectMake(18.75, 18.75, 23.5, 23.5);
    
    //视频icon上面覆盖的button
    playVedioBtn.frame = CGRectMake(vedioNumLbl.frame.size.width + 26.5, 31.0f, 61.0f, 61.0f);
    playVedioBtn.userInteractionEnabled = YES;
    
    //箭头
    UIImageView *arrowImgV =[[UIImageView alloc] initWithFrame:CGRectMake(302.0f, 43.25f, 8.0f, 13.5f)];//48
    [arrowImgV setImage:[UIHelper imageName:@"nearDetail_arrow_right"]];
    arrowBtn.frame = CGRectMake(0, 0, 320,100 );
    arrowBtn.userInteractionEnabled=YES;
    
    //标题
    [vedioTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
    vedioTitleLbl.text =@"圣萌级睡相";
    CGSize sizeNT =[@"圣萌级睡相" sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    vedioTitleLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    vedioTitleLbl.frame = CGRectMake(vedioPetIconV.frame.origin.x+vedioPetIconV.frame.size.width+10, 34.0f, 188.0f, 14);//vedioNumLbl.frame.size.width + 91.5
    
    [self addSubview:bgView];
    [self addSubview:titleLbl];
    [self addSubview:vedioNumLbl];
    [self addSubview:vedioPetIconV];
    [vedioPetIconV addSubview:playImageView];
    [self addSubview:vedioTitleLbl];
    [self addSubview:arrowImgV];
    [self addSubview:arrowBtn];
    [self addSubview:playVedioBtn];
}


@end
