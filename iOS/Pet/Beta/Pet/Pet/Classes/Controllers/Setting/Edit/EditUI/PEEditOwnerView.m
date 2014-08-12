//
//  PEEditOwnerView.m
//  Pet
//
//  Created by Wu Evan on 7/7/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEEditOwnerView.h"
#import "UIHelper.h"

@implementation PEEditOwnerView
@synthesize petDataIcon,petInfoLabel;
@synthesize lineImageView;
@synthesize dic;
@synthesize nameDetail,ageDetail,starDetail,signDetail;
@synthesize nameBtn,ageBtn,signBtn;
@synthesize nameBtn2,ageTextField,signBtn2;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //我的基本资料Icon
        UIImageView *cardV =[[UIImageView alloc] initWithFrame:CGRectMake(6.0f, 15.0f, 21.0f, 21.0f)];//0.0
        [cardV setImage:[UIHelper imageName:@"edit_owner_info"]];
        [self addSubview:cardV];
        
        //我的基本资料label
        UILabel *ownerInfoLbl =[[UILabel alloc] initWithFrame:CGRectMake(32.0f, 20.0f, 200.0f, 11.0f)];//5.0
        ownerInfoLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        ownerInfoLbl.font =[UIFont systemFontOfSize:11.0f];
        ownerInfoLbl.text =@"我的基本资料";
        [self addSubview:ownerInfoLbl];
        
        //添加4条分隔线
        for (int i =0; i <4; i++) {
            UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(91.0f, 96.0f + 40.0f*i, 228.0f, 1.0f)];
            [lineView setImage:[UIHelper imageName:@"edit_line"]];
            [self addSubview:lineView];
        }
        
        //姓名按钮----覆盖在姓名标签上面
        nameBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [nameBtn setFrame:CGRectMake(0.0f, 56.0f, 320.0f, 40.0f)];
        nameBtn.userInteractionEnabled = YES;
        
        nameBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        nameBtn2.tag = 300;
        [nameBtn2 setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
        
        
        //姓名标签
        UILabel *nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(51.5f, 13.5f, 59.0f, 13.0f)];
        nameLabel.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        nameLabel.font =[UIFont systemFontOfSize:13.0f];
        nameLabel.userInteractionEnabled = YES;
        nameLabel.text =@"姓名";
        [nameBtn addSubview:nameLabel];
        //姓名内容
        nameDetail =[[UILabel alloc] initWithFrame:CGRectMake(96.0f, 13.0f, 200.0f, 13.0f)];
        nameDetail.textColor =[UIHelper colorWithHexString:@"#000000"];
        nameDetail.font =[UIFont systemFontOfSize:14.0f];
        nameDetail.userInteractionEnabled = YES;
        [nameBtn addSubview:nameDetail];
        //姓名箭头
        UIImageView *nameAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 13.25f, 8.0f, 13.5f)];
        [nameAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
        [nameBtn addSubview:nameAorrow];
        
        [nameBtn addSubview:nameBtn2];
        [self addSubview:nameBtn];
        
        
        
        //年龄按钮
        ageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [ageBtn setFrame:CGRectMake(0.0f, 96.0f, 320.0f, 40.0f)];
        
        ageTextField =[[UITextField alloc]init];
        ageTextField.tag =908;
        [ageTextField setFrame:CGRectMake(96.0f, 0.0f, 320.0f, 40.0f)];
        ageTextField.text = @"23岁";
        ageTextField.font =[UIFont systemFontOfSize:14.0f];
        
        //年龄标签
        UILabel *ageLabel =[[UILabel alloc] initWithFrame:CGRectMake(51.5f, 13.5f, 59.0f, 13.0f)];
        ageLabel.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        ageLabel.font =[UIFont systemFontOfSize:13.0f];
        ageLabel.text =@"年龄";
        [ageBtn addSubview:ageLabel];
        //年龄内容
        ageDetail =[[UILabel alloc] initWithFrame:CGRectMake(96.0f, 13.0f, 200.0f, 14.0f)];
        ageDetail.textColor =[UIHelper colorWithHexString:@"#000000"];
        ageDetail.font =[UIFont systemFontOfSize:14.0f];
        ageDetail.text =@"23 岁";
//        [ageBtn addSubview:ageDetail];
        //年龄箭头
        UIImageView *ageAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 13.25f, 8.0f, 13.5f)];
        [ageAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
        [ageBtn addSubview:ageAorrow];
        
        [ageBtn addSubview:ageTextField];
        [self addSubview:ageBtn];
        
        
        
        //星座按钮
        UIButton *starBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [starBtn setFrame:CGRectMake(0.0f, 136.0f, 320.0f, 40.0f)];
        //星座标签
        UILabel *starLabel =[[UILabel alloc] initWithFrame:CGRectMake(51.5f, 13.5f, 59.0f, 13.0f)];
        starLabel.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        starLabel.font =[UIFont systemFontOfSize:13.0f];
        starLabel.text =@"星座";
        [starBtn addSubview:starLabel];
        //星座内容：自动根据年月日算
        starDetail =[[UILabel alloc] initWithFrame:CGRectMake(96.0f, 13.0f, 200.0f, 14.0f)];
        starDetail.textColor =[UIHelper colorWithHexString:@"#000000"];
        starDetail.font =[UIFont systemFontOfSize:14.0f];
        starDetail.text =@"大熊座";
        [starBtn addSubview:starDetail];
        //星座箭头
        UIImageView *starAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 13.25f, 8.0f, 13.5f)];
        [starAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
        //    [starBtn addSubview:starAorrow];
        [self addSubview:starBtn];
        
        //签名按钮
        signBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        signBtn.userInteractionEnabled = YES;
        [signBtn setFrame:CGRectMake(0.0f, 176.0f, 320.0f, 40.0f)];
        
        signBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        signBtn2.userInteractionEnabled = YES;
        signBtn2.tag = 301;
        [signBtn2 setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
        
        //签名标签
        UILabel *signLabel =[[UILabel alloc] initWithFrame:CGRectMake(25.0f, 13.5f, 59.0f, 13.0f)];
        signLabel.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
        signLabel.font =[UIFont systemFontOfSize:13.0f];
        signLabel.text =@"个人签名";
        [signBtn addSubview:signLabel];
        //签名内容
        signDetail =[[UILabel alloc] initWithFrame:CGRectMake(96.0f, 13.0f, 200.0f, 14.0f)];
        signDetail.textColor =[UIHelper colorWithHexString:@"#000000"];
        signDetail.font =[UIFont systemFontOfSize:14.0f];
        //    signDetail.text =@"最爱我家的阿咪哥，哈哈哈哈哈";
        [signBtn addSubview:signDetail];
        //签名箭头
        UIImageView *signAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 13.25f, 8.0f, 13.5f)];
        [signAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
        [signBtn addSubview:signAorrow];
        
        [signBtn addSubview:signBtn2];
        [self addSubview:signBtn];
        
        
        //=================我的宠物资料ICon
        petDataIcon = [[UIImageView alloc]init];
        petDataIcon.backgroundColor = [UIColor clearColor];
        petDataIcon.image = [UIHelper imageName:@"edit_pet_info"];
        petDataIcon.frame = CGRectMake(6, 236, 21, 21);
        [self addSubview:petDataIcon];
        
        //我的宠物资料
        petInfoLabel = [[UILabel alloc]init];
        petInfoLabel.backgroundColor = [UIColor clearColor];
        petInfoLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        petInfoLabel.font = [UIFont systemFontOfSize:11];
        petInfoLabel.text = @"我的宠物资料";
        petInfoLabel.frame = CGRectMake(32, 241, 200, 11);//386
        [self addSubview:petInfoLabel];
        
        //连线
        lineImageView = [[UIImageView alloc]init];
        lineImageView.frame = CGRectMake(16, 36, 0.5, 200);
        lineImageView.image = [UIHelper imageName:@"edit_line_ vertical"];
        lineImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:lineImageView];
        

    }
    return self;
}






-(void)changeStausBg
{
    
    NSLog(@"changeBg");
}

@end
