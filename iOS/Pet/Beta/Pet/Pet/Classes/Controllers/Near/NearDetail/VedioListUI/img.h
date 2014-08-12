//
//  img.h
//  img
//
//  Created by Wu Evan on 8/5/14.
//  Copyright (c) 2014 PE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PEImageDelegate <NSObject>

@optional
- (void)vedioBtnClicked:(NSString *)url;

@end

@interface img : UIImageView

@property (nonatomic, retain) NSString *vedioUrl;

@property (nonatomic, assign) id<PEImageDelegate>delegate;
@end
