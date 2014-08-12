//
//  PEShakeNewView.m
//  Pet
//
//  Created by Wu Evan on 7/23/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEShakeNewView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
@implementation PEShakeNewView

@synthesize dataDic;
@synthesize ownerIcon, ownerSex;
@synthesize petSex;
@synthesize nameLbl, distanceLbl;

- (id)initWithFrame:(CGRect)frame AndData:(NSDictionary *)friendData
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataDic =[[NSDictionary alloc] initWithDictionary:friendData];
        //头像设置
        ownerIcon =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
        //    [ownerIcon setImage:[UIImage imageNamed:@"owner1.png"]];
        ownerIcon.layer.cornerRadius =25.0f;
        ownerIcon.clipsToBounds =YES;
        
        //名字设置
        nameLbl =[[UILabel alloc] init];
        nameLbl.textColor =[UIColor blackColor];
        nameLbl.font =[UIFont systemFontOfSize:14.0f];
        
        
        //距离设置
        distanceLbl =[[UILabel alloc] init];
        distanceLbl.textColor =[UIHelper colorWithHexString:@"#959595"];
        distanceLbl.font =[UIFont systemFontOfSize:11.5f];
        
        
        //性别设置 -----用户性别
        ownerSex =[[UIImageView alloc] init];
        
        
        //宠物类别设置 ----分男女，图片分别为蓝和分红
        petSex =[[UIImageView alloc] init];
        petSex .frame = CGRectMake(197.0f, 18.0f, 14, 11);
        
        //添加这些view
        [self addSubview:ownerIcon];
        [self addSubview:nameLbl];
        [self addSubview:distanceLbl];
        [self addSubview:ownerSex];
        [self addSubview:petSex];
        
        //view设置
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius =5.0f;
        self.clipsToBounds =YES;
        
    }
    return self;
}

- (void)setUIWithData:(NSDictionary *)data {
    
    if(nameLbl.text)
    {
        nameLbl.text = @"";
    }
    if(distanceLbl.text){
        distanceLbl.text = @"";
    }
    
    if(ownerSex.image)
    {
        ownerSex.image = [UIHelper imageName:@""];
    }
    if(ownerIcon.image)
    {
       ownerSex.image = [UIImage imageNamed:@"owner1.png"];
    }
    if(petSex.image){
        
       ownerSex.image = [UIHelper imageName:@""];
        
    }
    
    
    //头像设置
//    [ownerIcon setImage:  [UIImage imageNamed:@"owner1.png"]];
    NSString *imageString = [data objectForKey:SHAKE_PETIMAGE];
    [ownerIcon setImageWithURL:[NSURL URLWithString:imageString]placeholderImage:[UIHelper imageName:@"cacheImage"]];
    
    //名字设置
    NSString *name = [data objectForKey:SHAKE_USERNAME];
    CGSize size =[name sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    nameLbl.frame = CGRectMake(68.0, 15.0, size.width, 14.0f);
    nameLbl.text =name;
    
    //距离设置
    NSString *distance = [NSString stringWithFormat:@"%@米以内",[data objectForKey:SHAKE_LASTLOCATION]];
    CGSize sizeD =[distance sizeWithFont:[UIFont systemFontOfSize:11.5f] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:NSLineBreakByCharWrapping];
     distanceLbl.frame = CGRectMake(68.0f, 41.0f, sizeD.width, 11.5f);
     distanceLbl.text =distance;
    
    //性别设置 -----用户性别
    ownerSex.frame = CGRectMake(size.width+84.0f, 17.0f, 10.0f, 10.0f);
    NSString *userSexString = [data objectForKey:SHAKE_USERSEX];
    
    if ([userSexString isEqualToString:@"男士"]) {
        [ownerSex setImage:[UIHelper imageName:@"near_cell_owner_male"]];
    }else {
        [ownerSex setImage:[UIHelper imageName:@"near_cell_owner_female"]];
    }
    
    
    //宠物类别设置 ----分男女，图片分别为蓝和分红
    NSString *petType = [data objectForKey:SHAKE_PETTYPE];
    NSString *petSexString = [data objectForKey:SHAKE_PETSEX];
    if ([petSexString isEqualToString:@"公"]) {
        [petSex setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petType]]];
    }else {
        [petSex setImage:[UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petType]]];
    }
    [petSex setImage:[UIHelper imageName:@"near_cell_1_male"]];
    


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
