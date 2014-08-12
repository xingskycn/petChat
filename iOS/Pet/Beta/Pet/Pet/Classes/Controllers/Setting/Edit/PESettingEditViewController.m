//
//  PESettingEditViewController.m
//  Pet
//
//  Created by Wu Evan on 7/4/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PESettingEditViewController.h"
#import "PESettingEditTableCellOne.h"
#import "PESettingEditTableCellTwo.h"
#import "PEMobile.h"
#import "PENetWorkingManager.h"
#import "PEEditDetailViewController.h"
#import "PEEditChangePwdViewController.h"
#import "PELoginViewController.h"
#import "Animations.h"
@interface PESettingEditViewController ()

@end

@implementation PESettingEditViewController
{
    int tag;
}

@synthesize editPetInfo, isDatePicked;
@synthesize grouptableView,sortArray,isOpen,selectIndex;
@synthesize topView, petIcon, ownerIcon,lineView;
@synthesize sv;
@synthesize photoSV, ownerV;
@synthesize petNameLabel,ownerNameLabel,changeImageLabel;
@synthesize actionView,addNewPetButton;
@synthesize addNewPetLabel,otherView;
@synthesize infoLineImageView,spaceView;
@synthesize dataArray,dataDic;
@synthesize userName,petSexString,petWantedTypeString;
@synthesize infomationDetailArray;
@synthesize datePicker,doneToolbar,selectSection,currentTag,exitBtn;
@synthesize sheet,arr,passPhotoArray,petImageIDString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sortArray =[[NSMutableArray alloc]init]; // Custom initialization
        dataArray = [[NSMutableArray alloc]init];
        dataDic = [[NSDictionary alloc]init];
        passPhotoArray = [[NSMutableArray alloc]init];
        infomationDetailArray = [[NSMutableArray alloc]init];
        arr = [[NSMutableArray alloc]init];
        
        editPetInfo =[[NSDictionary alloc] init];
        isDatePicked =NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //loginSuccess Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveBtnPressed:) name:DID_SAVE object:nil];
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"near_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(EDIT_INFOMATION_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem =nil;
    self.navigationItem.rightBarButtonItem =nil;
    
    
    //设置back按钮 by wu
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
   
    tag = 0;
    petSexString = @"母";
    petWantedTypeString = @"3";
    
    
    
    //时间选择的最大值为今天
    //最小值1914
    NSString *tempAgeString =@"19140101";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    //将字符串转化成NSDate类型
    NSDate *tempAgeDate =[formatter dateFromString:tempAgeString];
    NSDate *date = [NSDate date];
    datePicker.maximumDate = date;
    datePicker.minimumDate = tempAgeDate;
    
    sheet =[[UIActionSheet alloc]initWithTitle:nil
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                             otherButtonTitles:@"现在拍摄照片", @"选取已有的", nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUSerName:) name:@"changeUserNameSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUSerSign:) name:@"changeUserSignSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUSerDescription:) name:@"changeUserMoreInfoSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:@"UpdateData" object:nil];
    [self setupUI];//数据联调成功，创建UI
    
}

