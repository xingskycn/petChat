//
//  PENearDetailListView.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PENearDetailListView.h"
#import "UIHelper.h"

@implementation PENearDetailListView
@synthesize bgView;

@synthesize petNameLbl;
@synthesize petForwardV;
@synthesize distanceLbl;
@synthesize timeLbl;
@synthesize petSortV;
@synthesize petSortLbl;
@synthesize petAgeV;
@synthesize petAgeLbl;
@synthesize ownerNameLbl;
@synthesize ownerChatLabel;//宠聊号
@synthesize ownerAgeLbl;
@synthesize ownerSexV;
@synthesize petNumberLbl;
@synthesize ownerSignLbl;
@synthesize petPreferLbl;
@synthesize petSiteLbl;
@synthesize relationDetailLbl;

@synthesize newsNumLbl;
@synthesize newsDetailLbl;
@synthesize newsDistanceLbl;
@synthesize newsTimeLbl;

@synthesize shoutNumLbl;
@synthesize shoutDetailLbl;
@synthesize shoutDistanceLbl;
@synthesize shoutTimeLbl;

@synthesize vedioNumLbl;
@synthesize vedioDetailLbl;

@synthesize chatRoomSV;
@synthesize chatClubSV;

@synthesize moreInfoLbl;
@synthesize otherPetV;

@synthesize petType, ownerSex, petSex;
@synthesize chateNumber,petForward;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bgView =[[UIImageView alloc] init];
        
        petNameLbl =[[UILabel alloc]init];
        petForwardV =[[UIImageView alloc]init];
        distanceLbl =[[UILabel alloc]init];
        timeLbl =[[UILabel alloc]init];
        petSortV =[[UIImageView alloc]init];
        petSortLbl =[[UILabel alloc]init];
        petAgeV =[[UIImageView alloc]init];
        petAgeLbl =[[UILabel alloc]init];
        ownerNameLbl =[[UILabel alloc]init];
       
        ownerChatLabel = [[UILabel alloc]init];//by wu
        
        ownerAgeLbl =[[UILabel alloc]init];
        ownerSexV =[[UIImageView alloc]init];
        petNumberLbl =[[UILabel alloc]init];
        ownerSignLbl =[[UILabel alloc]init];
        petPreferLbl =[[UILabel alloc]init];
        petSiteLbl =[[UILabel alloc]init];
        relationDetailLbl = [[UILabel alloc]init];
        
        newsNumLbl =[[UILabel alloc]init];
        newsDetailLbl =[[UILabel alloc]init];
        newsDistanceLbl =[[UILabel alloc]init];
        newsTimeLbl =[[UILabel alloc]init];
        
        shoutNumLbl =[[UILabel alloc]init];
        shoutDetailLbl =[[UILabel alloc]init];
        shoutDistanceLbl =[[UILabel alloc]init];
        shoutTimeLbl =[[UILabel alloc]init];
        
        vedioNumLbl =[[UILabel alloc]init];
        vedioDetailLbl =[[UILabel alloc]init];
        
        chatRoomSV =[[UIScrollView alloc]init];
        chatClubSV =[[UIScrollView alloc]init];
        
        moreInfoLbl =[[UILabel alloc]init];
        otherPetV =[[PEOtherPetView alloc]init];
        
        ownerSex =[[NSString alloc] init];
        petSex =[[NSString alloc] init];
        petType =[[NSString alloc] init];
        chateNumber = [[NSString alloc]init];
        petForward = [[NSString alloc]init];
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

