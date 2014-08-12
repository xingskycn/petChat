//
//  PEDisNewsViewTableCell.m
//  Pet
//
//  Created by WuJunqiu on 14-6-26.
//  Copyright (c) 2014年 Pet. All rights reserved.
//


#import "PEDisNewsViewTableCell.h"
#import "UIHelper.h"
#import "PENearDetailListView.h"
#import "PENetWorkingManager.h"

@implementation PEDisNewsViewTableCell

@synthesize cID;
@synthesize friendAvatarImageView,friendAvaterBtn,passPhotoImageView,passPhotoImageViewTwo,bgImageViewUp,bgImageViewCenter,bgImageViewDown;
@synthesize friendLineImageViewOne,friendLineImageViewTwo;
@synthesize friendNameLabel,signNameLabel,distanceLabel,timeLabel,markCountLabel,favCountLable;
@synthesize markButton,favButton;
@synthesize personBgImageView,personImageView,personImageShadowView;
@synthesize friendAgeLabel,friendSexImageView;
@synthesize newsCellButtonClickDelegate;
@synthesize pid;
@synthesize favImageView,markImageView;
@synthesize friendNameString,friendSignString,photosImageView;
@synthesize photosArray;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndData:(NSMutableArray *)dataArray AndString:(NSString *)signString
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        photosArray = [[NSMutableArray alloc]init];
        for(int i = 0;i<dataArray.count;i++){
            [photosArray addObject:[dataArray objectAtIndex:i]];
        }
        
        //1.好友头像
        friendAvatarImageView = [[UIImageView alloc]init];
        friendAvaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //2.好友名
        friendNameLabel = [[UILabel alloc]init];
        
        //3.好友年龄label
        friendAgeLabel = [[UILabel alloc]init];
        
        //4.好友性别图片:根据传进来的性别决定显示其图片
        friendSexImageView = [[UIImageView alloc]init];
        
        //5.个性签名：label之间相差8像素
        signNameLabel = [[UILabel alloc]init];
        //个性签名
        signNameLabel.text = signString;
        signNameLabel.font =[UIFont systemFontOfSize:14];
        signNameLabel.numberOfLines = 0;
        signNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize sizeSN = [signString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        signNameLabel.frame = CGRectMake(61, 31, 255, sizeSN.height);
        if(signString.length >=54){
            signNameLabel.frame = CGRectMake(61, 23, 255, sizeSN.height);
        }
        
        //6.上传的两个头像button
        passPhotoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        passPhotoImageViewTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //7.时间-距离上传的图片高度有20.5
        timeLabel = [[UILabel alloc]init];
        
        //10.点赞按钮视图，button,点赞数label
        favImageView = [[UIImageView alloc]init];
        favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favCountLable = [[UILabel alloc]init];
        
        //11.评论按钮视图，button，评论label
        markImageView = [[UIImageView alloc]init];
        markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        markCountLabel =[[UILabel alloc]init];
        
        //12.好友气泡上，中，下
        bgImageViewUp = [[UIImageView alloc]init];
        bgImageViewCenter = [[UIImageView alloc]init];
        bgImageViewDown = [[UIImageView alloc]init];
        
        //13.好友头像之间的连线视图1 2
        friendLineImageViewOne = [[UIImageView alloc]init];
        friendLineImageViewTwo = [[UIImageView alloc]init];
        
        friendNameString = [[NSString alloc]init];
        friendSignString = [[NSString alloc]init];
        
        friendAvatarImageView.frame = CGRectMake(5, 3, 34, 34);
        friendAvatarImageView.layer.cornerRadius =17.0f;
        friendAvatarImageView.clipsToBounds =YES;
        //20140809
        friendAvaterBtn.frame = CGRectMake(0, 0, 39, 39);
//        [friendAvaterBtn addTarget:self action:@selector(friendAvaterBtnPressed) forControlEvents:UIControlStateNormal];
        
        
        friendNameLabel.backgroundColor = [UIColor clearColor];
        friendNameLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
        friendNameLabel.textAlignment = NSTextAlignmentLeft;
        friendNameLabel.font = [UIFont systemFontOfSize:15.0];
        

        //个性签名
        signNameLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        signNameLabel.textAlignment = NSTextAlignmentLeft;
        signNameLabel.font = [UIFont systemFontOfSize:14.0];
        signNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        signNameLabel.numberOfLines = 0;
        
         passPhotoImageView.tag = 1-ButtonBaseTag;
//      [passPhotoImageView addTarget:self action:@selector(passPhotoButtonIsPressed:) forControlEvents:UIControlEventTouchUpInside];//7-28
  
//      passPhotoImageViewTwo.frame = CGRectMake(62.5+5+84,passPhotoY, 84, 84);
        passPhotoImageViewTwo.tag = 2-ButtonBaseTag;
//        [passPhotoImageViewTwo addTarget:self action:@selector(passPhotoButtonIsPressed:) forControlEvents:UIControlEventTouchUpInside];//7-28
        
        timeLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont systemFontOfSize:12.0];


        //点赞按钮视图
        favImageView.image = [UIHelper imageName:@"news_btn_favOne"];

        //点赞数
        favCountLable.backgroundColor = [UIColor clearColor];
        favCountLable.textColor = [UIHelper colorWithHexString:@"#d6d6d6"];
        favCountLable.textAlignment = NSTextAlignmentLeft;
        favCountLable.font = [UIFont systemFontOfSize:11.0];
    
        
        //评论视图
         markImageView.image = [UIHelper imageName:@"news_btn_markTwo"];
        
        //评论数
        markCountLabel.backgroundColor = [UIColor clearColor];
        markCountLabel.textColor = [UIHelper colorWithHexString:@"#d6d6d6"];
        markCountLabel.textAlignment = NSTextAlignmentLeft;
        markCountLabel.font = [UIFont systemFontOfSize:11.0];
        
        
        
        //封装界面的bg:好友动态气泡向上
        UIImage *bgImageUp = [UIHelper imageName:@"news_bgImageUp"];
        bgImageViewUp.image = bgImageUp;
        //整个cell的高度
        bgImageViewUp.frame = CGRectMake(43, 0, 267+5, 36.5);
        
        //气泡中
        UIImage *bgImageCenter = [UIHelper imageName:@"news_bgImageCentre"];
        bgImageViewCenter.image = bgImageCenter;
        bgImageViewCenter.frame = CGRectMake(43, 24.5, 267+5, 25);
        
        //气泡下
        UIImage *bgImageDown = [UIHelper imageName:@"news_bgImageDown"];
        bgImageViewDown.image = bgImageDown;
        
        
        
        //好友头像连线连接1
        UIImage *lineImage = [UIImage imageNamed:@"news_friendLine"];
        friendLineImageViewOne.backgroundColor = [UIHelper colorWithHexString:@"#cae6ef"];//whiteColor显示白色线条
        friendLineImageViewOne.image = lineImage;
        
        //好友头像连线连接2
        friendLineImageViewTwo.backgroundColor = [UIHelper colorWithHexString:@"#cae6ef"];
        friendLineImageViewTwo.image = lineImage;
        friendLineImageViewTwo.frame = CGRectMake(43/2, 0, 0.5, 3);
        
        [self addSubview:friendLineImageViewOne];
        [self addSubview:friendLineImageViewTwo];
        [self addSubview:bgImageViewUp];
        [self addSubview:bgImageViewCenter];
        [self addSubview:bgImageViewDown];
        [self addSubview:friendAvatarImageView];
        [self addSubview:friendAvaterBtn];
        [self addSubview:friendNameLabel];
        [self addSubview:friendAgeLabel];
        [self addSubview:friendSexImageView];
        [self addSubview:signNameLabel];
        [self addSubview:passPhotoImageView];
        [self addSubview:passPhotoImageViewTwo];
        [self addSubview:timeLabel];
        [self addSubview:favCountLable];
        [self addSubview:markCountLabel];
        [self addSubview:favImageView];
        [self addSubview:favButton];
        [self addSubview:markImageView];
        [self addSubview:markButton];

        
        int h = photosArray.count;
        //显示的图片
        if(h >=2)
        {

            for(int i = 0;i< h;i++)
            {
                int m = i/3;//行数,从1开始
                int n = i%3;//该行有多少个
                
                NSString *imageString = [photosArray objectAtIndex:i];
                photosImageView = [[PEUIImageView alloc]init];
                photosImageView.frame = CGRectMake(62.5+83*n, 40.5+sizeSN.height+83*m, 78, 78);//62.5
                if([imageString hasSuffix:@".jpg"]){
                    photosImageView.vedioUrl = @"";
                    [photosImageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIHelper imageName:@""]];
                }else{
                    photosImageView.vedioUrl = imageString;
//                    photosImageView.image = [UIHelper imageName:@"Video_test"];
                    photosImageView.image = [Common getVideoPreViewImage:imageString];
                    UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectInset(photosImageView.bounds, 24.25f, 24.25f)];
                    imgV.image =[UIHelper imageName:@"vedio_play"];
                    imgV.userInteractionEnabled =YES;
                    [photosImageView addSubview:imgV];
                     photosImageView.delegate = self;
                }
                
               
                [self addSubview:photosImageView];
           
            }
            
            int j = (h+1)/3;
            
            timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+78*j+20.5, 70, 15);
            favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+78*j+20.5,14, 12);
            favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+78*j+20.5-12, 46.5, 38);
            favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+78*j+20.5-1, 33, 12.5);
            markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+78*j+20.5, 14, 12.5);
            markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+78*j+20.5-12, 50, 38);
            markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+78*j+20.5-1, 33, 12.5);
            bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+78*j+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
            friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+78*j+20.5+12+7-36+10.5);
            
        }
        else if (h == 1)
        {
            
            NSString *imageString = [photosArray objectAtIndex:0];
            photosImageView = [[PEUIImageView alloc]init];
            photosImageView.frame = CGRectMake(62.5, 40.5+sizeSN.height, 78, 78);
            if([imageString hasSuffix:@".jpg"]){
                photosImageView.vedioUrl = @"";
                [photosImageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIHelper imageName:@""]];
            }else{
                photosImageView.vedioUrl = imageString;
                UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectInset(photosImageView.bounds, 24.25f, 24.25f)];
                imgV.image =[UIHelper imageName:@"vedio_play"];
                imgV.userInteractionEnabled =YES;
                [photosImageView addSubview:imgV];
