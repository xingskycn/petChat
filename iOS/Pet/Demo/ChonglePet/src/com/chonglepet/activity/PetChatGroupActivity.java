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
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.view.MyExplandableListView;
import com.lidroid.xutils.view.annotation.event.OnClick;

/**
 * 
 * @author chen
 * 
 *  宠聊群组界面
 */

public class PetChatGroupActivity extends AbstractBaseActivity{
	
	private List<Map<String, String>> list;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.pet_groupchat);
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
		head_right_button.setBackgroundResource(R.drawable.search_select);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText(getApplication().getString(R.string.pet_chat_group));
	}
	
	private void initView() {
		
		/*try {
			JSONObject jsonObj = new JSONObject();
			 
			Map<String, String> ingredients = new HashMap<String, String>();
			ingredients.put("apples", "3kg");
			ingredients.put("sugar", "1kg");
			ingredients.put("pastry", "2.4kg");
			ingredients.put("bestEaten", "outdoors");
			jsonObj.put("groups", ingredients);
			System.out.println(jsonObj);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		String[] str_group_items_ = {"{\"groups\":{teamName=创意园(1), distance=300m}}", 
				 "{\"groups\":{teamName=崂山小区(2), distance=550m}}", 
				 "{\"groups\":{teamName=崂山二小区(4), distance=200m}}"};
		String[][] str_child_items_ = {{"{\"groups\":{groupName=上海宠物交流群, number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿1}}", 
					"{\"groups\":{groupName=狗狗交流群, number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿2}}"}, 
				   {"{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿3}}", 
				   	"{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿4}}"},
				   {"{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿5}}", 
				   	"{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿6}}",
				    "{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿6}}",
					"{\"groups\":{groupName=崂山二小区(4), number=\"20/90\",discription=嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿6}}"}
				  };
		
		MyExplandableListView explandableListView=new MyExplandableListView(this);
		
		explandableListView.addExpandListDate(str_group_items_, str_child_items_);
		LinearLayout layout=(LinearLayout)findViewById(R.id.expandeListLayout);
		layout.addView(explandableListView);
	}
	
	
	
	@Override
	protected void initRequestListDate() {
		
		String requestHttpKey="pet_group_list";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_GROUP_TASK, CommonConfig.petGroupUrl, requestHttpKey, value);

		
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		super.onTaskRequestSuccess(taskId, jsonTokener);
		switch (taskId) {
		case CommonConfig.PET_GROUP_TASK:
			
			onLoadingDateforGroup(jsonTokener);

			initView();
			break;

		default:
			break;
		}
	}
	
	@Override
	public void onClick(View v) {
		super.onClick(v);
		switch (v.getId()) {
		case R.id.head_right_button:
			
			Intent intent=new Intent(PetChatGroupActivity.this, SearchActivity.class);
			startActivity(intent);
			overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			
			break;

		default:
			break;
		}
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
}
