//
//  PESettingEditTableCellTwo.m
//  Pet
//
//  Created by WuJunqiu on 14-7-8.
//  Copyright (c) 2014年 Pet. All rights reserved.
//

#import "PESettingEditTableCellTwo.h"
#import "UIHelper.h"
@implementation PESettingEditTableCellTwo

@synthesize petWantedTypeString, petSexString, petID, petBirthday, petType;
@synthesize petNameLabelTwo,petSortLabel,petAgeLabel,petStausLabel,petFavLabel,petPlaySpaceLabel;
@synthesize petNameLabel,sortNameLabel,petAgeLabelTwo,petFavDetailLabel,playSpaceDetailLable,petSortImageView;
@synthesize stausImageViewNomal1,stausImageViewNomal2,stausImageViewNomal3;
@synthesize stausImageViewSelected1,stausImageViewSelected2,stausImageViewSelected3;
@synthesize forwardImageView1,forwardImageView2,forwardImageView3;
@synthesize forwardLabel1,forwardLabel2,forwardLabel3;
@synthesize button1,button2,button3;
@synthesize petSexLabel,petSexFemaleNormalImageView,petSexFemaleSelectedImageView,petSexMaleNormalImageView,petSexMaleSelectedImageView;
@synthesize isSelected,isMale;
@synthesize maleSexBtn,fmaleSexBtn;
@synthesize backGroundView;
@synthesize petFavBtn,petPlaySpaceBtn,nameBtn,petAgeTextField;
@synthesize datePicker,doneToolBar,delegate;
@synthesize isMiddle, subData, petSubType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIHelper colorWithHexString:@"#ffffff"];
    }
    return self;
}



//初始化cell
-(void)initEditCellTwo
{
    
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePetName:) name:@"changePetNameSuccess" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePetFav:) name:@"changePetFavSuccess" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePetSite:) name:@"changePetsiteSuccess" object:nil];
    
    //=============该cell的背景图片
    
    self.midArray = [[NSArray alloc] init];
    self.subArray = [[NSArray alloc] init];
    
    
    self.subPicker.delegate =self;
    self.subPicker.dataSource =self;
    
    petWantedTypeString =[[NSString alloc] init];
    petSexString =[[NSString alloc] init];
    petID =[[NSString alloc] init];
    petBirthday =[[NSString alloc] init];
    
    backGroundView = [[UIImageView alloc]init];
    backGroundView.backgroundColor = [UIColor clearColor];
    backGroundView.frame = CGRectMake(0, 0, ScreenWidth,15);
    UIImage *img = [UIHelper imageName:@"edit_cellPlayView"];
    backGroundView.image = img;
    [self addSubview:backGroundView];
    
    //=====================宠物姓名
    petNameLabelTwo = [[UILabel alloc]init];
    petNameLabelTwo.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petNameLabelTwo.font = [UIFont systemFontOfSize:13];
    petNameLabelTwo.text = @"宠物姓名";
    petNameLabelTwo.frame = CGRectMake(22.0, 12,60, 13);//421
    [self addSubview:petNameLabelTwo];
    

    
    
    //名字详情
    petNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(96.0f, 0.0f, 200.0f, 40.0f)];
    petNameLabel.textColor =[UIHelper colorWithHexString:@"#000000"];
    petNameLabel.font =[UIFont systemFontOfSize:13.0f];
    petNameLabel.text =@"虾条";
    [self addSubview:petNameLabel];
    
    //箭头
    UIImageView *nameTwoAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 13.25f, 8.0f, 13.5f)];
    [nameTwoAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:nameTwoAorrow];
    
    nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(0, 0, 320, 40);
    nameBtn.tag = 303;
    [self addSubview:nameBtn];
    
    
    //切割线
    for(int  i = 0; i<4; i++){
        UIImageView *gaplineView =[[UIImageView alloc] initWithFrame:CGRectMake(92.0f, 40+40.0f*i, 228.0f, 1.0f)];//446
        
        [gaplineView setImage:[UIHelper imageName:@"edit_line"]];
        [self addSubview:gaplineView];
    }
    
    UIImageView *gaplineView1 =[[UIImageView alloc] initWithFrame:CGRectMake(92.0f, 210, 228.0f, 1.0f)];//446
    [gaplineView1 setImage:[UIHelper imageName:@"edit_line"]];
    [self addSubview:gaplineView1];
    
    UIImageView *gaplineView2 =[[UIImageView alloc] initWithFrame:CGRectMake(92.0f, 250, 228.0f, 1.0f)];//446
    [gaplineView2 setImage:[UIHelper imageName:@"edit_line"]];
    [self addSubview:gaplineView2];
    
