package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.image.ImageZoomState;
import com.chonglepet.android.image.ImageZoomView;
import com.chonglepet.android.image.SimpleImageZoomListener;

/**
 * @author chen   
 *  @description   用于图片查看
 */
public class ImageActivity extends AbstractBaseActivity {

	private View zoomViewLayout;
	private ImageZoomView zoomView;// 自定义的图片显示组件
	private ImageZoomState zoomState;// 图片缩放和移动状态类
	private SimpleImageZoomListener zoomListener;// 缩放事件监听器
	
	private ProgressDialog progressDialog;
	
	private ViewPager viewPager; 
	
	private final int TASK_IMAGE_LOADING=15;
	
	private int count=1;
	private int position;
	
	private List<View> list=new ArrayList<View>();
	
	private Bitmap bitmap; // 要显示的图片位图
	private String imageUrl;  
	private String[] imageid;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		setContentView(R.layout.image_viewpage);
		viewPager=(ViewPager)findViewById(R.id.imageViewpage);
		
		//这边有的时候穿过来的可能是图片    有的时候可能是路径   有可能是图片路径集合
		Intent intent=getIntent();
		imageUrl=intent.getExtras().getString("imageurl");
		imageid=intent.getExtras().getStringArray("imageurl");
		position=intent.getExtras().getInt("position");

		initprogressdialog(); 
		
		bitmap=BitmapFactory.decodeResource(getResources(), R.drawable.logo_120);
		
		if(imageUrl!=null){
			onRequestLoadingIamge(TASK_IMAGE_LOADING, imageUrl);
		}
		if(imageid!=null){
			for (int i = 0; i < imageid.length; i++) {
				onRequestLoadingIamge(TASK_IMAGE_LOADING, imageid[i]);
				
			}
		}
		
		/*bitmap=BitmapFactory.decodeResource(getResources(), R.drawable.logo_120);
		onRequestLoadingIamge(TASK_IMAGE_LOADING, imageid[0]);
		for (int i = 0; i < imageid.length; i++) {
			list.add(initZoomView(bitmap));
			count++;
			if(count==imageid.length){
			}
		}
		viewPager.setAdapter(new Myadapter());
		viewPager.setCurrentItem(position);
		viewPager.setOnPageChangeListener(new MyOnPageChangeListener());*/
		
	}
	@Override
	public void onTaskRequestStart(int taskId) {

	}
	
	@Override
	public void onTaskRequestImageSuccess(int taskId, Bitmap bitmap1) {
		//super.onTaskRequestImageSuccess(taskId, bitmap1);
		switch (taskId) {
		case TASK_IMAGE_LOADING:
			
			progressDialog.dismiss();
			
			list.add(initZoomView(bitmap1));
			count++;
			if(imageUrl!=null){
				viewPager.setAdapter(new Myadapter());
				viewPager.setCurrentItem(position);
			}
			if(imageid!=null){
				if(count==imageid.length){
					viewPager.setAdapter(new Myadapter());
					viewPager.setCurrentItem(position);
					viewPager.setOnPageChangeListener(new MyOnPageChangeListener());
				}
			}
			break;

		default:
			break;
		}
	}
	
	public void initprogressdialog(){
		
		progressDialog=new ProgressDialog(this);
		//设置风格为圆形进度条  
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage("正在加载图片.....");
		progressDialog.setIndeterminate(false);
		progressDialog.setCancelable(true);
		
		progressDialog.setCanceledOnTouchOutside(false);
		progressDialog.show();
	}
	
	private View initZoomView(Bitmap bitmap) {
		
		zoomViewLayout=LayoutInflater.from(ImageActivity.this).inflate(R.layout.image, null);
		
		zoomState = new ImageZoomState();
		
		zoomListener = new SimpleImageZoomListener();
		zoomListener.setZoomState(zoomState);
		
		/*zoomCtrl = (ZoomControls) findViewById(R.id.zoomCtrl);
			setImageController();
		 */
		
		zoomView = (ImageZoomView)zoomViewLayout.findViewById(R.id.zoomView);
		
		
		int w = bitmap.getWidth();
		int h = bitmap.getHeight();
		
		Bitmap rotatedBMP = Bitmap.createBitmap(bitmap, 0, 0, w, h, null, true);
		//BitmapDrawable bmd = new BitmapDrawable(rotatedBMP);
		
		zoomView.setImage(rotatedBMP);
		zoomView.setImageZoomState(zoomState);
		zoomView.setOnTouchListener(zoomListener);
		zoomView.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//Toast.makeText(WebImageActivity.this, "aaa", 0).show();
				//图片点击的时候不能动    动了的话   不会执行这个方法
				//setFullScreen();
			}
		});
		
		//linearLayout.addView(zoomViewLayout);
		
		return zoomViewLayout;
	};
	
	
	class Myadapter extends PagerAdapter{

		@Override
		public int getCount() {
			return list.size();
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0==arg1;
		}
		
		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			((ViewPager)container).addView(list.get(position));
			return list.get(position);
		}
		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			((ViewPager)container).removeView(list.get(position));
		}
		
	}
	
	public class MyOnPageChangeListener implements OnPageChangeListener{

		@Override
		public void onPageScrollStateChanged(int arg0) {
			//toastShow(""+arg0);
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
			//toastShow(arg1+":sss:"+arg0+":"+arg2);
		}

		@Override
		public void onPageSelected(int arg0) {
			toastShow("dddd"+arg0);
		}

	}
	
}

