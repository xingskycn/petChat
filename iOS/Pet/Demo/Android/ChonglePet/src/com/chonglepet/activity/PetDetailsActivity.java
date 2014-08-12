package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.PetDetailGridviewAdapter;
import com.chonglepet.android.adapter.PetDetailViewpageAdapter;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author 陈永兵
 * 
 *  宠物详情页面
 */
public class PetDetailsActivity extends AbstractBaseActivity {
	
	private List<Map<String, String>> list=new ArrayList<Map<String,String>>();
	
	private ViewPager viewPager;
	
	private int pageNumber;
	
	private String[] imageurl;
	
	private String petImageUrl;
	
	private String userImageUrl;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.activity_pet_details);
		
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		head_left_button=(Button)findViewById(R.id.head_left_button);
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("详情");
	}
	
	@Override
	protected void initRequestListDate() {
		String requestUrl=CommonConfig.petDetailUrl;
		String requestHttpKey="petDetails";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":" +
				"{\"userID\":\"15678\",\"UUID\":\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"},\"petInfo\":{" +
				"\"petID\":\"24155\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_DETAIL_TASK, requestUrl, requestHttpKey, value);
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		switch (taskId) {
		case CommonConfig.PET_DETAIL_TASK:
			
			loadingDetailDate(jsonObject);
			
			loadindDetailViewpage();
			
			break;

		default:
			break;
		}
		super.onTaskRequestSuccess(taskId, jsonObject);
	}
	
	private void loadindDetailViewpage() {
		
		viewPager=(ViewPager)this.findViewById(R.id.detailViewpage);
		//总共有多少页
		int pagetotal=(list.size())%PetDetailGridviewAdapter.pageNumber == 0 ? (list.size())/PetDetailGridviewAdapter.pageNumber :(list.size())/PetDetailGridviewAdapter.pageNumber+1 ;
		List<View> listView=new ArrayList<View>();
		for (int i = 0; i < pagetotal; i++) { 
			
			View detailsViewpage=LayoutInflater.from(PetDetailsActivity.this).inflate(R.layout.petdetail_viewpage,null);
			GridView appPage=(GridView) detailsViewpage.findViewById(R.id.detailGridview);
			
			appPage.setAdapter(new PetDetailGridviewAdapter(this,list,i));  
			
			appPage.setOnItemClickListener(myGridviewListener);  
			listView.add(detailsViewpage);
		}  
		viewPager.setAdapter(new PetDetailViewpageAdapter(listView));
		viewPager.setOnPageChangeListener(new MyOnPageChangeListener());
		
		
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
		public void onPageSelected(int position) {
//			toastShow("dddd"+position);
			pageNumber=position;
		}

	}
	
	private OnItemClickListener myGridviewListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> view, View arg1, int position,
				long arg3) {
			
			GridView gridView=(GridView)view;
			Map<String, String> map=(Map<String, String>) gridView.getItemAtPosition(position);
			
			Intent intent=new Intent(PetDetailsActivity.this, ImageActivity.class);
			intent.putExtra("imageurl", imageurl);
			intent.putExtra("position", position+(8*pageNumber));
			startActivity(intent);
			
		}
	};
	
	private void loadingDetailDate(JSONTokener jsonObject) {
		
		TextView userId=(TextView)findViewById(R.id.userId);
		TextView petName=(TextView)findViewById(R.id.petName);
		TextView petNickName=(TextView)findViewById(R.id.petNickName);
		ImageView petImage=(ImageView)findViewById(R.id.petImageUrl);
		TextView userName=(TextView)findViewById(R.id.userName);
		ImageView userImage=(ImageView)findViewById(R.id.userImageUrl);
		TextView userSign=(TextView)findViewById(R.id.userSign);
		
		petImage.setOnClickListener(this);
		userImage.setOnClickListener(this);
		
		try {
			if(jsonObject!=null){
				JSONObject json=(JSONObject) jsonObject.nextValue();
				userId.setText(json.getString("userID"));
				JSONArray jsonArray=(JSONArray) json.get("petList");
				if(jsonArray!=null&&jsonArray.length()>0){
					for (int i = 0; i < jsonArray.length(); i++) {
						JSONObject petJsonObject=jsonArray.getJSONObject(i);
						petName.setText(petJsonObject.getString("petName"));
						BitmapHelper.getInstance().loadImage(null, petJsonObject.getString("petImageUrl"), R.drawable.test10, petImage);
						petImageUrl=petJsonObject.getString("petImageUrl");
						String petImageList=petJsonObject.getString("petImageList");
						String petSex=petJsonObject.getString("petSex");
						String petAge=petJsonObject.getString("petAge");
						petNickName.setText(petJsonObject.getString("petNickName"));
						userName.setText(petJsonObject.getString("userName"));
						BitmapHelper.getInstance().loadImage(null, petJsonObject.getString("userImageUrl"), R.drawable.test10, userImage);
						userImageUrl=petJsonObject.getString("userImageUrl");
						String userLocation=petJsonObject.getString("userLocation");
						String userLastLogin=petJsonObject.getString("userLastLogin");;
						userSign.setText(petJsonObject.getString("userSign"));
						String userSex=petJsonObject.getString("userSex");
						String userBirthday=petJsonObject.getString("userBirthday");
						
								
						getDetailImages(petImageList);
					}
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
	}
	
	private void getDetailImages(String petImageList) {
		petImageList=petImageList.replace("[", "");
		petImageList=petImageList.replace("]", "");
		petImageList=petImageList.replace("\"", "");
		petImageList=petImageList.replace("\\", "");
		String[] images=petImageList.split(",");
		imageurl=petImageList.split(",");
		Map<String, String> map;
		for (int i = 0; i < images.length; i++) {
			
			map=new HashMap<String, String>();
			map.put("gridviewIamge", images[i]);
			list.add(map);
		}
	}
	
	@Override
	public void onClick(View v) {
		super.onClick(v);
		if(v.getId()==R.id.petImageUrl){
			Intent intent=new Intent(PetDetailsActivity.this, ImageActivity.class);
			intent.putExtra("imageurl", petImageUrl);
			startActivity(intent);
		}
		if(v.getId()==R.id.userImageUrl){
			Intent intent=new Intent(PetDetailsActivity.this, ImageActivity.class);
			intent.putExtra("imageurl", userImageUrl);
			startActivity(intent);
		}
	}
}
