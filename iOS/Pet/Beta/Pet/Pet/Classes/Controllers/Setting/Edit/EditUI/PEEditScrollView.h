//
//  PEEditScrollView.h
//  Pet
//
//  Created by WuJunqiu on 14-8-3.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
@interface PEEditScrollView : UIScrollView

@property (nonatomic, retain) UIImageView * imageBg;

@property (nonatomic) BOOL isSingle;
@property (nonatomic , retain) NSArray *data;

- (id)initWithFrame:(CGRect)frame data:(NSArray *)dataArray AndType:(BOOL)single;
- (void)layout;
@end
