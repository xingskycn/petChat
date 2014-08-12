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
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.PetChatAdapter;

/**
 * 
 * @author chen
 * 
 *  宠聊活动界面
 */

public class PetChatActivity extends AbstractBaseActivity{
	
	private List<Map<String, String>> list;
	
	private ListView find_ListView;
	
	private PetChatAdapter adapter;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.pet_chat);
		super.onCreate(savedInstanceState);
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
		head_center_textview.setText(getApplication().getString(R.string.pet_activity));
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.pet_chat_ListView);
		adapter=new PetChatAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
	}
	
	@Override
	protected void initRequestListDate() {
		
		String requestHttpKey="event_list";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_ACTIVITY_TASK, CommonConfig.petActivityUrl, requestHttpKey, value);

	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		super.onTaskRequestSuccess(taskId, jsonTokener);
		switch (taskId) {
		case CommonConfig.PET_ACTIVITY_TASK:
			
			onLoadingDateforActivity(jsonTokener);

			initView();
			break;

		default:
			break;
		}
	}
	
	private void onLoadingDateforActivity(JSONTokener jsonTokener) {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		
		try {
			JSONObject jsonObject=(JSONObject)jsonTokener.nextValue();
			JSONArray array=jsonObject.getJSONArray("eventList");
			
			for (int j = 0; j < array.length(); j++) {
				JSONObject json=array.getJSONObject(j);
				String name=json.getString("name");
				String description=json.getString("description");
				String time=json.getString("time");
				
				map=new HashMap<String, String>();
				map.put("name", name);
				map.put("description", description);
				map.put("time", time);
				list.add(map);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	private OnItemClickListener findOnItemOnClickListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> view, View arg1, int position,
				long arg3) {
			
			ListView listView=(ListView)view;
			Map<String, String> map=(Map<String, String>)listView.getItemAtPosition(position);
			
			//toastShow(map.get("name")+"");
			if(map.get("name").equals("宠友动态")){
				Intent intent=new Intent(PetChatActivity.this, PetFriendActivity.class);
				startActivity(intent);
				PetChatActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}
		}
	};

	@Override
	public void onClick(View v) {
		super.onClick(v);
	}
	
	private void iniList() {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		map.put("name", "宠友动态");
		map.put("image", "chongle");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("name", "宠聊群组");
		map.put("image", "chongle");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("name", "宠聊喊话");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "宠聊俱乐部");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "游戏中心");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "宠聊活动");
		map.put("image", "chongle");
		list.add(map);
		
	}
}
