////
//  PENearViewController.m
//  Pet
//
//  Created by Wuzhiyong on 5/26/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//


#import "PENearViewController.h"

#import "PENearViewTableCell.h"
#import "PENearViewWaterCell.h"

#import "PENearDetailViewController.h"
#import "PEFliterViewController.h"

#import <SIAlertView.h>

@interface PENearViewController ()

@end

@implementation PENearViewController

@synthesize fliterView;
@synthesize nearViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fliterSuccDone) name:FLITER_SUCC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fliterBtnPressed:) name:DID_FLITER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeType:) name:DID_TYPEDBTN object:nil];
    
    //check database
    PEFMDBManager *manager =[PEFMDBManager sharedManager];
    manager.peFMDBDelegate =self;
    [manager selectAllDataFromNearTable];
    
    //添加筛选页面
    fliterView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    
    UIImageView *fliterBg =[[UIImageView alloc] initWithFrame:CGRectInset(fliterView.frame, 0.0f, 0.0f)];
    [fliterBg setImage:[self setImageFromColor:[UIColor blackColor]]];
    fliterBg.alpha =0.8f;
    
    UIImageView *centerView =[[UIImageView alloc] initWithFrame:CGRectMake(43.5f, 128.0f, 233.0f, 235.0f)];
    UIImage *centerImg =[UIHelper imageName:@"fliter_alert_bg"];
    [centerImg stretchableImageWithLeftCapWidth:centerImg.size.width/2 topCapHeight:centerImg.size.height/2];
    [centerView setImage:centerImg];
    centerView.alpha =0.9f;
    centerView.userInteractionEnabled =YES;
    
    UILabel *fliterTitle =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 50.0f, 35.0f)];
    [fliterTitle setFont:[UIFont systemFontOfSize:15.0f]];
    [fliterTitle setTextColor:[UIColor darkGrayColor]];
    fliterTitle.text =NSLocalizedString(NEAR_FLITER_TITLE, nil);
    
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(fliterClosePressed:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIHelper imageName:@"fliter_close"] forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(203.0f, 5.0f, 25.0f, 25.0f)];
    
    
    UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 35.0f, 233.0f, 1.0f)];
    [lineView setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#d0cfcf"]]];
    
    UIButton *allBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn addTarget:self action:@selector(fliterAllPressed:) forControlEvents:UIControlEventTouchUpInside];
    [allBtn setTitle:NSLocalizedString(NEAR_FLITER_ALL, nil) forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor colorWithRed:73.0/255.0 green:158.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [allBtn setFrame:CGRectMake(0.0f, 35.0f, 233.0f, 50.0f)];
    
    UIImageView *lineView2 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 85.0f, 233.0f, 1.0f)];
    [lineView2 setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#d0cfcf"]]];
    
    UIButton *maleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [maleBtn addTarget:self action:@selector(fliterMalePressed:) forControlEvents:UIControlEventTouchUpInside];
    [maleBtn setTitle:NSLocalizedString(NEAR_FLITER_ONLY_MALE, nil) forState:UIControlStateNormal];
    [maleBtn setTitleColor:[UIColor colorWithRed:73.0/255.0 green:158.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [maleBtn setFrame:CGRectMake(0.0f, 85.0f, 233.0f, 50.0f)];
    
    UIImageView *lineView3 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 135.0f, 233.0f, 1.0f)];
    [lineView3 setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#d0cfcf"]]];
    
    UIButton *femaleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [femaleBtn addTarget:self action:@selector(fliterFemalePressed:) forControlEvents:UIControlEventTouchUpInside];
    [femaleBtn setTitle:NSLocalizedString(NEAR_FLITER_ONLY_FEMALE, nil) forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor colorWithRed:73.0/255.0 green:158.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [femaleBtn setFrame:CGRectMake(0.0f, 135.0f, 233.0f, 50.0f)];
    
    UIImageView *lineView4 =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 185.0f, 233.0f, 1.0f)];
    [lineView4 setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#d0cfcf"]]];
    
    UIButton *customBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn addTarget:self action:@selector(fliterCustomPressed
                                               :) forControlEvents:UIControlEventTouchUpInside];
    [customBtn setTitle:NSLocalizedString(NEAR_FLITER_ONLY_CUSTOM, nil) forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor colorWithRed:73.0/255.0 green:158.0/255.0 blue:215.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [customBtn setFrame:CGRectMake(0.0f, 185.0f, 233.0f, 50.0f)];
    
    
    [centerView addSubview:fliterTitle];
    [centerView addSubview:closeBtn];
    [centerView addSubview:lineView];
    [centerView addSubview:lineView2];
    [centerView addSubview:lineView3];
    [centerView addSubview:lineView4];
    [centerView addSubview:allBtn];
    [centerView addSubview:maleBtn];
    [centerView addSubview:femaleBtn];
    [centerView addSubview:customBtn];
    
    [fliterView addSubview:fliterBg];
    [fliterView addSubview:centerView];
    
    [self.view addSubview:fliterView];
    [fliterView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADD WATER & TABLE VIEW
- (void)addDataView {
    
    self.myTable =[[PENearTableView alloc]initWithFrame:CGRectMake(0.0f, 64.5f, ScreenWidth, ScreenHeight -64.5 -49) AndData:_tableData];
    _myTable.tag =201;
    _myTable.backgroundColor =[UIColor clearColor];
    _myTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    _myTable.nearTableViewDelegate =self;
    
    
    self.myWater = [[PENearTMQuiltView alloc] initWithFrame:CGRectMake(0.0f, 64.5f, ScreenWidth, ScreenHeight -64.5 -49) AndData:_tableData];
    _myWater.tag =202;
    _myWater.nearWaterViewDelegate =self;
	
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    
    //添加类型按钮
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST]) {
        
        [self.view addSubview:_myWater];
        [self.view addSubview:bgV];
        [self.view addSubview:_myTable];
    } else {
        
        [self.view addSubview:_myTable];
        [self.view addSubview:bgV];
        [self.view addSubview:_myWater];
    }
    [_myWater reloadData];
    [_myTable reloadData];
}

#pragma mark - BUTTON ACTION
- (void)fliterBtnPressed:(id)sender {
    [fliterView setHidden:NO];
//    
//    SIAlertView *fliterAlert =[[SIAlertView alloc]initWithTitle:NSLocalizedString(NEAR_FLITER_TITLE, nil) andMessage:nil];
//    
//    [fliterAlert setTitleColor:[UIColor darkGrayColor]];
//    
//    [fliterAlert addButtonWithTitle:NSLocalizedString(NEAR_FLITER_ALL, nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//        [_myTable setDataInTable:FLITER_ALL];
//        [_myWater setDataInTable:FLITER_ALL];
//    }];
//    [fliterAlert addButtonWithTitle:NSLocalizedString(NEAR_FLITER_ONLY_MALE, nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//        [_myTable setDataInTable:FLITER_MALE];
//        [_myWater setDataInTable:FLITER_MALE];
//    }];
//    [fliterAlert addButtonWithTitle:NSLocalizedString(NEAR_FLITER_ONLY_FEMALE, nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//        [_myTable setDataInTable:FLITER_FEMALE];
//        [_myWater setDataInTable:FLITER_FEMALE];
//    }];
//    [fliterAlert addButtonWithTitle:NSLocalizedString(NEAR_FLITER_ONLY_CUSTOM, nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//        PEFliterViewController *flCtr =[[PEFliterViewController alloc]init];
//        [self.navigationController presentViewController:flCtr animated:YES completion:nil];
//    }];
//    [fliterAlert addButtonWithTitle:NSLocalizedString(CANCEL_TITLE, nil) type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
//        [alertView dismissAnimated:YES];
//    }];
//    
//    [fliterAlert show];
}

- (void)fliterClosePressed:(id)sender {
    [fliterView setHidden:YES];
}

- (void)fliterAllPressed:(id)sender {
    [fliterView setHidden:YES];
    [_myTable setDataInTable:FLITER_ALL];
    [_myWater setDataInTable:FLITER_ALL];
}

- (void)fliterMalePressed:(id)sender {
    [fliterView setHidden:YES];
    [_myTable setDataInTable:FLITER_MALE];
    [_myWater setDataInTable:FLITER_MALE];
}

- (void)fliterFemalePressed:(id)sender {
    [fliterView setHidden:YES];
    [_myTable setDataInTable:FLITER_FEMALE];
    [_myWater setDataInTable:FLITER_FEMALE];
}

- (void)fliterCustomPressed:(id)sender {
    [fliterView setHidden:YES];
//    [nearViewDelegate fliterBtnClick];
    
    PEFliterViewController *fCtr =[[PEFliterViewController alloc] init];
    [self.navigationController presentViewController:fCtr animated:YES completion:nil];
}

- (void)fliterSuccDone {
    [_myTable setDataInTable:FLITER_CUSTOM];
    [_myWater setDataInTable:FLITER_CUSTOM];
}



- (void)changeType:(id)sender {
    BOOL type =![[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST];
    [[NSUserDefaults standardUserDefaults] setBool:type forKey:IS_LIST];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LIST]) {
        [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:0];
        
    } else {
        [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:0];
    }
    [nearViewDelegate didTypedBtn];
}

