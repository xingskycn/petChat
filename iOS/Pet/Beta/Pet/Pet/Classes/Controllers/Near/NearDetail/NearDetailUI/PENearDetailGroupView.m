//
//  PENearDetailGroupView.m
//  Pet
//
//  Created by Wu Evan on 6/16/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailGroupView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"

@implementation PENearDetailGroupView

@synthesize titleName, count;
@synthesize dataArray, groupID;
@synthesize nearDetailGroupDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleName =[[NSString alloc]init];
        dataArray =[[NSArray alloc] init];
        groupID =[[NSString alloc] init];
        self.backgroundColor =[UIColor colorWithPatternImage:[UIHelper imageName:@"nearDetail_cell_bg"]];
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
    
    //宠聊群组
    UILabel *titleLbl =[[UILabel alloc] init];
    [titleLbl setFont:[UIFont systemFontOfSize:14.5f]];
    titleLbl.text =[NSString stringWithFormat:@"%@ (%d)", titleName, dataArray.count];
    CGSize siztT =[titleLbl.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    titleLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    titleLbl.frame = CGRectMake(13.0f, 9.0f, siztT.width, siztT.height);
    
    UIScrollView *sv =[[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, 0.0f, 0.0f)];
    
    for (int i =0; i<dataArray.count; i++) {
        UIButton *groupBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [groupBtn setFrame:CGRectMake(23.0f +69*i, 0.0f, 69.0f, 88.5f)];
        [groupBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        groupBtn.tag =i;
        
        UIImageView *icon =[[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 36.0f, 31.0f, 31.0f)];
        NSURL *url =[NSURL URLWithString:[dataArray[i] objectForKey:NEAR_DETAIL_GROUP_IMAGE_URL]];
        [icon setImageWithURL:url placeholderImage:[UIImage imageNamed:@"owner1.png"]];
        
        UILabel *name =[[UILabel alloc] init];
        [name setFont:[UIFont systemFontOfSize:12.0f]];
        name.text =[dataArray[i] objectForKey:NEAR_DETAIL_GROUP_NAME];
        name.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        name.textAlignment =UITextAlignmentCenter;
        name.frame = CGRectMake(0, 70.0f, 61.0f, 12.0f);
        
        [groupBtn addSubview:icon];
        [groupBtn addSubview:name];
        [sv addSubview:groupBtn];
    }
    
    sv.contentSize =CGSizeMake(69.0f*(dataArray.count +1), 90.5f);
    sv.backgroundColor =[UIColor clearColor];
    sv.bounces =NO;
    sv.showsHorizontalScrollIndicator =NO;
    sv.showsVerticalScrollIndicator =NO;
    
    [self addSubview:titleLbl];
    [self addSubview:sv];
}

- (void)btnPressed:(UIButton *)sender {
    [nearDetailGroupDelegate didSelectAtGroup:sender.tag];
}

@end
