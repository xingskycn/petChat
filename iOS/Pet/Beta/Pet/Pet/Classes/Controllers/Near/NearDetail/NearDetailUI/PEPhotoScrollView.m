//
//  PEPhotoScrollView.m
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEPhotoScrollView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"

@implementation PEPhotoScrollView

@synthesize isSingle;
@synthesize imageBg;
@synthesize data;

- (id)initWithFrame:(CGRect)frame data:(NSArray *)dataArray AndType:(BOOL)single
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageBg =[[UIImageView alloc]init];
        
        isSingle =single;
        
        data =[NSArray arrayWithArray:dataArray];
        
    }
    return self;
}

- (void)layoutSubviews {
    //黑色背景图
    UIImage *imgBg =[UIHelper imageName:@"nearDetail_photo_bg"];
    //图片拉伸
    [imgBg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    imageBg.image =imgBg;
    imageBg.frame =CGRectInset(self.bounds, 0.0f, 0.0f);
    [self addSubview:imageBg];
    
    if (isSingle) {
        [self layoutSingle:data];
    } else {
        [self layoutDouble:data];
    }
}


- (void)layoutSingle:(NSArray *)array {
    int count =[array count];
    int num = [array count] /4;
    int lestNum = [array count] %4;
    
    if (lestNum !=0) {
        num++;
    }
    
    //srcoller view setting
    self.contentSize =CGSizeMake(320.0f * num, 97.0f);
    self.pagingEnabled =YES;
    self.backgroundColor =[UIColor clearColor];
    self.bounces =NO;
    self.showsHorizontalScrollIndicator =NO;
    self.showsVerticalScrollIndicator =NO;
    
    //add subview
    for (int i =0; i<num; i++) {
        
        UIView *v =[[UIView alloc]initWithFrame:CGRectMake(320 * i, 0.0f, 320.0f, 97.0f)];
        v.backgroundColor =[UIColor clearColor];
        
        for (int j =0; j<4; j++) {
            //每张图片均可以进行点击 72*72，坐标只是x值不一样
            ClickImage * photoV =[[ClickImage alloc]initWithFrame:CGRectMake(8.5+j*(72+5), 7.0f, 72.0f, 72.0f)];
            
            //data里面存放的是图片的url
            NSURL *url =[NSURL URLWithString:[data objectAtIndex:j+i*4]];
            [photoV setImageWithURL:url placeholderImage:[UIHelper imageName:@"nearDetail_photo_icon_bg"]];
            photoV.layer.cornerRadius =7.0f;
            photoV.clipsToBounds =YES;
            photoV.canClick =YES;
            [v addSubview:photoV];
            
            //break when no photo
            if (--count ==0) {
                break;
            }
        }
        
        [self addSubview:v];
    }
    
}

//scroolView有多个page时
- (void)layoutDouble:(NSArray *)array {
    int count =[array count];
    int column =count/8 +1;
    int num =count/4;
    int lestNum = [array count] %4;
    
    if (lestNum !=0) {
        num++;
    }
    
    //srcoller view setting
    self.contentSize =CGSizeMake(320.0f * column, 174.0f);
    self.pagingEnabled =YES;
    self.backgroundColor =[UIColor clearColor];
    self.bounces =NO;
    self.showsHorizontalScrollIndicator =NO;
    self.showsVerticalScrollIndicator =NO;
    
    //add subview
    for (int i =0; i<num; i++) {
        
        if (i%2 ==0) {
            
            UIView *v =[[UIView alloc]initWithFrame:CGRectMake(320 * (i/2), 0.0f, 320.0f, 77.0f)];
            v.backgroundColor =[UIColor clearColor];
            
            for (int j =0; j<4; j++) {
                ClickImage * photoV =[[ClickImage alloc]initWithFrame:CGRectMake(8.5+j*(72+5), 7.0f, 72.0f, 72.0f)];
                
                NSURL *url =[NSURL URLWithString:[data objectAtIndex:j+i*4]];
                [photoV setImageWithURL:url placeholderImage:[UIHelper imageName:@"nearDetail_photo_icon_bg"]];
                photoV.layer.cornerRadius =7.0f;
                photoV.clipsToBounds =YES;
                photoV.canClick =YES;
                
                [v addSubview:photoV];
                
                //break when no photo
                if (--count ==0) {
                    break;
                }
            }
            
            [self addSubview:v];
        }else {
            
            UIView *v =[[UIView alloc]initWithFrame:CGRectMake(320 * (i/2), 77.0f, 320.0f, 97.0f)];
            v.backgroundColor =[UIColor clearColor];
            
            for (int j =0; j<4; j++) {
                ClickImage * photoV =[[ClickImage alloc]initWithFrame:CGRectMake(8.5+j*(72+5), 7.0f, 72.0f, 72.0f)];
                
                NSURL *url =[NSURL URLWithString:[data objectAtIndex:j+i*4]];
                [photoV setImageWithURL:url placeholderImage:[UIHelper imageName:@"nearDetail_photo_icon_bg"]];
                photoV.layer.cornerRadius =7.0f;
                photoV.clipsToBounds =YES;
                photoV.canClick =YES;
                
                [v addSubview:photoV];
                
                //break when no photo
                if (--count ==0) {
                    break;
                }
            }
            
            [self addSubview:v];
        }
        
        
    }
}

@end
