//
//  img.m
//  img
//
//  Created by Wu Evan on 8/5/14.
//  Copyright (c) 2014 PE. All rights reserved.
//

#import "img.h"

@implementation img

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
