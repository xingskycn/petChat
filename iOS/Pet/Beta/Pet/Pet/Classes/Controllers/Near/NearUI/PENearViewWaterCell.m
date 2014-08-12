//
//  PENearViewWaterCell.m
//  Pet
//
//  Created by Evan Wu on 6/11/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearViewWaterCell.h"
#import "UIHelper.h"

@implementation PENearViewWaterCell

@synthesize petImageV, petIconBg, petIconBgContent, petInfoBg, petTopBg;
@synthesize petSortImageV, petForwardImageV;
@synthesize petAgeLbl, petNameLbl, petSortLbl;

@synthesize ownerImageBg, ownerIconBgContent, ownerIconBg, ownerAgeBg;
@synthesize ownerNameLbl, ownerSignLbl, ownerAgeLbl;

@synthesize petSex, petSort, petForward, ownerSex, ownerBirth;
@synthesize heightCut;

@synthesize distanceLabel,timeLabel,view;
@synthesize petName,ownerDistance,ownerStaus,ownerName;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        //alloc
        self.backgroundColor = [UIColor clearColor];
        
        petTopBg =[[UIImageView alloc]init];
        petIconBg =[[UIImageView alloc]init];
        petIconBgContent =[[UIImageView alloc]init];
        petNameLbl =[[UILabel alloc]init];
        petForwardImageV =[[UIImageView alloc]init];
        petSortLbl =[[UILabel alloc]init];
        petInfoBg =[[UIImageView alloc]init];
        petSortImageV =[[UIImageView alloc]init];
        petAgeLbl =[[UILabel alloc]init];
        ownerImageBg =[[UIImageView alloc]init];
        ownerIconBg =[[UIImageView alloc]init];
        ownerIconBgContent =[[UIImageView alloc]init];
        ownerAgeBg =[[UIImageView alloc]init];
        ownerAgeLbl =[[UILabel alloc]init];
        ownerNameLbl =[[UILabel alloc]init];
        ownerSignLbl =[[UILabel alloc]init];
        
        //by wu
        distanceLabel = [[UILabel alloc]init];
        timeLabel = [[UILabel alloc]init];
        view = [[UIView alloc]init];
        
        petImageV =[[UIImageView alloc]init];
        petImageV.contentMode = UIViewContentModeScaleAspectFill;
        petImageV.clipsToBounds = YES;
        
        petSex =[[NSString alloc] init];
        ownerSex =[[NSString alloc] init];
        ownerBirth =[[NSString alloc] init];
        petSort =[[NSString alloc] init];
        petForward =[[NSString alloc] init];
        
        petName = [[NSString alloc]init];
        ownerDistance = [[NSString alloc]init];
        ownerStaus = [[NSString alloc]init];
        ownerName = [[NSString alloc]init];
    }
    return self;
}

