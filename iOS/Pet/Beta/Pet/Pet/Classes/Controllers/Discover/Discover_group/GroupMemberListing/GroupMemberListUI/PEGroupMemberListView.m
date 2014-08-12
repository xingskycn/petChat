//
//  PEGroupMemberListView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-9.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupMemberListView.h"
#import "UIHelper.h"
@implementation PEGroupMemberListView
@synthesize iconImageView,nameLabel,numberLabel,gapLineImageView1,gapLineImageView2;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //icon
        iconImageView = [[UIImageView alloc]init];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.frame = CGRectMake(12, 8.5, 59, 23);
        [self addSubview:iconImageView];
        
        //群主  管理员  成员
        nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
        nameLabel.font = [UIFont systemFontOfSize:12.5];
        nameLabel.frame = CGRectMake(80.5, 13.5, 80, 12.5);
//        [self addSubview:nameLabel];
        
        //数字
        numberLabel = [[UILabel alloc]init];
        numberLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
        numberLabel.font = [UIFont systemFontOfSize:15];
        numberLabel.frame = CGRectMake(290, 12.5, 20,15);
        [self addSubview:numberLabel];
        
        //间隔条
        gapLineImageView1 = [[UIImageView alloc]init];
        gapLineImageView1.backgroundColor = [UIColor clearColor];
        gapLineImageView1.image = [UIHelper imageName:@"club__unOpneGapLine"];
        gapLineImageView1.frame = CGRectMake(6, 39.5, 308, 0.5);
        [self addSubview:gapLineImageView1];
        
        //间隔条2
        gapLineImageView2 = [[UIImageView alloc]init];
        gapLineImageView2.backgroundColor = [UIColor clearColor];
        gapLineImageView2.image = [UIHelper imageName:@"club__unOpneGapLine"];
        gapLineImageView2.frame = CGRectMake(6, 0, 308, 0.5);
        [self addSubview:gapLineImageView2];
    }
    return self;
}



@end
