//
//  PEOtherPetView.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEOtherPetView.h"
#import "UIHelper.h"

@implementation PEOtherPetView

@synthesize petIconV, petNameLbl, petAgeLbl, petAgeV, petSortLbl, petSortV;
@synthesize petType, petID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor =[UIColor colorWithPatternImage:[UIHelper imageName:@"nearDetail_cell_bg"]];
        
        petIconV =[[UIImageView alloc] init];
        
        petNameLbl =[[UILabel alloc] init];
        petAgeLbl =[[UILabel alloc] init];
        petSortLbl =[[UILabel alloc] init];
        petSortV =[[UIImageView alloc] init];
        petAgeV =[[UIImageView alloc] init];
        
        petType =[[NSString alloc] init];
    }
    return self;
}


- (void)layoutSubviews {
//    [petIconV setImage:[UIImage imageNamed:@"pett.png"]];
    //宠物icon
    petIconV.frame =CGRectMake(7.0f, 10.0f, 57.0f, 57.0f);
    petIconV.layer.cornerRadius =28.5f;
    petIconV.clipsToBounds =YES;
    
    
    //名字
    [petNameLbl setFont:[UIFont boldSystemFontOfSize:15.0f]];
    CGSize sizePN =[petNameLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petNameLbl.textColor =[UIHelper colorWithHexString:@"#000000"];
    petNameLbl.frame = CGRectMake(77.0f, 10.0f, sizePN.width, sizePN.height);
    
    
    //分类
    petSortV.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petType]];
    petSortV.frame = CGRectMake(77.0f, 33.5f, 14.0f, 11.0f);
    
    //分类描述
    [petSortLbl setFont:[UIFont systemFontOfSize:14.5f]];
    CGSize sizePS =[petSortLbl.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petSortLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    petSortLbl.frame = CGRectMake(93.0f, 30.5f, sizePS.width, sizePS.height);
    
    //生日蛋糕
    petAgeV.image = [UIHelper imageName:@"near_cell_pet_age"];
    petAgeV.frame = CGRectMake(77.0f, 55.5f, 11.5f, 11.5f);
    
     //年龄
    [petAgeLbl setFont:[UIFont systemFontOfSize:14.5f]];
    CGSize sizePA =[petAgeLbl.text sizeWithFont:[UIFont systemFontOfSize:14.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petAgeLbl.textColor =[UIHelper colorWithHexString:@"#8d8d8d"];
    petAgeLbl.frame = CGRectMake(93.0f, 52.5f, sizePA.width, sizePA.height);
    
    
    
    [self addSubview:petNameLbl];
    [self addSubview:petIconV];
    [self addSubview:petSortV];
    [self addSubview:petSortLbl];
    [self addSubview:petAgeV];
    [self addSubview:petAgeLbl];
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
