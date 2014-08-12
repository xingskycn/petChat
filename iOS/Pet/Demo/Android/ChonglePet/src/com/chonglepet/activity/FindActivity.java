package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.baidu.platform.comapi.map.v;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.FindListAdapter;

/**
 * 
 * @author chen
 * 
 *  发现界面
 */

public class FindActivity extends AbstractBaseActivity implements OnClickListener{
	
	private List<Map<String, String>> list;
	
	private ListView find_ListView;
	
	private FindListAdapter adapter;

	@Override 
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.find);
		super.onCreate(savedInstanceState);
		iniList();
		
		find_ListView=(ListView)findViewById(R.id.find_ListView);
		adapter=new FindListAdapter(this, list);
		find_ListView.setAdapter(adapter);
		find_ListView.setOnItemClickListener(findOnItemOnClickListener);
		
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("发现");
	}
	
	private OnItemClickListener findOnItemOnClickListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> view, View arg1, int position,
				long arg3) {
			
			ListView listView=(ListView)view;
			Map<String, String> map=(Map<String, String>)listView.getItemAtPosition(position);
			
			//toastShow(map.get("name")+"");
			Intent intent=null;
			if(map.get("name").equals("宠友动态")){
				intent=new Intent(FindActivity.this, PetFriendActivity.class);
			}
			if(map.get("name").equals("宠聊群组")){
				intent=new Intent(FindActivity.this, PetChatGroupActivity.class);
			}
			if(map.get("name").equals("宠聊喊话")){
				intent=new Intent(FindActivity.this, CallTypeActivity.class);
			}
			if(map.get("name").equals("宠聊俱乐部")){
				intent=new Intent(FindActivity.this, PetClubActivity.class);
			}
			if(map.get("name").equals("游戏中心")){
				intent=new Intent(FindActivity.this, PetGameActivity.class);
			}
			if(map.get("name").equals("宠聊活动")){
				intent=new Intent(FindActivity.this, PetChatActivity.class);
			}
			startActivity(intent);
			FindActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
		}
	};

	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.head_left_button){
			/*finish();
			overridePendingTransition(R.anim.out_center, R.anim.out_from_righ);*/
		}
		
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
