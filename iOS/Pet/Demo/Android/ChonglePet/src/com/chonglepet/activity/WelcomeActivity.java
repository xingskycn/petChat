package com.chonglepet.activity;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;

public class WelcomeActivity extends AbstractBaseActivity {

	private TextView textView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.welcome);
		
		String str=BaseApplication.versionName+" \n---"+BaseApplication.versionCode
				+"\n-UUID-"+BaseApplication.clientUUID
				+"\n-IMEI-"+BaseApplication.IMEI
				+"\n-IMSI-"+BaseApplication.IMSI
				+"\n-osName-"+BaseApplication.osName
				+"\n-networkProvider-"+BaseApplication.networkProvider
				+"\n-ipOut-"+BaseApplication.ipOut
				+"\n-ipIn-"+BaseApplication.ipIn
				+"\n-mobileType-"+BaseApplication.mobileType
				+"\n-wifiMac-"+BaseApplication.wifiMac
				+"\n-timeZone-"+BaseApplication.timeZone
				+"\n-phoneTime-"+BaseApplication.phoneTime
				+"\n-latitude-"+BaseApplication.latitude
				+"\n-longitude-"+BaseApplication.longitude
				+"\n--"+BaseApplication.clientUUID
				+"\n--"+BaseApplication.clientUUID;
		
		/*textView=(TextView)findViewById(R.id.test);
		
		textView.setText(str);*/
		
		/*String values="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"ChonglePet\"},\"LBSInfo\":" +
				"{\"lbsTime\":\"2014-05-20 04:33:08 +0000\",\"longitude\":\"121.428696\",\"latitude\":\"31.187439\"},\"cellsInfo\":" +
				"{\"userID\":\"15678\",\"UUID\":\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\",\"IMEI\":\"1234567890987654321\",\"IMSI\":\"9876543210123456789\"" +
				",\"phonePlatform\":\"1\"},\"mobileInfo\":{\"osName\":\"Android 4.4.0\",\"networkProvider\":" +
				"\"Reachable via WiFi\",\"ipOut\":\"192.168.0.101\",\"timeZone\":\"Asia/Shanghai (GMT+8) offset 28800\",\"phoneTime\":\"2014-05-14 07:20:18 +0000\",\"contact\":\"\"" +
				",\"mobileType\":\"Sumsung G S5\",\"ipIn\":\"192.168.0.101\"}}";
		
		Log.e("aaaaaaaaaa", value.toString());
		Log.e("aaaaaaaaaa", values);
		 */
		
		
	}
	
	@Override
	protected void initRequestListDate() {
		StringBuffer value=new StringBuffer("{\"apiInfo\":{\"version\":\"");
		value.append(BaseApplication.versionCode+"\",");
		value.append("\"appName\":\""+BaseApplication.versionName);
		value.append("\"},\"LBSInfo\":{\"lbsTime\":\""+BaseApplication.lbsTime);
		value.append("\",\"longitude\":\""+BaseApplication.longitude);
		value.append("\",\"latitude\":\""+BaseApplication.latitude);
		value.append("\"},\"cellsInfo\":{\"userID\":\""+BaseApplication.userID);
		value.append("\",\"UUID\":\""+BaseApplication.clientUUID);
		value.append("\",\"IMEI\":\""+BaseApplication.IMEI);
		value.append("\",\"IMSI\":\""+BaseApplication.IMSI);
		value.append("\",\"phonePlatform\":\""+BaseApplication.phonePlatform);
		value.append("\"},\"mobileInfo\":{\"osName\":\""+BaseApplication.osName);
		value.append("\",\"networkProvider\":\""+BaseApplication.networkProvider);
		value.append("\",\"ipOut\":\""+BaseApplication.ipOut);
		value.append("\",\"timeZone\":\""+BaseApplication.timeZone);
		value.append("\",\"phoneTime\":\""+BaseApplication.phoneTime);
		value.append("\",\"contact\":\""+BaseApplication.contact);
		value.append("\",\"mobileType\":\""+BaseApplication.mobileType);
		value.append("\",\"ipIn\":\""+BaseApplication.ipIn+"\"}}");
		
		onRequsetViewDateList(CommonConfig.STARTAPP_TASK,CommonConfig.startAppUrl,"startApp",value.toString());
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		
		JSONObject jsonObject;
		try {
			jsonObject = (JSONObject) jsonTokener.nextValue();
			switch (taskId) {
			case CommonConfig.STARTAPP_TASK:
				String text=jsonObject.toString();
				//textView.setText(text);
				Intent intent=new Intent(WelcomeActivity.this, TabMainActivity.class);
				startActivity(intent);
				finish();
				
				break;
				
			default:
				break;
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		super.onTaskRequestSuccess(taskId, jsonTokener);
	}

}
