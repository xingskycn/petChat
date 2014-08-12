//
//  PEUIImageView.h
//  Pet
//
//  Created by WuJunqiu on 14-8-6.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PEImageDelegate <NSObject>

@optional
- (void)vedioBtnClicked:(NSString *)url;

@end
@interface PEUIImageView : UIImageView

@property (nonatomic, retain) NSString *vedioUrl;

@property (nonatomic, assign) id<PEImageDelegate>delegate;

@end