//                 photosImageView.image = [UIHelper imageName:@"Video_test"];
                photosImageView.image = [Common getVideoPreViewImage:imageString];
                
                 photosImageView.delegate = self;
            }
            
            [self addSubview:photosImageView];
            
            timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+78+20.5, 70, 15);
            favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+78+20.5,14, 12);
            favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+78+20.5-12, 46.5, 38);
            favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+78+20.5-1, 33, 12.5);
            markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+78+20.5, 14, 12.5);
            markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+78+20.5-12, 50, 38);
            markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+78+20.5-1, 33, 12.5);
            bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+78+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
            friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+78+20.5+12+7-36+10.5);

        }
        else if (h == 0){
            
            //没有图片的时候，所有控件的高度减小84
            NSLog(@"当前数组长度为空");
            timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+20.5, 70, 15);
            favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+20.5,14, 12);
            favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+20.5-12, 46.5, 38);
            favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+20.5-1, 33, 12.5);
            markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+20.5, 14, 12.5);
            markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+20.5-12, 50, 38);
            markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+20.5-1, 33, 12.5);
            bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
            friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+20.5+12+7-36+10.5);
        }

    }
    return self;
}




//当有回复消息时，背景白色图和连线都会拉长
-(void)setBackgroundImagViewHeight:(float)height
{
    float f = height - 49;
    bgImageViewDown.frame = CGRectMake(43, 49, 267+5, f+4);//175.5-49
    friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, height-36+10.5);
    
}


