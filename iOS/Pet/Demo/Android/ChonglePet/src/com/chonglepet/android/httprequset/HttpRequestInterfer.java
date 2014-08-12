package com.chonglepet.android.httprequset;

import org.json.JSONTokener;

import android.graphics.Bitmap;

public interface HttpRequestInterfer {

	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject);
	
	public void onTaskRequestImageSuccess(int taskId, Bitmap bitmap);
	
	public void onTaskRequestStart(int taskId);
	
	public void onTaskRequestFailure(int taskId);
	
	public void onTaskRequestProgress(int taskId,Integer... values);
}