- (void)layoutSubviews {
    //get bounds point & size
    CGPoint origin = self.bounds.origin;
    CGSize size = self.bounds.size;
    
    if (petTopBg) {
        [petTopBg removeFromSuperview];
        [petIconBg removeFromSuperview];
        [petIconBgContent removeFromSuperview];
        [petInfoBg removeFromSuperview];
        [petNameLbl removeFromSuperview];
        [petSortImageV removeFromSuperview];
        [petAgeLbl removeFromSuperview];
        [petForwardImageV removeFromSuperview];
        [petSortLbl removeFromSuperview];
        
        //by wu
        [distanceLabel removeFromSuperview];
        [timeLabel removeFromSuperview];
        [view removeFromSuperview];
        
        [ownerImageBg removeFromSuperview];
        [ownerIconBg removeFromSuperview];
        [ownerIconBgContent removeFromSuperview];
        [ownerAgeBg removeFromSuperview];
        [ownerAgeLbl removeFromSuperview];
        [ownerNameLbl removeFromSuperview];
        [ownerSignLbl removeFromSuperview];
    }
    
    //set petImage frame - 头像
    petImageV.frame = CGRectMake(origin.x, origin.y + 10, size.width, size.height - 100 + heightCut);
    petImageV.layer.cornerRadius =7.0f;
    petImageV.layer.masksToBounds =YES;
    
    //pet top background - 顶部的背景图：黑色圆角
    petTopBg.contentMode = UIViewContentModeScaleAspectFill;
    petTopBg.clipsToBounds = YES;
    petTopBg.frame = CGRectMake(origin.x, origin.y +10, size.width, 35.0f);
    petTopBg.image =[UIHelper imageName:@"near_water_pet_top"];
    
    //pet icon background - 头像圆圈背景
    petIconBg.contentMode = UIViewContentModeScaleAspectFill;
    petIconBg.clipsToBounds = YES;
    petIconBg.frame = CGRectMake(origin.x +10, origin.y, 36.0f, 36.0f);
    petIconBg.image =[UIHelper imageName:@"near_water_pet_icon"];
    
    //pet icon content
    petIconBgContent.contentMode = UIViewContentModeScaleAspectFill;
    petIconBgContent.clipsToBounds = YES;
    petIconBgContent.frame = CGRectInset(petIconBg.frame, 2.0f, 2.0f);
    petIconBgContent.layer.cornerRadius =16.0f;
    petIconBgContent.layer.masksToBounds =YES;
    
    //pet name label - 宠物名字label
    [petNameLbl setFont:[UIFont systemFontOfSize:12.0f]];
    petNameLbl.textColor =[UIHelper colorWithHexString:@"#ffffff"];
    CGSize nameLableSize = [petNameLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petNameLbl.frame = CGRectMake(petIconBg.frame.origin.x + 36 + 7, petTopBg.frame.origin.y + 5, nameLableSize.width, 13.0f);//这里55影响了其后面的位置
    
    //pet forward image -名字后面的图标
    petForwardImageV.contentMode = UIViewContentModeScaleAspectFill;
    petForwardImageV.clipsToBounds = YES;
    //petForwardImageV.frame = CGRectMake(petNameLbl.frame.origin.x + petNameLbl.frame.size.width +6, petNameLbl.frame.origin.y, 13.0f, 13.0f);
    petForwardImageV.frame = CGRectMake(petNameLbl.frame.origin.x + nameLableSize.width +6, petNameLbl.frame.origin.y, 13.0f, 13.0f);
    petForwardImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%@", petForward]];
    
    //pet sort label ---宠物种类:哈士奇
    [petSortLbl setFont:[UIFont systemFontOfSize:11.0f]];
    petSortLbl.textColor =[UIHelper colorWithHexString:@"#adaba9"];
    petSortLbl.frame = CGRectMake(petIconBg.frame.origin.x + 7 + 36, petTopBg.frame.origin.y + 20, 80, 13.0f);
    
    //pet info background - 年龄显示的背景图
    petInfoBg.frame = CGRectMake(petImageV.frame.size.width - 65.0, petImageV.frame.size.height - 30 - heightCut, 60.0f, 25.0f);
    petInfoBg.image =[UIHelper imageName:@"near_water_pet_info"];
    
    //pet sort image-------种类图片
    petSortImageV.frame = CGRectMake(petInfoBg.frame.origin.x + 5.5, petInfoBg.frame.size.height/2 - 7.5 + petInfoBg.frame.origin.y, 14.5f, 13.0f);
    if ([petSex isEqualToString:@"公"]) {//10.5
        petSortImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petSort]];
    }else {
        petSortImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petSort]];
    }
    
    //by wu  宠物种类图片和宠物年龄之间的间隔条
    view.frame = CGRectMake(petInfoBg.frame.origin.x + 23, petInfoBg.frame.size.height/2 - 7.5+1 + petInfoBg.frame.origin.y, 1, 13.0f);
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.6;

    
    
    //pet age label
    [petAgeLbl setFont:[UIFont systemFontOfSize:11.0f]];
    petAgeLbl.textColor =[UIHelper colorWithHexString:@"#ffffff"];
    petAgeLbl.frame = CGRectMake(petInfoBg.frame.origin.x + 28, petInfoBg.frame.size.height/2 - 7.5 + petInfoBg.frame.origin.y, 34.0f, 15.0f);
    
    //owner image bakground - 男士和女士标示的背景图 很大的白色背景图
    ownerImageBg.contentMode = UIViewContentModeScaleAspectFill;
    ownerImageBg.clipsToBounds = YES;
    ownerImageBg.frame = CGRectMake(origin.x, petImageV.frame.origin.y + petImageV.frame.size.height - heightCut, size.width,56.0f);
    if ([ownerSex isEqualToString:@"男士"]) {
        ownerImageBg.image =[UIHelper imageName:@"near_water_cell_male_bg"];
    } else {
        ownerImageBg.image =[UIHelper imageName:@"near_water_cell_female_bg"];
    }
    
    //owner icon background - 用户头像的圆圈背景
    ownerIconBg.contentMode = UIViewContentModeScaleAspectFill;
    ownerIconBg.clipsToBounds = YES;
    ownerIconBg.frame = CGRectMake(ownerImageBg.frame.origin.x + 10, ownerImageBg.frame.origin.y + 10, 30.0f, 30.0f);
    ownerIconBg.image =[UIHelper imageName:@"near_water_owner_icon_bg"];
    
    //owner icon content - 这是给用户头像赋值的imageView视图，中间没有外圈
    ownerIconBgContent.contentMode = UIViewContentModeScaleAspectFill;
    ownerIconBgContent.clipsToBounds = YES;
    ownerIconBgContent.frame = CGRectInset(ownerIconBg.frame, 0.0f, 0.0f);
    ownerIconBgContent.layer.cornerRadius =15.0f;
    ownerIconBgContent.layer.masksToBounds =YES;
    
    //owner age background - 年龄的背景图
    ownerAgeBg.contentMode = UIViewContentModeScaleAspectFill;
    ownerAgeBg.clipsToBounds = YES;
    ownerAgeBg.frame = CGRectMake(ownerImageBg.frame.origin.x + 13.5, ownerIconBg.frame.origin.y + ownerIconBg.frame.size.height -2, 23.0f, 11.0f);
    if ([ownerSex isEqualToString:@"男士"]) {
        ownerAgeBg.image =[UIHelper imageName:@"near_water_owner_age_bg_male"];
    }else {
        ownerAgeBg.image =[UIHelper imageName:@"near_water_owner_age_bg_female"];
    }
    
    //owner age label - 用户年龄 字体大小
