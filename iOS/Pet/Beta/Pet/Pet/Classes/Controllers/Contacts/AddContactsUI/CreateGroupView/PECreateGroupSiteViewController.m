//
//  PECreateGroupSiteViewController.m
//  Pet
//
//  Created by Wu Evan on 7/25/14.
//  Copyright (c) 2014 Pet. All rights reserved.
//

#import "PECreateGroupSiteViewController.h"
#import "UIHelper.h"
#import "Common.h"

@interface PECreateGroupSiteViewController ()

@end

@implementation PECreateGroupSiteViewController

@synthesize curLocation, page;
@synthesize isSetMapSpan, key;
@synthesize baiduMapView, locService, poisearch;
@synthesize searchText;
@synthesize placeTable, placeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        key =[[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATE_GROUP_SITE];
    
    UIImageView *bgV =[[UIImageView alloc]initWithImage:[UIHelper imageName:@"club_bg"]];
    [bgV setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [self.view addSubview:bgV];
    
    self.navigationItem.titleView = nil;
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=NSLocalizedString(CONSTACT_CREATE_GROUP_TITLE, nil);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    //定位服务设置 & 地图
    locService =[[BMKLocationService alloc] init];
    poisearch =[[BMKPoiSearch alloc] init];
    baiduMapView =[[BMKMapView alloc] initWithFrame:CGRectMake(0.0f, 124.5f, ScreenWidth, 168.0f)];
    baiduMapView.showsUserLocation = YES;
    [baiduMapView setZoomLevel:17.0f];//设置地图等级
    [self.view addSubview:baiduMapView];
    
    [locService startUserLocationService];
    
    placeArray =[[NSMutableArray alloc] init];
    
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated {
    [baiduMapView viewWillAppear];
    baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
    poisearch.delegate =self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [baiduMapView viewWillDisappear];
    baiduMapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
    poisearch.delegate =self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *topView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, ScreenWidth, 60.5f)];
    topView.backgroundColor =[UIHelper colorWithHexString:@"#f5f5f5"];
    
    //搜索图标
    UIImageView *searchIcon =[[UIImageView alloc] initWithFrame:CGRectMake(20.5f, 23.0f, 12.0f, 12.0f)];
    [searchIcon setImage:[UIHelper imageName:@"createGroup_search"]];
    //设置搜索框背景
    UIImageView *searchTextBg =[[UIImageView alloc] initWithFrame:CGRectMake(10.5f, 11.5f, 299.0f, 35.0f)];
    [searchTextBg setImage:[UIHelper imageName:@"createGroup_text"]];
    //设置搜索框
    searchText =[[UITextField alloc] initWithFrame:CGRectMake(42.0f, 11.5f, 299.0f, 35.0f)];
    searchText.textColor =[UIColor blackColor];
    searchText.font =[UIFont systemFontOfSize:14.0f];
    searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索附近两公里的地点"
                                                                       attributes:@{NSForegroundColorAttributeName:[UIHelper colorWithHexString:@"#bcbcbc"]}];
    searchText.delegate =self;
    
    //设置透明条
    UIImageView *upLine =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 124.5f, ScreenWidth, 6.0f)];
    [upLine setImage:[UIHelper imageName:@"createGroup_line_up"]];
    UIImageView *downLine =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 286.5f, ScreenWidth, 6.0f)];
    [downLine setImage:[UIHelper imageName:@"createGroup_line_down"]];
    
    placeTable =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 292.5f, ScreenWidth, 275.0f)];
    placeTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    placeTable.delegate =self;
    placeTable.dataSource =self;
    
    //提示
    UILabel *infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 422.5f, ScreenWidth, 15.0f)];
    infoLbl.textColor =[UIHelper colorWithHexString:@"#aaaaaa"];
    infoLbl.textAlignment =NSTextAlignmentCenter;
    infoLbl.font =[UIFont boldSystemFontOfSize:12.0f];
    infoLbl.text =@"请等待加载";
    
    [topView addSubview:searchTextBg];
    [topView addSubview:searchIcon];
    [topView addSubview:searchText];
    [self.view addSubview:topView];
    [self.view addSubview:upLine];
    [self.view addSubview:downLine];
    [self.view addSubview:infoLbl];
}


/**
 *poi执行方法
 *@param pageIndex 检索序号
 */