//刷新数据
 - (void)requestData{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGINED]) {
        self.navigationController.navigationBarHidden = NO;
        //        [self request];
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:appInfo];
        [[PENetWorkingManager sharedClient]getEditInfoList:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
//                NSLog(@"%@",results);
                NSArray *data = [results objectForKey:@"petsList"];
                dataDic = nil;
                dataDic = [[NSMutableDictionary alloc]init];
                dataArray = nil;
                dataArray = [[NSMutableArray alloc]init];
                
                infomationDetailArray = nil;
                infomationDetailArray = [[NSMutableArray alloc]init];
                
                dataDic = results;
                for(int i = 0;i < data.count; i++)
                {
                    [dataArray addObject:data[i]];//数组存放的是字典
                }
                
                for (int i =0; i <data.count; i++) {
                    [sortArray addObject:[NSString stringWithFormat:@"宠物%d", i+1]];
                }
                
                [self setupData];
                [grouptableView reloadData];
                
                //========第二个区域第1行默认是展开的
                if (!isOpen) {
                    [self tableView:grouptableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else {
        PELoginViewController *lCtr =[[PELoginViewController alloc] init];
        [self.navigationController pushViewController:lCtr animated:YES];
    }
    
}

#pragma mark - 
#pragma mark NSNotificationCenter
//用户名修改成功
- (void)changeUSerName:(NSNotification *)note{
    
    [self requestData];
}

//用户签名修改成功
- (void)changeUSerSign:(NSNotification *)note{
    
    ownerV.signDetail.text = [note object];
}

- (void)changeUSerDescription:(NSNotification *)note {
    
    otherView.moreInfoLabel.text = [note object];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)setupData {
    
    [petIcon setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:EDIT_INFO_PETIMAGE_URL]] placeholderImage:[UIHelper imageName:@"nearDetail_icon_bg"]];
    [ownerIcon setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:EDIT_INFO_USERIMAGE_URL]] placeholderImage:[UIHelper imageName:@"nearDetail_icon_bg"]];
    //    NSArray *temp = [dataDic objectForKey:EDIT_INFO_PETIMAGELIST];
    NSArray*photoArray = [[dataArray objectAtIndex:0]objectForKey:EDIT_INFO_PETIMAGELIST];
    NSMutableArray *photoIdArray = [[NSMutableArray alloc]init];
    [arr removeAllObjects];
    [photoIdArray removeAllObjects];
    for(int i=0;i<photoArray.count;i++){
        [arr addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETOTHERIMAGEURL]];
        [photoIdArray addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETOTHERIMAGEID]];
    }
    photoSV  =nil;
    photoSV =[[PEEditPhotoScrollView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, ScreenWidth, 97.0f) AndData:arr AndImageIDData:photoIdArray];
    photoSV.tag =909;
    [photoSV layoutByData];
    photoSV.esDelegate= self;
    
    //    photoSV =[[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, 320.0f, 97.0f) data:arr AndType:YES];
    [sv addSubview:photoSV];
    
    ownerV.nameDetail.text = [dataDic objectForKey:EDIT_INFO_USERNAME];
    ownerV.signDetail.text= [dataDic objectForKey:EDIT_INFO_USER_SIGN];
    NSString *userAgeString= [dataDic objectForKey:EDIT_INFO_USER_BIRTHDAY];
    NSDate * date=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    int year=[conponent year];//取系统的时间
    int age =year - [[userAgeString substringWithRange:NSMakeRange(0, 4)] intValue];//取返回值的前四个字符
    ownerV.ageTextField.text = [NSString stringWithFormat:@"%d岁",age];
    
    //星座应该随月份的更改而更改，显示走网络 分割2014-02-08
    NSArray *ageStringArray = [userAgeString componentsSeparatedByString:@"-"];
    if(ageStringArray.count ==3)
    {
//        NSLog(@"===============%d",ageStringArray.count);
        int month = [[ageStringArray objectAtIndex:1]intValue];
        int day =[[ageStringArray objectAtIndex:2]intValue];
        if((month ==1 && day>=20) || (month==2 &&day<=18)){
            ownerV.starDetail.text = @"水瓶座";
        }else if ((month ==2 && day>=19) || (month == 3 &&day<=20)){
            ownerV.starDetail.text = @"双鱼座";
        }else if ((month == 3 &&day>=21) || (month ==4 &&day<=19)){
            ownerV.starDetail.text = @"白羊座";
        }else if ((month == 4 &&day>=20) || (month ==5 &&day<=20)){
            ownerV.starDetail.text = @"金牛座";
        }else if ((month == 5 &&day>=21) || (month ==6 &&day<=21)){
            ownerV.starDetail.text = @"双子座";
        }else if ((month == 6 &&day>=22) || (month ==7 &&day<=22)){
            ownerV.starDetail.text = @"巨蟹座";
        }else if ((month == 7 &&day>=23) || (month ==8 &&day<=22)){
            ownerV.starDetail.text = @"狮子座";
        }else if ((month == 8 &&day>=23) || (month ==9 &&day<=22)){
            ownerV.starDetail.text = @"处女座";
        }else if ((month == 9 &&day>=23) || (month ==10 &&day<=23)){
            ownerV.starDetail.text = @"天秤座";
        }else if ((month == 10 &&day>=24) || (month ==11 &&day<=22)){
            ownerV.starDetail.text = @"天蝎座";
        }else if ((month == 11 &&day>=23) || (month ==12 &&day<=21)){
            ownerV.starDetail.text = @"射手座";
        }else if ((month == 12 &&day>=22) || (month ==1 &&day<=19)){
            ownerV.starDetail.text = @"魔蝎座";
        }
    }
    else{
        ownerV.starDetail.text = @"魔蝎座";
    }
    
    
    NSString *nameDetail = [dataDic objectForKey:EDIT_INFO_USERNAME];
    NSString *signDetail = [dataDic objectForKey:EDIT_INFO_USER_SIGN];
    NSString *moreDetail = [dataDic objectForKey:EDIT_INFO_USER_DESCRIPTION];
    
    if (moreDetail.length >0) {
        otherView.moreInfoLabel.text =moreDetail;
    }else {
        otherView.moreInfoLabel.text =@"";
    }
    
    [infomationDetailArray addObject:nameDetail];
    [infomationDetailArray addObject:signDetail];
    [infomationDetailArray addObject:moreDetail];
}

#pragma mark - 
#pragma mark PEScrollerDelegate

- (void)addBtnSelected{
    if (arr.count <12) {
//        NSLog(@"我要添加图片");
        [sheet showInView:self.view];
    }else {
        [Common showAlert:@"您的相册已满"];
    }
}

