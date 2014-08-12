//
//  PEEditPhotoScrollView.h
//  Pet
//
//  Created by Wu Evan on 7/5/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PEEditScrollerDelegate <NSObject>

@optional
/// 添加图片委托
- (void)addBtnSelected;
- (void)deleteImage:(NSString *)petImageID;
@end

@interface PEEditPhotoScrollView : UIScrollView

@property (nonatomic ,retain) NSArray *data;
@property (nonatomic,retain) NSArray *getIdArray;
@property (nonatomic, retain) UILabel *changeImageLabel;

@property (nonatomic, assign) id<PEEditScrollerDelegate> esDelegate;

- (id)initWithFrame:(CGRect)frame AndData:(NSArray *)dataArray AndImageIDData:(NSArray *)imageIDArray;

- (void)layoutByData;
@end