//    [ownerAgeLbl setFont:[UIFont systemFontOfSize:11.0f]];
    [ownerAgeLbl setFont:[UIFont boldSystemFontOfSize:10.0f]];//by wu
    ownerAgeLbl.textAlignment = NSTextAlignmentCenter;
    ownerAgeLbl.textColor =[UIColor whiteColor];
    ownerAgeLbl.frame = CGRectInset(ownerAgeBg.frame, 0.0f, 0.0f);
    
    NSDate * date=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    int year=[conponent year];
    int age =year - [[ownerBirth substringWithRange:NSMakeRange(0, 4)] intValue];
    
    ownerAgeLbl.text =[NSString stringWithFormat:@"%d", age];
    
    
    //owner name label -用户姓名字体大小
   [ownerNameLbl setFont:[UIFont systemFontOfSize:15.0f]];
    ownerNameLbl.textColor =[UIHelper colorWithHexString:@"#161616"];
    CGSize ownerNameLabelSize = [ownerNameLbl.text sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerNameLbl.frame = CGRectMake(ownerImageBg.frame.origin.x + 47, ownerImageBg.frame.origin.y + 6, ownerNameLabelSize.width, ownerNameLabelSize.height);//14.0f
    
    //owner sign label - 用户签名
    [ownerSignLbl setFont:[UIFont systemFontOfSize:12.0f]];
    ownerSignLbl.textColor =[UIHelper colorWithHexString:@"#929292"];
    ownerSignLbl.frame = CGRectMake(ownerImageBg.frame.origin.x + 47, ownerNameLbl.frame.origin.y + ownerNameLabelSize.height+4, 80, 14.0f);
    
    //by wu
    //distance label - 显示距离
    distanceLabel.font = [UIFont boldSystemFontOfSize:11];
    distanceLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    CGSize distanceLabelSize = [distanceLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    distanceLabel.frame = CGRectMake(origin.x , ownerImageBg.frame.origin.y +ownerImageBg.frame.size.height +5 , distanceLabelSize.width, distanceLabelSize.height);

  
    //time label - 显示时间
    timeLabel.font = [UIFont boldSystemFontOfSize:11];
    timeLabel.textColor = [UIHelper colorWithHexString:@"#ffffff"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    CGSize timeLabelSize = [timeLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    timeLabel.frame = CGRectMake(size.width - timeLabelSize.width,ownerImageBg.frame.origin.y +ownerImageBg.frame.size.height +5, timeLabelSize.width, timeLabelSize.height);


    
    [self addSubview:petImageV];
    [self addSubview:petInfoBg];
    [self addSubview:petTopBg];
    [self addSubview:petIconBg];
    [self addSubview:petIconBgContent];
    [self addSubview:petNameLbl];
    [self addSubview:petForwardImageV];
    [self addSubview:petSortLbl];
    
    [self addSubview:petSortImageV];
    [self addSubview:petAgeLbl];
    
    [self addSubview:ownerImageBg];
    [self addSubview:ownerIconBg];
    [self addSubview:ownerIconBgContent];
    [self addSubview:ownerAgeBg];
    [self addSubview:ownerAgeLbl];
    [self addSubview:ownerNameLbl];
    [self addSubview:ownerSignLbl];
    
    //by wu
//    [self addSubview:distanceLabel];
//    [self addSubview:timeLabel];  20140808
    [self addSubview:view];
}


@end
