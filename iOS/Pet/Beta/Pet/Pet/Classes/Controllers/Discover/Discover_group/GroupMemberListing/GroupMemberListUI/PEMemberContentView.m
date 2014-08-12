//
//  PEMemberContentView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEMemberContentView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
@implementation PEMemberContentView
@synthesize imageV, petNameLbl, petSortV, petSortLbl, petAgeV, petAgeLbl, petSignLbl,petImgContent;
@synthesize ownerAgeLbl, ownerAgeV, ownerNameLbl, ownerImageContent, ownerSexV;
@synthesize petSort, ownerSex, petSex, ownerBirth;
@synthesize petForwardImageV,petForward,headLineView;//by wu
@synthesize dic,ownHeadIconImageView,ownerImage;
- (id)initWithFrame:(CGRect)frame AndData:(NSDictionary *)dataDic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dic =[NSDictionary dictionaryWithDictionary:dataDic];
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
        petForward = [[NSString alloc]init];
        headLineView = [[UIView alloc]init];
        
        
        ownerAgeLbl =[[UILabel alloc] init];
        ownerAgeV =[[UIImageView alloc] init];
        ownerNameLbl =[[UILabel alloc] init];
        ownerImageContent =[[UIImageView alloc] init];
        ownerSexV =[[UIImageView alloc] init];
        
        
        //群主王冠
        ownHeadIconImageView = [[UIImageView alloc]init];
        
        ownerImage = [[UIImageView alloc]init];
        petSex =[[NSString alloc] init];
        ownerSex =[[NSString alloc] init];
        ownerBirth =[[NSString alloc] init];
        petSort =[[NSString alloc] init];
        
        
        UIView *detailView =[[UIView alloc]initWithFrame:CGRectMake(5.0f, 19.0f, 310.0f, 87.0f)];
        
        //用户头像上面的白色线条
        headLineView.frame = CGRectMake(275, 0, 2, 6);
        headLineView.backgroundColor = [UIColor whiteColor];
        headLineView.alpha = 0.3;
        
        
        petNameLbl.text = [dic objectForKey:NEAR_DETAIL_PET_NAME];
        //宠物年龄显示进行处理
