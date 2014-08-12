package com.chonglepet.android.group.chat;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smackx.ServiceDiscoveryManager;
import org.jivesoftware.smackx.packet.DiscoverItems;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.chat.XmppTool;
import com.chonglepet.android.group.chat.adapter.MultiRoomListAdapter;

/**
 * @author chen
 * @description 房间列表    
 */
public class MultiRoomListActivity extends AbstractBaseActivity implements OnClickListener{
	
	public final int MENU_MULCHAT = 1;
	private ProgressDialog dialog;
	private List<DiscoverItems.Item> listDiscoverItems = null;
	private MultiRoomListAdapter mrlAdapter;
	private ListView groupRoomListView;
	private boolean fristJoin = false;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.group_roomlist);
		super.onCreate(savedInstanceState);
		
		showLoadingRoomDialog();
		listDiscoverItems = new ArrayList<DiscoverItems.Item>();
		
		groupRoomListView = (ListView) this.findViewById(R.id.group_listview_room);
		groupRoomListView.setOnItemClickListener(roomItemOnClickListener); 
		
		new Thread(new Runnable() {
			@Override
			public void run() {
				initRoomList();
				Message msg = new Message();
				msg.what = 10;
				handler.sendMessage(msg);
			}
		}).start();
		
	}

	@Override
	protected void initHeadTitleLayout() {
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setText("返回");
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("群组列表");
	}
	
	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.head_left_button){
			finish();
			overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
		}
	}
	
	private OnItemClickListener roomItemOnClickListener=new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int position,
				long arg3) {
			// 获取用户，跳到会议
			DiscoverItems.Item room = listDiscoverItems.get(position);
			Intent intent = new Intent(MultiRoomListActivity.this,
					MultiRoomActivity.class);
			intent.putExtra("roomId", room.getEntityID());
			intent.putExtra("action", "join");
			startActivity(intent);
			overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
		}
	};
	
	private void showLoadingRoomDialog() {
		dialog = new ProgressDialog(this);
		dialog.setTitle("提示");
		dialog.setMessage("正在更新列表");
		dialog.show();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		if(fristJoin){
			listDiscoverItems.clear();
			new Thread(new Runnable() {
				@Override
				public void run() {
					initRoomList();
					Message msg = new Message();
					msg.what = 10;
					handler.sendMessage(msg);
				}
			}).start();
		}
		fristJoin = false;
	}

	@Override
	protected void onPause() {
		super.onPause();
		fristJoin = true;
	}


	/**
	 * 初始化房间列表
	 */
	public void initRoomList() {
		// 获得与XMPPConnection相关的ServiceDiscoveryManager
		ServiceDiscoveryManager discoManager = 
				ServiceDiscoveryManager.getInstanceFor(XmppTool.con);

		// 获得指定XMPP实体的项目
		// 这个例子获得与在线目录服务相关的项目
		DiscoverItems discoItems;
		try {
			discoItems = discoManager
					.discoverItems("conference.chongle.com");
			// 获得被查询的XMPP实体的要查看的项目
			Iterator it = discoItems.getItems();
			// 显示远端XMPP实体的项目
			while (it.hasNext()) {
				DiscoverItems.Item item = (DiscoverItems.Item) it.next();
				listDiscoverItems.add(item);
			}
		} catch (XMPPException e) {
			e.printStackTrace();
		}
	}
	
	public Handler handler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {

			switch (msg.what) {
			case 10:
				dialog.dismiss();
				if(mrlAdapter == null){
					mrlAdapter = new MultiRoomListAdapter(
							MultiRoomListActivity.this, listDiscoverItems);
					groupRoomListView.setAdapter(mrlAdapter);
				}else{
					mrlAdapter.notifyDataSetChanged();
					groupRoomListView.invalidate();
				}
				
				break;
			}
		}
	};

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

}
