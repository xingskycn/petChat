package com.chonglepet.android.group.chat;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.jivesoftware.smack.Roster;
import org.jivesoftware.smack.RosterEntry;
import org.jivesoftware.smack.packet.Presence;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.activity.TabMainActivity;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.chat.ChatClientActivity;
import com.chonglepet.android.chat.XmppTool;
import com.chonglepet.android.entity.User;
import com.chonglepet.android.group.chat.adapter.ContactsAdapter;

/***
 * 
 * @author chen
 * 所有好友列表    聊天联系人列表    那边已经做了   只是写死数据了 
 */
public class ContactsActivity extends AbstractBaseActivity implements OnClickListener{

	// 用户列表
	private List<User> userinfos = new ArrayList<User>();
	private ListView contactListView;
	//花名册
	private Roster roster;
	
    //花名册数据适配器
	private ContactsAdapter contactsAdapter;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.chat_contacts);
		super.onCreate(savedInstanceState);
		
		contactListView = (ListView) this.findViewById(R.id.chat_contacts_listview);
		//开启服务
		Intent service = new Intent(this,MucService.class);
		startService(service);
		// 获取花名册
		roster = XmppTool.con.getRoster();
		updateRoster();
		addUserInfo();
		contactsAdapter = new ContactsAdapter(this, userinfos);
		contactListView.setAdapter(contactsAdapter);
		
		contactListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View view,
					int position, long id) {
				
				ListView listView=(ListView)arg0;
				User user= (User) listView.getItemAtPosition(position);
				Intent intent = new Intent(TabMainActivity.tabMainContext, ChatClientActivity.class);
				intent.putExtra("USERID", user.getUser());
				startActivity(intent);
				toastShow(user.getUser());
				ContactsActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}
		});

	}

	@Override
	protected void initHeadTitleLayout() {
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setText("群组");
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("联系人列表");
	}

	@Override
	public void onClick(View v) {
		Intent intent=new Intent(ContactsActivity.this, MultiRoomListActivity.class);
		startActivity(intent);
		ContactsActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
	}
	
	/**
	 * 初始化用户列表
	 */
	public void updateRoster() {
		// 获取所有条目，大概只是获取所有好友的意思
		Collection<RosterEntry> entries = roster.getEntries();
		for (RosterEntry entry : entries) {
			// 根据用户名获取出席信息
			Presence presence = roster.getPresence(entry.getUser());
			User user = new User();
			System.out.println(entry.getName());
			System.out.println(entry.getUser());
			System.out.println(entry.getType());
			System.out.println(entry.getGroups().size());
			//这个获取不到
			//System.out.println(presence.getStatus());
			user.setName(entry.getName());
			user.setUser(entry.getUser());
			user.setType(entry.getType());
			user.setSize(entry.getGroups().size());
			user.setStatus(presence.getStatus());// 状态
			//user.setFrom(presence.getFrom());
			userinfos.add(user);
		}
	}
	
	private void addUserInfo() {
		User user=new User();
		user.setName("13122500140@chongle.com");
		user.setUser("13122500140");
		user.setType(null);
		user.setSize(1);
		user.setStatus("@chongle.com");// 状态
		//user.setFrom(presence.getFrom());
		userinfos.add(user);
	}
}