- (void)deleteImage:(NSString *)petImageID{
    NSLog(@"我要删除图片");
    petImageIDString = petImageID;
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"确定删除图片吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alter show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *petInfo = @{@"petImageID":petImageIDString};
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:petInfo forKey:@"petInfo"];
        [[PENetWorkingManager sharedClient]editViewDeleteImage:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                NSArray*photoArray = [results objectForKey:EDIT_INFO_PETIMAGELIST];
                NSMutableArray *photoIdArray = [[NSMutableArray alloc]init];
                [arr removeAllObjects];
                [photoIdArray removeAllObjects];
                for(int i=0;i<photoArray.count;i++){
                    [arr addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETIMAGEURL]];
                    [photoIdArray addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETIMAGEID]];
                }
                
                PEEditPhotoScrollView *photoScrollView =(PEEditPhotoScrollView *)[sv viewWithTag:909];
                [photoScrollView removeFromSuperview];
                photoScrollView  =nil;
                photoScrollView =[[PEEditPhotoScrollView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, ScreenWidth, 97.0f) AndData:arr AndImageIDData:photoIdArray];
                [photoScrollView layoutByData];
                photoScrollView.esDelegate= self;
                [sv addSubview:photoScrollView];
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        
    }
    
}

#pragma mark -
#pragma mark UIActionDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
      if (buttonIndex == 0) {
          [self takePhoto];
        }else if (buttonIndex == 1) {

            [self getPhoto];
        }
       else if (buttonIndex == 3) {
            NSLog(@"取消");
            
        }
 
}

//拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许使用相机");
    }
}

//访问相册
- (void)getPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"请允许访问相册");
    }
}

- (void)pickImageEnd:(UIImage *)img {
   
    [passPhotoArray addObject:img];
//    [sendNewsView endOfAddAction:dict];
}

#pragma mark - uiimagePickerDelaget
//取出相册的某张图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  [picker dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  //宠物头像赋值
  [self pickImageEnd:image];
    
    NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
    NSDictionary *petInfo = @{@"petID":[[dataArray objectAtIndex:0]objectForKey:@"petID"]};
    NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
    [request setObject:petInfo forKey:@"petInfo"];
    //上传图片
    [[PENetWorkingManager sharedClient]editViewAddPhotos:request data:passPhotoArray completion:^(NSDictionary *results, NSError *error) {
        if(results){
//            NSLog(@"%@",results);
            NSLog(@"*****Upload Success******");
            
            NSArray*photoArray = [results objectForKey:EDIT_INFO_PETIMAGELIST];
            NSMutableArray *photoIdArray = [[NSMutableArray alloc]init];
            [arr removeAllObjects];
            [photoIdArray removeAllObjects];
            for(int i=0;i<photoArray.count;i++){
                [arr addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETIMAGEURL]];
                [photoIdArray addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETIMAGEID]];
            }
            PEEditPhotoScrollView *photoScrollView =(PEEditPhotoScrollView *)[sv viewWithTag:909];
            [photoScrollView removeFromSuperview];
            photoScrollView  =nil;
            photoScrollView =[[PEEditPhotoScrollView alloc] initWithFrame:CGRectMake(0.0f, 74.0f, ScreenWidth, 97.0f) AndData:arr AndImageIDData:photoIdArray];
            [photoScrollView layoutByData];
            photoScrollView.esDelegate= self;
            [sv addSubview:photoScrollView];

        }else{
            NSLog(@"%@",error);
            [passPhotoArray removeLastObject];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SET UP UI
- (void)setupUI {
    sv =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, ScreenHeight-49)];
    [sv setContentSize:CGSizeMake(ScreenWidth, 1250)];//1200
    
    //scrollView 背景
    UIImageView *bgSV =[[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(sv.bounds.origin.x, sv.bounds.origin.y, sv.contentSize.width, sv.contentSize.height), 0.0f, 0.0f)];
    [bgSV setImage:[UIHelper setImageFromColor:[UIColor whiteColor]]];
    
    //头部背景------用户和宠物Icon的背景
    topView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 74.0f)];
    [topView setImage:[UIHelper imageName:@"edit_top_bg"]];
    
    //宠物头像
    //宠物Icon
    petIcon =[[UIImageView alloc]initWithFrame:CGRectMake(28.0f, 16.0f, 44.0f, 44.0f)];
    //editTest
    [petIcon setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIHelper imageName:@"nearDetail_icon_bg"]];
    petIcon.layer.cornerRadius =22.0f;
    petIcon.clipsToBounds =YES;
    petIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(petIconPressed:)];
    [petIcon addGestureRecognizer:tapGesture1];
    
    petNameLabel = [[UILabel alloc]init];
    petNameLabel.backgroundColor = [UIColor clearColor];
    petNameLabel.textColor = [UIColor whiteColor];
    petNameLabel.font = [UIFont systemFontOfSize:9];
    petNameLabel.text = @"宠物";
    CGSize sizePN  = [petNameLabel.text sizeWithFont:[UIFont systemFontOfSize:9] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petNameLabel.frame = CGRectMake(40, 3, sizePN.width, sizePN.height);
    
    
    //用户Icon
    ownerIcon =[[UIImageView alloc]initWithFrame:CGRectMake(260.0f, 16.0f, 44.0f, 44.0f)];
    //editTest
    [ownerIcon setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIHelper imageName:@"nearDetail_icon_bg"]];
    ownerIcon.layer.cornerRadius =22.0f;
    ownerIcon.clipsToBounds =YES;
    ownerIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ownerIconPressed:)];//添加手势
    [ownerIcon addGestureRecognizer:tapGesture2];
    
    ownerNameLabel = [[UILabel alloc]init];
    ownerNameLabel.backgroundColor = [UIColor clearColor];
    ownerNameLabel.textColor = [UIColor whiteColor];
    ownerNameLabel.font = [UIFont systemFontOfSize:9];
    ownerNameLabel.text = @"主人";
    CGSize sizeON  = [ownerNameLabel.text sizeWithFont:[UIFont systemFontOfSize:9] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    ownerNameLabel.frame = CGRectMake(272, 3, sizePN.width, sizePN.height);
    
    //用户下面的大小为1*14的白线
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(50.0f, 60.0f, 1.0f, 14.0f)];
    lineView.backgroundColor =[UIColor whiteColor];
    
    
    //=====================初始化photoSV
    //editTest
    NSArray *temp = [[NSArray alloc] init];
    NSArray *temp2 = [[NSArray alloc] init];
