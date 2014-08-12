//
//  PEEditOtherView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PEOtherDelegate <NSObject>

- (void)didMoreBtn:(UIButton *)sender;
- (void)didChangeBtn:(UIButton *)sender;

@end

@interface PEEditOtherView : UIView

@property(nonatomic,assign)id<PEOtherDelegate> delegate;

@property(nonatomic,retain)UILabel *moreLabel;
@property(nonatomic,retain)UILabel *connectLabel;
@property(nonatomic,retain)UILabel *changePwdLbl;
@property(nonatomic,retain)UILabel *otherlabel;
@property(nonatomic,retain)UILabel *moreInfoLabel;
@property(nonatomic,retain)UIImageView *iconImageView1;
@property(nonatomic,retain)UIImageView *iconImageView2;
@property(nonatomic,retain)UIImageView *otherLineImageView;
@property(nonatomic,retain)UIImageView *otherLineImageCircle;
@property(nonatomic,retain)UIButton *moreBtn;
@property(nonatomic,retain)UIButton *changeBtn;

@end
