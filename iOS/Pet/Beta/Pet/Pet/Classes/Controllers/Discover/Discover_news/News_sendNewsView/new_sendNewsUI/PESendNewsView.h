//
//  PESendNewsView.h
//  Pet
//
//  Created by WuJunqiu on 14-7-31.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendNewsDelegate <NSObject>

- (void)shoutSortClick;
- (void)mySiteClick;
- (void)synSendClick;
- (void)addBtnClick;

@end


@interface PESendNewsView : UIView<UITextViewDelegate>

@property int count;
@property(nonatomic,retain)UITextView *myTextView;
@property(nonatomic,retain)UILabel *wordsLabel;
@property(nonatomic,retain)UILabel *tempwordslabel;
@property(nonatomic,retain)UILabel *remaindLabel;
@property(nonatomic,retain)UIButton *shoutSortBtn;
@property(nonatomic,retain)UILabel *shoutLabel;
@property(nonatomic,retain)UIButton *mySiteBtn;
@property(nonatomic,retain)UIButton *SynchronousSendBtn;
@property(nonatomic,retain)UIScrollView *passPhotoView;

@property(nonatomic,assign)id<SendNewsDelegate>delegate;

- (void)endOfAddAction:(NSDictionary *)addData;
@end
