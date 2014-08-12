//
//  PEGroupDetailView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEGroupDetailView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import <CoreText/CoreText.h>
@implementation PEGroupDetailView
@synthesize groupIdNameLabel, groupIDLabel;
@synthesize siteNameLabel,siteLabel;
@synthesize distanceNameLabel,distanceLabel;
@synthesize groupSpaceLabel,groupNewsCountLabel,newsOwnerImageView,newsTitleLabel,newsContentLabel;
@synthesize members,groupMemberlabel,groupMemberCountLabel,memberImageView1,memberImageView2,memberImageView3,memberImageView4,memberNameLabel1,memberNameLabel2,memberNameLabel3,memberNameLabel4;
@synthesize groupIntroduceLabel,groupDescriptionLabel;
@synthesize groupRankLabel,groupRankCountLabel,groupRankDescriptionLabel,rankImageView;
@synthesize crateDateLabel,dateLabel;
@synthesize gapLineView1,gapLineView2,gapLineView3,gapLineView4,gapLineView5,gapLineView6,gapLineView7;
@synthesize arrowImageView2,arrowImageView4,arrowImageView5,arrowImageView8;
@synthesize ownerTopBgImageView;
@synthesize groupMemberButton;
@synthesize groupNewsLabel,groupNewsButton,gapLineView8;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        groupIdNameLabel = [[UILabel alloc]init];
        groupIDLabel = [[UILabel alloc]init];
        gapLineView1 = [[UIImageView alloc]init];
        siteLabel = [[UILabel alloc]init];
        siteNameLabel = [[UILabel alloc]init];
        gapLineView2 = [[UIImageView alloc]init];
        arrowImageView2 = [[UIImageView alloc]init];
        distanceNameLabel = [[UILabel alloc]init];
        distanceLabel = [[UILabel alloc]init];
        gapLineView3 = [[UIImageView alloc]init];
        groupSpaceLabel = [[UILabel alloc]init];
        groupNewsCountLabel = [[UILabel alloc]init];
        newsOwnerImageView = [[UIImageView alloc]init];
        newsTitleLabel = [[UILabel alloc]init];
        newsContentLabel = [[UILabel alloc]init];
        gapLineView4 = [[UIImageView alloc]init];
        arrowImageView4 = [[UIImageView alloc]init];
        members =[[NSArray alloc] init];
        groupMemberlabel = [[UILabel alloc]init];
        groupMemberCountLabel = [[UILabel alloc]init];
        memberImageView1 = [[UIImageView alloc]init];
        ownerTopBgImageView = [[UIImageView alloc]init];
        memberImageView2 = [[UIImageView alloc]init];
        memberImageView3 = [[UIImageView alloc]init];
        memberImageView4 = [[UIImageView alloc]init];
        memberNameLabel1 = [[UILabel alloc]init];
        memberNameLabel2 = [[UILabel alloc]init];
        memberNameLabel3 = [[UILabel alloc]init];
        memberNameLabel4 = [[UILabel alloc]init];
        gapLineView5 = [[UIImageView alloc]init];
        arrowImageView5 = [[UIImageView alloc]init];
        groupIntroduceLabel = [[UILabel alloc]init];
        groupDescriptionLabel = [[UILabel alloc]init];
        gapLineView6 = [[UIImageView alloc]init];
        groupRankLabel = [[UILabel alloc]init];
        rankImageView = [[UIImageView alloc]init];
        groupRankCountLabel = [[UILabel alloc]init];
        groupRankDescriptionLabel = [[UILabel alloc]init];
        gapLineView7 = [[UIImageView alloc]init];
        crateDateLabel = [[UILabel alloc]init];
        dateLabel = [[UILabel alloc]init];
        arrowImageView8 = [[UIImageView alloc]init];
        groupMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        groupNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        groupNewsLabel = [[UILabel alloc]init];
        gapLineView8 = [[UIImageView alloc]init];
        
    }
    return self;
}

