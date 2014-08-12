//
//  PEFaceView.h
//  Pet
//
//  Created by Wu Evan on 7/28/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDeleaget <NSObject>

@optional
- (void)didSortButton:(UIButton *)sender;
- (void)didFaceButton:(UIButton *)sender;

- (void)didDeleteButton:(UIButton *)sender;
- (void)didSendButton:(UIButton *)sender;
@end

@interface PEFaceView : UIView

@property (nonatomic, retain) UIView *face1;
@property (nonatomic, retain) UIView *face2;
@property (nonatomic, retain) UIView *face3;
@property (nonatomic, retain) UIView *face4;
@property (nonatomic, retain) UIView *face5;

@property (nonatomic, assign) id<FaceViewDeleaget> faceViewDelegate;

@end
