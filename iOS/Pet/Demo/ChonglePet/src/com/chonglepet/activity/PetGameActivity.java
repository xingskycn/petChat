package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.PetGameAdapter;

/**
 * 
 * @author chen
 * 
 *  宠聊游戏界面
 */

public class PetGameActivity extends AbstractBaseActivity{
	
	private List<Map<String, String>> list;
	
	private ListView find_ListView;
	
	private PetGameAdapter adapter;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.pet_game);
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
		head_center_textview.setText(getApplication().getString(R.string.pet_game));
	}
	
	private void initView() {
		find_ListView=(ListView)findViewById(R.id.pet_chat_ListView);
		adapter=new PetGameAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
	}
	
	@Override
	protected void initRequestListDate() {
		
		String requestHttpKey="game_list";
		String value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}";
		
		onRequsetViewDateList(CommonConfig.PET_GAME_TASK, CommonConfig.petGameUrl, requestHttpKey, value);

	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		super.onTaskRequestSuccess(taskId, jsonTokener);
		switch (taskId) {
		case CommonConfig.PET_GAME_TASK:
			
			onLoadingDateforGame(jsonTokener);

			initView();
			break;

		default:
			break;
		}
	}
	
	private void onLoadingDateforGame(JSONTokener jsonTokener) {
		list=new ArrayList<Map<String,String>>();
		Map<String ,String> map=new HashMap<String, String>();
		
		try {
			JSONObject object=(JSONObject)jsonTokener.nextValue();
			JSONArray array=object.getJSONArray("eventList");
			
			for (int j = 0; j < array.length(); j++) {
				JSONObject jsonObject=array.getJSONObject(j);
				String name=jsonObject.getString("name");
				String members=jsonObject.getString("members");
				
				map=new HashMap<String, String>();
				map.put("name", name);
				map.put("members", members);
				map.put("image", "chongle");
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
			/*if(map.get("name").equals("宠友动态")){
				Intent intent=new Intent(PetGameActivity.this, PetFriendActivity.class);
				startActivity(intent);
				PetGameActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}*/
		}
	};

	@Override
	public void onClick(View v) {
		super.onClick(v);
	}
	
}
