//
//  PESearchViewController.m
//  Pet
//
//  Created by Wu Evan on 7/14/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PESearchViewController.h"

@interface PESearchViewController ()

@end

@implementation PESearchViewController

@synthesize searchText;
@synthesize kindText, sortText, distanceText;
@synthesize cloudView, hotData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=self.title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    
    self.pickerArray = [[NSArray alloc] init];
    self.midArray = [[NSArray alloc] init];
    self.subArray = [[NSArray alloc] init];
    
    
    self.data =[[NSArray alloc] init];
    self.subData =[[NSArray alloc] init];
    
    
    self.selectPicker.delegate = self;
    self.selectPicker.dataSource = self;
    self.subPicker.delegate =self;
    self.subPicker.dataSource =self;
    
    [self setupUI];
    
    //数据请求---获取宠物种类和品种
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    [[PENetWorkingManager sharedClient] fliterDataDataRequest:appInfo completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            self.data =[results objectForKey:REQUEST_FLITER_DATA];
        }else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *detailBg =[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 251.0f)];
    UIImage *detailBgImage =[UIHelper setImageFromColor:[UIColor whiteColor]];
    [detailBg setImage:detailBgImage];
    [detailBg setAlpha:0.5f];
    
    //群搜索
    UILabel *searchLbl =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 85.0f, 300.0f, 15.0f)];
    searchLbl.textColor =[UIHelper colorWithHexString:@"#727f81"];
    searchLbl.text =NSLocalizedString(SEARCH_GROUP_SEARCH, nil);
    searchLbl.font =[UIFont systemFontOfSize:15.0f];
    
    //群搜索框
    UIImageView *searchTextBg =[[UIImageView alloc]initWithFrame:CGRectMake(23.0f, 112.0f, 274.0f, 34.0f)];
    [searchTextBg setImage:[UIHelper imageName:@"search_text_bg"]];
    searchTextBg.userInteractionEnabled =YES;
    searchText =[[UITextField alloc] initWithFrame:CGRectMake(16.5f, 0.0f, 241.0f, 34.0f)];
    searchText.textColor =[UIColor blackColor];
    searchText.font =[UIFont systemFontOfSize:15.0f];
    UIColor *color = [UIHelper colorWithHexString:@"#a3a3a3"];
    searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入群组名称或群号进行搜索"
                                                                       attributes:@{NSForegroundColorAttributeName: color}
                                        ];
    searchText.delegate = self;
    [searchTextBg addSubview:searchText];
    
    //群搜索分隔线
    UIImageView *searchLine =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 158.0f, 300.0f, 1.0f)];
    [searchLine setImage:[UIHelper imageName:@"search_line"]];
    
    //分类搜索
    UILabel *sortLbl =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 170.0f, 300.0f, 15.0f)];
    sortLbl.textColor =[UIHelper colorWithHexString:@"#727f81"];
    sortLbl.text =NSLocalizedString(SEARCH_SORT_SEARCH, nil);
    sortLbl.font =[UIFont systemFontOfSize:15.0f];
    
    //分类搜索框
    UIImageView *kindTextBg =[[UIImageView alloc] initWithFrame:CGRectMake(23.0f, 197.0f, 129.0f, 34.0f)];
    [kindTextBg setImage:[UIHelper imageName:@"search_sort_text_bg"]];
    kindTextBg.userInteractionEnabled =YES;
    
    kindText =[[UITextField alloc] initWithFrame:CGRectInset(kindTextBg.bounds, 11.5, 0.0f)];
    kindText.tag =501;
    kindText.font =[UIFont systemFontOfSize:15.0f];
    kindText.text = @"全部";
    kindText.delegate =self;
    kindText.inputView =self.selectPicker;
    kindText.inputAccessoryView =self.doneToolbar;
    
    UIImageView *kindArrow =[[UIImageView alloc] initWithFrame:CGRectMake(117.5f, 15.0f, 7.5f, 4.0f)];
    [kindArrow setImage:[UIHelper imageName:@"search_arrow_down"]];
    
    UIImageView *sortTextBg =[[UIImageView alloc] initWithFrame:CGRectMake(168.0f, 197.0f, 129.0f, 34.0f)];
    [sortTextBg setImage:[UIHelper imageName:@"search_sort_text_bg"]];
    sortTextBg.userInteractionEnabled =YES;
    sortText =[[UITextField alloc] initWithFrame:CGRectInset(sortTextBg.bounds, 11.5, 0.0f)];
    sortText.tag =502;
    sortText.font =[UIFont systemFontOfSize:15.0f];
    sortText.text = @"全部";
    sortText.delegate =self;
    sortText.inputView =self.subPicker;
    sortText.inputAccessoryView =self.doneToolbar;
    
    UIImageView *sortArrow =[[UIImageView alloc] initWithFrame:CGRectMake(117.5f, 15.0f, 7.5f, 4.0f)];
    [sortArrow setImage:[UIHelper imageName:@"search_arrow_down"]];
    
    //短分隔线
    UIImageView *shoutLine =[[UIImageView alloc] initWithFrame:CGRectMake(155.5f, 214.0f, 9.0f, 1.0f)];
    [shoutLine setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#b9c1c4"]]];
    
    //分类搜索分隔线
    UIImageView *sortLine =[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 242.0f, 300.0f, 1.0f)];
    [sortLine setImage:[UIHelper imageName:@"search_line"]];
    
    //范围搜索
    UILabel *distanceLbl =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 254.0f, 300.0f, 15.0f)];
    distanceLbl.textColor =[UIHelper colorWithHexString:@"#727f81"];
    distanceLbl.text =NSLocalizedString(SEARCH_DISTANCE_SEARCH, nil);
    distanceLbl.font =[UIFont systemFontOfSize:15.0f];
    
    //范围搜索框
    UIImageView *distanceTextBg =[[UIImageView alloc] initWithFrame:CGRectMake(23.0f, 281.0f, 129.0f, 34.0f)];
    [distanceTextBg setImage:[UIHelper imageName:@"search_sort_text_bg"]];
    distanceTextBg.userInteractionEnabled =YES;
    distanceText =[[UITextField alloc] initWithFrame:CGRectInset(distanceTextBg.bounds, 11.5, 0.0f)];
    distanceText.tag =401;
    distanceText.font =[UIFont systemFontOfSize:15.0f];
    distanceText.text = @"全部";
    distanceText.delegate =self;
    distanceText.inputView =self.selectPicker;
    distanceText.inputAccessoryView =self.doneToolbar;
    UIImageView *distanceArrow =[[UIImageView alloc] initWithFrame:CGRectMake(117.5f, 15.0f, 7.5f, 4.0f)];
    [distanceArrow setImage:[UIHelper imageName:@"search_arrow_down"]];
    
    //热门推荐
    UILabel *hotLbl =[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 336.0f, 300.0f, 15.0f)];
    hotLbl.textColor =[UIHelper colorWithHexString:@"#727f81"];
    hotLbl.text =NSLocalizedString(SEARCH_HOT_SEARCH, nil);
    hotLbl.font =[UIFont systemFontOfSize:15.0f];
    
    //热门搜索背景
    UIImageView *hotBg =[[UIImageView alloc] initWithFrame:CGRectMake(54.25f, 314.0f, 210.5f, 210.5f)];
    [hotBg setImage:[UIHelper imageName:@"search_cloud"]];
    hotBg.userInteractionEnabled =YES;
    
    hotData =@[@"哈士奇",
                        @"博美犬",
                        @"波斯猫",
                        @"萨摩耶",
                        @"古牧",
                        @"雪纳瑞",
                        @"白兔",
                        @"西施犬",
                        @"哈士奇",
                        @"西施犬"
                        ];