//    UIImageView *gaplineView3 =[[UIImageView alloc] initWithFrame:CGRectMake(92.0f, 290, 228.0f, 1.0f)];//446
//    [gaplineView3 setImage:[UIHelper imageName:@"edit_line"]];
//    [self addSubview:gaplineView3];
    
    UIView *gap3View = [[UIView alloc]init];
    gap3View.backgroundColor = [UIHelper colorWithHexString:@"#61becd"];
    gap3View.frame = CGRectMake(92.0f, 290, 228.0f, 1.0f);
    [self addSubview:gap3View];
    
    //======================宠物种类
    petSortLabel = [[UILabel alloc]init];
    petSortLabel.backgroundColor = [UIColor clearColor];
    petSortLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petSortLabel.font = [UIFont systemFontOfSize:13];
    petSortLabel.text = @"宠物种类";
    petSortLabel.frame = CGRectMake(22.0, 52,60, 13);
    [self addSubview:petSortLabel];
    
    
    
    //种类图片
    petSortImageView = [[UIImageView alloc]init];
    petSortImageView.backgroundColor = [UIColor clearColor];
    petSortImageView.frame = CGRectMake(96, 54, 14, 11);
    [self addSubview:petSortImageView];
    
    //种类详情
    sortNameLabel =[[UITextField alloc] initWithFrame:CGRectMake(112.f, 40, 200.0f, 40.0f)];
    sortNameLabel.backgroundColor=[UIColor clearColor];
    sortNameLabel.textColor =[UIHelper colorWithHexString:@"#000000"];
    sortNameLabel.font =[UIFont systemFontOfSize:13.0f];
    sortNameLabel.inputAccessoryView =self.doneToolBar;
    sortNameLabel.inputView =self.subPicker;
    sortNameLabel.delegate =self;
    [self addSubview:sortNameLabel];
    
    
    //箭头
    UIImageView *sortAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 53.25, 8.0f, 13.5f)];
    [sortAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:sortAorrow];
    
    //=====================宠物性别
    petSexLabel = [[UILabel alloc]init];
    petSexLabel.backgroundColor = [UIColor clearColor];
    petSexLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petSexLabel.font = [UIFont systemFontOfSize:13];
    petSexLabel.text = @"宠物性别";
    petSexLabel.frame = CGRectMake(22.0, 92,60, 13);
    [self addSubview:petSexLabel];
    
    petSexMaleNormalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(94, 93, 16.5, 15)];
    petSexMaleNormalImageView.backgroundColor = [UIColor clearColor];
    petSexMaleNormalImageView.image = [UIHelper imageName:@"edit_pet_forward"];
    petSexFemaleNormalImageView.alpha = 0.;
    [self addSubview:petSexMaleNormalImageView];
    petSexMaleSelectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(94, 93, 16.5, 15)];
    petSexMaleSelectedImageView.backgroundColor = [UIColor clearColor];
    petSexMaleSelectedImageView.image =[UIHelper imageName:@"edit_pet_forwad_selected"];
    petSexMaleSelectedImageView.alpha = 0.;
    [self addSubview:petSexMaleSelectedImageView];
    
    petSexFemaleNormalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 93, 16.5, 15)];
    petSexFemaleNormalImageView.backgroundColor = [UIColor clearColor];
    petSexFemaleNormalImageView.image = [UIHelper imageName:@"edit_pet_forward"];
    [self addSubview:petSexFemaleNormalImageView];
    petSexFemaleSelectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 93, 16.5, 15)];
    petSexFemaleSelectedImageView.backgroundColor = [UIColor clearColor];
    petSexFemaleSelectedImageView.image =[UIHelper imageName:@"edit_pet_forwad_selected"];
    petSexFemaleSelectedImageView.alpha = 0.;
    [self addSubview:petSexFemaleSelectedImageView];
    
    maleSexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maleSexBtn.frame = CGRectMake(94, 93, 62.5, 15);
    [self addSubview:maleSexBtn];
    
    fmaleSexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fmaleSexBtn.frame = CGRectMake(210, 93, 62.5, 15);
    [self addSubview:fmaleSexBtn];
    
     
    //男士箭头图片
    UIImageView *maleImageView = [[UIImageView alloc]init];
    maleImageView.backgroundColor = [UIColor clearColor];
    maleImageView.image = [UIHelper imageName:@"register_male"];
    maleImageView.frame = CGRectMake(120, 89, 22, 22);
    [self addSubview:maleImageView];
    
    //男士
    UILabel *malelabel = [[UILabel alloc]init];
    malelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    malelabel.font = [UIFont systemFontOfSize:13];
    malelabel.text = @"男生";
    malelabel.frame = CGRectMake(146, 92, 30, 13);
    [self addSubview:malelabel];
    
    //女士箭头图片
    UIImageView *femaleImageView = [[UIImageView alloc]init];
    femaleImageView.backgroundColor = [UIColor clearColor];
    femaleImageView.image = [UIHelper imageName:@"register_female"];
    femaleImageView.frame = CGRectMake(234.0f, 89.0f, 22, 22);
    [self addSubview:femaleImageView];
    
    //女士
    UILabel *femalelabel = [[UILabel alloc]init];
    femalelabel.textColor = [UIHelper colorWithHexString:@"#000000"];
    femalelabel.font = [UIFont systemFontOfSize:13];
    femalelabel.text = @"女生";
    femalelabel.frame = CGRectMake(260.f, 92, 30, 13);
    [self addSubview:femalelabel];
    

    //=====================宠物年龄
    petAgeLabel = [[UILabel alloc]init];
    petAgeLabel.backgroundColor = [UIColor clearColor];
    petAgeLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petAgeLabel.font = [UIFont systemFontOfSize:13];
    petAgeLabel.text = @"宠物年龄";
    petAgeLabel.textAlignment = NSTextAlignmentRight;
    CGSize sizePA = [petAgeLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petAgeLabel.frame = CGRectMake(22.0f, 132.0f, sizePA.width, sizePA.height);
    [self addSubview:petAgeLabel];
    
    //箭头
    UIImageView *petAgeAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 133.25, 8.0f, 13.5f)];
    [petAgeAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:petAgeAorrow];
    
    //年龄label
    petAgeLabelTwo =[[UILabel alloc] initWithFrame:CGRectMake(96.f, 120.0f, 200.0f, 40.0f)];
    petAgeLabelTwo.textColor =[UIHelper colorWithHexString:@"#000000"];
    petAgeLabelTwo.font =[UIFont systemFontOfSize:13.0f];
    petAgeLabelTwo.text =@"3岁";
