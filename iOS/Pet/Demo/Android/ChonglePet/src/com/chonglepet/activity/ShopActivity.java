package com.chonglepet.activity;

import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.BMapManager;
import com.baidu.mapapi.map.LocationData;
import com.baidu.mapapi.map.MKEvent;
import com.baidu.mapapi.map.MapController;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MyLocationOverlay;
import com.baidu.mapapi.map.PoiOverlay;
import com.baidu.mapapi.search.MKAddrInfo;
import com.baidu.mapapi.search.MKBusLineResult;
import com.baidu.mapapi.search.MKDrivingRouteResult;
import com.baidu.mapapi.search.MKPoiInfo;
import com.baidu.mapapi.search.MKPoiResult;
import com.baidu.mapapi.search.MKSearch;
import com.baidu.mapapi.search.MKSearchListener;
import com.baidu.mapapi.search.MKSuggestionResult;
import com.baidu.mapapi.search.MKTransitRouteResult;
import com.baidu.mapapi.search.MKWalkingRouteResult;
import com.baidu.platform.comapi.basestruct.GeoPoint;

/**
 * 
 * @author chen
 * 
 * 百度地图    功能比较强大
 * 
 * http://blog.csdn.net/xiaanming/article/details/11380619  这个可以看看
 *
 */

public class ShopActivity extends Activity {

	 private static final String TAG = "TIAN";//测试用
	 private int flag=0;//用于图层之间的切换
	 
	 private TextView textView1;
	 private Button button1,search;
	 private MapView mMapView;//显示地图的View
	 private MapController mMapController;//地图控制器
	 private LocationClient mLocationClient;//定位SDK的核心类
	 private LocationData locData;//存储用户位置信息数据
	 private BDLocation mBDLocation=null;//封装了定位SDK的定位结果
	 private MyLocationOverlay mLocationOverlay;//标注我的位置的覆盖物
	 private BDLocationListener mLocationListener = new MyLocationListener();;//作用：获取定位结果，获取POI信息
	 /** 搜索服务*/
	 private MKSearch mkSearch=null;
	 
	 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		 BaseApplication app = (BaseApplication)this.getApplication();
		 if (app.mBMapManager == null) {
			 app.mBMapManager = new BMapManager(app.mContext);
			 app.initEngineManager();
		 }
		 //注意：请在试用setContentView前初始化BMapManager对象，否则会报错
		 setContentView(R.layout.activity_shop);
		 mMapView=(MapView)findViewById(R.id.bmapsView);
		 mMapView.setBuiltInZoomControls(true);//设置启用内置的缩放控件
		 
		 mMapController=mMapView.getController();// 得到mMapView的控制权,可以用它控制和驱动平移和缩放
		 mMapController.enableClick(true);
		 mMapController.setZoom(12);//设置地图zoom级别
		 
		 locData=new LocationData();
		 
		 mLocationClient = new LocationClient(this);
		 mLocationClient.registerLocationListener(mLocationListener);//注册监听函数
		 
		 //设置定位参数
		 LocationClientOption locationOption = new LocationClientOption();
		 locationOption.setOpenGps(true);
		 locationOption.setAddrType("all");//返回的定位结果包含地址信息
		 locationOption.setCoorType("bd09ll");//返回的定位结果是百度经纬度,默认值gcj02
		 //locationOption.disableCache(true);//禁止启用缓存定位
		 locationOption.setPriority(LocationClientOption.GpsFirst);//设置定位方式的优先级
		 locationOption.setAddrType("all");//返回的定位结果包含地址信息
		 locationOption.setPoiExtraInfo(true); //是否需要POI的电话和地址等详细信息
		 //locationOption.setScanSpan(2000);//设置定时定位的时间间隔。单位ms
		 locationOption.setProdName("自我定位");
		 mLocationClient.setLocOption(locationOption);
		 mLocationClient.start();
		 
		 mLocationOverlay=new MLocationOverlay(mMapView);
		 
		 mkSearch=new MKSearch();
		 mkSearch.init(app.mBMapManager, new MyPoin());
		 
		 button1 = (Button)findViewById(R.id.button);//按钮用于卫星图和平面图切换
		 button1.setText("进入卫星图");
		 button1.setOnClickListener(new View.OnClickListener() {		
			 @Override
			 public void onClick(View v) {
				 if(flag == 0)  
				 {  
					 flag = flag+1;  
					 mMapView.setSatellite(true);//打开卫星图
					 button1.setText("进入普通地图");  
				 }else if(flag == 1)  
				 {  
					 flag = 0;  
					 mMapView.setSatellite(false);//关闭卫星图  
					 button1.setText("进入卫星图");  
				 }  
			 }
		 });
		 
		 search=(Button)findViewById(R.id.search);
		 search.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Toast.makeText(ShopActivity.this, locData.latitude+":  "+locData.longitude, 0).show();
				
				double lat=31.191884;
				double lon=121.439583;
				
