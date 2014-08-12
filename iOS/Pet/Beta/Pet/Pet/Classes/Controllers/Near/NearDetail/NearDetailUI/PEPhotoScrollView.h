//
//  PEPhotoScrollView.h
//  Pet
//
//  Created by Evan Wu on 6/12/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@interface PEPhotoScrollView : UIScrollView

@property (nonatomic, retain) UIImageView * imageBg;

@property (nonatomic) BOOL isSingle;
@property (nonatomic , retain) NSArray *data;

- (id)initWithFrame:(CGRect)frame data:(NSArray *)dataArray AndType:(BOOL)single;
- (void)layout;
@end
