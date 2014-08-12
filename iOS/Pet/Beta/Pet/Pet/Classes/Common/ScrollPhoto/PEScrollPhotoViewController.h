//
//  PEScrollPhotoViewController.h
//  Pet
//
//  Created by Wu Evan on 7/11/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEScrollPhotoViewController : UIViewController <UIScrollViewDelegate, UIPageViewControllerDelegate>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic) int index;

@property (nonatomic, retain) UIScrollView *sv;
@property (nonatomic, retain) UIPageControl *pageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)dataArray index:(int)indexPath;

@end
