package com.chonglepet.android.chat;

import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Presence;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.view.KeyEvent;

import com.chonglepet.activity.CommonConfig;
import com.chonglepet.activity.R;

public class LoginActivity extends Activity implements OnClickListener 
{

	private EditText useridText, pwdText;
	private LinearLayout layout1, layout2;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.chat_login);

		//获取用户和密码
		this.useridText = (EditText) findViewById(R.id.formlogin_userid);
		this.pwdText = (EditText) findViewById(R.id.formlogin_pwd);

		//正在登录
		this.layout1 = (LinearLayout) findViewById(R.id.formlogin_layout1);
		//登录界面
		this.layout2 = (LinearLayout) findViewById(R.id.formlogin_layout2);

		Button btsave = (Button) findViewById(R.id.formlogin_btsubmit);
		btsave.setOnClickListener(this);
		Button btcancel = (Button) findViewById(R.id.formlogin_btcancel);
		btcancel.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		//根据ID来进行提交或者取消
		switch (v.getId()) {
		case R.id.formlogin_btsubmit:
			//取得填入的用户和密码
			final String USERID = this.useridText.getText().toString();
			final String PWD = this.pwdText.getText().toString();
		
			
			Thread t=new Thread(new Runnable() {				
				public void run() {
					//sendEmptyMessage:发送一条消息
					handler.sendEmptyMessage(1);
					try {
						//连接
						XmppTool.getConnection().login(USERID, PWD);
//						Log.i("XMPPClient", "Logged in as " + XmppTool.getConnection().getUser());
						
						//状态
						Presence presence = new Presence(Presence.Type.available);
						XmppTool.getConnection().sendPacket(presence);
						
						Intent intent = new Intent();
						intent.setClass(LoginActivity.this, ChatContactsActivity.class);
						intent.putExtra("USERID", USERID);
						LoginActivity.this.startActivity(intent);
						LoginActivity.this.finish();
						
					}
					catch (XMPPException e) 
					{
						XmppTool.closeConnection();
						
						handler.sendEmptyMessage(2);
					}					
				}
			});
			t.start();
			break;
		case R.id.formlogin_btcancel:
			finish();
			break;
		}
	}
	
	private Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg)
		{
			
			if(msg.what==1)
			{
				layout1.setVisibility(View.VISIBLE);
				layout2.setVisibility(View.GONE);
			}
			else if(msg.what==2)
			{
				layout1.setVisibility(View.GONE);
				layout2.setVisibility(View.VISIBLE);
				Toast.makeText(LoginActivity.this, "登录失败！",Toast.LENGTH_SHORT).show();
			}
		};
	};
	
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode==KeyEvent.KEYCODE_BACK){
			finish();
			overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
		}
		return super.onKeyDown(keyCode, event);
	};
}