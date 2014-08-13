//
//  PENearViewTableCell.m
//  Pet
//
//  Created by Evan Wu on 6/10/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewTableCell.h"
#import "UIHelper.h"

@implementation PENearViewTableCell

@synthesize imageV, petNameLbl, petSortV, petSortLbl, petAgeV, petAgeLbl, petSignLbl,petImgContent;
@synthesize ownerAgeLbl, ownerAgeV, ownerNameLbl, ownerImageContent, ownerSexV;
@synthesize petSort, ownerSex, petSex, ownerBirth;
@synthesize petForwardImageV,petForward;
@synthesize petForwardImageV2,petForward2;
@synthesize petForwardImageV3,petForward3;
@synthesize petForwardImageV4,petForward4;
@synthesize headLineView,distanceLabel,timeLabel,gapLine;//by wu
- (void)awakeFromNib
{
    // Initialization code
    imageV =[[UIImageView alloc] init];
    petNameLbl =[[UILabel alloc] init];
    petSortV =[[UIImageView alloc] init];
    petSortLbl =[[UILabel alloc] init];
    petAgeV =[[UIImageView alloc] init];
    petAgeLbl =[[UILabel alloc] init];
    petSignLbl =[[UILabel alloc] init];
    petImgContent =[[UIImageView alloc] init];
    
    //by wu
    petForwardImageV = [[UIImageView alloc]init];
    petForwardImageV2 = [[UIImageView alloc]init];
    petForwardImageV3 = [[UIImageView alloc]init];
    petForwardImageV4 = [[UIImageView alloc]init];
    petForward = [[NSString alloc]init];
    petForward2 = [[NSString alloc]init];
    petForward3 = [[NSString alloc]init];
    petForward4 = [[NSString alloc]init];
    headLineView = [[UIView alloc]init];
    distanceLabel = [[UILabel alloc]init];
    timeLabel = [[UILabel alloc]init];
    gapLine = [[UIView alloc]init];
    
    ownerAgeLbl =[[UILabel alloc] init];
    ownerAgeV =[[UIImageView alloc] init];
    ownerNameLbl =[[UILabel alloc] init];
    ownerImageContent =[[UIImageView alloc] init];
    ownerSexV =[[UIImageView alloc] init];
    
    petSex =[[NSString alloc] init];
    ownerSex =[[NSString alloc] init];
    ownerBirth =[[NSString alloc] init];
    petSort =[[NSString alloc] init];
}