//    [self addSubview:petAgeLabelTwo];
    
    
    
    petAgeTextField = [[UITextField alloc]init];
    petAgeTextField.frame = CGRectMake(96.0f, 120.0f, 200.0f, 40.0f);
    petAgeTextField.textColor =[UIHelper colorWithHexString:@"#000000"];
    petAgeTextField.font =[UIFont systemFontOfSize:13.0f];
    int n = [self getAgeString];
    petAgeTextField.text =@"3岁";
    petAgeTextField.inputView = self.datePicker;
    petAgeTextField.inputAccessoryView = self.doneToolBar;
    petAgeTextField.delegate = self;
    [self addSubview:petAgeTextField];
    
    //宠物状态
    petStausLabel = [[UILabel alloc]init];
    petStausLabel.backgroundColor = [UIColor clearColor];
    petStausLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petStausLabel.font = [UIFont systemFontOfSize:13.0f];
    petStausLabel.text = @"宠物状态";
    CGSize sizePSL = [petStausLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petStausLabel.frame = CGRectMake(22.0, 176, sizePSL.width, sizePSL.height);
    [self addSubview:petStausLabel];
    
    
    
    //添加三个点击状态下的照片
    stausImageViewSelected1 = [[UIImageView alloc]initWithFrame:CGRectMake(94, 185, 16.5, 15)];
    stausImageViewSelected1.backgroundColor = [UIColor clearColor];
    stausImageViewSelected1.image =[UIHelper imageName:@"edit_pet_forwad_selected"];
    stausImageViewSelected1.alpha = 0.;
    [self addSubview:stausImageViewSelected1];
    
    stausImageViewSelected2 = [[UIImageView alloc]initWithFrame:CGRectMake(170,185, 16.5, 15)];
    stausImageViewSelected2.backgroundColor = [UIColor clearColor];
    stausImageViewSelected2.image =[UIHelper imageName:@"edit_pet_forwad_selected"];
    stausImageViewSelected2.alpha = 0.;
    [self addSubview:stausImageViewSelected2];
    
    stausImageViewSelected3 = [[UIImageView alloc]initWithFrame:CGRectMake(247, 185, 16.5, 15)];
    stausImageViewSelected3.backgroundColor = [UIColor clearColor];
    stausImageViewSelected3.image =[UIHelper imageName:@"edit_pet_forwad_selected"];
    stausImageViewSelected3.alpha = 0.;
    [self addSubview:stausImageViewSelected3];
    
    
    //添加三个未点击时的圆圈照片
    stausImageViewNomal1 = [[UIImageView alloc]initWithFrame:CGRectMake(94, 185, 16.5, 15)];
    stausImageViewNomal1.backgroundColor = [UIColor clearColor];
    stausImageViewNomal1.image = [UIHelper imageName:@"edit_pet_forward"];
    stausImageViewNomal1.alpha = 0.;
    [self addSubview:stausImageViewNomal1];
    
    
    stausImageViewNomal2 = [[UIImageView alloc]initWithFrame:CGRectMake(170,185, 16.5, 15)];
    stausImageViewNomal2.backgroundColor = [UIColor clearColor];
    stausImageViewNomal2.image = [UIHelper imageName:@"edit_pet_forward"];
    [self addSubview:stausImageViewNomal2];
    
    stausImageViewNomal3 = [[UIImageView alloc]initWithFrame:CGRectMake(247, 185, 16.5, 15)];
    stausImageViewNomal3.backgroundColor = [UIColor clearColor];
    stausImageViewNomal3.image = [UIHelper imageName:@"edit_pet_forward"];
    [self addSubview:stausImageViewNomal3];
    
    //三个button
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(94, 185, 62.5, 15);
    [self addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(170, 185, 62.5, 15);
    [self addSubview:button2];
   
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(247, 185, 62.5, 15);
    [self addSubview:button3];
    
    
    
    
    forwardImageView1 = [[UIImageView alloc]init];
    forwardImageView1.image = [UIHelper imageName:@"edit_forward_1"];
    forwardImageView1.backgroundColor = [UIColor clearColor];
    forwardImageView1.frame = CGRectMake(128, 169, 13, 13);
    [self addSubview:forwardImageView1];
    
    forwardImageView2 = [[UIImageView alloc]init];
    forwardImageView2.image = [UIHelper imageName:@"edit_forward_3"];
    forwardImageView2.backgroundColor = [UIColor clearColor];
    forwardImageView2.frame = CGRectMake(206, 169, 13, 13);
    [self addSubview:forwardImageView2];
    
    forwardImageView3 = [[UIImageView alloc]init];
    forwardImageView3.image = [UIHelper imageName:@"edit_forward_2"];
    forwardImageView3.backgroundColor = [UIColor clearColor];
    forwardImageView3.frame = CGRectMake(284, 169, 13, 13);
    [self addSubview:forwardImageView3];
    
    //三个固定信息的label:求相亲，求寄养，求领养
    forwardLabel1 = [[UILabel alloc]init];
    forwardLabel1.backgroundColor = [UIColor clearColor];
    forwardLabel1.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardLabel1.font =[UIFont systemFontOfSize:13];
    forwardLabel1.text = @"求相亲";
    forwardLabel1.frame = CGRectMake(114, 185, 46, 14);
    
    forwardLabel2 = [[UILabel alloc]init];
    forwardLabel2.backgroundColor = [UIColor clearColor];
    forwardLabel2.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardLabel2.font =[UIFont systemFontOfSize:13];
    forwardLabel2.text = @"求寄养";
    forwardLabel2.frame = CGRectMake(194, 185, 46, 14);
    
    forwardLabel3 = [[UILabel alloc]init];
    forwardLabel3.backgroundColor = [UIColor clearColor];
    forwardLabel3.textColor = [UIHelper colorWithHexString:@"#000000"];
    forwardLabel3.font =[UIFont systemFontOfSize:13];
    forwardLabel3.text = @"求领养";
    forwardLabel3.frame = CGRectMake(270, 185, 46, 14);
    [self addSubview:forwardLabel1];
    [self addSubview:forwardLabel2];
    [self addSubview:forwardLabel3];
    
    
    //三个button
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(94, 185, 62.5, 15);
    [self addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(170, 185, 62.5, 15);
    [self addSubview:button2];
    
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(247, 185, 62.5, 15);
    [self addSubview:button3];
    
    //宠物爱好
    petFavLabel = [[UILabel alloc]init];
    petFavLabel.backgroundColor = [UIColor clearColor];
    petFavLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petFavLabel.font = [UIFont systemFontOfSize:13];
    petFavLabel.text = @"宠物爱好";
    CGSize sizePFL = [petFavLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petFavLabel.frame = CGRectMake(22.0, 222, sizePFL.width, 13);
    [self addSubview:petFavLabel];

    
    
    //箭头
    UIImageView *favAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 223.25, 8.0f, 13.5f)];
    [favAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:favAorrow];
    
    //宠物爱好label
    petFavDetailLabel =[[UILabel alloc] initWithFrame:CGRectMake(96.f, 210, 200.0f, 40.0f)];
    petFavDetailLabel.textColor =[UIHelper colorWithHexString:@"#000000"];
    petFavDetailLabel.font =[UIFont systemFontOfSize:13.0f];
    petFavDetailLabel.text =@"抓人、钻箱子";
    [self addSubview:petFavDetailLabel];
    
    
    petFavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    petFavBtn.frame = CGRectMake(0, 210, 320, 40);
    petFavBtn.tag = 304;
    
    [self addSubview:petFavBtn];
    
    //活动范围
    petPlaySpaceLabel = [[UILabel alloc]init];
    petPlaySpaceLabel.backgroundColor = [UIColor clearColor];
    petPlaySpaceLabel.textColor = [UIHelper colorWithHexString:@"#8d8d8d"];
    petPlaySpaceLabel.font = [UIFont systemFontOfSize:13];
    petPlaySpaceLabel.text = @"活动范围";
    CGSize sizePPS = [petPlaySpaceLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    petPlaySpaceLabel.frame = CGRectMake(22.0, 262, sizePPS.width, sizePPS.height);
    [self addSubview:petPlaySpaceLabel];
    //箭头
    UIImageView *playSpaceAorrow =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-8, 263.5, 8.0f, 13.5f)];
    [playSpaceAorrow setImage:[UIHelper imageName:@"edit_arrow_right"]];
    [self addSubview:playSpaceAorrow];
    
    //活动范围label
    playSpaceDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(96.f, 252, 200.0f, 40.0f)];
    playSpaceDetailLable.textColor =[UIHelper colorWithHexString:@"#c2c2c2"];
    playSpaceDetailLable.font =[UIFont systemFontOfSize:13.0f];
    playSpaceDetailLable.text =@"输入活动范围";
    [self addSubview:playSpaceDetailLable];
    
    
    petPlaySpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    petPlaySpaceBtn.frame = CGRectMake(0,250, 320, 40);
    petPlaySpaceBtn.tag = 305;
    [self addSubview:petPlaySpaceBtn];
    
    isSelected = YES;
    isMale = YES;

    
    
    [button1 addTarget:self action:@selector(button1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(button3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [maleSexBtn addTarget:self action:@selector(maleSexBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [fmaleSexBtn addTarget:self action:@selector(fmaleSexBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
}

- (IBAction)doneToolBtn:(id)sender;{
    [sortNameLabel resignFirstResponder];
    [petAgeTextField resignFirstResponder];
    
    if (petSubType) {
        [self changeDataSucc];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    int n = [self getAgeString];
    petAgeTextField.text = [NSString stringWithFormat:@"%d岁",n];
}


- (NSInteger)getAgeString{
    
    NSDate *date = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    petBirthday = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSString *str =[petBirthday substringToIndex:4];
    
    NSDate * tempDate=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:tempDate];
    int year=[conponent year];//取系统的时间
    
    int age =year - [str intValue];//取返回值的前四个字符
    return age;
}

- (void)setpetAge {
    if (petBirthday.length>4) {
        NSString *str =[petBirthday substringToIndex:4];
        
        NSDate * tempDate=[NSDate date];
        NSCalendar * cal=[NSCalendar currentCalendar];
        NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:tempDate];
        int year=[conponent year];//取系统的时间
        int age =year - [str intValue];//取返回值的前四个字符
        
        petAgeTextField.text =[NSString stringWithFormat:@"%d岁", age];
        
    }
}

//================所有显示走网络端
#pragma mark - NSNOTIFICATIONCE

//求相亲
- (void)button1Pressed{
    NSLog(@"button1 pressed");
    petWantedTypeString = @"1";
    
    stausImageViewNomal1.alpha = 0.0f;
    stausImageViewSelected1.alpha = 1.0f;
    stausImageViewNomal2.alpha = 1;
    stausImageViewSelected2.alpha = 0;
    stausImageViewNomal3.alpha = 1;
    stausImageViewSelected3.alpha = 0;
    
    [self changeDataSucc];
}

//求寄养
- (void)button2Pressed{
    NSLog(@"button2 pressed");
    petWantedTypeString = @"2";
    
    stausImageViewNomal2.alpha = 0;
    stausImageViewSelected2.alpha = 1;
    stausImageViewNomal1.alpha = 1;
    stausImageViewSelected1.alpha = 0;
    stausImageViewNomal3.alpha = 1;
    stausImageViewSelected3.alpha = 0.;
    
    [self changeDataSucc];
}


//求领养
- (void)button3Pressed{
    NSLog(@"button3 pressed");
    petWantedTypeString = @"3";
    
    stausImageViewNomal3.alpha = 0;
    stausImageViewSelected3.alpha = 1;
    stausImageViewNomal1.alpha = 1;
    stausImageViewSelected1.alpha = 0;
    stausImageViewNomal2.alpha = 1;
    stausImageViewSelected2.alpha = 0;
    
    [self changeDataSucc];
}


//男生
- (void)maleSexBtnPressed{
    NSLog(@"maleSex button pressed");
    petSexString = @"公";
    
    isMale = YES;
    petSexMaleNormalImageView.alpha = 0.0f; 
    petSexMaleSelectedImageView.alpha = 1.0f;
    petSexFemaleNormalImageView.alpha = 1.0f;
    petSexFemaleSelectedImageView.alpha = 0.0f;
    
    petSortImageView.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_male", petType]];
    
    
    [self changeDataSucc];
}

//女生
- (void)fmaleSexBtnPressed{
    NSLog(@"fmaleSex button pressed");
    petSexString = @"母";
    
    petSortImageView.image = [UIHelper imageName:[NSString stringWithFormat:@"near_cell_%@_female", petType]];
    
    isMale = NO;
    petSexFemaleSelectedImageView.alpha = 1.0f;
    petSexFemaleNormalImageView.alpha = 0.0f;
    petSexMaleNormalImageView.alpha = 1.0f;
    petSexMaleSelectedImageView.alpha = 0.0f;
    
    [self changeDataSucc];
}


- (void)changeSexImage:(NSString *)sexString AndType:(NSString *)typeString;{
    if([sexString isEqualToString:@"公"]){
        
        petSexString = @"公";
        
        isMale = YES;
        petSexMaleNormalImageView.alpha = 0.0f;
        petSexMaleSelectedImageView.alpha = 1.0f;
        petSexFemaleNormalImageView.alpha = 1.0f;
        petSexFemaleSelectedImageView.alpha = 0.0f;
    }else{
        
        petSexString = @"母";
        
        isMale = NO;
        petSexFemaleSelectedImageView.alpha = 1.0f;
        petSexFemaleNormalImageView.alpha = 0.0f;
        petSexMaleNormalImageView.alpha = 1.0f;
        petSexMaleSelectedImageView.alpha = 0.0f;
    }
    
    if([typeString isEqualToString:@"1"]){
        
        stausImageViewNomal1.alpha = 0.0f;
        stausImageViewSelected1.alpha = 1.0f;
        stausImageViewNomal2.alpha = 1;
        stausImageViewSelected2.alpha = 0;
        stausImageViewNomal3.alpha = 1;
        stausImageViewSelected3.alpha = 0;

    }else if ([typeString isEqualToString:@"2"]){
        stausImageViewNomal2.alpha = 0;
        stausImageViewSelected2.alpha = 1;
        stausImageViewNomal1.alpha = 1;
        stausImageViewSelected1.alpha = 0;
        stausImageViewNomal3.alpha = 1;
        stausImageViewSelected3.alpha = 0.;
    }else{
        
        stausImageViewNomal3.alpha = 0;
        stausImageViewSelected3.alpha = 1;
        stausImageViewNomal1.alpha = 1;
        stausImageViewSelected1.alpha = 0;
        stausImageViewNomal2.alpha = 1;
        stausImageViewSelected2.alpha = 0;
    }
}

- (void)awakeFromNib
{
    // Initialization code
    
    [self initEditCellTwo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//宠物名修改成功
- (void)changePetName:(NSNotification *)note{
    petNameLabel.text =[note object];
    [self changeDataSucc];
}


//宠物爱好修改成功
- (void)changePetFav:(NSNotification *)note{
    
    petFavDetailLabel.text =[note object];
    [self changeDataSucc];
    
}

//宠物活动范围修改成功
- (void)changePetSite:(NSNotification *)note{
    
    playSpaceDetailLable.text =[note object];
    [self changeDataSucc];
    
}

- (void)changeDataSucc {
    if (petID) {
        
        NSDictionary *petInfo = @{@"petID":petID,
                                  @"petName":petNameLabel.text,
                                  @"petSex":petSexString,
                                  @"petBirthday":petBirthday,
                                  @"petNickName":petNameLabel.text,
                                  @"petType":petType,
                                  @"petSubType":petSubType,
                                  @"petWantedType":petWantedTypeString,
                                  @"petFavorite":petFavDetailLabel.text,
                                  @"petSite":playSpaceDetailLable.text
                                  };
        [delegate endEdit:petInfo];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self subSortRequest];
    

}

#pragma mark - pickerController setting

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component ==0) {
        return [self.midArray count];
    } else {
        return [self.subArray count];
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component ==0) {
        if (self.isMiddle) {
            self.subArray =[[self.midArray objectAtIndex:row] objectForKey:FLITER_SORT_SUB_LIST];
        }
        [self.subPicker reloadAllComponents];
    }else if(petType.length !=0 && self.subArray.count >0){
        
        
        sortNameLabel.text =[[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_NAME];
        petSubType =[NSString stringWithFormat:@"%@", [[self.subArray objectAtIndex:row] objectForKey:FLITER_SORT_ID]];
    }
    
}

- (void)subSortRequest {
    
    NSDictionary *appInfo =[[PEMobile sharedManager] getAppInfo];
    NSDictionary *sortDict =@{@"sortID":[NSString stringWithFormat:@"%@", petType]};
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
            
            NSMutableArray *pickMidArr=[[NSMutableArray alloc]init];
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
            
        } else {
            NSLog(@"%@", error);
        }
    }];
    
}
@end