//        NSString *ageString = [dic objectForKey:NEAR_DETAIL_PET_AGE];
//        if([ageString intValue]>12){
//            int n = [ageString intValue]/12;
//            petAgeLbl.text =[NSString stringWithFormat:@"%d岁",n];
//        }else{
//            petAgeLbl.text =[NSString stringWithFormat:@"%d个月",[ageString intValue]];
//        }
        //时间显示： 20140809
        NSString *ageString =[dic objectForKey:NEAR_DETAIL_PETBIRTHDAY];//NEAR_DETAIL_PET_AGE
        if([ageString isEqualToString:@""] || ageString ==nil ){
            petAgeLbl.text = @"0月";
        }else{
            NSString *tempAgeString =[ageString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSDateComponents *ageConponents = [Common getDateConponent:tempAgeString];
            NSDateComponents *tempDateConponents = [Common getTempDateConponent];
            int year=[tempDateConponents year]-[ageConponents year];
            int month = [tempDateConponents month]- [ageConponents month];
            if(year >0){
                petAgeLbl.text =[NSString stringWithFormat:@"%d岁",year];
            }else{
               petAgeLbl.text =[NSString stringWithFormat:@"%d月",month];
                
            }
        }
        
        
        
        petSortLbl.text =@"HeHe";
        [petImgContent setImageWithURL:[NSURL URLWithString:[dic objectForKey:DB_COLUMN_NEAR_PETIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
        
        //by wu
        petForward = [dic objectForKey:DB_COLUMN_NEAR_PETWANTEDTYPE];
        petSignLbl.text =[dic objectForKey:DB_COLUMN_NEAR_USERSIGN];
        ownerNameLbl.text =[dic objectForKey:DB_COLUMN_NEAR_USERNAME];
        [ownerImageContent setImageWithURL:[NSURL URLWithString:[dic objectForKey:DB_COLUMN_NEAR_USERIMAGEURL]] placeholderImage:[UIHelper imageName:@"cacheImage"]];
        petSort =[NSString stringWithString:[dic objectForKey:DB_COLUMN_NEAR_PETTYPE]];
        petSex =[NSString stringWithString:[dic objectForKey:DB_COLUMN_NEAR_PETSEX]];
        ownerSex =[NSString stringWithString:[dic objectForKey:DB_COLUMN_NEAR_USERSEX]];
        ownerBirth =[NSString stringWithString:[dic objectForKey:DB_COLUMN_NEAR_USERBIRTHDAY]];
        
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
        [petSortV setFrame:CGRectMake(97.0f, 33.0f, 14.0f, 11.0f)];
        
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
        [petNameLbl setFrame:CGRectMake(97.0f, 8.0f, sizePN.width, sizePN.height)];
        
        //pet forward image -名字后面的图标 by wu
        petForwardImageV.contentMode = UIViewContentModeScaleAspectFill;
        petForwardImageV.clipsToBounds = YES;
        petForwardImageV.frame = CGRectMake(petNameLbl.frame.origin.x + sizePN.width +5, petNameLbl.frame.origin.y+3, 13.0f, 13.0f);
        petForwardImageV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%@", petForward]];
        
        
        //苏格兰折耳
        petSortLbl.backgroundColor = [UIColor clearColor];
        petSortLbl.numberOfLines = 0;
        petSortLbl.lineBreakMode = NSLineBreakByCharWrapping;
        petSortLbl.font = [UIFont systemFontOfSize:12.0];
        petSortLbl.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        CGSize sizePS = [petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [petSortLbl setFrame:CGRectMake(117.0f, 33.0f, sizePS.width, sizePS.height)];
        
        
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
        
        //person UI setting 用户头像背景
        ownerImage =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"group_ownerBg"]];//near_cell_owner_bg
        [ownerImage setFrame:CGRectMake(259.0f, 6.0f, 34.0f, 34.0f)];
        
        //群主王冠图片
        ownHeadIconImageView.backgroundColor = [UIColor clearColor];
        ownHeadIconImageView.frame = CGRectMake(261, 0, 31, 37);
        ownHeadIconImageView.image = [UIHelper imageName:@"group_ownerTopBg"];
        

        
        [ownerImageContent setFrame:CGRectInset(ownerImage.frame, 0.5f, 0.5f)];
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
        [ownerNameLbl setFrame:CGRectMake(232.0f, 35.0f, 78.0f, 12.0f)];
        
        NSDate * date=[NSDate date];
        NSCalendar * cal=[NSCalendar currentCalendar];
        NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
        int year=[conponent year];
        int age =year - [[self.ownerBirth substringWithRange:NSMakeRange(0, 4)] intValue];
        
        
        //用户年龄
        ownerAgeLbl =[[UILabel alloc]init];
        ownerAgeLbl.backgroundColor = [UIColor clearColor];
        ownerAgeLbl.font = [UIFont systemFontOfSize:12.0];
        ownerAgeLbl.textColor = [UIHelper colorWithHexString:@"#7e7e7e"];
        ownerAgeLbl.textAlignment =UITextAlignmentRight;
//        ownerAgeLbl.text =[NSString stringWithFormat:@"%d岁", age];
        ownerAgeLbl.text =[NSString stringWithFormat:@"%d岁", 8];
        CGSize sizeOA = [ownerAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [ownerAgeLbl setFrame:CGRectMake(8.0f, 5.0f, sizeOA.width, 12.0f)];// 6.0 5.0 30 12.0
        [ownerSexV setFrame:CGRectMake(8.0+sizeOA.width+4, 5.0f, 10.5f, 11.0f)];//34.
        
        [ownerAgeV addSubview:ownerAgeLbl];
        [ownerAgeV addSubview:ownerSexV];
        
        [detailView addSubview:ownerNameLbl];
        [detailView addSubview:ownerAgeV];
        

        
        [self addSubview:detailView];
        [self addSubview:ownerImage];
        [self addSubview:ownHeadIconImageView];
        [self addSubview:ownerImageContent];

    }
    return self;
}

//- (void)gotoDetailBtnPressed{
//    
//    [contentDelegate gotoDetailView];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