//    NSArray*photoArray = [[dataArray objectAtIndex:0]objectForKey:EDIT_INFO_PETIMAGELIST];
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    [arr removeAllObjects];
//    for(int i=0;i<photoArray.count;i++){
//        [arr addObject:[[photoArray objectAtIndex:i]objectForKey:EDIT_INFO_PETOTHERIMAGEURL]];
//    }
    photoSV = [[PEEditPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, ScreenWidth, 97.0f) AndData:temp AndImageIDData:temp2];//138.0
    photoSV.esDelegate = self;
//     photoSV = [[PEPhotoScrollView alloc]initWithFrame:CGRectMake(0.0f, 74.0f, ScreenWidth, 97.0f) data:temp AndType:YES];
    
    
    
    //set action view
    //为了显示“点击更换图片”
    UIImageView *bgImage =[[UIImageView alloc] init];
    bgImage.backgroundColor =[UIColor colorWithRed:229.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0];
    bgImage.frame =CGRectMake(0.0f, 20.0f, ScreenWidth, 20);// y=20
    
    actionView =[[UIView alloc] init];
    actionView.backgroundColor =[UIColor clearColor];
    actionView.frame =CGRectMake(0.0f, 151.0, ScreenWidth, 20);
//    [actionView addSubview:bgImage];
    //点击更换图片label
    changeImageLabel = [[UILabel alloc]init];
    changeImageLabel.backgroundColor = [UIColor clearColor];
    changeImageLabel.textColor = [UIColor whiteColor];
    changeImageLabel.font = [UIFont systemFontOfSize:9];
    changeImageLabel.text = @"点击更换图片";
    CGSize sizeCI = [changeImageLabel.text sizeWithFont:[UIFont systemFontOfSize:9] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    changeImageLabel.frame = CGRectMake(20,7, sizeCI.width, sizeCI.height);
    
    //=====================我的基本资料
    ownerV =[[PEEditOwnerView alloc] initWithFrame:CGRectMake(0.0f, 171, ScreenWidth,257)];//196
    ownerV.backgroundColor = [UIHelper colorWithHexString:@"#f5f5f5"];
    [ownerV layoutSubviews];
    //editTest
    ownerV.nameDetail.text = @"";
    ownerV.signDetail.text= @"";
    ownerV.starDetail.text = @"";
    
    //editTest
    ownerV.ageTextField.text = @"";
    [ownerV.nameBtn2 addTarget:self action:@selector(changeInfomation:) forControlEvents:UIControlEventTouchUpInside];
    [ownerV.signBtn2 addTarget:self action:@selector(changeInfomation:) forControlEvents:UIControlEventTouchUpInside];
    
    ownerV.ageTextField.delegate = self;
    ownerV.ageTextField.inputView = self.datePicker;
    ownerV.ageTextField.inputAccessoryView = self.doneToolbar;

    //editTest
//    NSString *nameDetail = [dataDic objectForKey:EDIT_INFO_USERNAME];
//    NSString *signDetail = [dataDic objectForKey:EDIT_INFO_USER_SIGN];
//    
//    [infomationDetailArray addObject:nameDetail];
//    [infomationDetailArray addObject:signDetail];
    
    //=====================tableView部分
    grouptableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 428, self.view.frame.size.width, 378) style:UITableViewStylePlain];//405
    grouptableView.backgroundColor = [UIColor clearColor];
    grouptableView.separatorColor=[UIColor clearColor];
    grouptableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    grouptableView.clipsToBounds = NO;
    grouptableView.bounces =NO;//不能上下回弹
    grouptableView.scrollEnabled =NO;//不能滑动
    grouptableView.dataSource = self;
    grouptableView.delegate = self;
    grouptableView.sectionFooterHeight = 0;
    grouptableView.sectionHeaderHeight = 0;
    
    //=============活动范围底部到其他资料这段
    spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = [UIHelper colorWithHexString:@"#f5f5f5"];
    spaceView.frame = CGRectMake(0, 805, ScreenWidth, 91);   //如果都收起来515
    
    //连线
    infoLineImageView = [[UIImageView alloc]init];
    infoLineImageView.image = [UIHelper imageName:@"edit_line_ vertical"];
    infoLineImageView.frame = CGRectMake(16, 0, 0.5,111);
    infoLineImageView.backgroundColor = [UIColor clearColor];
    [spaceView addSubview:infoLineImageView];
    
    //添加新宠物button---------tableView的初始值+tableView的高+间隔7
    //tableViewHeight = 250 *sortArray.count
    addNewPetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNewPetButton setImage:[UIHelper imageName:@"edit_add_pet"] forState:UIControlStateNormal];
    addNewPetButton.frame = CGRectMake(140.25, 7, 39.5, 39.5);  //806.5+7
