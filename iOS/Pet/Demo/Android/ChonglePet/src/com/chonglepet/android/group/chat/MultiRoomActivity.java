package com.chonglepet.android.group.chat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jivesoftware.smack.PacketListener;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smack.packet.Packet;
import org.jivesoftware.smack.packet.Presence;
import org.jivesoftware.smackx.Form;
import org.jivesoftware.smackx.FormField;
import org.jivesoftware.smackx.muc.MultiUserChat;
import org.jivesoftware.smackx.muc.ParticipantStatusListener;
import org.jivesoftware.smackx.packet.DelayInformation;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.MainActivity;
import com.chonglepet.activity.R;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.chat.XmppTool;
import com.chonglepet.android.group.chat.adapter.GroupChatAdapter;
import com.chonglepet.android.group.chat.adapter.MemberAdapter;
import com.chonglepet.android.utils.DBHelper;

/**
 * 
 * @author chen
 * 
 *  群聊窗口   聊天房间
 *
 */

public class MultiRoomActivity extends AbstractBaseActivity implements OnClickListener {

	private String TAG = "ActivityMultiRoom";
	private final int RECEIVE = 1;
	private final int MEMBER = 2;
	public final int MENU_MULCHAT = 1;
	public final int MENU_DESTROY = 2;
	private Button sendButton;
	private Button showHistory;
	private EditText et_Message;
	private ListView lv_Members;
	/**
	 * 聊天室成员
	 */
	private List<String> roomMember = new ArrayList<String>();
	private MultiUserChat userChat;
	private MemberAdapter memberAdapter;
	private boolean isHistory = false;
	private int count = 0;
	private String history = "";
	SharedPreferences sharedPreferences = null;
	/**
	 * 房间ID
	 */
	private String roomId;
	private String dbRoomId;

	private ChatPacketListener chatListener;
	private MyPacketListener myPacketListener;
	private MyParticipantStatusListener myParticipantStatusListener;
	
	private boolean isMyselfSend=false;  //是否是自己发送的消息
	
	private GroupChatAdapter adapter;
	
	List<Msg> listMsg=new ArrayList<MultiRoomActivity.Msg>();
	
	private String userId="";
	
	private DBHelper dbHelper;
	
	private ListView listView;
	
	public class Msg {
		public String userid;
		public String msg;
		public String date;
		public String from;