//
//    //热门搜索标签云
//    sphereView = [[PFSphereView alloc] initWithFrame:CGRectInset(hotBg.frame, 10.0f, 10.0f)];
//    sphereView.center=CGPointMake(self.view.center.x, 419.25f);
//	NSMutableArray *views = [[NSMutableArray alloc] init];
//	for (int i = 0; i < hotData.count; i++) {
//		UIButton *subV = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *name =hotData[i];
//        [subV setFrame:CGRectMake(0.0f, 0.0f, 80.0f, 24.0f)];
//        [subV setTitle:name forState:UIControlStateNormal];
//        [subV.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
//        [subV setTitleColor:[UIColor colorWithRed:(arc4random_uniform(50)+25)/100.
//                                            green:(arc4random_uniform(50)+25)/100.
//                                             blue:(arc4random_uniform(50)+25)/100.
//                                            alpha:1]
//                   forState:UIControlStateNormal];
//        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
//        [views addObject:subV];
//        [subV release];
//	}
//    
//	[sphereView setItems:views];
//    
//	[views release];
//    sphereView.isPanTimerStart=YES;
//    [sphereView timerStart];
    
    
    cloudView = [[RTagCloudView alloc] initWithFrame:CGRectInset(hotBg.frame, 10.0f, 10.0f)];
    cloudView.backgroundColor = [UIColor clearColor];
    cloudView.center = CGPointMake(self.view.center.x, 419.25f);
    cloudView.dataSource = self;
    cloudView.delegate = self;
    
    //添加button
    UIButton *okBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake(10.0f, 513.5f, 300.0f, 43.0f)];
    [okBtn setBackgroundImage:[UIHelper imageName:@"search_ok_btn"] forState:UIControlStateNormal];
    [okBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [okBtn addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加view
    [self.view addSubview:hotLbl];
    [self.view addSubview:hotBg];
    [self.view addSubview:cloudView];
    [self.view addSubview:detailBg];
    
    [self.view addSubview:searchLbl];
    [self.view addSubview:searchTextBg];
    [self.view addSubview:searchLine];
    
    
    [self.view addSubview:sortLbl];
    [self.view addSubview:sortLine];
    
    [kindTextBg addSubview:kindText];
    [sortTextBg addSubview:sortText];
    [kindTextBg addSubview:kindArrow];
    [sortTextBg addSubview:sortArrow];
    [self.view addSubview:kindTextBg];
    [self.view addSubview:sortTextBg];
    [self.view addSubview:shoutLine];
    
//    [distanceTextBg addSubview:distanceText];20140809
    [distanceTextBg addSubview:distanceArrow];
//    [self.view addSubview:distanceLbl]; 20140809
//    [self.view addSubview:distanceTextBg]; 20140809
    
    [self.view addSubview:okBtn];
}



#pragma mark - 
#pragma mark BUTTON ACTION

- (IBAction)doneBtnPressed:(id)sender {
    [kindText endEditing:YES];
    [sortText endEditing:YES];
    [distanceText endEditing:YES];
}

//开始搜索按钮点击事件
- (void)okBtnPressed:(id)sender {
    if (searchText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_GROUP_ID];
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_GROUP_NAME];
    } else {//正则表达式判断输入的是否是纯数字
        if ([Common regexer:searchText.text rx_matchesPattern:@"^[0-9]*$"]) {
            [[NSUserDefaults standardUserDefaults] setObject:searchText.text forKey:SEARCH_GROUP_ID];
            [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_GROUP_NAME];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:searchText.text forKey:SEARCH_GROUP_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_GROUP_ID];
        }
    }
    
    if (kindText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_KIND];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:kindText.text forKey:SEARCH_KIND];
    }
    
    if (sortText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_SORT];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:sortText.text forKey:SEARCH_SORT];
    }
    
    if (distanceText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:SEARCH_DISTANCE];
    } else {
        
        NSString *distanceString = distanceText.text;
        NSString *tempString = [distanceString substringToIndex:distanceString.length-2];
        [[NSUserDefaults standardUserDefaults] setObject:tempString forKey:SEARCH_DISTANCE];//distanceText.text
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_FINISHED object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark -textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSMutableArray *pickArr=[[NSMutableArray alloc]init];
    NSMutableArray *pickMidArr=[[NSMutableArray alloc]init];
    self.type =textField.tag;
    switch (textField.tag) {
        case 401:
            [pickArr addObject:@"0.5公里"];
            [pickArr addObject:@"1公里"];
            [pickArr addObject:@"2公里"];
            [pickArr addObject:@"5公里"];
            [pickArr addObject:@"10公里"];
            [pickArr addObject:@"50公里"];
            [pickArr addObject:@"100公里"];
            [pickArr addObject:@"不限"];
            
            self.pickerArray =pickArr;
            [self.selectPicker reloadAllComponents];
            break;
        case 501:
            for (int i =0; i<self.data.count; i++) {
                NSString *kind =[self.data[i] objectForKey:FLITER_SORT_NAME];
                [pickArr addObject:kind];
            }
            self.pickerArray =pickArr;
            [self.selectPicker reloadAllComponents];
            break;
        case 502:
            if (self.isMiddle) {
                //                for (int i =0; i <self.subData.count; i++) {
                //                    NSDictionary *midDict =[self.subData objectAtIndex:i];
                //                    [pickMidArr addObject:[midDict objectForKey:FLITER_SORT_MID_NAME]];
                //                }
                self.midArray =self.subData;
            } else {
                [pickMidArr addObject:@"全部"];
                self.midArray =pickMidArr;
            }
            //            self.midArray =[midDict objectForKey:FLITER_SORT_MID_NAME];
            
            if (!self.isMiddle) {
                self.subArray =self.subData;
            }else {
                self.subArray =[[self.midArray objectAtIndex:0] objectForKey:FLITER_SORT_SUB_LIST];
            }
            [self.subPicker reloadAllComponents];
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [searchText resignFirstResponder];
}

#pragma mark - pickerController setting

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView ==self.selectPicker) {
        return 1;
    } else {
        return 2;
    }
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView ==self.selectPicker) {
        return [self.pickerArray count];
    } else {
        if (component ==0) {
            return [self.midArray count];
        } else {
            return [self.subArray count];
        }
        
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView ==self.selectPicker) {
        return [NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
    }else {
        if (component ==0) {
            if (self.isMiddle) {
                return [[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_MID_NAME];
            } else {
                return [self.midArray objectAtIndex:row];
            }
        }else {
            return [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
        }
        
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView ==self.selectPicker) {
        switch (self.type) {
            case 401:
                distanceText.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 501:
                kindText.text =[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_NAME]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
                [self subSortRequest:row];
                break;
            case 502:
                sortText.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
                
            default:
                break;
        }
    } else {
        switch (self.type) {
            case 501:
                kindText.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
                [self subSortRequest:row];
                break;
            case 502:
                if (component ==0) {
                    if (self.isMiddle) {
                        self.subArray =[[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_SUB_LIST];
                    }
                    [self.subPicker reloadAllComponents];
                }else {
                    if (kindText.text.length !=0) {
                        
                        sortText.text =[[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_SUBTYPE];
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

- (void)subSortRequest:(int)row {
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *sortDict =@{@"sortID":[NSString stringWithFormat:@"%d", row +1]};
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:sortDict forKey:FLITER_SORT_INFO];
    
    [[PENetWorkingManager sharedClient] fliterSubDataRequest:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            if ([results objectForKey:REQUEST_FLITER_SUB_DATA]) {
                self.subData =[results objectForKey:REQUEST_FLITER_SUB_DATA];
                self.isMiddle =YES;
            } else {
                self.subData =[results objectForKey:REQUEST_FLITER_DATA];
                self.isMiddle =NO;
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - RTagCloudViewDatasource
- (NSInteger)numberOfTags:(RTagCloudView *)tagCloud
{
    return hotData.count;
}

- (NSString*)RTagCloudView:(RTagCloudView *)tagCloud
            tagNameOfIndex:(NSInteger)index
{
    return hotData[index];
}

- (UIFont*)RTagCloudView:(RTagCloudView *)tagCloud
          tagFontOfIndex:(NSInteger)index
{
    UIFont *fonts[] = {
        [UIFont systemFontOfSize:14.f],
        [UIFont systemFontOfSize:16.f],
        [UIFont systemFontOfSize:18.f],
        [UIFont systemFontOfSize:20.f],
    };
    return fonts[index%4];
}

- (UIColor*)RTagCloudView:(RTagCloudView *)tagCloud tagColorOfIndex:(NSInteger)index
{
    return [UIColor colorWithRed:(arc4random_uniform(50)+25)/100.
                           green:(arc4random_uniform(50)+25)/100.
                            blue:(arc4random_uniform(50)+25)/100.
                           alpha:1];
}

#pragma mark - RTagCloudViewDelegate

- (void)RTagCloudView:(RTagCloudView*)tagCloud didTapOnTagOfIndex:(NSInteger)index
{
    NSLog(@"我选中的是%@", hotData[index]);
//    searchText.text = hotData[index];
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *hot =@{@"hotName": hotData[index]};
    
    NSMutableDictionary *request =[NSMutableDictionary dictionaryWithDictionary:appInfo];
    [request setObject:hot forKey:@"filtersInfo"];
    
    [[PENetWorkingManager sharedClient] searchGetDetailWithHot:request completion:^(NSDictionary *results, NSError *error) {
        if (results) {
            NSLog(@"%@", results);
            kindText.text =[results objectForKey:@"name"];
            sortText.text =[results objectForKey:@"subName"];
            [[NSUserDefaults standardUserDefaults] setObject:[results objectForKey:@"type"] forKey:FLITER_TYPE];
            [[NSUserDefaults standardUserDefaults] setObject:[results objectForKey:@"subType"] forKey:FLITER_SUBTYPE];
        }else {
            
        }
    }];
}
@end