#pragma mark -
#pragma WATERVIEW DELEGATE & TABLEVIEW DELEGATE

- (void)didSelectTable:(NSDictionary *)data {
    
    PENearDetailViewController *ndCtr =[[PENearDetailViewController alloc] initWithNibName:@"PENearDetailViewController" bundle:nil];
    ndCtr.title =[data objectForKey:DB_COLUMN_NEAR_USERNAME];
    ndCtr.petID =[data objectForKey:DB_COLUMN_NEAR_PETID];
    ndCtr.ownerID =[data objectForKey:DB_COLUMN_NEAR_USERID];
    [[self navigationController] pushViewController:ndCtr animated:YES];
}

- (void)didSelectWater:(NSDictionary *)dict {
    
    PENearDetailViewController *ndCtr =[[PENearDetailViewController alloc] initWithNibName:@"PENearDetailViewController" bundle:nil];
    ndCtr.title =[dict objectForKey:DB_COLUMN_NEAR_USERNAME];
    ndCtr.petID =[dict objectForKey:DB_COLUMN_NEAR_PETID];
    ndCtr.ownerID =[dict objectForKey:DB_COLUMN_NEAR_USERID];
    [[self navigationController] pushViewController:ndCtr animated:YES];
    
}

#pragma mark -
#pragma SELECT FROM NEAR TABLE DELEGATE

- (void)selectNearDataSucc:(NSArray *)data {
    
    //setting data
    self.tableData = [[NSMutableArray alloc]init];
    for (int i =0; i < data.count; i ++) {
        [_tableData addObject:data[i]];
    }
    
    [self addDataView];
}

#pragma matk -
#pragma mark CUSTOM PICTURE
//纯色图片
- (UIImage *)setImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
