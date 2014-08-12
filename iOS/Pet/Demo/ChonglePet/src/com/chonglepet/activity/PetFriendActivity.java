package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.FindFriendListAdapter;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author chen
 * 
 *  宠友动态页面
 */

public class PetFriendActivity extends AbstractBaseActivity{
	
	private List<Map<String, Object>> list;
	
	private ListView find_ListView;
	
	private FindFriendListAdapter adapter;
	
	private static LinearLayout layoutSend;
	
	private static Button buttonSend;
	private static TextView sendContent;
	
	private String userImageUrl;
	private String userName;
	
	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.find_friend);
		super.onCreate(savedInstanceState);
	
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.find_friend_ListView);
		View headView=LayoutInflater.from(this).inflate(R.layout.find_friend_headview, null);
		find_ListView.addHeaderView(headView);

		TextView friendUserNmae=(TextView) headView.findViewById(R.id.friendUserNmae);
		friendUserNmae.setText(userName);
		ImageView userImage=(ImageView) headView.findViewById(R.id.userImage);
		BitmapHelper.getInstance().loadImage(null, userImageUrl, R.drawable.ic_launcher, userImage);
		
		adapter=new FindFriendListAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
		layoutSend=(LinearLayout)findViewById(R.id.layout_send);
		buttonSend=(Button)layoutSend.findViewById(R.id.button_send);
		sendContent=(TextView)layoutSend.findViewById(R.id.send_content);
		buttonSend.setOnClickListener(this);

	}
	
	@Override
	protected void initHeadTitleLayout() {
		head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.back_button_select);
		head_left_button.setOnClickListener(this);
		
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.back_button_select);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		String titleName=getApplication().getString(R.string.friend_activity);
		head_center_textview.setText(titleName);
	}
	
	@Override
	protected void initRequestListDate() {
		String requestHttpKey="pet_news";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15678\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_FRIEND_TASK, CommonConfig.petFriendUrl, requestHttpKey, value);
	}
	
	private OnItemClickListener findOnItemOnClickListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> view, View arg1, int position,
				long arg3) {
			
			ListView listView=(ListView)view;
			Map<String, String> map=(Map<String, String>)listView.getItemAtPosition(position);
			
			toastShow(map.get("name")+"");
		}
	};
	
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		
		super.onTaskRequestSuccess(taskId, jsonObject);
		switch (taskId) {
		case CommonConfig.PET_FRIEND_TASK:
			loadingDate(jsonObject);
			
			initView();
			
			break;

		default:
			break;
		}
	};

	@Override
	public void onClick(View v) {
		super.onClick(v);
		if(v==buttonSend){
			toastShow("发送");
			layoutSend.setVisibility(View.GONE);
			FindFriendListAdapter.refreshAdapter(sendContent.getText().toString());
		}
	}
	
	public static void onCommentClick() {
		layoutSend.setVisibility(View.VISIBLE);
	}
	
	private void loadingDate(JSONTokener jsonTokener) {
		try {
			list=new ArrayList<Map<String,Object>>();
			Map<String ,Object> map=null;
			
			JSONObject jsonObject=(JSONObject)jsonTokener.nextValue();
			userImageUrl=jsonObject.getString("userImage");
			userName=jsonObject.getString("userName");
			JSONArray jsonArray=jsonObject.getJSONArray("newsDetail");
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject json=jsonArray.getJSONObject(i);
				String newsImage=json.getString("newsImage");
				String newsUserName=json.getString("userName");
				String newsDetail=json.getString("newsDetail");
				String newsTime=json.getString("newsTime");
				
				map=new HashMap<String, Object>();
				map.put("newsUserName", newsUserName);
				map.put("newsImage", newsImage);
				map.put("newsDetail", newsDetail);
				map.put("newsTime", newsTime);
				List<Map<String, String>>  listitem=new ArrayList<Map<String,String>>();
				Map<String, String> mapItem=new HashMap<String, String>();
				mapItem.put("name", "宠友动态");
				mapItem.put("imageUrl", "chongle");
				listitem.add(mapItem);
				mapItem.put("name", "宠友动态");
				mapItem.put("imageUrl", "chongle");
				listitem.add(mapItem);
				mapItem.put("name", "宠友动态");
				mapItem.put("imageUrl", "chongle");
				listitem.add(mapItem);
				map.put("item", listitem);
				list.add(map);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	/*
	private void iniList() {
		
		list=new ArrayList<Map<String,Object>>();
		Map<String ,Object> map=new HashMap<String, Object>();
		map.put("name", "宠友动态");
		map.put("image", "chongle");
		List<Map<String, String>>  listitem=new ArrayList<Map<String,String>>();
		Map<String, String> mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		map.put("item", listitem);
		list.add(map);

		map=new HashMap<String, Object>();
		map.put("name", "宠友动态1");
		map.put("image", "chongle");
		listitem=new ArrayList<Map<String,String>>();
		mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		map.put("item", listitem);
		list.add(map);


		map=new HashMap<String, Object>();
		map.put("name", "宠友动态2");
		map.put("image", "chongle");
		listitem=new ArrayList<Map<String,String>>();
		mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		
		map.put("item", listitem);
		list.add(map);

		
		map=new HashMap<String, Object>();
		map.put("name", "宠友动态3");
		map.put("image", "chongle");
		listitem=new ArrayList<Map<String,String>>();
		mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		map.put("item", listitem);
		list.add(map);

		
		map=new HashMap<String, Object>();
		map.put("name", "宠友动态4");
		map.put("image", "chongle");
		listitem=new ArrayList<Map<String,String>>();
		mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		map.put("item", listitem);
		list.add(map);

		map=new HashMap<String, Object>();
		map.put("name", "宠友动态5");
		map.put("image", "chongle");
		listitem=new ArrayList<Map<String,String>>();
		mapItem=new HashMap<String, String>();
		mapItem.put("name", "宠友动态");
		mapItem.put("imageUrl", "chongle");
		listitem.add(mapItem);
		map.put("item", listitem);
		list.add(map);

		
	}*/
}
