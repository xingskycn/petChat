package com.chonglepet.android.httprequset;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.graphics.Bitmap;
import android.graphics.Paint.Join;
import android.os.AsyncTask;

import com.chonglepet.activity.CommonConfig;
import com.chonglepet.android.entity.Parameter;

public class HttpRequsetCallback extends AsyncTask<Object, Integer, JSONTokener>{
	
	private int taskId;
	
	private HttpRequestInterfer httpRequestInterfer;
	
	private JSONTokener jsonObject;
	
	private String requestUrl;
	
	private List<Parameter> parameters;
	
	private RequestType requestType;
	
	private Bitmap bitmap;
	
	
	public HttpRequsetCallback(int taskId,HttpRequestInterfer httpRequestInterfer,RequestType requestType,
			String requestUrl,List<Parameter> parameters) {
		this.taskId=taskId;
		this.httpRequestInterfer=httpRequestInterfer;
		this.requestType=requestType;
		this.requestUrl=requestUrl;
		this.parameters=parameters;
	}

	
	@Override
	protected JSONTokener doInBackground(Object... params) {
		
		try {
			HttpHelper httpHelper=new HttpHelper();
			List<BasicNameValuePair> paramer=new ArrayList<BasicNameValuePair>();
			
			if(parameters!=null){
				for (int i = 0; i < parameters.size(); i++) {
					Parameter parameter=parameters.get(i);
					paramer.add(new BasicNameValuePair(parameter.getRequestHttpKey(), parameter.getValue()));
					
				}
			}
			
			String obj="";
			if(requestType==RequestType.REQUEST_VIEW_LIST_DATE){
				httpHelper.initHttpClient(requestUrl);
				obj=httpHelper.execute(paramer);
			}
			if(requestType==RequestType.REQUEST_UPLOAD_IMAGE){
				/*String uploadFile="/storage/sdcard0/chongle/img/test1.png"; 
				uploadFile="/storage/sdcard0/照相机/Camera/VID_20140604_122836.3gp";
				uploadFile="/storage/sdcard0/照相机/Camera/IMG_20140502_004828.jpg";*/
				//String actionUrl="http://173.255.221.74/xampp/petAPI/chattingMgr/add_chattingImages_android.php";
				
				String value=parameters.get(0).getValue();
				String uploadFile=parameters.get(1).getValue();
				obj=httpHelper.uploadFile_Paramters(value,requestUrl,uploadFile);
			}
			if(requestType==RequestType.REQUEST_UPLOAD_VEDIO){
				Parameter parameter=parameters.get(0);
				paramer.add(new BasicNameValuePair(parameter.getRequestHttpKey(), parameter.getValue()));
				httpHelper.initHttpClient(CommonConfig.addUploadVedioUrl);
				String addChatResult=httpHelper.execute(paramer);
				JSONObject chatJson=new JSONObject(addChatResult);
				String result=chatJson.getString("result");
				if(result.equals("0")){
					parameter=parameters.get(1);
					//obj=httpHelper.executeUploadFile(requestUrl,parameter.getValue());
					//obj=httpHelper.executeUploadFile();
				}
				
			}
			
			if(requestType==RequestType.REQUEST_LOADING_IMAGE){
				bitmap=httpHelper.executeImageLoad(requestUrl);
			}
			
			jsonObject=new JSONTokener(obj);
 			
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		
		httpRequestInterfer.onTaskRequestStart(taskId);
	}
	
	@Override
	protected void onPostExecute(JSONTokener result) {
		super.onPostExecute(result);
		
		if(jsonObject!=null){
			httpRequestInterfer.onTaskRequestSuccess(taskId, jsonObject);
		}
		else if(bitmap!=null){
			httpRequestInterfer.onTaskRequestImageSuccess(taskId, bitmap);
		}
		else{
			httpRequestInterfer.onTaskRequestFailure(taskId);
		}
	}
	
	@Override
	protected void onProgressUpdate(Integer... values) {
		super.onProgressUpdate(values);
		httpRequestInterfer.onTaskRequestProgress(taskId,values);
	}
	
	public enum RequestType{
		
		REQUEST_UPLOAD_IMAGE,  //上传图片
		
		REQUEST_LOADING_IMAGE,  //加载图片
		
		REQUEST_UPLOAD_VEDIO,  //上传视频
		
		REQUEST_VIEW_LIST_DATE;  //获取列表数据
		
	}

}
