 //
//  PEMoreInfoView.m
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEMoreInfoView.h"
#import "UIHelper.h"

@implementation PEMoreInfoView

@synthesize qqBtn, moreInfoLbl, renrenBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor =[UIColor colorWithPatternImage:[UIHelper imageName:@"nearDetail_cell_bg"]];
        
        moreInfoLbl =[[UILabel alloc] init];
        
        qqBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        renrenBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    }
    return self;
}

- (void)layoutSubviews {
    UILabel *moreInfo =[[UILabel alloc]initWithFrame:CGRectMake(13.0f, 12.0f, 80.0f, 13.0f)];
    UILabel *shareLbl =[[UILabel alloc]initWithFrame:CGRectMake(13.0f, 44.0f, 80.0f, 13.0f)];
    moreInfo.font =[UIFont systemFontOfSize:14.5f];
    shareLbl.font =[UIFont systemFontOfSize:14.5f];
    moreInfo.textColor = [UIHelper colorWithHexString:@"#000000"];
    shareLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    moreInfo.text =@"更多说明";
    shareLbl.text =@"社交网络";
    
    //“就是喜欢你"
    moreInfoLbl.font =[UIFont systemFontOfSize:14.0f];
    moreInfoLbl.textColor = [UIHelper colorWithHexString:@"#7e7e7e"];
    moreInfoLbl.frame =CGRectMake(80.0f, 12.5f, 227.0f, 13.0f);
    
    [qqBtn setImage:[UIHelper imageName:@"qq"] forState:UIControlStateNormal];
    [renrenBtn setImage:[UIHelper imageName:@"renren"] forState:UIControlStateNormal];
    qqBtn.frame =CGRectMake(83.5f, 45.0f, 13.0f, 13.0f);
    renrenBtn.frame =CGRectMake(83.5+13+13, 45.0f, 13.0f, 13.0f);
    
    [self addSubview:moreInfo];
//    [self addSubview:shareLbl];
    [self addSubview:moreInfoLbl];
//    [self addSubview:qqBtn];
//    [self addSubview:renrenBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