//画view
- (void)layoutSubviews {
    //白色背景图
    UIImage *bgImg =[UIHelper imageName:@"nearDetail_cell_bg"];
    [bgImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgView setFrame:CGRectInset(self.bounds, 0.0f, 0.0f)];
    [bgView setImage:bgImg];
    
    //宠物名
    [petNameLbl setFont:[UIFont boldSystemFontOfSize:15.0f]];
    CGSize sizePN =[petNameLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petNameLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    petNameLbl.frame = CGRectMake(18.0f, 11.0f, sizePN.width, 17);
    
    //宠物名后面的icon 有三张
//    petForwardV.image =[UIHelper imageName:@"near_pet_forward_1"];
    petForwardV.frame = CGRectMake(18+sizePN.width+5, 15.0f, 13.0f, 13.0f);
    petForwardV.image =[UIHelper imageName:[NSString stringWithFormat:@"near_pet_forward_%@", petForward]];
    
    //时间label
    [timeLbl setFont:[UIFont boldSystemFontOfSize:11.0f]];
    CGSize sizeT =[timeLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    timeLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    timeLbl.textAlignment = NSTextAlignmentLeft;
    timeLbl.frame = CGRectMake(ScreenWidth-13-sizeT.width+3, 13.0f, sizeT.width, sizeT.height);

   //距离label
    [distanceLbl setFont:[UIFont boldSystemFontOfSize:11.0f]];
    CGSize sizeD =[distanceLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:11.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    distanceLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    distanceLbl.textAlignment = NSTextAlignmentRight;
    distanceLbl.frame = CGRectMake(ScreenWidth-13-sizeT.width-3-0.5-3-sizeD.width, 13.0f, sizeD.width, sizeD.height);

    //by wu 时间和距离之间一个px的间隔条
    //距离和时间之间一个像素的间隔线 分别间距2px by wu
    UIView *view =[[UIView alloc]init];
    CGRect frame = CGRectMake(distanceLbl.frame.origin.x+sizeD.width+5, 13.0f, 0.5, 10);
    view.frame = frame;
    view.backgroundColor =[UIHelper colorWithHexString:@"#878787"];
    
    //宠物性别显示view
    if ([petSex isEqualToString:@"公"]) {
        petSortV.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petType]];
        petSortV.frame = CGRectMake(18.0f, 42, 14.0f, 11.0f);
    } else {
        petSortV.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petType]];
        petSortV.frame = CGRectMake(18.0f, 42, 14.0f, 11.0f);
    }
    
    
    //宠物类别----苏格兰折耳
    [petSortLbl setFont:[UIFont systemFontOfSize:14.5f]];
    CGSize sizePS =[petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petSortLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    petSortLbl.textAlignment = NSTextAlignmentCenter;
    petSortLbl.frame = CGRectMake(33.0f, 39, sizePS.width, sizePS.height);
    
    //宠物年龄view---显示生日蛋糕
    petAgeV.image = [UIHelper imageName:@"near_cell_pet_age"];
    petAgeV.frame = CGRectMake(18.0f, 60, 11.5f, 11.5f);
    
    
    //宠物年龄label
    [petAgeLbl setFont:[UIFont systemFontOfSize:14.5f]];
    CGSize sizePA =[petAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petAgeLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    petAgeLbl.frame = CGRectMake(33.0f, 57, sizePA.width, sizePA.height);
    
    //显示用户性别图像的view
    if ([ownerSex isEqualToString:@"男士"]) {
        ownerSexV.image = [UIHelper imageName:@"near_cell_owner_male"];
        ownerSexV.frame = CGRectMake(ScreenWidth-13-10, 34.5f, 10.0f, 10.0f);

    } else {
        ownerSexV.image = [UIHelper imageName:@"near_cell_owner_female"];
        ownerSexV.frame = CGRectMake(ScreenWidth-13-10, 34.5f, 10.0f, 10.0f);

    }
    
    //显示用户年龄label
    [ownerAgeLbl setFont:[UIFont systemFontOfSize:12.0f]];
    CGSize sizeOA =[ownerAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerAgeLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    ownerAgeLbl.frame = CGRectMake(ScreenWidth-13-13-sizeOA.width, 34.0f, sizeOA.width, 12.0f);
    //by wu

    
    //用户名----胡平安  字体不对
    [ownerNameLbl setFont:[UIFont boldSystemFontOfSize:15.0f]];
    CGSize sizeON =[@"我们都有一个家名字叫" sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerNameLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    ownerNameLbl.textAlignment = NSTextAlignmentRight;
    ownerNameLbl.frame = CGRectMake(ScreenWidth-13-13-sizeOA.width-6-sizeON.width, 29.0f, sizeON.width, 18.0f);

    
    //添加宠聊号  7-4
    [ownerChatLabel setFont:[UIFont systemFontOfSize:12]];
    ownerChatLabel.text = [NSString stringWithFormat:@"宠聊号:%@",chateNumber];
    CGSize sizeOC =[ownerChatLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerChatLabel.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    ownerChatLabel.frame = CGRectMake(ScreenWidth-13-sizeOC.width, 54.0f, 108, 15.0f);
    
    
    
    [petNumberLbl setFont:[UIFont boldSystemFontOfSize:12.0f]];
    CGSize sizePNL =[petNumberLbl.text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petNumberLbl.textColor =[UIColor lightGrayColor];
    petNumberLbl.frame = CGRectMake(ScreenWidth-80, 45.0f, 67.0f, 12.0f);
    
    
    //个性签名 宠物爱好  活动范围
    UILabel *signLbl =[[UILabel alloc]initWithFrame:CGRectMake(13.0f, 87.0f, 60, 14.0f)];
    UILabel *preferLbl =[[UILabel alloc]initWithFrame:CGRectMake(13.0f, 111.0f, 60, 14.0f)];
    UILabel *siteLbl =[[UILabel alloc]initWithFrame:CGRectMake(13.0f, 135.0f, 60, 14.0f)];
    UILabel *relationLbl = [[UILabel alloc]initWithFrame:CGRectMake(13.0F, 159.0f, 60, 14.0f)];
    [signLbl setFont:[UIFont systemFontOfSize:14.5f]];
    [preferLbl setFont:[UIFont systemFontOfSize:14.5f]];
    [siteLbl setFont:[UIFont systemFontOfSize:14.5f]];
    [relationLbl setFont:[UIFont systemFontOfSize:14.5f]];
    signLbl.text =@"个性签名";
    preferLbl.text =@"宠物爱好";
    siteLbl.text =@"活动范围";
    relationLbl.text = @"关系";
    signLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    preferLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    siteLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    relationLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    [ownerSignLbl setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize sizeOS =[ownerSignLbl.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerSignLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    ownerSignLbl.frame = CGRectMake(88, 86, sizeOS.width, sizeOS.height);
    
    [petPreferLbl setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize sizeOP =[petPreferLbl.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petPreferLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    petPreferLbl.frame = CGRectMake(88, 109.5, sizeOP.width, sizeOP.height);
    
    [petSiteLbl setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize sizePSL =[petSiteLbl.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petSiteLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    petSiteLbl.frame = CGRectMake(88, 133.5, sizePSL.width, sizePSL.height);
    
    
    //关系详情
    [relationDetailLbl setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize sizeRGL =[relationDetailLbl.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    relationDetailLbl.textColor =[UIHelper colorWithHexString:@"#7e7e7e"];
    relationDetailLbl.frame = CGRectMake(88, 157.5, 100, 14);
//    relationDetailLbl.text = @"陌生人";
    
    [self addSubview:bgView];
    
    [self addSubview:petNameLbl];
    [self addSubview:petForwardV];
    
//    [self addSubview:timeLbl];
//    [self addSubview:view];//by wu
//    [self addSubview:distanceLbl];20140808
    
    [self addSubview:petSortV];
    [self addSubview:petSortLbl];
    [self addSubview:petAgeV];
    [self addSubview:petAgeLbl];
    
    [self addSubview:ownerSexV];
    [self addSubview:ownerAgeLbl];
    [self addSubview:ownerNameLbl];
    [self addSubview:ownerChatLabel];//宠聊号
    [self addSubview:petNameLbl];
    
    [self addSubview:signLbl];
    [self addSubview:preferLbl];
    [self addSubview:siteLbl];
    [self addSubview:relationLbl];
    [self addSubview:ownerSignLbl];
    [self addSubview:petPreferLbl];
    [self addSubview:petSiteLbl];
    [self addSubview:relationDetailLbl];//陌生人
}

@end
