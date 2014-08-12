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
import com.chonglepet.android.adapter.PetChatGroupAdapter;

/**
 * 
 * @author chen
 * 
 *  宠聊群组界面
 */

public class PetChatGroupActivity extends AbstractBaseActivity{
	
	private List<Map<String, String>> list;
	
	private ListView find_ListView;
	
	private PetChatGroupAdapter adapter;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.pet_chat_group);
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.test22);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText(getApplication().getString(R.string.pet_chat_group));
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.pet_chat_ListView);
		adapter=new PetChatGroupAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
	}
	
	@Override
	protected void initRequestListDate() {
		
		String requestHttpKey="pet_group_list";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_GROUP_TASK, CommonConfig.petGroupUrl, requestHttpKey, value);

		
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		switch (taskId) {
		case CommonConfig.PET_GROUP_TASK:
			
			onLoadingDateforGroup(jsonObject);

			initView();
			break;

		default:
			break;
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
				Intent intent=new Intent(PetChatGroupActivity.this, PetFriendActivity.class);
				startActivity(intent);
				PetChatGroupActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}
		}
	};

	@Override
	public void onClick(View v) {
		super.onClick(v);
	}
	
	private void onLoadingDateforGroup(JSONTokener jsonTokener) {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		
		try {
			JSONArray jsonArray=(JSONArray)jsonTokener.nextValue();
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject object=jsonArray.getJSONObject(i);
				JSONArray array=object.getJSONArray("petGroups");
				
				String regionName=object.getString("regionName");
				for (int j = 0; j < array.length(); j++) {
					JSONObject jsonObject=array.getJSONObject(j);
					String groupDescription=jsonObject.getString("groupDescription");
					String groupSize=jsonObject.getString("groupSize");
					String groupImageUrl=jsonObject.getString("groupImageUrl");
					String groupName=jsonObject.getString("groupName");
					
					map=new HashMap<String, String>();
					map.put("head", regionName);
					map.put("name", groupName);
					map.put("groupSize", groupSize);
					map.put("groupDescription", groupDescription);
					map.put("image", groupImageUrl);
					list.add(map);
					regionName="";
				}
				
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

	}
	
	/*private void iniList() {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		map.put("head", "汇竹花园");
		map.put("name", "宠友动态");
		map.put("image", "chongle");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("head", "");
		map.put("name", "宠聊群组");
		map.put("image", "chongle");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("head", "");
		map.put("name", "宠聊喊话");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("head", "龚组创意园");
		map.put("name", "宠聊俱乐部");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("head", "");
		map.put("name", "游戏中心");
		map.put("image", "chongle");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("head", "");
		map.put("name", "宠聊活动");
		map.put("image", "chongle");
		list.add(map);
		
	}*/
}
