//
//  PEAddFindFriendsTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-7-21.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEAddFindFriendsTableCell.h"
#import "UIHelper.h"
@implementation PEAddFindFriendsTableCell
@synthesize imageV, petNameLbl, petSortV, petSortLbl,petImgContent;
@synthesize  ownerNameLbl, ownerImageContent;
@synthesize petSort, petSex;
@synthesize petForward,headLineView,gapLine,gapLineView,contactBookImageView;//by wu
@synthesize contactNameLabel,addBtn;

- (void)awakeFromNib
{
    // Initialization code
    imageV =[[UIImageView alloc] init];
    petNameLbl =[[UILabel alloc] init];
    petSortV =[[UIImageView alloc] init];
    petSortLbl =[[UILabel alloc] init];
    contactNameLabel = [[UILabel alloc]init];
  
    petImgContent =[[UIImageView alloc] init];

    petForward = [[NSString alloc]init];
    headLineView = [[UIView alloc]init];

    
    ownerNameLbl =[[UILabel alloc] init];
    ownerImageContent =[[UIImageView alloc] init];
    gapLineView = [[UIView alloc]init];
    contactBookImageView = [[UIImageView alloc]init];
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    petSex =[[NSString alloc] init];
    
    petSort =[[NSString alloc] init];

}

- (void)layoutSubviews {
    
   UIView *detailView =[[UIView alloc]initWithFrame:CGRectMake(5.0f, 19.0f, 310.0f, 87.0f)];
    
    //用户头像上面的白色线条
    headLineView.frame = CGRectMake(275, 0, 2, 6);
    headLineView.backgroundColor = [UIColor whiteColor];
    headLineView.alpha = 0.3;

    //宠物头像
    petImgContent.layer.cornerRadius = 7.0f;
    petImgContent.layer.masksToBounds = YES;
    [petImgContent setFrame:CGRectMake(0.0f, 0.0f, 89.5f, 87.0f)];

    //白色大背景图
    UIImage *img =[UIHelper imageName:@"near_cell_bg"];
    [img stretchableImageWithLeftCapWidth:100 topCapHeight:0.0f];
    [imageV setImage:img];
    [imageV setFrame:CGRectMake(83.0f, 0.0f, 227.0f, 87.0f)];
    

    //宠物名
    petNameLbl.backgroundColor = [UIColor clearColor];
    petNameLbl.numberOfLines = 0;
    petNameLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petNameLbl.font = [UIFont boldSystemFontOfSize:14.0];
    petNameLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    CGSize sizePN = [petNameLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petNameLbl setFrame:CGRectMake(97.0f, 8.0f, sizePN.width, sizePN.height)];
    
    //苏格兰折耳前面的icon
    if ([petSex isEqualToString:@"公"]) {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petSort]]];
    }else {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petSort]]];
    }
    [petSortV setFrame:CGRectMake(97.0f, 33.0f, 14.0f, 11.0f)];
    
    
    //苏格兰折耳
    petSortLbl.backgroundColor = [UIColor clearColor];
    petSortLbl.numberOfLines = 0;
    petSortLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petSortLbl.font = [UIFont systemFontOfSize:12.0];
    petSortLbl.text = @"苏格兰折耳";
    petSortLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    CGSize sizePS = [petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petSortLbl setFrame:CGRectMake(117.0f, 33.0f, sizePS.width, sizePS.height)];
    
    //绿色间隔条
    gapLineView.backgroundColor = [UIHelper colorWithHexString:@"#aed0d8"];
    gapLineView.frame = CGRectMake(97.0f, 51, 206, 0.5);
    
    //联系人本图像
    contactBookImageView.backgroundColor = [UIColor clearColor];
    contactBookImageView.image = [UIHelper imageName:@"Contact_contactBook"];
    contactBookImageView.frame = CGRectMake(97.0f, 62, 15, 15);
    
    //anni姐姐
    contactNameLabel.textColor = [UIHelper colorWithHexString:@"#ec6941"];
    contactNameLabel.font = [UIFont systemFontOfSize:13.5];
    contactNameLabel.text = @"anni 姐姐";
    contactNameLabel.frame = CGRectMake(124, 62, 70, 13.5);
    
    [detailView addSubview:petImgContent];
    [detailView addSubview:imageV];
    [detailView addSubview:petSortV];
    [detailView addSubview:gapLineView];
    [detailView addSubview:contactBookImageView];
    [detailView addSubview:contactNameLabel];
    [detailView addSubview:petNameLbl];
    [detailView addSubview:petSortLbl];
    
    //用户头像背景
    UIImageView *ownerImage =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_cell_owner_bg"]];
    [ownerImage setFrame:CGRectMake(259.0f, 6.0f, 34.0f, 34.0f)];
    
    
    //用户头像
    [ownerImageContent setFrame:CGRectInset(ownerImage.frame, 0.0f, 0.0f)];
    ownerImageContent.layer.cornerRadius = 17.0f;
    ownerImageContent.layer.masksToBounds = YES;
//    ownerImageContent.image = [UIHelper imageName:@"cacheImage"];

    //用户姓名
    ownerNameLbl.font = [UIFont systemFontOfSize:13.5];
    ownerNameLbl.textColor = [UIHelper colorWithHexString:@"#00b7ee"];
    [ownerNameLbl setFrame:CGRectMake(232.0f, 35.0f, 78.0f, 12.0f)];
    ownerNameLbl.text = @"小唐宁";
    
    //添加按钮
    [addBtn setImage:[UIHelper imageName:@"Contact_addBtn"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(243, 57, 60, 25);

    [detailView addSubview:ownerNameLbl];
    [detailView addSubview:addBtn];
    
    [self addSubview:detailView];
    [self addSubview:ownerImage];
    [self addSubview:ownerImageContent];
    //by wu
    [self addSubview:headLineView];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
