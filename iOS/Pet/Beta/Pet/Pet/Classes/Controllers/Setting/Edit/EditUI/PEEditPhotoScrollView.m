//
//  PEEditPhotoScrollView.m
//  Pet
//
//  Created by Wu Evan on 7/5/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEEditPhotoScrollView.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "ClickImage.h"
#import "PELongPress.h"

@implementation PEEditPhotoScrollView
@synthesize data,changeImageLabel;
@synthesize esDelegate;
@synthesize getIdArray;
- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)dataArray  AndImageIDData:(NSArray *)imageIDArray{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        data =[[NSArray alloc]initWithArray:dataArray];
        getIdArray = [[NSArray alloc]initWithArray:imageIDArray];
        
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

- (void)layoutByData {
    
    //创建照片背景
    UIImage *bgImage =[UIHelper imageName:@"edit_photo_bg"];
    [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIImageView *bgImageV =[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, (data.count/4 +1)*320, self.bounds.size.height)];
    [bgImageV setImage:bgImage];
    
    [self addSubview:bgImageV];
    
    
    
    //创建照片墙内元素
    int count =[data count]+1;
    int num = ([data count]+1) /4;
    int lestNum = ([data count]+1) %4;
    
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
            
            
            //break when no photo
            if (--count ==0) {
                UIButton * photoV =[UIButton buttonWithType:UIButtonTypeCustom];
                [photoV setFrame:CGRectMake(8.5+j*(72+5), 7.0f, 72.0f, 72.0f)];
                [photoV setImage:[UIHelper imageName:@"edit_photo_add"] forState:UIControlStateNormal];
                [photoV addTarget:self action:@selector(addImageBtnPrssed:) forControlEvents:UIControlEventTouchUpInside];
                photoV.layer.cornerRadius =7.0f;
                photoV.clipsToBounds =YES;
                
                [v addSubview:photoV];
                break;
            }else {
                UIButton * photoV =[UIButton buttonWithType:UIButtonTypeCustom];
                [photoV setFrame:CGRectMake(8.5+j*(72+5), 7.0f, 72.0f, 72.0f)];
                NSURL *url =[NSURL URLWithString:[data objectAtIndex:j+i*4]];
                [photoV setImageForState:UIControlStateNormal withURL:url placeholderImage:[UIHelper imageName:@"cacheImage"]];
                //            [photoV setImage:[UIHelper setImageFromColor:[UIColor blackColor]] forState:UIControlStateNormal];
                photoV.layer.cornerRadius =7.0f;
                photoV.clipsToBounds =YES;
                photoV.tag = [[getIdArray objectAtIndex:j+i*4]integerValue];
                
                //button长按事件
                PELongPress *longPress = [[PELongPress alloc] initWithTarget:self action:@selector(deleteImage:)];
                longPress.minimumPressDuration = 1.0; //定义按的时间
                longPress.tag = [[getIdArray objectAtIndex:j+i*4]integerValue];
                [photoV addGestureRecognizer:longPress];
                [v addSubview:photoV];
            }
        }
        
        [self addSubview:v];
    }
}

/**
 *添加图片动作
 */
- (void)addImageBtnPrssed:(id)sender {
    [esDelegate addBtnSelected];
}

- (void)deleteImage:(PELongPress *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        NSInteger tag =sender.tag;
        NSString *petImageID = [NSString stringWithFormat:@"%ld",(long)tag];
        
        [esDelegate deleteImage: petImageID];
    }
    
}

@end
