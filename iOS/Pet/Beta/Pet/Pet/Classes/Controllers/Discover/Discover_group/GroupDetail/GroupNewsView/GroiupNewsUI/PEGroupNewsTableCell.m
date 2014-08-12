//
//  PEGroupNewsTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupNewsTableCell.h"
#import "UIHelper.h"
@implementation PEGroupNewsTableCell
@synthesize imageV, petNameLbl, petSortV, petSortLbl,petImgContent;
@synthesize  ownerNameLbl, ownerImageContent;
@synthesize petSort, petSex;
@synthesize petForward,headLineView,gapLine,gapLineView;//by wu
@synthesize groupTitleLabel,groupNewsLabel,distanceLabel,timeLabel;
- (void)awakeFromNib
{
    // Initialization code
    imageV =[[UIImageView alloc] init];
    petNameLbl =[[UILabel alloc] init];
    petSortV =[[UIImageView alloc] init];
    petSortLbl =[[UILabel alloc] init];
    petImgContent =[[UIImageView alloc] init];
    petForward = [[NSString alloc]init];
    headLineView = [[UIView alloc]init];
    ownerNameLbl =[[UILabel alloc] init];
    ownerImageContent =[[UIImageView alloc] init];
    gapLineView = [[UIView alloc]init];
   

    groupTitleLabel = [[UILabel alloc]init];
    groupNewsLabel = [[UILabel alloc]init];
    distanceLabel = [[UILabel alloc]init];
    timeLabel = [[UILabel alloc]init];
    gapLine = [[UIView alloc]init];
    
    petSex =[[NSString alloc] init];
    petSort =[[NSString alloc] init];
}

- (void)layoutSubviews {
    
    UIView *detailView =[[UIView alloc]initWithFrame:CGRectMake(5.0f, 19.0f, 310.0f, 87.0f)];
    
    
    //距离label
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont systemFontOfSize:10.0];
    distanceLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    CGSize sizeDL = [distanceLabel.text sizeWithFont:[UIFont systemFontOfSize:10.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [distanceLabel setFrame:CGRectMake(166.f,6.0f, sizeDL.width, sizeDL.height)];
    
    //距离和时间之间的分割线
    gapLine.frame = CGRectMake(166+sizeDL.width+5, 8.0, 0.5, 11);
    gapLine.backgroundColor = [UIColor whiteColor];
    gapLine.alpha = 0.5;
    
    //时间label
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:10.0];
    timeLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    CGSize sizeTL = [timeLabel.text sizeWithFont:[UIFont systemFontOfSize:10.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [timeLabel setFrame:CGRectMake(170.5+sizeDL.width+5, 6.0f, sizeTL.width, sizeTL.height)];
    
    
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
    
    //群组协会名
    groupTitleLabel.textColor = [UIHelper colorWithHexString:@"#707070"];
    groupTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    groupTitleLabel.text = @"徐汇爱狗爱猫爱小动物协会";
    groupTitleLabel.frame = CGRectMake(97, 7, 170, 13);
    
    //宠物名
    petNameLbl.backgroundColor = [UIColor clearColor];
    petNameLbl.numberOfLines = 0;
    petNameLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petNameLbl.font = [UIFont boldSystemFontOfSize:14.0];
    petNameLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    CGSize sizePN = [petNameLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petNameLbl setFrame:CGRectMake(97.0f, 22.0f, sizePN.width, sizePN.height)];
    
    //苏格兰折耳前面的icon
    if ([petSex isEqualToString:@"公"]) {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petSort]]];
    }else {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petSort]]];
    }
    [petSortV setFrame:CGRectMake(97.0f, 42.0f, 14.0f, 11.0f)];
    
    
    //苏格兰折耳
    petSortLbl.backgroundColor = [UIColor clearColor];
    petSortLbl.numberOfLines = 0;
    petSortLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petSortLbl.font = [UIFont systemFontOfSize:12.0];
    petSortLbl.text = @"苏格兰折耳";
    petSortLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    CGSize sizePS = [petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petSortLbl setFrame:CGRectMake(117.0f, 40.0f, sizePS.width, sizePS.height)];
    
    //绿色间隔条
    gapLineView.backgroundColor = [UIHelper colorWithHexString:@"#aed0d8"];
    gapLineView.frame = CGRectMake(97.0f, 57.5, 205, 0.5);
    
    //绿色间隔条下的动态消息
    groupNewsLabel.textColor = [UIHelper colorWithHexString:@"#585858"];
    groupNewsLabel.font = [UIFont systemFontOfSize:12.0];
    groupNewsLabel.text = @"群成员退出群组";
    groupNewsLabel.frame = CGRectMake(97, 59, 142, 29);
    
    //anni姐姐

    
    [detailView addSubview:petImgContent];
    [detailView addSubview:imageV];
    [detailView addSubview:groupTitleLabel];
    [detailView addSubview:petSortV];
    [detailView addSubview:gapLineView];
    [detailView addSubview:groupNewsLabel];
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
    [ownerNameLbl setFrame:CGRectMake(251.0f, 35.0f, 78.0f, 12.0f)];
    ownerNameLbl.text = @"小唐宁";
    

    
    [detailView addSubview:ownerNameLbl];
    
    [self addSubview:detailView];
    [self addSubview:ownerImage];
    [self addSubview:ownerImageContent];
    //by wu
    [self addSubview:headLineView];
    [self addSubview:gapLine];
    [self addSubview:distanceLabel];
    [self addSubview:timeLabel];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
