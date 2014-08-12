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
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.SlideCallAdapter;

/**
 * 
 * @author chen
 * 
 *  附近喊话界面
 */

public class SlideCallActivity extends AbstractBaseActivity{
	
	private List<Map<String, Object>> list;
	
	private ListView find_ListView;
	
	private SlideCallAdapter adapter;
	
	private String shoutTypeId;
	
	private static LinearLayout layoutSend;
	
	private EditText commentContent;
	
	private Button sendButton;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.slidecall);
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		super.initHeadTitleLayout();
		head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.back_button_select);
		head_left_button.setOnClickListener(this);
		
		head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.back_button_select);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText(getApplication().getString(R.string.slide_call));
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.pet_chat_ListView);
		adapter=new SlideCallAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
		layoutSend=(LinearLayout)findViewById(R.id.layout_slideCall_send);
		commentContent=(EditText)findViewById(R.id.send_content);
		sendButton=(Button)findViewById(R.id.button_send);
		sendButton.setOnClickListener(this);
	}
	
	@Override
	protected void initRequestListDate() {
		
		Intent intent=getIntent();
		shoutTypeId=intent.getExtras().getString("shoutTypeId");
		String requestHttpKeyInfo="shoutInfo";
		String valueInfo="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"},\"shoutTypeInfo\":{\"id\":"+shoutTypeId+"}}";
		onRequsetViewDateList(CommonConfig.PET_CALL_INFO_TASK, CommonConfig.petCallUrlInfo, requestHttpKeyInfo, valueInfo);
		
	}
	
	public void addShoutInfo(){
		layoutSend.setVisibility(View.VISIBLE);
	}
	
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		super.onTaskRequestSuccess(taskId, jsonTokener);
		switch (taskId) {
		case CommonConfig.PET_CALL_INFO_TASK:
			onLoadingCallInfoDate(jsonTokener);
			initView();
			
			break;
		case CommonConfig.PET_CALL_ADD_TASK:
			onLoadingCallAddDate(jsonTokener);
			break;
			
		default:
			break;
		}
	}
	
	private void onLoadingCallInfoDate(JSONTokener jsonTokener) {
		
		list=new ArrayList<Map<String,Object>>();
		Map<String ,Object> map=new HashMap<String, Object>();
		try {
			JSONObject jsonObject=(JSONObject)jsonTokener.nextValue();
			JSONArray jsonArray=jsonObject.getJSONArray("petList");
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject json=jsonArray.getJSONObject(i);
				String content=json.getString("content");
				String time=json.getString("time");
				String petName=json.getString("petName");
				String imageUrl=json.getString("imageUrl");
				String petSex=json.getString("petSex");
				String userName=json.getString("userName");
				String lastLocation=json.getString("lastLocation");
				String shoutId=json.getString("shoutId");
				JSONArray comments=json.getJSONArray("comments");
				List<Map<String, String>>  listitem=new ArrayList<Map<String,String>>();
				Map<String, String> mapItem=new HashMap<String, String>();
				for (int j = 0; j < comments.length(); j++) {
					JSONObject jsonObj=comments.getJSONObject(j);
					mapItem=new HashMap<String, String>();
					mapItem.put("content", jsonObj.getString("content"));
					mapItem.put("userName", jsonObj.getString("userName"));
					mapItem.put("time", jsonObj.getString("time"));
					listitem.add(mapItem);
				}
				
				
				map.put("comments", listitem);
				map.put("content", content);
				map.put("time", time);
				map.put("petName", petName);
				map.put("imageUrl", imageUrl);
				map.put("petSex", petSex);
				map.put("userName", userName);
				map.put("lastLocation", lastLocation);
				map.put("shoutId", shoutId);
				
				list.add(map);
				
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
	}
	
	private void onLoadingCallAddDate(JSONTokener jsonTokener) {

	}
	
	private OnItemClickListener findOnItemOnClickListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> view, View arg1, int position,
				long arg3) {
			
			/*ListView listView=(ListView)view;
			Map<String, String> map=(Map<String, String>)listView.getItemAtPosition(position);
			
			//toastShow(map.get("name")+"");
			if(map.get("name").equals("宠友动态")){
				Intent intent=new Intent(SlideCallActivity.this, PetFriendActivity.class);
				startActivity(intent);
				SlideCallActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}*/
		}
	};

	public void onClick(View v) {
		super.onClick(v);
		if (v==sendButton) {
			
			layoutSend.setVisibility(View.GONE);
			
			String content=commentContent.getText().toString();
			String requestHttpKeyAdd="shoutInfo_add";
			String valueAdd="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"},\"shoutCommentsInfo\":{\"shoutID\":1,\"comments\":\""+content+"\"}}";
			onRequsetViewDateList(CommonConfig.PET_CALL_ADD_TASK, CommonConfig.petCallUrlAdd, requestHttpKeyAdd, valueAdd);
			
			commentContent.setText("");
		}
	};
	
}
