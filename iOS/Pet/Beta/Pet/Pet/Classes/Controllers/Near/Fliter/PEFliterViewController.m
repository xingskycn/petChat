
//
//  PEFliterViewController.m
//  Pet
//
//  Created by Wu Evan on 6/18/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PEFliterViewController.h"
#import "UIHelper.h"
#import "PENetWorkingManager.h"
#import "PeModel.h"
@interface PEFliterViewController ()

@end

@implementation PEFliterViewController
@synthesize vipLbl,timeLbl,petSexLbl,petSortLbl, forwardLbl;
@synthesize sexAllBtn,sexMaleBtn,sexFemaleBtn;
@synthesize forwardAllBtn, forwardMarrayBtn, forwardAdeptBtn, forwardSaveBtn;
@synthesize time15mBtn,time2dBtn,time1dBtn,time1hBtn;
@synthesize sortText;
@synthesize petAgeLbl,ownerAgeLbl,ownerSexLbl,ownerStarLbl;
@synthesize petAgeDetail;
@synthesize ownerMaleBtn,ownerFemaleBtn;
@synthesize gapLineView,gapLineImageView;
@synthesize vipView;
@synthesize fliterViewDelegate;
 
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
    
    //scrollView
    if (IS_IPhone_5) {
        [self.sv setFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight-64)];
    } else {
        [self.sv setFrame:CGRectMake(0.0f, 150.0f, ScreenWidth, ScreenHeight-64)];
    }
    [self.sv setContentSize:CGSizeMake( ScreenWidth, 580.0f)];
    
    self.pickerArray = [[NSArray alloc] init];
    self.midArray = [[NSArray alloc] init];
    self.subArray = [[NSArray alloc] init];
    
    self.data =[[NSArray alloc] init];
    self.subData =[[NSArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //宠物年龄
    self.petAgeDetail.inputView = self.selectPicker;
    self.petAgeDetail.inputAccessoryView = self.doneToolbar;
    self.petAgeDetail.font =[UIFont systemFontOfSize:14];
    self.petAgeDetail.placeholder =@"不限";
    self.petAgeDetail.textColor = [UIHelper colorWithHexString:@"#89837f"];
    self.petAgeDetail.delegate =self;
    
    
    self.selectPicker.delegate = self;
    self.selectPicker.dataSource = self;
    self.subPicker.delegate =self;
    self.subPicker.dataSource =self;
    
    //宠物种类
    self.KindText.inputView = self.selectPicker;
    self.KindText.font = [UIFont systemFontOfSize:14];
    self.KindText.textColor = [UIHelper colorWithHexString:@"#000000"];
    self.KindText.placeholder = @"全部";
    self.KindText.inputAccessoryView = self.doneToolbar;
    self.KindText.delegate = self;
    
    
    self.sortText.inputView = self.subPicker;
    self.KindText.font = [UIFont systemFontOfSize:14];
    self.KindText.textColor = [UIHelper colorWithHexString:@"#000000"];
    self.sortText.placeholder = @"全部";
    self.sortText.inputAccessoryView = self.doneToolbar;
    self.sortText.delegate = self;
    
    
    self.ownerAgeDetail.inputView = self.selectPicker;
    self.ownerAgeDetail.font =[UIFont systemFontOfSize:14];
    self.ownerAgeDetail.placeholder =@"不限";
    self.ownerAgeDetail.textColor = [UIHelper colorWithHexString:@"#89837f"];
    self.ownerAgeDetail.inputAccessoryView = self.doneToolbar;
    self.ownerAgeDetail.delegate = self;
    
    self.ownerStarDetail.inputView = self.selectPicker;
    self.ownerStarDetail.font =[UIFont systemFontOfSize:14];
    self.ownerStarDetail.placeholder =@"不限";
    self.ownerStarDetail.textColor = [UIHelper colorWithHexString:@"#89837f"];
    self.ownerStarDetail.inputAccessoryView = self.doneToolbar;
    self.ownerStarDetail.delegate = self;
    
    //调整字体的大小和RGB
    //1.会员专有选项
    vipLbl.textColor = [UIHelper colorWithHexString:@"#748183"];
    vipLbl.font = [UIFont systemFontOfSize:14.5];
    
    
    vipView = [[UIImageView alloc]init];
    vipView.frame = CGRectMake(0, 355, 320, 160);
    vipView.backgroundColor = [UIColor clearColor];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:IS_LOGINED];
    
    //20140809
    self.ownerStarLbl.hidden = YES;
    
    
    //2.出现的时间
    timeLbl.textColor = [UIHelper colorWithHexString:@"#748183"];
    timeLbl.font = [UIFont systemFontOfSize:14.5];
    
    forwardLbl.font = [UIFont systemFontOfSize:14.5];
    forwardLbl.textColor = [UIHelper colorWithHexString:@"#748183"];
    
    //3.想看到的宠物性别,种类
    petSexLbl.textColor = [UIHelper colorWithHexString:@"#748183"];
    petSexLbl.font = [UIFont systemFontOfSize:14.5];
    petSortLbl.textColor = [UIHelper colorWithHexString:@"#748183"];
    petSortLbl.font = [UIFont systemFontOfSize:14.5];
    
    
    //4.全部，男，女button
    sexAllBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    sexAllBtn.selected = YES;//7-28
    sexAllBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    sexMaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    sexMaleBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    sexFemaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    sexFemaleBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    forwardAllBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardAllBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    forwardAllBtn.selected = YES;//7-28
    
    forwardMarrayBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardMarrayBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    forwardAdeptBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardAdeptBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    forwardSaveBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardSaveBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    //5.出现的时间 15，1，1，3
    time15mBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    time15mBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    time1dBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    time1dBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    time1hBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    time1hBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    time2dBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    time2dBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    time2dBtn.selected = YES;
    
    
    //6.狗 阿拉斯加
    sortText.font = [UIFont systemFontOfSize:14];
    sortText.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    //7.宠物年龄，主人性别，主人年龄，主人星座
    petAgeLbl.font = [UIFont systemFontOfSize:14];
    petAgeLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    ownerSexLbl.font = [UIFont systemFontOfSize:14];
    ownerSexLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    ownerAgeLbl.font = [UIFont systemFontOfSize:14];
    ownerAgeLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    ownerStarLbl.font = [UIFont systemFontOfSize:14];
    ownerStarLbl.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    //8.主人性别--男女
    ownerMaleBtn.font = [UIFont systemFontOfSize:14];
    ownerMaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    ownerFemaleBtn.font = [UIFont systemFontOfSize:14];
    ownerFemaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    
    
    gapLineImageView.frame = CGRectMake(157, 70, 5, 0.5);
    gapLineImageView.backgroundColor = [UIHelper colorWithHexString:@"#b0bec2"];
    
    //20140809 去掉了主人星座
    ownerStarLbl.hidden = YES;
    
    
    if(!isLogin){
        vipView.hidden = NO;
        vipView.userInteractionEnabled = YES;
        petAgeLbl.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        ownerSexLbl.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        ownerAgeLbl.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        ownerStarLbl.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        petAgeDetail.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        self.ownerAgeDetail.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        self.ownerStarDetail.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        self.ownerMaleIcon.image = [UIHelper imageName:@"fliter_maleIcon"];
        self.ownerFemaleIcon.image = [UIHelper imageName:@"fliter_fmaleIcon"];
        
        self.petAgeArrowView.image = [UIHelper imageName:@"fliter_arrowUnLogin"];
        self.ownerAgeArrowView.image = [UIHelper imageName:@"fliter_arrowUnLogin"];
        self.ownerStarArrowView.image = [UIHelper imageName:@"fliter_arrowUnLogin"];
        
        [ownerMaleBtn setBackgroundImage:[UIHelper imageName:@"fliter_ownerMaleBtn"] forState:UIControlStateNormal];
        [self.ownerFemaleBtn setBackgroundImage:[UIHelper imageName:@"fliter_ownerMaleBtn"] forState:UIControlStateNormal];
        
        ownerMaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        ownerFemaleBtn.titleLabel.textColor = [UIHelper colorWithHexString:@"#a0a0a0"];
        ownerMaleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    
    [self.view addSubview:self.sv];
    [self.sv addSubview:vipView];
    
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

#pragma mark - BUTTON ACTION

- (IBAction)petSexBtnPressed:(id)sender {
    UIButton *button =(UIButton *)sender;
    
    switch (button.tag) {
        case 101:
            self.sexAllBtn.selected =YES;
            self.sexMaleBtn.selected =NO;
            self.sexFemaleBtn.selected =NO;
            break;
        case 102:
            self.sexAllBtn.selected =NO;
            self.sexMaleBtn.selected =YES;
            self.sexFemaleBtn.selected =NO;
            break;
        case 103:
            self.sexAllBtn.selected =NO;
            self.sexMaleBtn.selected =NO;
            self.sexFemaleBtn.selected =YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)forwardBtnPressed:(id)sender {
    UIButton *button =(UIButton *)sender;
    
    switch (button.tag) {
        case 100:
            self.forwardAllBtn.selected =YES;
            self.forwardMarrayBtn.selected =NO;
            self.forwardAdeptBtn.selected =NO;
            self.forwardSaveBtn.selected =NO;
            break;
        case 101:
            self.forwardAllBtn.selected =NO;
            self.forwardMarrayBtn.selected =YES;
            self.forwardAdeptBtn.selected =NO;
            self.forwardSaveBtn.selected =NO;
            break;
        case 102:
            self.forwardAllBtn.selected =NO;
            self.forwardMarrayBtn.selected =NO;
            self.forwardAdeptBtn.selected =YES;
            self.forwardSaveBtn.selected =NO;
            break;
        case 103:
            self.forwardAllBtn.selected =NO;
            self.forwardMarrayBtn.selected =NO;
            self.forwardAdeptBtn.selected =NO;
            self.forwardSaveBtn.selected =YES;
            break;
            
        default:
            break;
    }

}

- (IBAction)timeBtnPressed:(id)sender {
    UIButton *button =(UIButton *)sender;
    
    switch (button.tag) {
        case 201:
            self.time15mBtn.selected =YES;
            self.time1hBtn.selected =NO;
            self.time1dBtn.selected =NO;
            self.time2dBtn.selected =NO;
            break;
        case 202:
            self.time15mBtn.selected =NO;
            self.time1hBtn.selected =YES;
            self.time1dBtn.selected =NO;
            self.time2dBtn.selected =NO;
            break;
        case 203:
            self.time15mBtn.selected =NO;
            self.time1hBtn.selected =NO;
            self.time1dBtn.selected =YES;
            self.time2dBtn.selected =NO;
            break;
        case 204:
            self.time15mBtn.selected =NO;
            self.time1hBtn.selected =NO;
            self.time1dBtn.selected =NO;
            self.time2dBtn.selected =YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)ownerSexBtnPressed:(id)sender {
    UIButton *button =(UIButton *)sender;
    switch (button.tag) {
        case 301:
            ownerMaleBtn.selected =YES;
            self.ownerFemaleBtn.selected =NO;
            break;
        case 302:
            ownerMaleBtn.selected =NO;
            self.ownerFemaleBtn.selected =YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)sureBtnPressed:(id)sender {
    if (self.KindText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_TYPE];
    }
    
    if (self.sortText.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_SUBTYPE];
    }
    
    if (self.sexFemaleBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"母" forKey:FLITER_PETSEX];
    }else if (self.sexMaleBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"公" forKey:FLITER_PETSEX];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_PETSEX];
    }
    
    if (self.time15mBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_TIME_15M forKey:FLITER_PETTIME];
    }else if (self.time1dBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_TIME_1D forKey:FLITER_PETTIME];
    }else if (self.time1hBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_TIME_1H forKey:FLITER_PETTIME];
    }else if (self.time2dBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_TIME_3D forKey:FLITER_PETTIME];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_PETTIME];
    }
    
    if (self.forwardMarrayBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_WANT_MARRY forKey:FLITER_WANT_TYPE];
    }else if (self.forwardAdeptBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_WANT_ADEPT forKey:FLITER_WANT_TYPE];
    }else if (self.forwardSaveBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:FLITER_WANT_SAVE forKey:FLITER_WANT_TYPE];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_WANT_TYPE];
    }
    
    if (self.petAgeDetail.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_PETAGE];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.petAgeDetail.text forKey:FLITER_PETAGE];
    }
    
    if (self.ownerAgeDetail.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_USERAGE];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.ownerAgeDetail.text forKey:FLITER_USERAGE];
    }
    
    if (ownerMaleBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"男士" forKey:FLITER_USERSEX];
    }else if (self.ownerFemaleBtn.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:@"女士" forKey:FLITER_USERSEX];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_USERSEX];
    }
    
    if (self.ownerStarDetail.text.length ==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不限" forKey:FLITER_USERSTAR];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.ownerStarDetail.text forKey:FLITER_USERSTAR];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FLITER_SUCC object:nil];
    
    [self.petAgeDetail endEditing:YES];
    [self.ownerAgeDetail endEditing:YES];
    [self.ownerStarDetail endEditing:YES];
    [self.KindText endEditing:YES];
    [self.sortText endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)doneBtnPressed:(id)sender {
    [self.petAgeDetail endEditing:YES];
    [self.ownerAgeDetail endEditing:YES];
    [self.ownerStarDetail endEditing:YES];
    [self.KindText endEditing:YES];
    [self.sortText endEditing:YES];
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self.petAgeDetail endEditing:YES];
    [self.ownerAgeDetail endEditing:YES];
    [self.ownerStarDetail endEditing:YES];
    [self.KindText endEditing:YES];
    [self.sortText endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSMutableArray *pickArr=[[NSMutableArray alloc]init];
    NSMutableArray *pickMidArr=[[NSMutableArray alloc]init];
    self.type =textField.tag;
    switch (textField.tag) {
        case 401:
            for (int i =1; i<=100; i++) {
                [pickArr addObject:[NSNumber numberWithInt:i]];
            }
            self.pickerArray =pickArr;
            [self.selectPicker reloadAllComponents];
            break;
        case 402://20140809 i<100
            for (int i =1; i<=100; i++) {
                [pickArr addObject:[NSNumber numberWithInt:i]];
            }
            self.pickerArray =pickArr;
            [self.selectPicker reloadAllComponents];
            break;
        case 403:
            [pickArr addObject:@"水瓶座"];
            [pickArr addObject:@"双鱼座"];
            [pickArr addObject:@"白羊座"];
            [pickArr addObject:@"金牛座"];
            [pickArr addObject:@"双子座"];
            [pickArr addObject:@"巨蟹座"];
            [pickArr addObject:@"狮子座"];
            [pickArr addObject:@"处女座"];
            [pickArr addObject:@"天秤座"];
            [pickArr addObject:@"天蝎座"];
            [pickArr addObject:@"射手座"];
            [pickArr addObject:@"摩羯座"];
            
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
                self.petAgeDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 402:
                self.ownerAgeDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 403:
                self.ownerStarDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 501:
                self.KindText.text =[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_NAME]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
                [self subSortRequest:row];
                break;
            case 502:
                self.sortText.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
                
            default:
                break;
        }
    } else {
        switch (self.type) {
            case 401:
                self.petAgeDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 402:
                self.ownerAgeDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 403:
                self.ownerStarDetail.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                break;
            case 501:
                self.KindText.text =[NSString stringWithFormat:@"%@", [self.pickerArray objectAtIndex:row]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[self.data objectAtIndex:row] objectForKey:FLITER_SORT_ID]] forKey:FLITER_TYPE];
                [self subSortRequest:row];
                break;
            case 502:
                if (component ==0) {
                    if (self.isMiddle) {
                         self.subArray =[[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_SUB_LIST];
                    }
                    [self.subPicker reloadAllComponents];
                }else {if(self.KindText.text.length !=0 && self.subArray.count >0){
                     self.sortText.text =[[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
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

@end
