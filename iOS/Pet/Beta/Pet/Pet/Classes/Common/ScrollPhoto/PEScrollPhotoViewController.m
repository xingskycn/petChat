//
//  PEScrollPhotoViewController.m
//  Pet
//
//  Created by Wu Evan on 7/11/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEScrollPhotoViewController.h"
#import "PENetWorkingManager.h"
#import "UIHelper.h"

@interface PEScrollPhotoViewController ()

@end

@implementation PEScrollPhotoViewController

@synthesize data;
@synthesize index;
@synthesize sv, pageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)dataArray index:(int)indexPath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data =[[NSArray alloc] initWithArray:dataArray];
        index =indexPath;
        
        sv =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 120.0f, 320.0f, 320.0f)];
        pageController =[[UIPageControl alloc]initWithFrame:CGRectMake(0.0f, 460.0f, 320.0f, 10.0f)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    for (int i =0; i<data.count; i++) {
        NSURL *url =[NSURL URLWithString:data[i]];
        UIImageView *imgV =[[UIImageView alloc] initWithFrame:CGRectMake(320.0f *i, 0.0f, 320.0f, 320.0f)];
        [imgV setImageWithURL:url];
        [sv addSubview:imgV];
    }
    [sv setContentSize:CGSizeMake(320.0 *data.count, 320.0f -64)];
    sv.pagingEnabled =YES;
    sv.showsHorizontalScrollIndicator =NO;
    sv.showsVerticalScrollIndicator =NO;
    sv.contentOffset =CGPointMake((index-1) * 320, 0.0f);
    sv.delegate =self;
    
    pageController.numberOfPages =data.count;
    pageController.currentPage =index-1;
    
    [self.view addSubview:sv];
    [self.view addSubview:pageController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = floor((sv.contentOffset.x - 320.0f / 2) / 320.0f) + 1;
    pageController.currentPage = page;
}

@end
