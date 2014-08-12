//
//  PEDisGroupCellOne.h
//  Pet
//
//  Created by WuJunqiu on 14-6-30.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDisGroupCellOne : UITableViewCell
{
    UIImageView *iconImageView;
    UILabel *groupNameLabel;
    UIImageView *distanceImageView;
    UILabel *distanceLable;
    UIImageView *arrowImageView;
    UIImageView *lineImageView;
    UIImageView *bgImageView;//选中时背景
}

@property(nonatomic,retain)UIImageView *iconImageView;
@property(nonatomic,retain)UILabel *groupNameLabel;
@property(nonatomic,retain)UIImageView *distanceImageView;
@property(nonatomic,retain)UILabel *distanceLable;
@property(nonatomic,retain)UIImageView *arrowImageView;
@property(nonatomic,retain)UIImageView *lineImageView;
@property(nonatomic,retain)UIImageView *bgImageView;
//改变
- (void)changeArrowWithUp:(BOOL)up;
@end