//    [spaceView addSubview:addNewPetButton];
    
    addNewPetLabel = [[UILabel alloc]init];
    addNewPetLabel.textColor = [UIHelper colorWithHexString:@"#b9b9b9"];
    addNewPetLabel.font = [UIFont systemFontOfSize:12.5];
    addNewPetLabel.textAlignment = NSTextAlignmentCenter;
    addNewPetLabel.frame = CGRectMake(125, 53, 70, 12.5);//859.5
    addNewPetLabel.text = @"添加新宠物";
//    [spaceView addSubview:addNewPetLabel];
    
    //====================其他资料---微博 人人
    otherView = [[PEEditOtherView alloc]initWithFrame:CGRectMake(0, 871+25, 320, 160)]; //如果都收起来580+25
    otherView.backgroundColor = [UIHelper colorWithHexString:@"#f5f5f5"];
    otherView.delegate =self;
    
    exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIHelper colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    exitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [exitBtn setBackgroundImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#f16161"]] forState:UIControlStateNormal];
    if (dataArray.count ==0) {
        exitBtn.frame = CGRectMake(20, 1100, 280, 40);
    }else {
        exitBtn.frame = CGRectMake(20, 815, 280, 40);
    }
    [exitBtn addTarget:self action:@selector(exitBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [actionView addSubview:changeImageLabel];
    [sv addSubview:bgSV];
    [sv addSubview:topView];
    [sv addSubview:photoSV];
    [sv addSubview:ownerV];
    [sv addSubview:petNameLabel];
    [sv addSubview:ownerNameLabel];
    [sv addSubview:petIcon];
    [sv addSubview:ownerIcon];
    [sv addSubview:lineView];
    [sv addSubview:actionView];
    [sv addSubview:grouptableView];
    [sv addSubview:spaceView];
    [sv addSubview:otherView];
    [sv addSubview:exitBtn];
    [self.view addSubview:sv];
    
    
}



- (NSInteger)getAgeString{
    
    NSDate *date = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    NSDate * tempDate=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:tempDate];
    int year=[conponent year];//取系统的时间
    int age =year - [currentyearString intValue];//取返回值的前四个字符
    return age;
}

#pragma mark - UITapGestureRecognizer
- (void)petIconPressed:(UITapGestureRecognizer *)gesture {
    [lineView setFrame:CGRectMake(50.0f, 60.0f, 1.0f, 14.0f)];
}

- (void)ownerIconPressed:(UITapGestureRecognizer *)gesture {
    [lineView setFrame:CGRectMake(282.0f, 60.0f, 1.0f, 14.0f)];
}


//doneBtn
- (IBAction)doneBtnPressed:(id)sender{
    
    [ownerV.ageTextField endEditing:YES];
    UITextField *text = (UITextField *)[grouptableView viewWithTag:currentTag];
    [text resignFirstResponder];
    
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTag = textField.tag;
    if (currentTag ==908) {
        isDatePicked =YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    int n = [self getAgeString];
    ownerV.ageTextField.text = [NSString stringWithFormat:@"%d岁",n];
    NSDate *date = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    // Get Current  Year
    NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    NSString * currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    int year = [currentyearString intValue];
    int month = [currentMonthString intValue];
    int day = [currentDateString intValue];
    if((month ==1 && day>=20) || (month==2 &&day<=18)){
        ownerV.starDetail.text = @"水瓶座";
    }else if ((month ==2 && day>=19) || (month == 3 &&day<=20)){
        ownerV.starDetail.text = @"双鱼座";
    }else if ((month == 3 &&day>=21) || (month ==4 &&day<=19)){
        ownerV.starDetail.text = @"白羊座";
    }else if ((month == 4 &&day>=20) || (month ==5 &&day<=20)){
        ownerV.starDetail.text = @"金牛座";
    }else if ((month == 5 &&day>=21) || (month ==6 &&day<=21)){
        ownerV.starDetail.text = @"双子座";
    }else if ((month == 6 &&day>=22) || (month ==7 &&day<=22)){
        ownerV.starDetail.text = @"巨蟹座";
    }else if ((month == 7 &&day>=23) || (month ==8 &&day<=22)){
        ownerV.starDetail.text = @"狮子座";
    }else if ((month == 8 &&day>=23) || (month ==9 &&day<=22)){
        ownerV.starDetail.text = @"处女座";
    }else if ((month == 9 &&day>=23) || (month ==10 &&day<=23)){
        ownerV.starDetail.text = @"天秤座";
    }else if ((month == 10 &&day>=24) || (month ==11 &&day<=22)){
        ownerV.starDetail.text = @"天蝎座";
    }else if ((month == 11 &&day>=23) || (month ==12 &&day<=21)){
        ownerV.starDetail.text = @"射手座";
    }else if ((month == 12 &&day>=22) || (month ==1 &&day<=19)){
        ownerV.starDetail.text = @"魔蝎座";
    }
    
}



#pragma mark - TableView
//分区---------分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return dataArray.count;
//    return 1;
}

//每个区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen)
    {
        if(self.selectIndex.section == section)
        {
            //根据键“list取出数组”
            return 2;
            
        }
    }
    return 1;
}