				double lat2=31.221884;
				double lon2=121.459583;
		        GeoPoint ptLB = new GeoPoint( (int)(lat * 1E6),(int)(lon * 1E6));   
		        GeoPoint ptRT = new GeoPoint( (int)(lat2 * 1E6),(int)(lon2 * 1E6));  
		        mkSearch.poiSearchInbounds("KTV", ptLB, ptRT); 
			}
		});
	}
	
	//检索
	class MyPoin implements MKSearchListener{

		@Override
		public void onGetAddrResult(MKAddrInfo arg0, int arg1) {
			
			
		}

		@Override
		public void onGetBusDetailResult(MKBusLineResult arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onGetDrivingRouteResult(MKDrivingRouteResult arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onGetPoiDetailSearchResult(int arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onGetPoiResult(MKPoiResult res, int type, int error) {
			// 错误号可参考MKEvent中的定义  
			if ( error == MKEvent.ERROR_RESULT_NOT_FOUND){  
				Toast.makeText(ShopActivity.this, "抱歉，未找到结果",Toast.LENGTH_LONG).show();  
				return ;  
			        }  
			        else if (error != 0 || res == null) {  
			Toast.makeText(ShopActivity.this, "搜索出错啦..", Toast.LENGTH_LONG).show();  
			return;  
			} 
			// 将poi结果显示到地图上  
			PoiOverlay poiOverlay = new PoiOverlay(ShopActivity.this, mMapView);  
			poiOverlay.setData(res.getAllPoi());  
			mMapView.getOverlays().clear();  
			mMapView.getOverlays().add(poiOverlay);  
			mMapView.refresh();  
			//当ePoiType为2（公交线路）或4（地铁线路）时， poi坐标为空  
			for(MKPoiInfo info : res.getAllPoi() ){  
				if ( info.pt != null ){  
					mMapView.getController().animateTo(info.pt);  
					break;  
				}  
			}  
			
		}

		@Override
		public void onGetSuggestionResult(MKSuggestionResult arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onGetTransitRouteResult(MKTransitRouteResult arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onGetWalkingRouteResult(MKWalkingRouteResult arg0, int arg1) {
			// TODO Auto-generated method stub
			
		}
		
	}
	
	class MyLocationListener implements BDLocationListener {//BDLocationListener获取定位结果，获取POI信息
		
		@Override
		public void onReceiveLocation(BDLocation location) {
			if (location == null) {
				return;
			}
			//在地图上标注定位得到我当前的位置
			markLocation(location);
			mBDLocation = location;
		}
		
		@Override
		public void onReceivePoi(BDLocation location) {
			// TODO Auto-generated method stub
		}
		
	}
	
	//覆盖物
	class MLocationOverlay extends MyLocationOverlay {//显示用户当前位置的Overlay
		public MLocationOverlay(MapView mapView){
			super(mapView);
		}
		
		@Override
		public boolean enableCompass() {
			// TODO Auto-generated method stub
			return super.enableCompass();
		}
		
		@Override
		public void setData(LocationData arg0) {
			super.setData(arg0);
		}
		
		// 处理在“我的位置”坐标上的点击事件。
		@Override
		protected boolean dispatchTap() {//处理在“我的位置”坐标上的点击事件 dispatchTap()
			if (mBDLocation.getAddrStr() != null) {
				Toast.makeText(ShopActivity.this, "我的位置"+mBDLocation.getAddrStr(), Toast.LENGTH_LONG).show();
			}else{
				Toast.makeText(ShopActivity.this, "无法获得我的位置", Toast.LENGTH_LONG).show();
			}
			return super.dispatchTap();
		}

	}

	private void markLocation(BDLocation location) {//在地图上标注定位得到我当前的位置
		locData.latitude = location.getLatitude();//获取维度
		locData.longitude = location.getLongitude();//获取经度
		locData.direction = location.getDerect();
		
		// 判断是否有定位精度半径
		if (location.hasRadius()) {
			// 获取定位精度半径，单位是米
			locData.accuracy = location.getRadius();
		}
		mLocationOverlay.enableCompass();//打开指南针
		mLocationOverlay.setData(locData);//设置位置数据
		//Overlay是一个基类，它表示可以显示在地图上方的覆盖物
		mMapView.getOverlays().add(mLocationOverlay);//获取Overlay列表。 这个列表中的任何一个 Overlay都将被绘制（以升序方式），都能收到事件（以降序方式，直到返回true）。
		mMapView.refresh();
		
		// 将我的当前位置移动到地图的中心点
		mMapController.animateTo(new GeoPoint(
				(int) (locData.latitude * 1e6), 
				(int) (locData.longitude * 1e6)));
	}    
	
	@Override
	protected void onDestroy() {//Activity被回收时调用
		mMapView.destroy();
		BaseApplication app = (BaseApplication)this.getApplication();
		if (app.mBMapManager != null) {
			app.mBMapManager.destroy();
			app.mBMapManager = null;
		}
		if(mLocationClient!=null){
			mLocationClient.stop();
			mLocationClient.unRegisterLocationListener(mLocationListener);
		}
		//this.getApplicationContext();
		super.onDestroy();
	}
	
	@Override
	protected void onPause() {//Activity从活动状态（前景画面）到暂停状态（背景画面）时调用
		mMapView.onPause();
		super.onPause();
	}
	
	@Override
	protected void onResume() {//Activity从不可见状态到活动状态（前景画面）时调用
		//或从暂停状态回到活动状态（前景画面）时调用
		mMapView.onResume();
		super.onResume();
	}
	
	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		mMapView.onSaveInstanceState(outState);
	}
	
	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState);
		mMapView.onRestoreInstanceState(savedInstanceState);
	}
	
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
	}
}