- (void)layoutSubviews {
    
    
    UIView *detailView =[[UIView alloc]initWithFrame:CGRectMake(5.0f, 19.0f, 310.0f, 87.0f)];
    
    //用户头像上面的白色线条
    headLineView.frame = CGRectMake(275, 0, 2, 6);
    headLineView.backgroundColor = [UIColor whiteColor];
    headLineView.alpha = 0.3;
    
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
    
    
    //pet UI setting ---白色大背景图
    UIImage *img =[UIHelper imageName:@"near_cell_bg"];
    [img stretchableImageWithLeftCapWidth:100 topCapHeight:0.0f];
    [imageV setImage:img];
    [imageV setFrame:CGRectMake(83.0f, 0.0f, 227.0f, 87.0f)];
    
    petImgContent.layer.cornerRadius = 7.0f;
    petImgContent.layer.masksToBounds = YES;
    [petImgContent setFrame:CGRectMake(0.0f, 0.0f, 89.5f, 87.0f)];
    
    //苏格兰折耳前面的icon
    if ([petSex isEqualToString:@"公"]) {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petSort]]];
    }else {
        [petSortV setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petSort]]];
    }
    [petSortV setFrame:CGRectMake(97.0f, 32.0f, 14.0f, 11.0f)];
    
    //生日蛋糕形状图片
    [petAgeV setImage:[UIHelper imageName:@"near_cell_pet_age"]];
    [petAgeV setFrame:CGRectMake(98.0f, 50.0f, 11.5f, 11.5f)];
    
    
    //宠物名
    petNameLbl.backgroundColor = [UIColor clearColor];
    petNameLbl.numberOfLines = 0;
    petNameLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petNameLbl.font = [UIFont boldSystemFontOfSize:14.0];
    petNameLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    CGSize sizePN = [petNameLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petNameLbl setFrame:CGRectMake(97.0f, 7.0f, sizePN.width, 15)];
    
    int x =0;
    int num =0;
    
    //pet forward image -名字后面的图标 by wu
    num ++;
    petForwardImageV.contentMode = UIViewContentModeScaleAspectFill;
    petForwardImageV.clipsToBounds = YES;
    petForwardImageV.frame = CGRectMake(petNameLbl.frame.origin.x + sizePN.width +5 +x *18.0f, petNameLbl.frame.origin.y+2, 13.0f, 13.0f);
    if ([petForward isEqualToString:@"1"]) {
        petForwardImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%d", num]];
        x ++;
    } else {
        petForwardImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_0"]];
    }
    
    num ++;
    petForwardImageV2.contentMode = UIViewContentModeScaleAspectFill;
    petForwardImageV2.clipsToBounds = YES;
    petForwardImageV2.frame = CGRectMake(petNameLbl.frame.origin.x + sizePN.width +5 +x *18.0f, petNameLbl.frame.origin.y+2, 13.0f, 13.0f);
    if ([petForward2 isEqualToString:@"1"]) {
        petForwardImageV2.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%d", num]];
        x ++;
    } else {
        petForwardImageV2.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_0"]];
    }
    
    num ++;
    petForwardImageV3.contentMode = UIViewContentModeScaleAspectFill;
    petForwardImageV3.clipsToBounds = YES;
    petForwardImageV3.frame = CGRectMake(petNameLbl.frame.origin.x + sizePN.width +5 +x *18.0f, petNameLbl.frame.origin.y+2, 13.0f, 13.0f);
    if ([petForward3 isEqualToString:@"1"]) {
        petForwardImageV3.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%d", num]];
        x ++;
    } else {
        petForwardImageV3.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_0"]];
    }
    
    num ++;
    petForwardImageV4.contentMode = UIViewContentModeScaleAspectFill;
    petForwardImageV4.clipsToBounds = YES;
    petForwardImageV4.frame = CGRectMake(petNameLbl.frame.origin.x + sizePN.width +5 +x *18.0f, petNameLbl.frame.origin.y+2, 13.0f, 13.0f);
    if ([petForward4 isEqualToString:@"1"]) {
        petForwardImageV4.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%d", num]];
        x ++;
    } else {
        petForwardImageV4.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_0"]];
    }
    
    
    //苏格兰折耳
    petSortLbl.backgroundColor = [UIColor clearColor];
    petSortLbl.numberOfLines = 0;
    petSortLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petSortLbl.font = [UIFont systemFontOfSize:12.0];
    petSortLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    CGSize sizePS = [petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petSortLbl setFrame:CGRectMake(117.0f, 30.0f, sizePS.width, sizePS.height)];
    
    
    //宠物年龄
    petAgeLbl.backgroundColor = [UIColor clearColor];
    petAgeLbl.numberOfLines = 0;
    petAgeLbl.lineBreakMode = NSLineBreakByCharWrapping;
    petAgeLbl.font = [UIFont systemFontOfSize:12.0];
    petAgeLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    CGSize sizePA = [petAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petAgeLbl setFrame:CGRectMake(117.0f, 50.0f, sizePA.width, sizePA.height)];
    
    petSignLbl.backgroundColor = [UIColor clearColor];
    petSignLbl.font = [UIFont systemFontOfSize:12.0];
    petSignLbl.textColor = [UIHelper colorWithHexString:@"#585858"];
    CGSize sizePSL = [petSignLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [petSignLbl setFrame:CGRectMake(97.0f, 69.5f, 150.0f, sizePSL.height)];
    
    
    

    [detailView addSubview:petImgContent];
    [detailView addSubview:imageV];
    [detailView addSubview:petSortV];
    [detailView addSubview:petAgeV];
    
    [detailView addSubview:petNameLbl];
    [detailView addSubview:petSortLbl];
    [detailView addSubview:petAgeLbl];
    [detailView addSubview:petSignLbl];
    
    //by wu
    [detailView addSubview:petForwardImageV];
    [detailView addSubview:petForwardImageV2];
    [detailView addSubview:petForwardImageV3];
    [detailView addSubview:petForwardImageV4];
    
    //person UI setting 用户头像背景
    UIImageView *ownerImage =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_cell_owner_bg"]];
    [ownerImage setFrame:CGRectMake(259.0f, 6.0f, 34.0f, 34.0f)];
    

    [ownerImageContent setFrame:CGRectInset(ownerImage.frame, 0.0f, 0.0f)];
    ownerImageContent.layer.cornerRadius = 17.0f;
    ownerImageContent.layer.masksToBounds = YES;
    
    [ownerAgeV setImage:[UIHelper imageName:@"near_cell_owner_age_bg"]];
    [ownerAgeV setFrame:CGRectMake(246.0f, 57.0f, 54.0f, 21.0f)];//51*21
    
    if ([self.ownerSex isEqualToString:@"男士"]) {
        [ownerSexV setImage:[UIHelper imageName:@"near_cell_owner_male"]];
    } else {
        [ownerSexV setImage:[UIHelper imageName:@"near_cell_owner_female"]];
    }
//    [ownerSexV setFrame:CGRectMake(38.0f, 5.0f, 10.5f, 11.0f)];//34.
    
    //用户姓名
    ownerNameLbl.backgroundColor = [UIColor clearColor];
    ownerNameLbl.font = [UIFont systemFontOfSize:12.0];
    ownerNameLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    ownerNameLbl.textAlignment =UITextAlignmentCenter;
    [ownerNameLbl setFrame:CGRectMake(232.0f, 35.0f, 78.0f, 13.0f)];
    
    
    //用户年龄计算
    NSDate * date=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    int year=[conponent year];//取系统的时间
    int age =year - [[self.ownerBirth substringWithRange:NSMakeRange(0, 4)] intValue];//取返回值的前四个字符
    
    
    //用户年龄
    ownerAgeLbl =[[UILabel alloc]init];
    ownerAgeLbl.backgroundColor = [UIColor clearColor];
    ownerAgeLbl.font = [UIFont systemFontOfSize:12.0];
    ownerAgeLbl.textColor = [UIHelper colorWithHexString:@"#7e7e7e"];
    ownerAgeLbl.textAlignment =UITextAlignmentRight;
    ownerAgeLbl.text =[NSString stringWithFormat:@"%d岁", age];
//    ownerAgeLbl.text =[NSString stringWithFormat:@"%d岁", 8];
    CGSize sizeOA = [ownerAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [ownerAgeLbl setFrame:CGRectMake(8.0f, 5.0f, sizeOA.width, 12.0f)];// 6.0 5.0 30 12.0
    [ownerSexV setFrame:CGRectMake(8.0+sizeOA.width+4, 5.0f, 10.5f, 11.0f)];//34.
    
    [ownerAgeV addSubview:ownerAgeLbl];
    [ownerAgeV addSubview:ownerSexV];
    
    [detailView addSubview:ownerNameLbl];
    [detailView addSubview:ownerAgeV];
    
    [self addSubview:detailView];
    [self addSubview:ownerImage];
    [self addSubview:ownerImageContent];
    //by wu
    [self addSubview:headLineView];
//    [self addSubview:gapLine];
//    [self addSubview:distanceLabel];
//    [self addSubview:timeLabel];20140808
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
