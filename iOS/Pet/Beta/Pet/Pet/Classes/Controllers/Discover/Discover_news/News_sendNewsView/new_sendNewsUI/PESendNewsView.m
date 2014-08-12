//
//  PESendNewsView.m
//  Pet
//
//  Created by WuJunqiu on 14-7-31.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PESendNewsView.h"
#import "UIHelper.h"
@implementation PESendNewsView

@synthesize count;
@synthesize myTextView,wordsLabel,tempwordslabel,remaindLabel;
@synthesize mySiteBtn,SynchronousSendBtn,shoutSortBtn, shoutLabel;
@synthesize delegate, passPhotoView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];// Initialization code
            }
    return self;
}


- (void)setupUI{
    count =101;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIHelper colorWithHexString:@"#e8edee"];
    bgView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    [self addSubview:bgView];
    
    
    remaindLabel = [[UILabel alloc]init];
    remaindLabel.textColor = [UIHelper colorWithHexString:@"#b8b8b8"];
    remaindLabel.font = [UIFont systemFontOfSize:14];
    remaindLabel.text = @"想对朋友说些什么呢?";
    remaindLabel.frame = CGRectMake(12, 9, 200, 14);
    [bgView addSubview:remaindLabel];
    
    
    myTextView = [[UITextView alloc]init];
    myTextView.backgroundColor = [UIColor clearColor];
    myTextView.frame = CGRectMake(7, 0, ScreenWidth, 200);
    myTextView.textColor = [UIColor blackColor];
    myTextView.delegate = self;
    myTextView.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:myTextView];
    
    
    wordsLabel = [[UILabel alloc]init];
    wordsLabel.textColor = [UIHelper colorWithHexString:@"#707070"];
    wordsLabel.font = [UIFont systemFontOfSize:9.5];
    wordsLabel.text = @"0/120字";
    CGSize wordSize = [wordsLabel.text sizeWithFont:[UIFont systemFontOfSize:9.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    wordsLabel.frame = CGRectMake(ScreenWidth-6-wordSize.width, 184.5, 50, 9.5);
    [bgView addSubview:wordsLabel];
    
    
    tempwordslabel = [[UILabel alloc]init];
    tempwordslabel.textColor = [UIHelper colorWithHexString:@"#707070"];
    tempwordslabel.font = [UIFont systemFontOfSize:9.5];
    CGSize tempwordsSize = [@"101/120" sizeWithFont:[UIFont systemFontOfSize:9.5] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    tempwordslabel.frame = CGRectMake(ScreenWidth-6-tempwordsSize.width, 184.5, 50, 9.5);
    [bgView addSubview:tempwordslabel];
    
    UIView *gapLineView1 = [[UIView alloc]init];
    gapLineView1.backgroundColor = [UIHelper colorWithHexString:@"#bac0c6"];
    gapLineView1.frame = CGRectMake(0, 200, ScreenWidth, 0.5);
    [self addSubview:gapLineView1];
    
    //=======上传图片和视频:ScrollView
    passPhotoView = [[UIScrollView alloc]init];
    passPhotoView.backgroundColor = [UIColor whiteColor];
    passPhotoView.frame = CGRectMake(0, 200.5, ScreenWidth, 123);
    passPhotoView.contentSize = CGSizeMake(88.0f, 123);
    passPhotoView.bounces =NO;
    passPhotoView.showsHorizontalScrollIndicator =NO;
    passPhotoView.showsVerticalScrollIndicator =NO;
    [self addSubview:passPhotoView];
    
    
    UIImageView *passImageIcon = [[UIImageView alloc]init];
    passImageIcon.image = [UIHelper imageName:@"news_sendNew_passImageICon"];
    passImageIcon.frame = CGRectMake(11.5, 209.5, 17, 14);
    [self addSubview:passImageIcon];
    
    UILabel *passPhotoLel = [[UILabel alloc]init];
    passPhotoLel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    passPhotoLel.font = [UIFont systemFontOfSize:14];
    passPhotoLel.text = @"上传图片/视频";
    passPhotoLel.frame = CGRectMake(33.5, 209.5, 200, 14);
    [self addSubview:passPhotoLel];
    
    UIView *gapLineView2 = [[UIView alloc]init];
    gapLineView2.backgroundColor = [UIHelper colorWithHexString:@"#bac0c6"];
    gapLineView2.frame = CGRectMake(0, 323.5, ScreenWidth, 0.5);
    [self addSubview:gapLineView2];
    
    //========添加照片&视频
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(8.0f, 33.0f, 72.0f, 72.0f)];
    addBtn.tag =100;
    [addBtn setImage:[UIHelper imageName:@"news_sendNew_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [passPhotoView addSubview:addBtn];
    
    //=======喊话类别
    shoutSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoutSortBtn.frame = CGRectMake(0, 324, ScreenWidth, 50);
    [shoutSortBtn addTarget:self action:@selector(shoutSortBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *shoutIcon = [[UIImageView alloc]init];
    shoutIcon.image = [UIHelper imageName:@"news_sendNew_shoutICon"];
    shoutIcon.frame = CGRectMake(11.5, 18.25, 18, 12.5);
    [shoutSortBtn addSubview:shoutIcon];
    
    shoutLabel = [[UILabel alloc]init];
    shoutLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    shoutLabel.font = [UIFont systemFontOfSize:14];
    shoutLabel.text = @"动态类别";
    shoutLabel.frame = CGRectMake(33.5, 18, 200, 14);
    [shoutSortBtn addSubview:shoutLabel];
    
    UIImageView *shoutAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-28.5-8, 18.25f, 8.0f, 13.5f)];
    [shoutAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [shoutSortBtn addSubview:shoutAorrow];
    [self addSubview:shoutSortBtn];
    
    
    
    UIView *gapLineView3 = [[UIView alloc]init];
    gapLineView3.backgroundColor = [UIHelper colorWithHexString:@"#bac0c6"];
    gapLineView3.frame = CGRectMake(0, 374, ScreenWidth, 0.5);
//    [self addSubview:gapLineView3];
    
    
    
    
    
    //=======您的位置
    mySiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mySiteBtn.frame = CGRectMake(0, 374.5, ScreenWidth, 50);
    [mySiteBtn addTarget:self action:@selector(siteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *siteIcon = [[UIImageView alloc]init];
    siteIcon.image = [UIHelper imageName:@"news_sendNew_siteICon"];
    siteIcon.frame = CGRectMake(11.5, 16.25, 13, 17.5);
    [mySiteBtn addSubview:siteIcon];
    
    UILabel *siteLabel = [[UILabel alloc]init];
    siteLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    siteLabel.font = [UIFont systemFontOfSize:14];
    siteLabel.text = @"您的位置";
    siteLabel.frame = CGRectMake(33.5, 18, 200, 14);
    [mySiteBtn addSubview:siteLabel];
    
    UIImageView *siteAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-28.5-8, 18.25f, 8.0f, 13.5f)];
    [siteAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [mySiteBtn addSubview:siteAorrow];
//    [self addSubview:mySiteBtn];
    
    
    
    UIView *gapLineView4 = [[UIView alloc]init];
    gapLineView4.backgroundColor = [UIHelper colorWithHexString:@"#bac0c6"];
    gapLineView4.frame = CGRectMake(0, 424.5, ScreenWidth, 0.5);
//    [self addSubview:gapLineView4];
    
    
    
    //=======同步发送
    SynchronousSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SynchronousSendBtn.frame = CGRectMake(0, 425, ScreenWidth, 50);
    [SynchronousSendBtn addTarget:self action:@selector(SynchronousSendBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *sendIcon = [[UIImageView alloc]init];
    sendIcon.image = [UIHelper imageName:@"news_sendNew_sendICon"];
    sendIcon.frame = CGRectMake(11.5, 17.25, 15.5, 15.5);
    [SynchronousSendBtn addSubview:sendIcon];
    
    UILabel *sendLabel = [[UILabel alloc]init];
    sendLabel.textColor = [UIHelper colorWithHexString:@"#727f81"];
    sendLabel.font = [UIFont systemFontOfSize:14];
    sendLabel.text = @"同步发送";
    sendLabel.frame = CGRectMake(33.5, 18, 200, 14);
    [SynchronousSendBtn addSubview:sendLabel];
    
    UIImageView *sendAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-28.5-8, 18.25f, 8.0f, 13.5f)];
    [sendAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [SynchronousSendBtn addSubview:sendAorrow];
//    [self addSubview:SynchronousSendBtn];
    
    
    
    UIView *gapLineView5 = [[UIView alloc]init];
    gapLineView5.backgroundColor = [UIHelper colorWithHexString:@"#bac0c6"];
    gapLineView5.frame = CGRectMake(0, 475.5, ScreenWidth, 0.5);
//    [self addSubview:gapLineView5];

    
}

- (void)shoutSortBtnPressed{
    [delegate shoutSortClick];
}

- (void)siteBtnPressed{
    
    [delegate mySiteClick];
    
}

- (void)SynchronousSendBtnPressed{
    
    [delegate synSendClick];
}



#pragma mark -
#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    remaindLabel.text = @"";
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.25];
    //    [self.view setFrame:CGRectMake(0.0f, -85.0f, ScreenWidth, ScreenHeight)];
    //    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView
{
    myTextView.text =  textView.text;
    if (myTextView.text.length == 0) {
        remaindLabel.text = @"想对朋友说些什么呢?";
        wordsLabel.alpha = 1.0f;
        tempwordslabel.alpha = 0.0f;
    }else {
        remaindLabel.text = @"";
        wordsLabel.alpha = 0.0f;
        tempwordslabel.alpha = 1.0f;
        tempwordslabel.text = [NSString stringWithFormat:@"%d/120字",myTextView.text.length];
        int  signStringValue = [[tempwordslabel.text substringWithRange:NSMakeRange(0,3)]intValue];
        if(signStringValue >120){
//            tempwordslabel.text = [NSString stringWithFormat:@"%d/120字",120];
//            [Common showAlert:@"最多120个字！"];
            return;
        }

        if (myTextView.text.length >120) {
            [Common showAlert:@"字数不能超过120"];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if([text length]>0) {
        return [[textView text] length]<120;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    myTextView.text =  textView.text;
    if (textView.text.length == 0) {
        remaindLabel.text = @"想对朋友说些什么呢?";
        wordsLabel.alpha = 1.0f;
        tempwordslabel.alpha = 0.0f;
    }else{
        remaindLabel.text = @"";
        wordsLabel.alpha = 0.0f;
        tempwordslabel.alpha = 1.0f;
        tempwordslabel.text = [NSString stringWithFormat:@"%d/120字",myTextView.text.length];
        int  signStringValue = [[tempwordslabel.text substringWithRange:NSMakeRange(0,3)]intValue];
        if(signStringValue >120){
//            tempwordslabel.text = [NSString stringWithFormat:@"%d/120字",120];
            [Common showAlert:@"最多120个字！"];
            return;
        }
        
    }
}


//完成添加视频和图片的动作
- (void)endOfAddAction:(NSDictionary *)addData {
    NSString *type =[addData objectForKey:@"type"];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(8.0f, 33.0f, 72.0f, 72.0f)];
    button.layer.cornerRadius =5;
    button.clipsToBounds =YES;
    button.tag =count;
    
    if ([type isEqualToString:@"image"]) {
        UIImage *img =[addData objectForKey:@"image"];
        [button setImage:img forState:UIControlStateNormal];
    }else {
        UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectInset(button.bounds, 24.25f, 24.25f)];
        imgV.image =[UIHelper imageName:@"vedio_play"];
        imgV.userInteractionEnabled =YES;
        [button addSubview:imgV];
        [button setBackgroundImage:[UIHelper imageName:@"cacheImage"] forState:UIControlStateNormal];
    }
    [passPhotoView addSubview:button];
    count ++;
    passPhotoView.contentSize =CGSizeMake(passPhotoView.contentSize.width + 76, 123);
    [self animationWithEndAdd];
    
}


//添加完成的动画
- (void)animationWithEndAdd {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    for (int i =100; i<count-1; i++) {//int i =100; i<count-1; i++
        UIButton *button =(UIButton *)[passPhotoView viewWithTag:i];
        [button setFrame:CGRectMake(button.frame.origin.x+76, button.frame.origin.y, 72.0f, 72.0f)];
    }
    [UIView commitAnimations];
}

#pragma mark -
#pragma ADD BUTTON PRESSED
- (void)addBtnPressed:(id)sender {
    [delegate addBtnClick];
}



@end
