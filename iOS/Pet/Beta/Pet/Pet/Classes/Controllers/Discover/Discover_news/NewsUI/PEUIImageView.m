//
//  PEUIImageView.m
//  Pet
//
//  Created by WuJunqiu on 14-8-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PEUIImageView.h"

@implementation PEUIImageView
@synthesize vedioUrl;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        vedioUrl =[[NSString alloc] init];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVedio:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTouchesRequired:1];
        
        
    }
    return self;
}

- (void)playVedio:(UITapGestureRecognizer *)gesture {
    [delegate vedioBtnClicked:vedioUrl];
}



@end