		public Msg(String userid, String msg, String date, String from) {
			this.userid = userid;
			this.msg = msg;
			this.date = date;
			this.from = from;
		}
	}


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.group_room);
		super.onCreate(savedInstanceState);

		dbHelper=DBHelper.getInstance(this);
		dbHelper.open();
		
		// 旧消息
		sharedPreferences = getSharedPreferences("history", Context.MODE_PRIVATE);
		// 后面服务名称必需是创建房间的那个服务
		roomId = getIntent().getStringExtra("roomId");
		dbRoomId=roomId.substring(0,roomId.indexOf("@"));

		sendButton = (Button) findViewById(R.id.send);
		showHistory = (Button) findViewById(R.id.showHistory);
		et_Message = (EditText) findViewById(R.id.message);
		lv_Members = (ListView) this.findViewById(R.id.listview);
		sendButton.setOnClickListener(this);
		showHistory.setOnClickListener(this);
		// 使用XMPPConnection创建一个MultiUserChat  
		userChat = new MultiUserChat(XmppTool.con, roomId);
		//创建聊天室
		chatListener = new ChatPacketListener(userChat);
		myPacketListener = new MyPacketListener();
		myParticipantStatusListener = new MyParticipantStatusListener();
		String action = getIntent().getStringExtra("action");
		try {
			System.out.println("房间号：" + roomId);
			if ("join".equals(action)) {
				// 进入房间后的nickname(昵称)
				String nickName = XmppTool.vCard.getNickName().toString();
				userChat.join(nickName);
				Log.v(TAG, "join success");
			} else {
				// 创建房间并加入
				createRoom(roomId);
				Log.v(TAG, "create success");
			}
			// 开启子线程加载成员
			getAllMember();
			userChat.addMessageListener(chatListener);
			userChat.addParticipantListener(myPacketListener);
			userChat.addParticipantStatusListener(myParticipantStatusListener);

		} catch (XMPPException e) {
			e.printStackTrace();
		}
		
		listView = (ListView) findViewById(R.id.groupChat_listview);
		listView.setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL);
		initGroupListDate();//不知道为什么   读取本地数据反而很慢了
		adapter = new GroupChatAdapter(MultiRoomActivity.this,listMsg);
		listView.setAdapter(adapter);
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setText("群成员");
		head_right_button.setOnClickListener(this);
		
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setText("返回");
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("testRoom");
	}
	
	private void initGroupListDate() {
		try {
			List<Map<String, String>> list=dbHelper.queryTable_GroupChat(new String[]{dbRoomId});
			for (Iterator iterator = list.iterator(); iterator.hasNext();) {
				Map<String, String> map = (Map<String, String>) iterator.next();
				listMsg.add(new Msg(map.get("groupName"), map.get("chatContent"), map.get("chatTime"), map.get("type")));
			}
			handler.sendEmptyMessage(0);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		switch (resultCode) {
		case 20:
			Log.i(TAG, "邀请人了");
			String userjid = data.getExtras().getString("userJid");
			if (userjid != null || !"".equals(userjid)) {
				userChat.invite(userjid, "来谈谈人生");
			}
			break;
		}
	}

	/**
	 * 获取聊天室的所有成员
	 */
	private void getAllMember() {
		Log.i(TAG, "获取聊天室的所有成员");
		roomMember.clear();
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					Iterator<String> it = userChat.getOccupants();
					while (it.hasNext()) {
						String name = it.next();
						name = name.substring(name.indexOf("/") + 1);
						roomMember.add("[空闲]" + name);
						Log.i(TAG, "成员名字;" + name);
					}

					android.os.Message msg = new android.os.Message();
					msg.what = MEMBER;
					handler.sendMessage(msg);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}).start();
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {
		// 发送消息
		case R.id.send: {
			String msg = et_Message.getText().toString();
			
			msg="{\"textContent\":"+msg+",\"type\":\"text\"}";
			if (!"".equals(msg)) {
				try {
					JSONObject jsonObject=new JSONObject(msg);
					userChat.sendMessage(jsonObject.toString());
					isMyselfSend=true;
				} catch (Exception e) {
					Log.i(TAG, "发送异常");
					e.printStackTrace();
				} finally {
					et_Message.setText("");
				}
			}
		}
			break;
		case R.id.showHistory:
			String newMessage = et_Message.getText().toString();

			String history = sharedPreferences.getString("historyMessage", null);
			System.out.println("历史消息：" + history);
			break;
		case R.id.head_right_button:
			Intent intent=new Intent(MultiRoomActivity.this, GroupInfoActivity.class);
			startActivity(intent);
			overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			
			break;
			
		case R.id.head_left_button:
			finish();
			overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
			break;
			
		}
		
	}
	
	public Handler handler = new Handler() {

		@Override
		public void handleMessage(android.os.Message msg) {

			switch (msg.what) {
			case RECEIVE: {
				try {
					// 新消息
					Bundle bd = msg.getData();
					String from = bd.getString("from");
					String body = bd.getString("body");
					
					JSONObject jsonObject=new JSONObject(body);
					String textContent=jsonObject.getString("textContent");
					history += from + ":" + msg + "\n";
					if (isHistory) {
						receiveMsg(from, textContent);
					} else {
						Editor editor = sharedPreferences.edit();
						editor.putString("historyMessage", history);
						editor.commit();
						System.out.println("保存了历史消息");
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
				break;
			case MEMBER:
				if (memberAdapter == null) {
					// 更行成员列表
					/*memberAdapter = new MemberAdapter(MultiRoomActivity.this,
							roomMember);
					lv_Members.setAdapter(memberAdapter);*/
				} else {
					memberAdapter.notifyDataSetChanged();
					lv_Members.invalidate();
				}
				Log.i(TAG, "成员列表 " + roomMember.size() + " 个！");
				break;
			}
		}
	};
	
	/**
	 * 往聊天列表中添加信息
	 * 
	 * @param from
	 * @param msg
	 */
	private void receiveMsg(String from, String msg) {
		userId=from.substring(from.lastIndexOf("/")+1);
		Date date=new Date(System.currentTimeMillis());
		String time=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(date);
		Msg message=null;
		if(isMyselfSend){	
			isMyselfSend=false;
			message=new Msg(userId, msg, time, "OUT");
			dbHelper.insertTable_GroupChat(dbRoomId, "sss.jpg", time, msg, "OUT");
		}
		else{
			message=new Msg(userId, msg, time, "IN");
			dbHelper.insertTable_GroupChat(dbRoomId, "sss.jpg", time, msg, "IN");
		}
		listMsg.add(message);
		adapter.notifyDataSetChanged();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		// 把所有对象变NULL
		userChat.removeMessageListener(chatListener);
		userChat.removeParticipantListener(myPacketListener);
		userChat.removeParticipantStatusListener(myParticipantStatusListener);
		chatListener = null;
		myPacketListener = null;
		myParticipantStatusListener = null;
		userChat.leave();
		userChat = null;
		roomMember = null;
		finish();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(1, MENU_MULCHAT, Menu.NONE, "邀请");
		menu.add(2, MENU_DESTROY, Menu.NONE, "销毁");
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		// 长按ListView弹出的对话框
		super.onCreateContextMenu(menu, v, menuInfo);
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.notemenu, menu);
	}

	@Override
	public boolean onContextItemSelected(MenuItem item) {
		AdapterContextMenuInfo info = (AdapterContextMenuInfo) item
				.getMenuInfo();
		int id = (int) info.id;
		switch (item.getItemId()) {
		case R.id.mn_tall:
			// 私聊
			break;
		case R.id.mn_Grant:
			// 授权
			break;
		case R.id.mn_kick:
			// 踢人
			try {
				String nickName = roomMember.get(id);
				userChat.kickParticipant(nickName
						.substring(nickName.indexOf("]") + 1), "看你不爽就 踢了你");
				getAllMember();
				android.os.Message msg = new android.os.Message();
				msg.what = MEMBER;
				handler.sendMessage(msg);
				Toast.makeText(this, "他被T了", Toast.LENGTH_LONG).show();
			} catch (XMPPException e) {
				e.printStackTrace();
				Toast.makeText(this, "你没有权利踢人", Toast.LENGTH_LONG).show();
			}
			break;
		}
		return super.onContextItemSelected(item);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		Intent intent;
		switch (item.getItemId()) {
		case MENU_MULCHAT:
			intent = new Intent(MultiRoomActivity.this, MainActivity.class);
			intent.putExtra("type", "1");
			startActivityForResult(intent, 0);
			break;
		case MENU_DESTROY:
			// 销毁房间，根据JID
			try {
				userChat.destroy("不要了，销毁掉！", roomId);
			} catch (XMPPException e) {
				e.printStackTrace();
				Log.i(TAG, "销毁失败");
			}
			intent = new Intent(MultiRoomActivity.this, MainActivity.class);
			startActivity(intent);
			break;
		}
		return false;// false表示继续传递到父类处理
	}

	/**
	 * 创建房间
	 */
	public void createRoom(String room) {
		// 使用XMPPConnection创建一个MultiUserChat
		// MultiUserChat userChat = new MultiUserChat(Constants.conn, room
		// + "@conference.xmpp.chaoboo.com");
		try {
			// 创建聊天室
			userChat.create(XmppTool.vCard.getNickName().toString());
			// 获得聊天室的配置表单
			Form form = userChat.getConfigurationForm();
			// 根据原始表单创建一个要提交的新表单。
			Form submitForm = form.createAnswerForm();
			// 向要提交的表单添加默认答复
			for (Iterator fields = form.getFields(); fields.hasNext();) {
				FormField field = (FormField) fields.next();
				if (!FormField.TYPE_HIDDEN.equals(field.getType())
						&& field.getVariable() != null) {
					// 设置默认值作为答复
					submitForm.setDefaultAnswer(field.getVariable());
				}
			}
			// 设置聊天室的新拥有者
			// List owners = new ArrayList();
			// owners.add("liaonaibo2\\40slook.cc");
			// owners.add("liaonaibo1\\40slook.cc");
			// submitForm.setAnswer("userChat#roomconfig_roomowners", owners);
			// 设置聊天室是持久聊天室，即将要被保存下来
			submitForm.setAnswer("userChat#roomconfig_persistentroom", true);
			// 房间仅对成员开放
			submitForm.setAnswer("userChat#roomconfig_membersonly", false);
			// 允许占有者邀请其他人
			submitForm.setAnswer("userChat#roomconfig_allowinvites", true);
			// 能够发现占有者真实 JID 的角色
			// submitForm.setAnswer("userChat#roomconfig_whois", "anyone");
			// 登录房间对话
			submitForm.setAnswer("userChat#roomconfig_enablelogging", true);
			// 仅允许注册的昵称登录
			submitForm.setAnswer("x-userChat#roomconfig_reservednick", true);
			// 允许使用者修改昵称
			submitForm.setAnswer("x-userChat#roomconfig_canchangenick", false);
			// 允许用户注册房间
			submitForm.setAnswer("x-userChat#roomconfig_registration", false);
			// 发送已完成的表单（有默认值）到服务器来配置聊天室
			userChat.sendConfigurationForm(submitForm);
		} catch (XMPPException e) {
			e.printStackTrace();
		}
	}

	/**
	 * PacketListener 通过一个规定的过滤器提供一个机制来监听数据包
	 * 
	 * @author chen
	 * 
	 */
	class ChatPacketListener implements PacketListener {
		private String _number;
		private Date _lastDate;
		private MultiUserChat _userChat;
		private String _roomName;

		public ChatPacketListener(MultiUserChat userChat) {
			_number = "0";
			_lastDate = new Date(0);
			_userChat = userChat;
			_roomName = userChat.getRoom();
		}

		@Override
		public void processPacket(Packet packet) {
			System.out.println("消息格式:" + packet.toXML());
			Message message = (Message) packet;
			String from = message.getFrom();

			if (message.getBody() != null) {
				DelayInformation inf = (DelayInformation) message.getExtension(
						"x", "jabber:x:delay");
				System.out.println("判断消息");
				if (inf == null && count >= 1) {
					System.out.println("新消息来了");
					isHistory = true;
				} else {
					System.out.println("这是旧的消息");
				}
				android.os.Message msg = new android.os.Message();
				msg.what = RECEIVE;
				Bundle bd = new Bundle();
				bd.putString("from", from);
				bd.putString("body", message.getBody());
				msg.setData(bd);
				handler.sendMessage(msg);
			}
			count++;
		}
	}

	/**
	 * 聊天室成员的监听器
	 */
	class MyParticipantStatusListener implements ParticipantStatusListener {

		@Override
		public void adminGranted(String arg0) {
			Log.i(TAG, "执行了adminGranted方法:" + arg0);
		}

		@Override
		public void adminRevoked(String arg0) {
			Log.i(TAG, "执行了adminRevoked方法:" + arg0);
		}

		@Override
		public void banned(String arg0, String arg1, String arg2) {
			Log.i(TAG, "执行了banned方法:" + arg0);
		}

		@Override
		public void joined(String arg0) {
			Log.i(TAG, "执行了joined方法:" + arg0 + "加入了房间");
			getAllMember();
			android.os.Message msg = new android.os.Message();
			msg.what = MEMBER;
			handler.sendMessage(msg);
		}

		@Override
		public void kicked(String arg0, String arg1, String arg2) {
			Log.i(TAG, "执行了kicked方法:" + arg0 + "被踢出房间");
		}

		@Override
		public void left(String arg0) {
			String lefter = arg0.substring(arg0.indexOf("/") + 1);
			Log.i(TAG, "执行了left方法:" + lefter + "离开的房间");
			getAllMember();
			android.os.Message msg = new android.os.Message();
			msg.what = MEMBER;
			handler.sendMessage(msg);
		}

		@Override
		public void membershipGranted(String arg0) {
			Log.i(TAG, "执行了membershipGranted方法:" + arg0);
		}

		@Override
		public void membershipRevoked(String arg0) {
			Log.i(TAG, "执行了membershipRevoked方法:" + arg0);
		}

		@Override
		public void moderatorGranted(String arg0) {
			Log.i(TAG, "执行了moderatorGranted方法:" + arg0);
		}

		@Override
		public void moderatorRevoked(String arg0) {
			Log.i(TAG, "执行了moderatorRevoked方法:" + arg0);
		}

		@Override
		public void nicknameChanged(String arg0, String arg1) {
			Log.i(TAG, "执行了nicknameChanged方法:" + arg0);
		}

		@Override
		public void ownershipGranted(String arg0) {
			Log.i(TAG, "执行了ownershipGranted方法:" + arg0);
		}

		@Override
		public void ownershipRevoked(String arg0) {
			Log.i(TAG, "执行了ownershipRevoked方法:" + arg0);
		}

		@Override
		public void voiceGranted(String arg0) {
			Log.i(TAG, "执行了voiceGranted方法:" + arg0);
		}

		@Override
		public void voiceRevoked(String arg0) {
			Log.i(TAG, "执行了voiceRevoked方法:" + arg0);
		}
	}

	/**
	 * 
	 */
	public class MyPacketListener implements PacketListener {

		@Override
		public void processPacket(Packet arg0) {
			// 线上--------------chat
			// 忙碌--------------dnd
			// 离开--------------away
			// 隐藏--------------xa
			Presence presence = (Presence) arg0;
			// PacketExtension pe = presence.getExtension("x",
			// "http://jabber.org/protocol/userChat#user");
			String LogKineName = presence.getFrom().toString();
			String kineName = LogKineName
					.substring(LogKineName.indexOf("/") + 1);
			String stats = "";
			if ("chat".equals(presence.getMode().toString())) {
				stats = "[线上]";
			}
			if ("dnd".equals(presence.getMode().toString())) {
				stats = "[忙碌]";
			}
			if ("away".equals(presence.getMode().toString())) {
				stats = "[离开]";
			}
			if ("xa".equals(presence.getMode().toString())) {
				stats = "[隐藏]";
			}

			for (int i = 0; i < roomMember.size(); i++) {
				String name = roomMember.get(i);
				if (kineName.equals(name.substring(name.indexOf("]") + 1))) {
					roomMember.set(i, stats + kineName);
					System.out.println("状态改变成：" + roomMember.get(i));
					android.os.Message msg = new android.os.Message();
					msg.what = MEMBER;
					handler.sendMessage(msg);
					break;
				}
			}
		}
	}
}
