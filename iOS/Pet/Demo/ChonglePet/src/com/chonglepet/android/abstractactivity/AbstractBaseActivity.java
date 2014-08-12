package com.chonglepet.android.abstractactivity;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONTokener;

import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.CommonConfig;
import com.chonglepet.activity.R;
import com.chonglepet.android.entity.Parameter;
import com.chonglepet.android.httprequset.HttpRequestManager;

public abstract class AbstractBaseActivity extends HttpRequestManager implements OnClickListener{
	
	protected Button head_left_button,head_right_button;
	
	protected TextView head_center_textview;
	
	private Dialog dialog;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		initHeadTitleLayout();
		
		initRequestListDate();
		
	}
	
	protected void initHeadTitleLayout() {
		/*head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setOnClickListener(this);
		head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setOnClickListener(this);
		head_center_textview=(TextView)findViewById(R.id.head_center_textview);*/
	}
	
	protected void initRequestListDate() {

	}
	
	protected void initRequestLoading(){
		View layout2 = getLayoutInflater().inflate(R.layout.loading,null);
		ImageView imageView=(ImageView)layout2.findViewById(R.id.img);
		imageView.setBackgroundResource(R.anim.loading);
		AnimationDrawable animationDrawable=(AnimationDrawable)imageView.getDrawable();
		animationDrawable.start();
		
		dialog=new Dialog(this, R.style.CustomProgressDialog);
		dialog.setContentView(layout2);
		dialog.setCanceledOnTouchOutside(false);
		//dialog.show();
	}
	
	@Override
	public void onTaskRequestStart(int taskId) {
		super.onTaskRequestStart(taskId);
		initRequestLoading();
	}
	
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		super.onTaskRequestSuccess(taskId, jsonTokener);
		dialog.dismiss();
	}
	
	@Override
	public void onTaskRequestImageSuccess(int taskId, Bitmap bitmap) {
		super.onTaskRequestImageSuccess(taskId, bitmap);
		dialog.dismiss();
	}
	
	@Override
	public void onTaskRequestFailure(int taskId) {
		super.onTaskRequestFailure(taskId);
	}
	
	protected void toastShow(String toastString) {
		
		Toast.makeText(this, toastString, Toast.LENGTH_SHORT).show();
	}
	
	/**
	 * 上传图片    返回一个图片的URL
	 */    
	protected void uploadImage(int taskId,String imageUploadUrl,String add_chattingImages,String addValue,String chatting_images,String iamgeUrl){
		
		List<Parameter> params=new ArrayList<Parameter>();
		params =new ArrayList<Parameter>();
		Parameter parameter=new Parameter();
		parameter.setRequestHttpKey(add_chattingImages);
		parameter.setValue(addValue);
		params.add(parameter);
		
		parameter=new Parameter();
		parameter.setRequestHttpKey(chatting_images);
		parameter.setValue(iamgeUrl);
		params.add(parameter);
		onRequestImageUpload(taskId, imageUploadUrl, params);
		
	}
	
	/**
	 * 上传视频的   返回一个图片的URL
	 * @param iamgeUrl
	 */
	protected void uploadVedio(String iamgeUrl,String get_mainVideo_key,String getMainVedeoValue){
		
		List<Parameter> params=new ArrayList<Parameter>();
		params =new ArrayList<Parameter>();
		Parameter parameter=new Parameter();
		parameter.setRequestHttpKey("get_mainVideo_android");
		parameter.setValue("{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"}}");
		params.add(parameter);
		
//			parameter=new Parameter();
//			parameter.setRequestHttpKey("chatting_images");
//			parameter.setValue(iamgeUrl);
//			params.add(parameter);
		onRequestVedioUpload(CommonConfig.PET_VEDIO_UPLOAD, CommonConfig.addUploadVedioUrl, params);
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode==KeyEvent.KEYCODE_BACK){
			onBackActivity();
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onClick(View v) {
		if(v==head_left_button){
			onBackActivity();
		}
	}
	
	private void onBackActivity() {
		finish();
		overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
	}
}
