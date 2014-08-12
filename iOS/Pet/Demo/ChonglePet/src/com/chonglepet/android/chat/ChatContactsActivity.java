package com.chonglepet.android.chat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.R;
import com.chonglepet.activity.TabMainActivity;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;

/**
 * 
 * @author chen
 * 
 *  @description 聊天联系人列表
 */

public class ChatContactsActivity extends AbstractBaseActivity implements OnClickListener{
	
	private ListView contacts;
	
	private List<Map<String, String>> list=new ArrayList<Map<String,String>>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.chat_contacts);
		
		super.onCreate(savedInstanceState);
		
		contacts=(ListView)findViewById(R.id.chat_contacts_listview);
		initList();
		
		ContactsAdapter adapter=new ContactsAdapter(this);
		contacts.setAdapter(adapter);
		contacts.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> view, View arg1, int position,
					long arg3) {
				
				ListView listView=(ListView)view;
				Map<String, String> map=(Map<String, String>) listView.getItemAtPosition(position);
				Toast.makeText(ChatContactsActivity.this, map.get("contacts_name").toString()+map.get("contacts_account").toString(),0).show();
				Intent intent = new Intent(TabMainActivity.tabMainContext, ChatClientActivity.class);
				intent.putExtra("USERID", map.get("contacts_account").toString());
				startActivity(intent);
			}
		});
	}
	
	@Override
	protected void initHeadTitleLayout() {
		
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.back_button_select);
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("聊天");
	}
	
	private void initList() {
		Map<String, String> map=new HashMap<String, String>();
		map.put("contacts_name", "带泪的鱼");
		map.put("contacts_account", "13122500140");
		list.add(map);
		
		map=new HashMap<String, String>();
		map.put("contacts_name", "麦克");
		map.put("contacts_account", "13712345678");
		list.add(map);
	}
	

	@Override
	public void onClick(View v) {
		
		
	}
	
	class ContactsAdapter extends BaseAdapter{
		
		private Context context;

		public ContactsAdapter(Context context) {
			this.context=context;
		}
		
		@Override
		public int getCount() {
			return list.size();
		}

		@Override
		public Object getItem(int position) {
			return list.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			Hendle hendle=null;
			if(convertView==null){
				hendle=new Hendle();
				convertView=LayoutInflater.from(context).inflate(R.layout.chat_contacts_item, null);
				hendle.contacts_name=(TextView)convertView.findViewById(R.id.contacts_name);
				hendle.contacts_account=(TextView)convertView.findViewById(R.id.contacts_account);
				hendle.contacts_name.setText(list.get(position).get("contacts_name").toString());
				hendle.contacts_account.setText(list.get(position).get("contacts_account").toString());
				
				convertView.setTag(hendle);
			}
			else{
				hendle=(Hendle) convertView.getTag();
			}
			
			return convertView;
		}
		
		class Hendle{
			TextView contacts_name;
			TextView contacts_account;
		}
		
	}

	
}