//行高  怎样控制行高？？？
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height =43.5f;
    if(self.isOpen)
    {
        if(self.selectIndex.section == indexPath.section)
        {
            if (indexPath.row ==0) {
                return 43.5f;//每个区域的第一行高度：section的高度
            } else {
                
                height = 291.0f;
            }
        }
        
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"Cell2";
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        PESettingEditTableCellTwo *cell = (PESettingEditTableCellTwo *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil)
        {

            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"PESettingEditTableCellTwo" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate =self;
        
        NSDictionary *tempDic = [dataArray objectAtIndex:indexPath.section];
        cell.petNameLabel.text = [tempDic objectForKey:EDIT_INFO_PETNAME];
       
        NSString *petNameString  = [tempDic objectForKey:EDIT_INFO_PETNAME];
        [infomationDetailArray addObject:petNameString];
        
        cell.petID =[tempDic objectForKey:EDIT_INFO_PETID];
        
        NSString *sexString = [tempDic objectForKey:EDIT_INFO_PET_SEX];
        NSString *wantedTypeString = [tempDic objectForKey:EDIT_INFO_PETWANTEDTYPE];
        cell.petWantedTypeString =[tempDic objectForKey:EDIT_INFO_PETWANTEDTYPE];
        [cell changeSexImage:sexString AndType:wantedTypeString];
        
        NSString *petBirthdayString = [tempDic objectForKey:EDIT_INFO_PET_BIRTHDAY];
        cell.petBirthday =petBirthdayString;
        [cell setpetAge];
        
        if ([[tempDic objectForKey:EDIT_INFO_PET_SEX] isEqualToString:@"公"]) {
            cell.petSortImageView.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", [tempDic objectForKey:EDIT_INFO_PETTYPE]]];
        } else {
            cell.petSortImageView.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", [tempDic objectForKey:EDIT_INFO_PETTYPE]]];
        }
        
        
        cell.petType =[tempDic objectForKey:EDIT_INFO_PETTYPE];
        cell.petSubType =[tempDic objectForKey:EDIT_INFO_PETSUBTYPE];
        cell.sortNameLabel.text = [tempDic objectForKey:EDIT_INFO_PETSUBNAME];
        
        cell.petFavDetailLabel.text = [tempDic objectForKey:EDIT_INFO_PETFAVORITE];
        NSString *petFavString = [tempDic objectForKey:EDIT_INFO_PETFAVORITE];
        [infomationDetailArray addObject:petFavString];
        
        cell.playSpaceDetailLable.text =[tempDic objectForKey:EDIT_INFO_PETSITE];
         NSString *petPlaySpaceString = [tempDic objectForKey:EDIT_INFO_PETSITE];
        [infomationDetailArray addObject:petPlaySpaceString];
        
        if(indexPath.section == 0){
            cell.backGroundView.hidden = YES;
        }
   
        
        [cell.nameBtn addTarget:self action:@selector(changeInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.petFavBtn addTarget:self action:@selector(changeInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.petPlaySpaceBtn addTarget:self action:@selector(changeInfomation:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.fmaleSexBtn.tag = indexPath.row;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell1";
        //外面一级的cell
        PESettingEditTableCellOne *cell = (PESettingEditTableCellOne*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PESettingEditTableCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIHelper colorWithHexString:@"#f5f5f5"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.petLabel.text = [sortArray objectAtIndex:indexPath.section];
        [cell.deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text = [[dataArray objectAtIndex:indexPath.section]objectForKey:EDIT_INFO_PETNAME];
        
        //第一个区域不需要删除按钮
        
        if(indexPath.section == 0)
        {
            cell.deleteButton.alpha = 0;
            cell.gapView.alpha = 0;
            cell.petDataIcon.frame = CGRectMake(31.5, 13.25f, 12.5, 16);
            cell.petLabel.frame  = CGRectMake(46,14.75f,40,14);

        }else{
            cell.gapLineView.hidden = YES;
        }
        
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    
    if (indexPath.row == 0)//点击的是外层Title
    {   //收起来的动画
        if ([indexPath isEqual:self.selectIndex])
        {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
           //by wu  如果点击收起的是第二行,则第一行打开
            spaceView.frame = CGRectMake(0, 515, ScreenWidth, 91);   //如果都收起来515
            otherView.frame = CGRectMake(0, 580+25, 320, 160); //如果都收起来580+25
            exitBtn.frame = CGRectMake(20, 815, 280, 40);
            [sv setContentSize:CGSizeMake(ScreenWidth, 965)];//1200
            
            NSLog(@"我不收起来");
            
        }
        else
        {
            //展开动画
            if (!self.selectIndex)
            {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
              
                spaceView.frame = CGRectMake(0, 805, ScreenWidth, 91);
                otherView.frame = CGRectMake(0, 871+25, 320, 160);
                exitBtn.frame = CGRectMake(20, 1100, 280, 40);
                [sv setContentSize:CGSizeMake(ScreenWidth, 1250)];//1200

            }
            else
            {
    
                [self didSelectCellRowFirstDo:NO nextDo:YES];
                spaceView.frame = CGRectMake(0, 805, ScreenWidth, 91);
                otherView.frame = CGRectMake(0, 871+25, 320, 160);
                exitBtn.frame = CGRectMake(20, 1100, 280, 40);
                [sv setContentSize:CGSizeMake(ScreenWidth, 1250)];//1200
            }
        }
        
    }else //点击的是里面一级的cell
    {
        
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//选中第一个区域
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    isOpen = firstDoInsert;
    
    PESettingEditTableCellOne *cell = (PESettingEditTableCellOne *)[self.grouptableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    
    [grouptableView beginUpdates];
    
    int section = self.selectIndex.section;
//    int contentCount = [[[sortArray objectAtIndex:section] objectForKey:DISCOVER_GROUP_LIST] count];
    int contentCount = 1;
    //这是要插入的行数
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
        //添加cell-NSIndexPath
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
    //如果是第一次点击，就会展开
	if (firstDoInsert)
    {   [grouptableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        
    }//收起来
	else
    {
        [grouptableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [grouptableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.grouptableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.grouptableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - BUTTON PRESSED
- (void)saveBtnPressed:(id)sender{
    if (![editPetInfo objectForKey:@"petID"]) {
        NSString *tempUserID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
        NSString *userNameString = ownerV.nameDetail.text;
        NSString *userSignString = ownerV.signDetail.text;
        
        
        NSString *userBirthDayString;
        if (isDatePicked) {
            NSDate *date = [datePicker date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            [formatter setDateFormat:@"MM"];
            NSString * currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
            // Get Current  Date
            [formatter setDateFormat:@"dd"];
            NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
            [formatter setDateFormat:@"yyyy"];
            NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
            
            userBirthDayString = [NSString stringWithFormat:@"%@-%@-%@",currentyearString,currentMonthString,currentDateString];
        } else {
            userBirthDayString = [dataDic objectForKey:EDIT_INFO_USER_BIRTHDAY];
        }
        
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"userID":tempUserID,
                                   @"userName":userNameString,
                                   @"userSign":userSignString,
                                   @"userSex":@"女士",
                                   @"userBirthday":userBirthDayString,
                                   @"userDescription":otherView.moreInfoLabel.text
                                   };
        
        NSString *petIDString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETID];
        NSString *petNameString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETNAME];
        NSString *petBirthDayString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PET_BIRTHDAY];
        NSString *petNickNameString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETNICKNAME];
        NSString *petTypeString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETTYPE];
        NSString *petSubTypeString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETSUBTYPE];
        
        NSString *petFavString =  [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETFAVORITE];
        NSString *petSiteString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETSITE];
        
        NSDictionary *petInfo = @{@"petID":petIDString,
                                  @"petName":petNameString ,
                                  @"petSex":petSexString,
                                  @"petBirthday":petBirthDayString,
                                  @"petNickName":petNickNameString,
                                  @"petType":petTypeString,
                                  @"petSubType":petSubTypeString,
                                  @"petWantedType":petWantedTypeString,
                                  @"petFavorite":petFavString,
                                  @"petSite":petSiteString ,
                                  };
        
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        [request setObject:petInfo forKey:@"petInfo"];
        
        [[PENetWorkingManager sharedClient]editSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                    [Common showAlert:@"保存成功"];
                }
            }else{
                
                NSLog(@"%@",error);

            }
        }];
    }else {
        NSString *tempUserID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_ID];
        NSString *userNameString = ownerV.nameDetail.text;
        NSString *userSignString = ownerV.signDetail.text;
        NSDate *date = [datePicker date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"MM"];
        NSString * currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
        // Get Current  Date
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        [formatter setDateFormat:@"yyyy"];
        NSString *currentyearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        NSString *userBirthDayString = [NSString stringWithFormat:@"%@-%@-%@",currentyearString,currentMonthString,currentDateString];
        
        
        
        NSDictionary *appInfo = [[PEMobile sharedManager]getAppInfo];
        NSDictionary *userInfo = @{@"userID":tempUserID,
                                   @"userName":userNameString,
                                   @"userSign":userSignString,
                                   @"userSex":@"女士",
                                   @"userBirthday":userBirthDayString,
                                   };
        
        NSString *petIDString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETID];
        NSString *petNameString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETNAME];
        NSString *petBirthDayString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PET_BIRTHDAY];
        NSString *petNickNameString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETNICKNAME];
        NSString *petTypeString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETTYPE];
        NSString *petSubTypeString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETSUBTYPE];
        
        NSString *petFavString =  [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETFAVORITE];
        NSString *petSiteString = [[dataArray objectAtIndex:selectIndex.section]objectForKey:EDIT_INFO_PETSITE];
        
        NSDictionary *petInfo = @{@"petID":petIDString,
                                  @"petName":petNameString ,
                                  @"petSex":petSexString,
                                  @"petBirthday":petBirthDayString,
                                  @"petNickName":petNickNameString,
                                  @"petType":petTypeString,
                                  @"petSubType":petSubTypeString,
                                  @"petWantedType":petWantedTypeString,
                                  @"petFavorite":petFavString,
                                  @"petSite":petSiteString ,
                                  };
        
        NSMutableDictionary *request = [[NSMutableDictionary alloc]initWithDictionary:appInfo];
        [request setObject:userInfo forKey:@"userInfo"];
        [request setObject:petInfo forKey:@"petInfo"];
        
        [[PENetWorkingManager sharedClient]editSaveInfomation:request completion:^(NSDictionary *results, NSError *error) {
            if(results){
                
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
//                    [Common showAlert:@"保存成功"];
                }
            }else{
                
                NSLog(@"%@",error);
                
            }
        }];
        
        
        
        NSDictionary *appInfo2 = [[PEMobile sharedManager]getAppInfo];
        
        NSMutableDictionary *request2 = [[NSMutableDictionary alloc]initWithDictionary:appInfo2];
        [request2 setObject:editPetInfo forKey:@"petInfo"];
        
        [[PENetWorkingManager sharedClient]editPetSaveInfomation:request2 completion:^(NSDictionary *results, NSError *error) {
            if(results){
                
                NSLog(@"%@",results);
                if([[results objectForKey:HTTP_RESULTS]isEqualToString:@"0"]){
                    [Common showAlert:@"保存成功"];
                }
            }else{
                
                NSLog(@"%@",error);
            }
        }];
    }
    

}