- (void)startPOISearch:(int)pageIndex {
    BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc] init];
    nearSearchOption.pageIndex =pageIndex;
    nearSearchOption.pageCapacity =50;
    nearSearchOption.radius =2000;
    nearSearchOption.location =curLocation;
    if (searchText.text.length !=0) {
        nearSearchOption.keyword =[NSString stringWithFormat:@"%@,%@", searchText.text, key];
        
    }else {
        nearSearchOption.keyword =key;
    }
    BOOL flag = [poisearch poiSearchNearBy:nearSearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark - LocationDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [baiduMapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [baiduMapView updateLocationData:userLocation];//更新位置信息
    
    if (userLocation.location.coordinate.latitude) {
        BMKCoordinateRegion region;
        if (!isSetMapSpan)//这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
        {
            region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.05, 0.05));//越小地图显示越详细
            isSetMapSpan = YES;
            [baiduMapView setRegion:region animated:YES];//执行设定显示范围
        }
        curLocation =userLocation.location.coordinate;
        [baiduMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
        
        [locService stopUserLocationService];
        
        [self startPOISearch:page];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:baiduMapView.annotations];
	[baiduMapView removeAnnotations:array];
    
    if (result.poiInfoList.count ==0) {
        [Common showAlert:@"已无更多"];
        return;
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"检索接收成功");
        //创建数组
        NSMutableArray *places =[[NSMutableArray alloc]init];
		for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
//            [baiduMapView addAnnotation:item];
            [places addObject:@{@"name":poi.name, @"distance":[NSNumber numberWithFloat:[self distanceBetween:poi.pt]/1000.0f] }];
            
//            if(i == 0)
//            {
//                //将第一个点的坐标移到屏幕中央
//                [baiduMapView setCenterCoordinate:poi.pt animated:YES];
//            }
		}
        //table数据赋值
        [places addObject:@{@"name":@"点击加载更多", @"distance":[NSNumber numberWithFloat:-1.0f]}];
        
        if (page) {
            [placeArray removeLastObject];
            for (NSDictionary *p in places) {
                [placeArray addObject:p];
            }
        }else {
            placeArray =nil;
            placeArray =[NSMutableArray arrayWithArray:places];
        }

//        NSLog(@"%@", placeArray);
        
        [placeTable reloadData];
        [self.view addSubview:placeTable];
        
	} else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        NSLog(@"搜索词有误");
        
    }
}

/**
 *计算两点间的距离
 */
- (float)distanceBetween:(CLLocationCoordinate2D)loc1{
    BMKMapPoint mp1 =BMKMapPointForCoordinate(loc1);
    BMKMapPoint mp2 =BMKMapPointForCoordinate(curLocation);
    
    CLLocationDistance dis =BMKMetersBetweenMapPoints(mp1, mp2);
    
    return dis;
}

#pragma mark - 
#pragma TableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *place =placeArray[indexPath.row];
    
    static NSString *cellID =@"Places";
    UITableViewCell *cell = [placeTable dequeueReusableCellWithIdentifier:cellID];
    UIImageView *line =[[UIImageView alloc]initWithFrame:CGRectMake(12.5f, 39.0f, 300.0f, 1.0f)];
    [line setImage:[UIHelper setImageFromColor:[UIHelper colorWithHexString:@"#dcdcdc"]]];
    line.tag =808;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel *disLbl =[[UILabel alloc]init];
        disLbl.tag =606;
        [disLbl setFrame:CGRectMake(260.5f, 0.0f, 50.0f, 40.0f)];
        disLbl.textColor =[UIHelper colorWithHexString:@"#aaaaaa"];
        disLbl.textAlignment =NSTextAlignmentLeft;
        disLbl.font =[UIFont systemFontOfSize:14.0f];
        [cell addSubview:disLbl];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.row ==placeArray.count-1) {
        [cell.textLabel setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
        cell.textLabel.textColor =[UIHelper colorWithHexString:@"#707070"];
        cell.textLabel.textAlignment =NSTextAlignmentCenter;
        cell.textLabel.font =[UIFont systemFontOfSize:12.0f];
        cell.textLabel.text =[place objectForKey:@"name"];
        
        UILabel *disLbl =(UILabel *)[cell viewWithTag:606];
        disLbl.text =@"";
        //移除line
        UIImageView *line =(UIImageView *)[cell viewWithTag:808];
        [line removeFromSuperview];
    }else {
        [cell.textLabel setFrame:CGRectMake(12.5f, 0.0f, 300.0f, 40.0f)];
        cell.textLabel.textColor =[UIHelper colorWithHexString:@"#707070"];
        cell.textLabel.textAlignment =NSTextAlignmentLeft;
        cell.textLabel.font =[UIFont systemFontOfSize:14.0f];
        cell.textLabel.text =[place objectForKey:@"name"];
        
        UILabel *disLbl =(UILabel *)[cell viewWithTag:606];
        disLbl.text =[NSString stringWithFormat:@"%.2fkm", [[place objectForKey:@"distance"] floatValue]];
        
        if (![cell viewWithTag:808]) {
            [cell addSubview:line];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==placeArray.count-1) {
        page ++;
        [self startPOISearch:page];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[placeArray[indexPath.row] objectForKey:@"name"] forKey:CREATE_GROUP_SITE];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    page =0;
    [self startPOISearch:page];
    
    return YES;
}

@end