//设置名字，年龄，性别相关显示控件的位置-----------无回复消息时
-(void)setNameAndAgeLocatonWith:(NSString *)nameString Sign:(NSString *)signString AndAgreeStatus:(NSString *)agreeStatus AndArray:(NSMutableArray *)imageListArray
{
    
    friendNameLabel.text = nameString;
    CGSize sizeFN = [friendNameLabel.text  sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    [friendNameLabel setFrame:CGRectMake(58, 5.0,200, 18)];//16.0
    
//    //个性签名
//    signNameLabel.text = signString;
//    CGSize sizeSN = [signString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
//    signNameLabel.frame = CGRectMake(61, 31, 255, sizeSN.height);
//    
//    NSLog(@"当前个性签名的高度为:%f",sizeSN.height);
    //int n = imageListArray.count%2;
//    int m = (imageListArray.count+1)/2;//行数取出来了
//    if(imageListArray.count >=2)
//    {
//       for(int j = 0;j<m;j++)
//        {
//             for(int k = 0;k<2;k++)
//            {
//               NSString *imageString = [imageListArray objectAtIndex:k+j*2];
//               photosImageView = [[UIImageView alloc]init];
//               photosImageView.frame = CGRectMake(62.5+5*k, 40.5+sizeSN.height+84*j, 84, 84);
//               [photosImageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIHelper imageName:@""]];
//               [self addSubview:photosImageView];
//            }
//        }
//        float h = 84*m;
//        
//        timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+h+20.5, 70, 15);
//        favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+h+20.5,14, 12);
//        favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+h+20.5-12, 46.5, 38);
//        favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+h+20.5-1, 33, 12.5);
//        markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+h+20.5, 14, 12.5);
//        markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+h+20.5-12, 50, 38);
//        markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+h+20.5-1, 33, 12.5);
//        bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+h+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
//        friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+h+20.5+12+7-36+10.5);
//        
//     
//    }else if (imageListArray.count == 1){
//        NSString *imageString = [imageListArray objectAtIndex:0];
//        photosImageView = [[UIImageView alloc]init];
//        photosImageView.frame = CGRectMake(62.5, 40.5+sizeSN.height, 84, 84);
//        [photosImageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIHelper imageName:@""]];
//        [self addSubview:photosImageView];
//        
////        passPhotoImageView.frame = CGRectMake(62.5,31+sizeSN.height+9.5, 84, 84);
////        passPhotoImageViewTwo.frame = CGRectMake(62.5+5+84,31+sizeSN.height+9.5, 84, 84);
//        timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+84+20.5, 70, 15);
//        favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+84+20.5,14, 12);
//        favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+84+20.5-12, 46.5, 38);
//        favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+84+20.5-1, 33, 12.5);
//        markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+84+20.5, 14, 12.5);
//        markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+84+20.5-12, 50, 38);
//        markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+84+20.5-1, 33, 12.5);
//        bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+84+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
//        friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+84+20.5+12+7-36+10.5);
//        
//    }else{//数组为空,直接把图片的位置顶掉
//        
////        passPhotoImageView.frame = CGRectMake(62.5,31+sizeSN.height+9.5, 84, 84);
////        passPhotoImageViewTwo.frame = CGRectMake(62.5+5+84,31+sizeSN.height+9.5, 84, 84);
//        timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+20.5, 70, 15);
//        favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+20.5,14, 12);
//        favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+20.5-12, 46.5, 38);
//        favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+20.5-1, 33, 12.5);
//        markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+20.5, 14, 12.5);
//        markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+20.5-12, 50, 38);
//        markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+20.5-1, 33, 12.5);
//        bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
//        friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+20.5+12+7-36+10.5);
//        
//  
//    }
//    passPhotoImageView.frame = CGRectMake(62.5,31+sizeSN.height+9.5, 84, 84);
//    passPhotoImageViewTwo.frame = CGRectMake(62.5+5+84,31+sizeSN.height+9.5, 84, 84);
//    timeLabel.frame = CGRectMake(62,  31+sizeSN.height+9.5+84+20.5, 70, 15);
//    favImageView.frame = CGRectMake(227, 31+sizeSN.height+9.5+84+20.5,14, 12);
//    favButton.frame = CGRectMake(205, 31+sizeSN.height+9.5+84+20.5-12, 46.5, 38);
//    favCountLable.Frame = CGRectMake(245, 31+sizeSN.height+9.5+84+20.5-1, 33, 12.5);
//    markImageView.frame = CGRectMake(274, 31+sizeSN.height+9.5+84+20.5, 14, 12.5);
//    markButton.frame = CGRectMake(256.5,  31+sizeSN.height+9.5+84+20.5-12, 50, 38);
//    markCountLabel.Frame = CGRectMake(293, 31+sizeSN.height+9.5+84+20.5-1, 33, 12.5);
//    bgImageViewDown.frame = CGRectMake(43, 49, 267+5, 31+sizeSN.height+9.5+84+20.5+12+7-49+4);//175.5-49 白色背景向下拉长
//    friendLineImageViewOne.frame = CGRectMake(43/2, 36, 0.5, 31+sizeSN.height+9.5+84+20.5+12+7-36+10.5);
    if([agreeStatus isEqualToString:@"0"]){
        favImageView.image = [UIHelper imageName:@"news_btn_favTwo"];
    }else{
        
        favImageView.image = [UIHelper imageName:@"news_btn_favOne"];
    }
}



#pragma mark  - buttonIsPressed
- (void)passPhotoButtonIsPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag +ButtonBaseTag;
    int dex = cID;
    //交出委托事件
    [self.newsCellButtonClickDelegate newsCellButtonClick:i Section:dex];
    NSLog(@"交出委托事件，当前点击的图片索引：%ld",i);
}

- (void)vedioBtnClicked:(NSString *)url{
    
    [newsCellButtonClickDelegate newsPlayVideoClick:url];
}



- (void)awakeFromNib{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