- (void)deleteButtonPressed{
    
    NSLog(@"我要删除消息");
    
}

//退出当前账号
- (void)exitBtnPressed{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setBool:NO forKey:IS_LOGINED];
    [config setObject:@"null" forKey:USER_INFO_ID];
    [config removeObjectForKey:CELLACCOUNT];
    [config removeObjectForKey:MAILACCOUNT];
    [config removeObjectForKey:ACCOUNT];
    [config removeObjectForKey:PASSWORD];
    
    
    [[PEXMPP sharedInstance] logout];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOut Succ" object:nil];

    
    
}

//传值到修改的详情页面
- (void)changeInfomation:(UIButton *)sender{
    
    NSInteger tempTag = sender.tag-300;
    NSString *passInfomation = [infomationDetailArray objectAtIndex:tempTag];
    PEEditDetailViewController *detailView = [[PEEditDetailViewController alloc]init];
    detailView.infomationString = @"";
    detailView.infomationString = passInfomation;
    detailView.tag = tempTag;
    detailView.dic = dataDic;
    detailView.selectSection = self.selectIndex.section;
    NSLog(@"==========当前点击的是%d",detailView.selectSection);
    [self.navigationController pushViewController:detailView animated:YES];
    
}

- (void)endEdit:(NSDictionary *)data {
    editPetInfo =[[NSDictionary alloc] initWithDictionary:data];
    
}

#pragma mark -
#pragma mark Other View Delegate
- (void)didChangeBtn:(UIButton *)sender {
    PEEditChangePwdViewController *pCtr =[[PEEditChangePwdViewController alloc] init];
    pCtr.title =@"更换密码";
    [self.navigationController pushViewController:pCtr animated:YES];
}

- (void)didMoreBtn:(UIButton *)sender {
    sender.tag =302;
    
    NSInteger tempTag = sender.tag-300;
    NSString *passInfomation = [infomationDetailArray objectAtIndex:tempTag];
    PEEditDetailViewController *detailView = [[PEEditDetailViewController alloc]init];
    detailView.infomationString = @"";
    detailView.infomationString = passInfomation;
    detailView.tag = tempTag;
    detailView.dic = dataDic;
    detailView.selectSection = self.selectIndex.section;
    NSLog(@"==========当前点击的是%d",detailView.selectSection);
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
