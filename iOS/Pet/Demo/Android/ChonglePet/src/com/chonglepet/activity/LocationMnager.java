package com.chonglepet.activity;

import java.util.Iterator;
import java.util.List;

import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;


/**
 * 
 * @author chen
 *  
 *  @description 获得所在位置的经纬度    以及地理位置信息
 *
 */
public class LocationMnager {

	private static double latitude;
	private static double longitude;
	private static  Context context;
	
	public static LocationMnager getInstance(Context con) {
		context=con;
		getLocation();
		return new LocationMnager();
	}
	
	private static void getLocation() {
		 String serviceString=Context.LOCATION_SERVICE; 
         LocationManager locationManager=(LocationManager)context.getSystemService(serviceString); 
         
         //利用Criteria选择最优的位置服务
         Criteria criteria = new Criteria();   
         // 设置定位精确度 Criteria.ACCURACY_COARSE 比较粗略， Criteria.ACCURACY_FINE则比较精细    
         criteria.setAccuracy(Criteria.ACCURACY_FINE);   
         // 设置是否需要海拔信息 Altitude    
         criteria.setAltitudeRequired(false);   
         // 设置是否需要方位信息 Bearing    
         criteria.setBearingRequired(false);   
         // 设置是否允许运营商收费    
         criteria.setCostAllowed(true);   
         
         //// 低功耗
         //criteria.setPowerRequirement(Criteria.POWER_LOW);
         //消耗大的话，获取的频率高
         criteria.setPowerRequirement(Criteria.POWER_HIGH);

         ////使用GPS卫星             纠结了我很久的问题     就是手机里的GPS一定要打开，不然location永远为null
         String provider= locationManager.getBestProvider(criteria, true);
         
         //String provider=LocationManager.GPS_PROVIDER;   为什么这里老是出现空呢
         Location location=locationManager.getLastKnownLocation(provider); 
         
         if(location==null){
         	provider=LocationManager.NETWORK_PROVIDER;
         	location=locationManager.getLastKnownLocation(provider); 
         }
         if(location==null){
         	provider=LocationManager.GPS_PROVIDER;
         	location=locationManager.getLastKnownLocation(provider); 
         }
         
         List<String> list=locationManager.getAllProviders();
         for (Iterator iterator = list.iterator(); iterator.hasNext();) {
				String string = (String) iterator.next();
				System.out.println(string);
			}
         
         gps_loc(location);
         LocationListener GPS_listener = new LocationListener() {
             //监听位置变化，实时获取位置信息
                 @Override
                 public void onStatusChanged(String provider, int status,

                        Bundle extras) {
                 }

                 @Override
                 public void onProviderEnabled(String provider) {

                 }

                 @Override
                 public void onProviderDisabled(String provider) {

                 }

                 @Override
                 public void onLocationChanged(Location location) {
                	 //位置发生改变时
                    gps_loc(location);
                 }
             };

         locationManager.requestLocationUpdates(provider, 1000, 0, GPS_listener); 
         
	}
	
	// 获得自己位置
    private static void gps_loc(Location location) {

       if (location != null) {
           latitude = location.getLatitude();
           longitude = location.getLongitude();

       } else {
    	   latitude = 0;
    	   longitude = 0;
       }
    }
    
    public static double getLatitude(){
    	return latitude;
    }
    
    public static double getLongitude(){
    	return longitude;
    }
}
