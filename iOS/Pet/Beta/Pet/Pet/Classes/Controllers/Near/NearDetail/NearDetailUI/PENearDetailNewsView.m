//
//  PENearDetailNewsView.m
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailNewsView.h"
#import "UIHelper.h"

@implementation PENearDetailNewsView

@synthesize newsNumLbl, newsPetIconV, newsTitleLbl;
@synthesize newsDistanceLbl, newsTimeLbl;
@synthesize nearDetailNewsDelegate;
@synthesize arrowImgV;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor colorWithPatternImage:[UIHelper imageName:@"nearDetail_cell_bg"]];
        newsNumLbl =[[UILabel alloc] init];
        newsPetIconV =[[UIImageView alloc] init];
        newsTitleLbl =[[UILabel alloc] init];
        
        newsDistanceLbl =[[UILabel alloc] init];
        newsTimeLbl =[[UILabel alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    //最新动态
    UILabel *titleLbl =[[UILabel alloc] init];
    [titleLbl setFont:[UIFont systemFontOfSize:14.5f]];
    titleLbl.text =@"最新动态";
    CGSize siztT =[@"最新动态" sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    titleLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    titleLbl.frame = CGRectMake(13.0f, 9.0f, siztT.width, siztT.height);
    
    //125
    [newsNumLbl setFont:[UIFont boldSystemFontOfSize:25.0f]];
//    newsNumLbl.text =@"152";
    CGSize sizeNN =[@"152" sizeWithFont:[UIFont boldSystemFontOfSize:25.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsNumLbl.textColor =[UIHelper colorWithHexString:@"#ff7676"];
    newsNumLbl.textAlignment = UITextAlignmentRight;
    newsNumLbl.frame = CGRectMake(13.0f, 68-sizeNN.height+5, siztT.width, sizeNN.height);
    
    //宠物icon
    [newsPetIconV setFrame:CGRectMake(newsNumLbl.frame.size.width + 26.5, 36.f, 31.0f, 31.0f)];
//    [newsPetIconV setImage:[UIImage imageNamed:@"owner1.png"]];
    
    //右边箭头view
     arrowImgV =[[UIImageView alloc] initWithFrame:CGRectMake(302.0f, 37.0f, 8.0f, 13.5f)];//48
    [arrowImgV setImage:[UIHelper imageName:@"nearDetail_arrow_right"]];
    
    //消息名字
    [newsTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
//    newsTitleLbl.text =@"雪橇犬哈士奇纯种健康";
    CGSize sizeNT =[@"雪橇犬哈士奇纯种健康" sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsTitleLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    newsTitleLbl.textAlignment = NSTextAlignmentLeft;
    newsTitleLbl.frame = CGRectMake(newsNumLbl.frame.size.width + 61.5, 37.0, sizeNT.width, sizeNT.height);//188
    
    //距离 和消息名字间隔8px
    [newsDistanceLbl setFont:[UIFont systemFontOfSize:11.0f]];
    newsDistanceLbl.text =@"0.1km";
    CGSize sizeND =[@"0.1km" sizeWithFont:[UIFont systemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsDistanceLbl.textColor =[UIHelper colorWithHexString:@"#b2b2b2"];
    newsDistanceLbl.textAlignment = NSTextAlignmentRight;
    newsDistanceLbl.frame = CGRectMake(newsNumLbl.frame.size.width + 61.5+5, 58.0f, sizeND.width, 12);//63
    
    //距离和时间之间一个像素的间隔线 分别间距2px by wu
    UIView *view =[[UIView alloc]init];
    CGRect frame = CGRectMake(newsNumLbl.frame.size.width + 61.5+5+sizeND.width+3, 58.0f, 0.5, 11);
    view.frame = frame;
    view.backgroundColor =[UIHelper colorWithHexString:@"#dfdfdf"];
    
    
    //时间
    [newsTimeLbl setFont:[UIFont systemFontOfSize:11.0f]];
    newsTimeLbl.text =@"3分钟";
    CGSize sizeNTL =[@"3分钟" sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsTimeLbl.textColor =[UIHelper colorWithHexString:@"#b2b2b2"];
    newsTimeLbl.frame = CGRectMake(view.frame.origin.x+0.5+3, 58.0f, sizeNTL.width, 12);
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(viewPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectInset(self.bounds, 0.0f, 0.0f)];
    
    [self addSubview:titleLbl];
    [self addSubview:newsNumLbl];
    [self addSubview:newsPetIconV];
    [self addSubview:newsTitleLbl];
    [self addSubview:arrowImgV];
//    [self addSubview:newsDistanceLbl];
//    [self addSubview:view];//by wu
//    [self addSubview:newsTimeLbl];20140808
    [self addSubview:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)viewPressed {
    [nearDetailNewsDelegate didSelectAtNews];
}

@end
