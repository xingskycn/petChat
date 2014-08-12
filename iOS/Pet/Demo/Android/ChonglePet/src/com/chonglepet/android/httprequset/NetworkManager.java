package com.chonglepet.android.httprequset;

import android.content.Context;
import android.net.ConnectivityManager;

/**
 * 检测网络是否正常
 * @author chen
 * 
 */
public class NetworkManager {

	public static boolean isNetworkAvailable(Context context) {
		try {
			ConnectivityManager cm = (ConnectivityManager) context
					.getSystemService(Context.CONNECTIVITY_SERVICE);
			if(cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI).isConnectedOrConnecting()){
				return true;
			}
			if(cm.getNetworkInfo(ConnectivityManager.TYPE_MOBILE)!=null && cm.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).isConnectedOrConnecting()){
				return true;
			}
		} catch (Exception e) {
			return false;
		}
		return false;
	}
}
