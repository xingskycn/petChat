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
import com.chonglepet.android.adapter.SlideCallTypeAdapter;

/**
 * 
 * @author chen
 * 
 *  附近喊话list界面
 */

public class CallTypeActivity extends AbstractBaseActivity{
	
	private List<Map<String, String>> list;
	
	private ListView find_ListView;
	
	private SlideCallTypeAdapter adapter;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.slidecall_type);
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		super.initHeadTitleLayout();
		head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		
		head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.test22);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText(getApplication().getString(R.string.slide_call));
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.pet_chat_ListView);
		adapter=new SlideCallTypeAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);

	}
	
	@Override
	protected void initRequestListDate() {
		
		String requestHttpKey="shoutType";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		onRequsetViewDateList(CommonConfig.PET_CALL_TYPE_TASK, CommonConfig.petCallUrltype, requestHttpKey, value);
		
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		
		switch (taskId) {
		case CommonConfig.PET_CALL_TYPE_TASK:
			
			onLoadingCallTypeDate(jsonTokener);
			
			initView();
			
			break;
			
		default:
			break;
		}
	}
	
	private void onLoadingCallTypeDate(JSONTokener jsonTokener) {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		
		try {
			JSONObject jsonObject=(JSONObject)jsonTokener.nextValue();
			JSONArray jsonArray=jsonObject.getJSONArray("petList");
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject object=jsonArray.getJSONObject(i);
				String shoutTypeId=object.getString("shoutTypeID");
				String shoutTypeName=object.getString("shoutTypeName");
				
				map=new HashMap<String, String>();
				map.put("shoutTypeId", shoutTypeId);
				map.put("shoutTypeName", shoutTypeName);
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
			String shoutTypeId=map.get("shoutTypeId");
			
			Intent intent=new Intent(CallTypeActivity.this, SlideCallActivity.class);
			intent.putExtra("shoutTypeId", shoutTypeId);
			startActivity(intent);
			overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
		}
	};

	public void onClick(View v) {
		super.onClick(v);
	};
	
	/*private void iniList() {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		map.put("name", "宠友动态");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("name", "宠聊群组");
		list.add(map);

		map=new HashMap<String, String>();
		map.put("name", "宠聊喊话");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "宠聊俱乐部");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "游戏中心");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("name", "宠聊活动");
		list.add(map);
		
	}*/
}
