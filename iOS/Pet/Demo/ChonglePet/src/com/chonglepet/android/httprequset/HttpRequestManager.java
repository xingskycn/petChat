package com.chonglepet.android.httprequset;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONTokener;

import android.app.Activity;
import android.graphics.Bitmap;

import com.chonglepet.android.entity.Parameter;
import com.chonglepet.android.httprequset.HttpRequsetCallback.RequestType;

/**
 * 
 * @author chen
 * 
 *  各种请求网络数据
 *
 */

public class HttpRequestManager extends Activity implements HttpRequestInterfer{
	
	
	protected void onRequsetViewDateList(int taskId,String requestUrl,String requestHttpKey,String value) {
		
		Parameter parameter=new Parameter();
		parameter.setRequestHttpKey(requestHttpKey);
		parameter.setValue(value);
		List<Parameter> params=new ArrayList<Parameter>();
		params.add(parameter);
		HttpRequsetCallback httpRequsetCallback=new HttpRequsetCallback(taskId, this,RequestType.REQUEST_VIEW_LIST_DATE,requestUrl,params);
		httpRequsetCallback.execute();
	}
	
	protected void onRequestImageUpload(int taskId,String requestUrl, List<Parameter> params){
		
		HttpRequsetCallback httpRequsetCallback=new HttpRequsetCallback(taskId, this,RequestType.REQUEST_UPLOAD_IMAGE,requestUrl,params);
		httpRequsetCallback.execute();
	}
	
	protected void onRequestVedioUpload(int taskId,String requestUrl, List<Parameter> params){
		
		HttpRequsetCallback httpRequsetCallback=new HttpRequsetCallback(taskId, this,RequestType.REQUEST_UPLOAD_VEDIO,requestUrl,params);
		httpRequsetCallback.execute();
	}

	protected void onRequestLoadingIamge(int taskId,String imageUrl) {
		HttpRequsetCallback httpRequsetCallback=new HttpRequsetCallback(taskId, this,RequestType.REQUEST_LOADING_IMAGE,imageUrl,null);
		httpRequsetCallback.execute();
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		
	}

	@Override
	public void onTaskRequestStart(int taskId) {
		
	}

	@Override
	public void onTaskRequestFailure(int taskId) {
		
	}

	@Override
	public void onTaskRequestProgress(int taskId, Integer... values) {
		
	}

	@Override
	public void onTaskRequestImageSuccess(int taskId, Bitmap bitmap) {
		
	}
	
}
