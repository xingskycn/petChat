package com.chonglepet.activity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.TimeZone;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.widget.Toast;

import com.baidu.mapapi.BMapManager;
import com.baidu.mapapi.MKGeneralListener;
import com.baidu.mapapi.map.MKEvent;


/**
 * 
 * @author chen
 * 
 *  @description 用于初始化获得IMEI码   以及设备信息 
 *
 */
@SuppressLint("SimpleDateFormat")
public class BaseApplication extends Application{

	
	public static int versionCode; //版本
	
	public static String versionName;  //版本名称
	
	public static String lbsTime; 
	
	public static double longitude; 
	
	public static double latitude;
	
	public static String userID;

	public static String clientUUID;
	
	public static String IMEI=null;  //获得手机的IMEI码
	
	public static String IMSI=null;  //(国际移动用户识别码)
	
	public static int phonePlatform=1; //0 代表iOS   1代表Android
	
	public static String osName; //手机版本
	
	public static int networkProvider; 
	
	public static String ipOut;
	
	public static String timeZone;
	
	public static String phoneTime;
	
	public static String contact="";  //手机设备信息
	
	public static String mobileType; 
	
	public static String ipIn;
	
	public static String wifiMac;  //WiFi mac地址  及物理地址
	
	public TelephonyManager telephonyManager;
	
	BMapManager mBMapManager = null;//BMapManager地图引擎管理类
    Context mContext;
    public static final String strKey = "23A8191CBBAED2446738894C62DD2CE367F6894A";
	
	@Override
	public void onCreate() {
		
		super.onCreate();

		telephonyManager=(TelephonyManager)this.getSystemService(TELEPHONY_SERVICE);
		
		initClientInfo();
		
		initLBSInfo();
		
		initMobileInfo();
		
		//初始化地图
		mContext = getApplicationContext();
		mBMapManager = new BMapManager(getApplicationContext());
		initEngineManager();
	}
	
	/**
	 * 初始化客户端信息
	 */
	public void initClientInfo() {
		try {
		
			PackageInfo packageInfo = getPackageManager().getPackageInfo(getPackageName(), 0);

			versionCode=packageInfo.versionCode;
			versionName=packageInfo.versionName;

			DisplayMetrics dm =getResources().getDisplayMetrics();  
			CommonConfig.mobileWidth = dm.widthPixels;  
			CommonConfig.mobieHeigth = dm.heightPixels; 
			CommonConfig.mobieDpi=dm.densityDpi;
			 
			//默认为
			userID=null;
			
			//UUID uuid=UUID.randomUUID();
			
			IMEI=telephonyManager.getDeviceId();
			IMSI=telephonyManager.getSubscriberId();
			
			if(IMSI==null){
				long date=System.currentTimeMillis();
				SimpleDateFormat format=new SimpleDateFormat("yyyyMMddhhmmssSSS");
				IMSI=format.format(date);
				Random random=new Random();
				int rand=random.nextInt(100000);
				IMSI=IMSI+rand;
			}
			if(IMEI.length()<15){
				IMEI="-"+telephonyManager.getDeviceId()+"-";
			}
			
			String uuidSting=IMEI+IMSI;
			StringBuffer uuid=new StringBuffer("-");
			int j=uuidSting.length()/4;
			for (int i = 0; i < j; i++) {
				String u=uuidSting.substring(4*i, 4*(i+1));
				uuid.append(u+"-");
			}
			uuid.append("UUID-");
			
			clientUUID=uuid.toString();
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 初始化手机地理位置信息
	 */
	public void initLBSInfo() {
		long date=System.currentTimeMillis();
		Date time=new Date(date);
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		lbsTime=simpleDateFormat.format(date);
		
		latitude=LocationMnager.getInstance(this).getLatitude();
		longitude=LocationMnager.getInstance(this).getLongitude();

	}
	
	/**
	 * 初始化手机信息
	 */
	public void initMobileInfo() {
		osName=Build.VERSION.RELEASE;
		osName="Android "+osName;
		networkProvider=telephonyManager.getNetworkType();  //3 表示UMTS网络
		
		WifiManager wifiManager=(WifiManager)getSystemService(WIFI_SERVICE);
		
		
		ipOut="192.168.0.101";
		
		long date=System.currentTimeMillis();
		Date time=new Date(date);
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		TimeZone tz=TimeZone.getDefault();
		timeZone =tz.getID(); 
		
		phoneTime=simpleDateFormat.format(time);
		contact="";
		//手机型号
		mobileType=Build.BOARD;
		if(wifiManager.isWifiEnabled()){
			WifiInfo wifiInfo=wifiManager.getConnectionInfo();
			ipIn=intToIp(wifiInfo.getIpAddress());
			wifiMac=wifiInfo.getMacAddress();
		}

	}
	
	private String intToIp(int ip)  {
	     return (ip & 0xFF)+ "." + ((ip >> 8 ) & 0xFF) + "." + ((ip >> 16 ) & 0xFF) +"."+((ip >> 24 ) & 0xFF);
	}
	
	//建议在您app的退出之前调用mapapi的destroy()函数，避免重复初始化带来的时间消耗
	@Override
	public void onTerminate() {
	    if (mBMapManager != null) {
            mBMapManager.destroy();
            mBMapManager = null;
        }
		super.onTerminate();
	}
	
	public void initEngineManager() {
        if (!mBMapManager.init(strKey,new MyGeneralListener())) {
            Toast.makeText(getApplicationContext(), 
                    "初始化地图引擎失败!", Toast.LENGTH_LONG).show();
        }
	}
	
    class MyGeneralListener implements MKGeneralListener {//常用事件监听，用来处理通常的网络错误，授权验证错误等
    	//MKGeneralListener该接口返回网络状态，授权验证等结果，用户需要实现该接口以处理相应事件
        @Override
        public void onGetNetworkState(int iError) {
            if (iError == MKEvent.ERROR_NETWORK_CONNECT) {
                Toast.makeText(getApplicationContext(), "网络未连接，请检查网络后重试！",
                    Toast.LENGTH_LONG).show();
            }
            else if (iError == MKEvent.ERROR_NETWORK_DATA) {
                Toast.makeText(getApplicationContext(), "输入正确的检索条件！",
                        Toast.LENGTH_LONG).show();
            }
        }

        @Override
        public void onGetPermissionState(int iError) {
            if (iError ==  MKEvent.ERROR_PERMISSION_DENIED) {
                //授权Key错误：
                Toast.makeText(getApplicationContext(), 
                        "请在 MyApplication.java文件输入正确的授权Key！", Toast.LENGTH_LONG).show();
            }
        }
    }
	
}
