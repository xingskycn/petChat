//
//  PEFaceView.m
//  Pet
//
//  Created by Wu Evan on 7/28/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEFaceView.h"

@implementation PEFaceView
@synthesize faceViewDelegate;

@synthesize face1, face2, face3, face4, face5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)layoutSubviews {
    

    face1 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 183.0f)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 50 * j, 15 + 45 * i, 30, 30);
            [face1 addSubview:button];
        }
    }
    face1.tag =900;
    face1.backgroundColor =[UIColor whiteColor];
    
    //添加删除发送按钮
    //        UIButton *dBtn =[]
    [self addSubview:face1];
    
    face2 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 183.0f)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num +100*1];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num +100 *1;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 50 * j, 15 + 45 * i, 30, 30);
            [face2 addSubview:button];
        }
    }
    face2.tag =1+900;
    face2.backgroundColor =[UIColor whiteColor];
    
    //添加删除发送按钮
    //        UIButton *dBtn =[]
    [self addSubview:face2];
    
    face3 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 183.0f)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num +100*2];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num +100 *2;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 50 * j, 15 + 45 * i, 30, 30);
            [face3 addSubview:button];
        }
    }
    face3.tag =2+900;
    face3.backgroundColor =[UIColor whiteColor];
    
    //添加删除发送按钮
    //        UIButton *dBtn =[]
    [self addSubview:face3];
    
    face4 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 183.0f)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num +100*3];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num +100 *3;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 50 * j, 15 + 45 * i, 30, 30);
            [face4 addSubview:button];
        }
    }
    face4.tag =3+900;
    face4.backgroundColor =[UIColor whiteColor];
    
    //添加删除发送按钮
    //        UIButton *dBtn =[]
    [self addSubview:face4];
    
    face5 =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 183.0f)];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 6; j++) {
            int num = j + 6 * i;
            NSString* name = [NSString stringWithFormat:@"%03d.png",num +100*4];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = num +100 *4;
            if (num >17) {
                break;
            }
            
            [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(faceChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 50 * j, 15 + 45 * i, 30, 30);
            [face5 addSubview:button];
        }
    }
    face5.tag =4+900;
    face5.backgroundColor =[UIColor whiteColor];
    
    [self addSubview:face5];
    
    
    UIView *f =(UIView *)[self viewWithTag:900];
    [self bringSubviewToFront:f];
    
    
    
    //添加删除发送按钮
    UIButton *delete =[UIButton buttonWithType:UIButtonTypeCustom];
    [delete setFrame:CGRectMake(171.0f, 140.0f, 52.5f, 31.5f)];
    [delete setImage:[UIHelper imageName:@"chat_emo_delete"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *send =[UIButton buttonWithType:UIButtonTypeCustom];
    [send setFrame:CGRectMake(234.0f, 140.0f, 75.0f, 31.5f)];
    [send setImage:[UIHelper imageName:@"chat_emo_send"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:delete];
    [self addSubview:send];
    
    //横线
    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 182.0f, 320.0f, 1.0f)];
    [line setBackgroundColor:[UIHelper colorWithHexString:@"#bac0c6"]];
    [self addSubview:line];
    
    //表情切换按钮
    UIScrollView *faceSV =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 183.0f, 320.0f, 42.0f)];
    for (int m =0; m<5; m++) {
        UIButton *faceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [faceBtn setFrame:CGRectMake(64.0f *m, 0.0f, 64.0f, 42.0f)];
        faceBtn.tag =m +800 ;
        UIImageView *icon =[[UIImageView alloc]initWithFrame:CGRectMake(17.0f, 6.0f, 30.0f, 30.0f)];
        [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d00.png", m]]];
        UIImageView *line =[[UIImageView alloc]initWithFrame:CGRectMake(63.0f, 0.0f, 1.0f, 42.0f)];
        [line setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#bac0c6"]]];
        icon.userInteractionEnabled =NO;
        [faceBtn addTarget:self action:@selector(sortChoose:) forControlEvents:UIControlEventTouchUpInside];
        [faceBtn setBackgroundColor:[UIColor whiteColor]];
        if (m !=4) {
            [faceBtn addSubview:line];
        }
        [faceBtn addSubview:icon];
        [faceSV addSubview:faceBtn];
    }
    [faceSV setContentSize:CGSizeMake(320.0f, 42.0f)];
    faceSV.showsHorizontalScrollIndicator =NO;
    faceSV.showsVerticalScrollIndicator =NO;
    [self addSubview:faceSV];
}


- (void)faceChoose:(id)sender {
    UIButton *btn =(UIButton *)sender;
    [faceViewDelegate didFaceButton:btn];
}

- (void)deleteBtnPressed:(id)sender {
    UIButton *btn =(UIButton *)sender;
    [faceViewDelegate didDeleteButton:btn];
}

- (void)sendBtnPressed:(id)sender {
    UIButton *btn =(UIButton *)sender;
    [faceViewDelegate didSendButton:btn];
}


- (void)sortChoose:(UIButton *)sender {
    switch (sender.tag) {
        case 800:
            face1.hidden =NO;
            face2.hidden =YES;
            face3.hidden =YES;
            face4.hidden =YES;
            face5.hidden =YES;
            break;
        case 801:
            face1.hidden =YES;
            face2.hidden =NO;
            face3.hidden =YES;
            face4.hidden =YES;
            face5.hidden =YES;
            break;
        case 802:
            face1.hidden =YES;
            face2.hidden =YES;
            face3.hidden =NO;
            face4.hidden =YES;
            face5.hidden =YES;
            break;
        case 803:
            face1.hidden =YES;
            face2.hidden =YES;
            face3.hidden =YES;
            face4.hidden =NO;
            face5.hidden =YES;
            break;
        case 804:
            face1.hidden =YES;
            face2.hidden =YES;
            face3.hidden =YES;
            face4.hidden =YES;
            face5.hidden =NO;
            break;
            
        default:
            break;
    }
}

@end