- (void)layoutSubviews
{
    //==================群组号
    groupIdNameLabel.backgroundColor = [UIColor clearColor];
    groupIdNameLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupIdNameLabel.font = [UIFont systemFontOfSize:14];
    groupIdNameLabel.textAlignment = NSTextAlignmentRight;
    groupIdNameLabel.text = @"群组号";
    CGSize sizeGIN = [groupIdNameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupIdNameLabel.frame = CGRectMake(78-sizeGIN.width, 15, sizeGIN.width, sizeGIN.height);
    [self addSubview:groupIdNameLabel];
    
    groupIDLabel.backgroundColor = [UIColor clearColor];
    groupIDLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    groupIDLabel.font = [UIFont systemFontOfSize:14];
    groupIDLabel.textAlignment = NSTextAlignmentLeft;
    CGSize sizeGI = [groupIDLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupIDLabel.frame = CGRectMake(91, 15, sizeGI.width, sizeGI.height);
    [self addSubview:groupIDLabel];
    
    gapLineView1.backgroundColor = [UIColor whiteColor];
    gapLineView1.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView1.frame = CGRectMake(92, 39.5, 228, 0.5);
    [self addSubview:gapLineView1];
    
    //群主号右边箭头
    arrowImageView2.backgroundColor = [UIColor clearColor];
    arrowImageView2.image = [UIHelper imageName:@"group_arrowNormal"];
    arrowImageView2.frame = CGRectMake(296, 0, 22, 40);
//    [self addSubview:arrowImageView2];
    
    //========================地点
    siteNameLabel.backgroundColor = [UIColor clearColor];
    siteNameLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    siteNameLabel.font = [UIFont systemFontOfSize:14];
    siteNameLabel.textAlignment = NSTextAlignmentRight;
    siteNameLabel.text = @"地点";
    CGSize sizeSNL = [siteNameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    siteNameLabel.frame = CGRectMake(78-sizeSNL.width, 52.5, sizeSNL.width, sizeSNL.height);
    [self addSubview:siteNameLabel];
    
    siteLabel.backgroundColor = [UIColor clearColor];
    siteLabel.textColor = [UIHelper colorWithHexString:@"000000"];
    siteLabel.font = [UIFont systemFontOfSize:14];
    siteLabel.textAlignment = NSTextAlignmentLeft;
    CGSize sizeSL = [siteLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    siteLabel.frame = CGRectMake(91, 52.5, sizeSL.width, sizeSL.height);
    [self addSubview:siteLabel];
    
    gapLineView2.backgroundColor = [UIColor whiteColor];
    gapLineView2.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView2.frame = CGRectMake(92, 79.5, 228, 0.5);
    [self addSubview:gapLineView2];
    

    //======================距离
    distanceNameLabel.backgroundColor = [UIColor clearColor];
    distanceNameLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    distanceNameLabel.font = [UIFont systemFontOfSize:14];
    distanceNameLabel.textAlignment = NSTextAlignmentRight;
    distanceNameLabel.text = @"距离";
    CGSize sizeDNL = [distanceNameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    distanceNameLabel.frame = CGRectMake(35, 93.75, sizeGIN.width, sizeDNL.height);
    [self addSubview:distanceNameLabel];
    
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textColor = [UIHelper colorWithHexString:@"000000"];
    distanceLabel.font = [UIFont systemFontOfSize:14];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    CGSize sizeDL = [distanceLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    distanceLabel.frame = CGRectMake(91, 93.75, sizeDL.width, sizeDL.height);
    [self addSubview:distanceLabel];
    
    gapLineView3.backgroundColor = [UIColor whiteColor];
    gapLineView3.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView3.frame = CGRectMake(92, 119.5, 228, 0.5);
    [self addSubview:gapLineView3];
    
    
    //======================群空间
    groupSpaceLabel.backgroundColor = [UIColor clearColor];
    groupSpaceLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupSpaceLabel.font = [UIFont systemFontOfSize:14];
    groupSpaceLabel.textAlignment = NSTextAlignmentRight;
    groupSpaceLabel.text = @"群空间";
    CGSize sizeGSL = [groupSpaceLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupSpaceLabel.frame = CGRectMake(35, 129, sizeGSL.width, sizeGSL.height);
    [self addSubview:groupSpaceLabel];
    CGFloat f = 129 +sizeGSL.height;
    
    groupNewsCountLabel.backgroundColor = [UIColor clearColor];
    groupNewsCountLabel.textColor = [UIHelper colorWithHexString:@"#ff7676"];
    groupNewsCountLabel.font  =[UIFont boldSystemFontOfSize:21];
//    groupNewsCountLabel.text = @"125";
    CGSize sizeGNC = [groupNewsCountLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:21] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupNewsCountLabel.frame = CGRectMake(78-sizeGNC.width,151 , sizeGNC.width, sizeGNC.height);
    [self addSubview:groupNewsCountLabel];
    
    newsOwnerImageView.backgroundColor = [UIColor clearColor];
    newsOwnerImageView.frame = CGRectMake(94, 134, 31, 31);
    newsOwnerImageView.layer.cornerRadius = 15.5f;
    newsOwnerImageView.clipsToBounds = YES;
    [self addSubview:newsOwnerImageView];
    
    
    newsTitleLabel.backgroundColor = [UIColor clearColor];
    newsTitleLabel.textColor = [UIHelper colorWithHexString:@"#737373"];
    newsTitleLabel.font = [UIFont systemFontOfSize:14];
    newsTitleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize sizeNTL = [newsTitleLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsTitleLabel.frame = CGRectMake(131, 135.5, sizeNTL.width, sizeNTL.height);
    [self addSubview:newsTitleLabel];
    
    CGFloat g = 125.5+sizeNTL.height+4.5;//135
    
    newsContentLabel.backgroundColor = [UIColor clearColor];
    newsContentLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    newsContentLabel.font = [UIFont systemFontOfSize:12.5];
    newsContentLabel.textAlignment = NSTextAlignmentLeft;
    CGSize sizeNCL = [newsContentLabel.text sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:CGSizeMake(150, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    newsContentLabel.frame = CGRectMake(131, g, sizeNCL.width, sizeNCL.height);
    [self addSubview:newsContentLabel];
    
    
    gapLineView4.backgroundColor = [UIColor whiteColor];
    gapLineView4.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView4.frame = CGRectMake(92, 179.5, 228, 0.5);
    [self addSubview:gapLineView4];
    
    
    arrowImageView4.backgroundColor = [UIColor clearColor];
    arrowImageView4.image = [UIHelper imageName:@"group_arrowNormal"];
    arrowImageView4.frame = CGRectMake(296, 130, 22, 40);
//    [self addSubview:arrowImageView4];//群空间箭头
    
    
    //=========================群成员
    groupMemberlabel.backgroundColor = [UIColor clearColor];
    groupMemberlabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupMemberlabel.font = [UIFont systemFontOfSize:14];
    groupMemberlabel.textAlignment = NSTextAlignmentRight;
    groupMemberlabel.text = @"群成员";
    CGSize sizeGML = [groupMemberlabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupMemberlabel.frame = CGRectMake(35, 190.25, sizeGIN.width, sizeGML.height);
    [self addSubview:groupMemberlabel];
    
    CGFloat h = 190.25+sizeGML.height+11;
    
    groupMemberCountLabel.backgroundColor = [UIColor clearColor];
    groupMemberCountLabel.textColor = [UIHelper colorWithHexString:@"#b8b8b8"];
    groupMemberCountLabel.font = [UIFont boldSystemFontOfSize:21];
    groupMemberCountLabel.textAlignment = NSTextAlignmentRight;
    CGSize sizeGMC = [groupMemberCountLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:21] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupMemberCountLabel.frame = CGRectMake(78-sizeGMC.width, 213, sizeGMC.width, sizeGMC.height);
    [self addSubview:groupMemberCountLabel];
    


    
    //显示群主 注：暂时没有群主的标识，故把数组的第一位作为群主处理 8-2
    if (members.count >0) {
        
        //群主
        NSDictionary *memberImageView1Dict =members[0];
        
        memberImageView1.backgroundColor = [UIColor clearColor];
        memberImageView1.frame = CGRectMake(94, 190.25, 31, 31);
        memberImageView1.image = [UIHelper imageName:@"group_ownerBg"];
        [self addSubview:memberImageView1];
        
        ownerTopBgImageView.backgroundColor = [UIColor clearColor];
        ownerTopBgImageView.frame = CGRectMake(94, 184, 31, 37);
        ownerTopBgImageView.image = [UIHelper imageName:@"group_ownerTopBg"];
        [self addSubview:ownerTopBgImageView];
        
        UIImageView *mOwner =[[UIImageView alloc] init];
        mOwner.frame = CGRectInset(memberImageView1.frame, 0.5f, 0.5f);
        mOwner.layer.cornerRadius = 15.0f;
        mOwner.clipsToBounds = YES;
        [mOwner setImageWithURL:[NSURL URLWithString:[memberImageView1Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETIAMGEURL]]
               placeholderImage:[UIHelper imageName:@"group_memberBg"]];
        [self addSubview:mOwner];
    }
    
    
    if (members.count >1) {
        
        NSDictionary *memberImageView2Dict =members[1];
        memberImageView2.backgroundColor = [UIColor clearColor];
        memberImageView2.frame = CGRectMake(144, 190.25, 31, 31);
        memberImageView2.layer.cornerRadius = 15.5f;
        memberImageView2.clipsToBounds = YES;
        [memberImageView2 setImageWithURL:[NSURL URLWithString:[memberImageView2Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETIAMGEURL]]
                         placeholderImage:[UIHelper imageName:@"group_memberBg"]];
        [self addSubview:memberImageView2];
    }
    
    if (members.count >2) {
        
        NSDictionary *memberImageView3Dict =members[2];
        memberImageView3.backgroundColor = [UIColor clearColor];
        memberImageView3.frame = CGRectMake(194, 190.25, 31, 31);
        memberImageView3.layer.cornerRadius = 15.5f;
        memberImageView3.clipsToBounds = YES;
        [memberImageView3 setImageWithURL:[NSURL URLWithString:[memberImageView3Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETIAMGEURL]]
                         placeholderImage:[UIHelper imageName:@"group_memberBg"]];
        [self addSubview:memberImageView3];
    }
    
    if (members.count >3) {
            NSDictionary *memberImageView4Dict =members[3];
            memberImageView4.backgroundColor = [UIColor clearColor];
            memberImageView4.frame = CGRectMake(244, 190.25, 31, 31);
            memberImageView4.layer.cornerRadius = 15.5f;
            memberImageView4.clipsToBounds = YES;
            [memberImageView4 setImageWithURL:[NSURL URLWithString:[memberImageView4Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETIAMGEURL]]
                             placeholderImage:[UIHelper imageName:@"group_memberBg"]];
            [self addSubview:memberImageView4];
        }
    
    
    
    CGFloat k = 190.25+ 31 +6;
    
    
    
    if (members.count >0) {
        
        NSDictionary *memberNameLabel1Dict =members[0];
        memberNameLabel1.backgroundColor = [UIColor clearColor];
        memberNameLabel1.textColor = [UIHelper colorWithHexString:@"#ff8400"];
        memberNameLabel1.font = [UIFont systemFontOfSize:12];
        memberNameLabel1.text = [memberNameLabel1Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETNAME];
        memberNameLabel1.textAlignment = NSTextAlignmentCenter;
        memberNameLabel1.frame = CGRectMake(75.0f, k, 69.0f, 12.0f);
        [self addSubview:memberNameLabel1];
    }
    
    if (members.count >1) {
        
        NSDictionary *memberNameLabel2Dict =members[1];
        memberNameLabel2.backgroundColor = [UIColor clearColor];
        memberNameLabel2.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        memberNameLabel2.font = [UIFont systemFontOfSize:12];
        memberNameLabel2.text = [memberNameLabel2Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETNAME];
        memberNameLabel2.textAlignment = NSTextAlignmentCenter;
        memberNameLabel2
        .frame = CGRectMake(125.0f, k, 69.0f, 12.0f);
        [self addSubview:memberNameLabel2];
    }
    
    
    
    if (members.count >2) {
        
        NSDictionary *memberNameLabel3Dict =members[2];
        memberNameLabel3.backgroundColor = [UIColor clearColor];
        memberNameLabel3.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        memberNameLabel3.font = [UIFont systemFontOfSize:12];
        memberNameLabel3.text = [memberNameLabel3Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETNAME];
        memberNameLabel3.textAlignment = NSTextAlignmentCenter;
        memberNameLabel3.frame = CGRectMake(175.0f, k, 69.0f, 12.0f);
        [self addSubview:memberNameLabel3];
    }
    
    
    if (members.count >3) {
        
        NSDictionary *memberNameLabel4Dict =members[3];
        memberNameLabel4.backgroundColor = [UIColor clearColor];
        memberNameLabel4.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        memberNameLabel4.font = [UIFont systemFontOfSize:12];
        memberNameLabel4.text = [memberNameLabel4Dict objectForKey:DISCOVER_GROUPDETAIL_PETLIST_PETNAME];
        memberNameLabel4.textAlignment = NSTextAlignmentCenter;
        memberNameLabel4.frame = CGRectMake(225.0f, k, 69.0f, 12.0f);
        [self addSubview:memberNameLabel4];
    }
    

    gapLineView5.backgroundColor = [UIColor whiteColor];
    gapLineView5.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView5.frame = CGRectMake(92, 245.5, 228, 0.5);
    [self addSubview:gapLineView5];
    
    arrowImageView5.backgroundColor = [UIColor whiteColor];
    arrowImageView5.image = [UIHelper imageName:@"group_arrowNormal"];
    arrowImageView5.frame = CGRectMake(296, 193, 22, 40);
    [self addSubview:arrowImageView5];  //群成员箭头
    
    //群成员button
    groupMemberButton.frame = CGRectMake(90, 180, 230, 66);
    [self addSubview:groupMemberButton];
    
    
    //========================群介绍
    groupIntroduceLabel.backgroundColor = [UIColor clearColor];
    groupIntroduceLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupIntroduceLabel.font = [UIFont systemFontOfSize:14];
    groupIntroduceLabel.textAlignment = NSTextAlignmentRight;
    groupIntroduceLabel.text = @"群介绍";
    CGSize sizeGID = [groupIntroduceLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupIntroduceLabel.frame = CGRectMake(36, 254, sizeGIN.width, sizeGID.height);
    [self addSubview:groupIntroduceLabel];
    
    groupDescriptionLabel.backgroundColor = [UIColor clearColor];
    groupDescriptionLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    groupDescriptionLabel.font = [UIFont systemFontOfSize:12.5];
    
    
    groupDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    groupDescriptionLabel.numberOfLines = 0;
    CGSize sizeGDL = [groupDescriptionLabel.text sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    //必须先初始化一个位置
    groupDescriptionLabel.frame = CGRectMake(94, 250, sizeGDL.width, 50.0);//253
    if (groupDescriptionLabel.text.length<=16) {
        groupDescriptionLabel.frame = CGRectMake(94, 257, sizeGDL.width, 13);//253
    }

    
    //控制label之间的行间距
    NSMutableAttributedString *nameString  = [[NSMutableAttributedString alloc]initWithString:groupDescriptionLabel.text];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineBreakMode:NSLineBreakByCharWrapping];
    [ps setLineSpacing:7];//行间距为7
    if(nameString.length>16){
        [nameString addAttribute:NSParagraphStyleAttributeName value:ps  range:NSMakeRange(0, nameString.length)];
    }
    groupDescriptionLabel.attributedText = nameString;
    [self addSubview:groupDescriptionLabel];
    
    
    gapLineView6.backgroundColor = [UIColor whiteColor];
    gapLineView6.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView6.frame = CGRectMake(92, 318.5, 228, 0.5);
    [self addSubview:gapLineView6];
    
    
    //群等级
    groupRankLabel.backgroundColor = [UIColor clearColor];
    groupRankLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupRankLabel.font = [UIFont systemFontOfSize:14];
    groupRankLabel.textAlignment = NSTextAlignmentRight;
    groupRankLabel.text = @"群等级";
    CGSize sizeGRL = [groupRankLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupRankLabel.frame = CGRectMake(35, 330, sizeGRL.width, sizeGRL.height);
    [self addSubview:groupRankLabel];
    
    rankImageView.backgroundColor = [UIColor clearColor];
    rankImageView.frame = CGRectMake(93, 332, 12.5, 15.5);
    rankImageView.image = [UIHelper imageName:@"club_starIcon"];
    [self addSubview:rankImageView];
    
    groupRankCountLabel.backgroundColor = [UIColor clearColor];
    groupRankCountLabel.textColor = [UIColor whiteColor];
    groupRankCountLabel.font =  [UIFont systemFontOfSize:8];
    groupRankCountLabel.textAlignment = NSTextAlignmentCenter;
//    groupRankCountLabel.text = @"1";
    groupRankCountLabel.frame = CGRectMake(0, 1.5, 12.5, 8);
    [rankImageView addSubview:groupRankCountLabel];
    
    
    
    groupRankDescriptionLabel.backgroundColor = [UIColor clearColor];
    groupRankDescriptionLabel.textColor = [UIHelper colorWithHexString:@"#c2c2c2"];
    groupRankDescriptionLabel.font = [UIFont systemFontOfSize:14];
//    groupRankDescriptionLabel.text = @"普通30人群";
    groupRankDescriptionLabel.textAlignment = NSTextAlignmentRight;
    CGSize sizeGRDL= [groupRankDescriptionLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupRankDescriptionLabel.frame = CGRectMake(93+12.5+9, 330, sizeGRDL.width, sizeGRDL.height);
    [self addSubview:groupRankDescriptionLabel];
    
    gapLineView7.backgroundColor = [UIColor whiteColor];
    gapLineView7.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView7.frame = CGRectMake(92, 358.5, 228, 0.5);
    [self addSubview:gapLineView7];
    
    //创建日期
    crateDateLabel.backgroundColor = [UIColor clearColor];
    crateDateLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    crateDateLabel.font = [UIFont systemFontOfSize:14];
    crateDateLabel.textAlignment = NSTextAlignmentRight;
    crateDateLabel.text = @"创建日期";
    CGSize sizeCDL = [crateDateLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    crateDateLabel.frame = CGRectMake(22, 372, sizeCDL.width, sizeCDL.height);
    [self addSubview:crateDateLabel];
    
    
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    dateLabel.font = [UIFont systemFontOfSize:14];
//    dateLabel.text = @"2014.6.17";
    dateLabel.textAlignment = NSTextAlignmentRight;
    CGSize sizeDTL= [dateLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    dateLabel.frame = CGRectMake(22+sizeCDL.width+16, 372, sizeDTL.width, sizeDTL.height);
    [self addSubview:dateLabel];
    

    
    //群组动态
    groupNewsLabel.backgroundColor = [UIColor clearColor];
    groupNewsLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    groupNewsLabel.font = [UIFont systemFontOfSize:14];
    groupNewsLabel.textAlignment = NSTextAlignmentRight;
    groupNewsLabel.text = @"群组动态";
    CGSize sizeGNL = [groupNewsLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    groupNewsLabel.frame = CGRectMake(22, 414, sizeGNL.width, sizeGNL.height);
//    [self addSubview:groupNewsLabel];
    

    
    arrowImageView8.backgroundColor = [UIColor clearColor];
    arrowImageView8.image = [UIHelper imageName:@"group_arrowNormal"];
    arrowImageView8.frame = CGRectMake(296, 399, 22, 40);
//    [self addSubview:arrowImageView8];
    
    gapLineView8.backgroundColor = [UIColor whiteColor];
    gapLineView8.image = [UIHelper imageName:@"group_gapLine"];
    gapLineView8.frame = CGRectMake(92, 398.5, 228, 0.5);
    [self addSubview:gapLineView8];
    
    groupNewsButton.frame = CGRectMake(0, 399, 320, 40);
    [self addSubview:groupNewsButton];
    
    
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
