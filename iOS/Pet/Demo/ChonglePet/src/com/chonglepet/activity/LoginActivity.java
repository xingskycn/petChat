package com.chonglepet.activity;

import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Presence;
import org.jivesoftware.smackx.packet.VCard;
import org.json.JSONTokener;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.chat.XmppTool;

/**
 * 
 * @author chen
 * 
 *  登录页面
 */
public class LoginActivity extends AbstractBaseActivity {

	private Button loginButton;
	private EditText userName,passWord;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		
		
		loginButton=(Button)findViewById(R.id.button_login);
		userName=(EditText)findViewById(R.id.login_username);
		passWord=(EditText)findViewById(R.id.login_password);
		
		loginButton.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		super.onClick(v);
		if(v.getId()==R.id.button_login){
			String loginUserName=userName.getText().toString();
			String loginPassWord=passWord.getText().toString();
			//调用登入的方法
			startConnectXmpp(loginUserName, loginPassWord);
		}
	}
	
	@Override
	public void onTaskRequestStart(int taskId) {

	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		
		/*JSONObject jsonObject;
		try {
			jsonObject = (JSONObject) jsonTokener.nextValue();
			switch (taskId) {
			case CommonConfig.STARTAPP_TASK:
				String text=jsonObject.toString();
				//textView.setText(text);
				Intent intent=new Intent(LoginActivity.this, TabMainActivity.class);
				startActivity(intent);
				finish();
				
				break;
				
			default:
				break;
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}*/
	}

	private void startConnectXmpp(String userName,String passWord) {
		//取得填入的用户和密码
		final String USERID = userName;
		final String PWD = passWord;
	
		
		Thread t=new Thread(new Runnable() {				
			public void run() {
				//sendEmptyMessage:发送一条消息
				//handler.sendEmptyMessage(1);
				try {
					
					//连接
					XmppTool.con=XmppTool.getConnection();
					XmppTool.con.login(USERID, PWD);
					//状态
					Presence presence = new Presence(Presence.Type.available);
					XmppTool.getConnection().sendPacket(presence);
					
					//加入vcard
					VCard vCard = new VCard();
					vCard.load(XmppTool.con);
					if("".equals(vCard.getNickName()) || null == vCard.getNickName()){
						System.out.println("昵称是空的");
						vCard.setNickName("131225001040-chen");
					}
					XmppTool.vCard = vCard;
					
					
					CommonConfig.editor.putString("loginName", USERID);
					CommonConfig.editor.putString("loginPassword", PWD);
					CommonConfig.editor.commit();
					
					handler.sendEmptyMessage(3);
					
				}
				catch (XMPPException e) 
				{
					XmppTool.closeConnection();
					
					//handler.sendEmptyMessage(2);
				}					
			}
		});
		t.start();
	}
	
	@SuppressLint("HandlerLeak")
	private Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg)
		{
			
			if(msg.what==3)
			{
				
			}
			
		};
	};
}
