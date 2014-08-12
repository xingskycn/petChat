package com.chonglepet.activity;

import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Presence;
import org.jivesoftware.smackx.packet.VCard;

import android.app.Dialog;
import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TabHost;
import android.widget.TabWidget;
import android.widget.Toast;

import com.chonglepet.android.chat.XmppTool;
import com.chonglepet.android.group.chat.ContactsActivity;


/**
 * 
 * @author chen
 * 
 * @description 宠物首页面
 */
public class TabMainActivity extends TabActivity{ 
    public static TabHost mTabHost; 
    private Dialog dialog=null;
    public static Context tabMainContext;
    
    private SharedPreferences preferences;
    private Editor editor;
    
    private  String loginName;
    private String loginPassword;
    
    private Intent service;
    
    public static TabHost getmTabHost() { 
        return mTabHost; 
    } 
   
    private RadioGroup main_radio; 
    private RadioButton tab_icon_fujin, 
    					tab_icon_find,
    					tab_icon_chat,
    					tab_icon_contact,
    					tab_icon_set,
    					tab_icon_shop; 
   
    @Override 
    public void onCreate(Bundle savedInstanceState) { 
        super.onCreate(savedInstanceState); 
        setContentView(R.layout.tab_main); 
        tabMainContext=this;
        
        CommonConfig.sharedPreferences=getApplicationContext().getSharedPreferences("chongle", MODE_PRIVATE);
        CommonConfig.editor=CommonConfig.sharedPreferences.edit();
        preferences=CommonConfig.sharedPreferences;
        editor=CommonConfig.editor;
        loginName=preferences.getString("loginName", null);
        loginPassword=preferences.getString("loginPassword", null);
        
        if(loginName!=null&&
				loginPassword!=null){
        	startConnectXmpp(loginName,loginPassword);
        }
        
        mTabHost = getTabHost(); 
        final TabWidget tabWidget = mTabHost.getTabWidget(); 
        tabWidget.setStripEnabled(false);// 圆角边线不启用 
        //添加n个tab选项卡，定义他们的tab名，指示名，目标屏对应的类 
        mTabHost.addTab(mTabHost.newTabSpec("TAG1").setIndicator("0").setContent(new Intent(this, MainActivity.class))); 
        mTabHost.addTab(mTabHost.newTabSpec("TAG2").setIndicator("1").setContent(new Intent(this, FindActivity.class))); 
        mTabHost.addTab(mTabHost.newTabSpec("TAG3").setIndicator("2").setContent(new Intent(this, ContactsActivity.class))); 
        mTabHost.addTab(mTabHost.newTabSpec("TAG4").setIndicator("3").setContent(new Intent(this, LoginActivity.class)));
        mTabHost.addTab(mTabHost.newTabSpec("TAG5").setIndicator("4").setContent(new Intent(this, SetInfoActivity.class))); 
       // mTabHost.addTab(mTabHost.newTabSpec("TAG6").setIndicator("5").setContent(new Intent(this, ShopActivity.class)));
        // 视觉上,用单选按钮替代TabWidget 
        main_radio = (RadioGroup) findViewById(R.id.main_radio); 
        tab_icon_fujin = (RadioButton) findViewById(R.id.tab_icon_fujin); 
        tab_icon_find = (RadioButton) findViewById(R.id.tab_icon_find); 
        tab_icon_chat = (RadioButton) findViewById(R.id.tab_icon_chat); 
        tab_icon_contact = (RadioButton) findViewById(R.id.tab_icon_contact);
        tab_icon_set = (RadioButton) findViewById(R.id.tab_icon_set);
        //tab_icon_shop = (RadioButton) findViewById(R.id.tab_icon_shop);
        main_radio.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() { 
                    @Override 
                    public void onCheckedChanged(RadioGroup group, int id) { 
                    	if (id == tab_icon_fujin.getId()) {  
                    		//这里用来解决点击之后变图片
                    		/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide_press,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/
                            mTabHost.setCurrentTab(0);  
                        } else if (id == tab_icon_find.getId()) { 
                    		/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find_press,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/
                            mTabHost.setCurrentTab(1);  
                        } else if (id == tab_icon_chat.getId()) {  
                    		/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat_press,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/
                    		
                    		//如果已经登录过了   就不用在此登录了
            				if(loginName!=null&&
            						loginPassword!=null){
            					mTabHost.setCurrentTab(2);
            				}else{
            					showLogingDialog();
            				}
                    		
                        } else if (id == tab_icon_contact.getId()) {  
                    		/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts_press,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/  
                            mTabHost.setCurrentTab(3);  
                        } else if (id == tab_icon_set.getId()) {  
                    		/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set_press,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/
                    		//如果已经登录过了   就不用在此登录了
            				if(loginName!=null&&
            						loginPassword!=null){
            					mTabHost.setCurrentTab(4);
            				}else{
            					showLogingDialog();
            				}
                        }/* else if (id == tab_icon_shop.getId()) {  
                    		tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
                    		tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
                    		tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
                    		tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
                    		tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set,0, 0);  
                    		tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts_press,0,0); 
                            mTabHost.setCurrentTab(5);  
                        } */ 
                    }  
                }); 
   
        // 设置当前显示哪一个标签 
        mTabHost.setCurrentTab(0); 
        // 遍历tabWidget每个标签，设置背景图片 无 
        for (int i = 0; i < tabWidget.getChildCount(); i++) { 
            View vv = tabWidget.getChildAt(i); 
            vv.getLayoutParams().height = 45; 
            // vv.getLayoutParams().width = 65; 
            vv.setBackgroundDrawable(null); 
        } 
    } 
    
    public EditText useridText, pwdText;
	private LinearLayout layout1, layout2;
	
    private void showLogingDialog() {
		
    	dialog=new Dialog(this, R.style.CustomProgressDialog);
    	
    	View view=LayoutInflater.from(this).inflate(R.layout.chat_login, null);
    	//获取用户和密码
    	this.useridText = (EditText)view.findViewById(R.id.formlogin_userid);
    	this.pwdText = (EditText)view.findViewById(R.id.formlogin_pwd);
    	
    	//正在登录
    	this.layout1 = (LinearLayout)view.findViewById(R.id.formlogin_layout1);
    	//登录界面
    	this.layout2 = (LinearLayout) view.findViewById(R.id.formlogin_layout2);
    	
    	Button btsave = (Button) view.findViewById(R.id.formlogin_btsubmit);
    	btsave.setOnClickListener(loginOnClickListener);
    	Button btcancel = (Button) view.findViewById(R.id.formlogin_btcancel);
    	btcancel.setOnClickListener(loginOnClickListener);
    	
    	
    	dialog.setContentView(view);
    	dialog.show();
	}
    
    private OnClickListener loginOnClickListener=new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.formlogin_btsubmit:
				//取得填入的用户和密码
				final String USERID = TabMainActivity.this.useridText.getText().toString();
				final String PWD = TabMainActivity.this.pwdText.getText().toString();
				//startConnectXmpp(USERID, PWD);
				
				Thread t=new Thread(new Runnable() {				
					public void run() {
						//sendEmptyMessage:发送一条消息
						handler.sendEmptyMessage(1);
						try {
							//连接
							XmppTool.con=XmppTool.getConnection();
							XmppTool.con.login(USERID, PWD);
							//XmppTool.getConnection().login(USERID, PWD);
//							Log.i("XMPPClient", "Logged in as " + XmppTool.getConnection().getUser());
							
							//状态
							Presence presence = new Presence(Presence.Type.available);
							XmppTool.getConnection().sendPacket(presence);
							
							//加入vcard
							VCard vCard = new VCard();
							vCard.load(XmppTool.con);
							if("".equals(vCard.getNickName()) || null == vCard.getNickName()){
								System.out.println("昵称是空的");
								vCard.setNickName("快乐的汤姆猫");
							}
							XmppTool.vCard = vCard;
							
							editor.putString("loginName", USERID);
							editor.putString("loginPassword", PWD);
							editor.commit();
							
							handler.sendEmptyMessage(3);
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
				dialog.dismiss();
				break;
			}
			
		}
	};
	
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
				Toast.makeText(TabMainActivity.this, "登录失败！",Toast.LENGTH_SHORT).show();
			}
			else if(msg.what==3)
			{
				if(loginName ==null&&
						loginPassword ==null){
					dialog.dismiss();
					/*tab_icon_fujin.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.slide,0, 0);  
					tab_icon_find.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.find,0, 0);  
					tab_icon_chat.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.chat,0, 0);  
					tab_icon_contact.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0, 0);
					tab_icon_set.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.set_press,0, 0);  
					tab_icon_shop.setCompoundDrawablesWithIntrinsicBounds(0,R.drawable.contacts,0,0);*/
					mTabHost.setCurrentTab(2);  
				}
				
				/*      	
				//开启服务
				service = new Intent(TabMainActivity.this,MucService.class);
				startService(service);
*/
			}
			
		};
	};
	
	/**
	 * 开启连接
	 * @param userName
	 * @param passWord
	 */
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
					
					
					editor.putString("loginName", USERID);
					editor.putString("loginPassword", PWD);
					editor.commit();
					
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
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		//stopService(service);
		XmppTool.closeConnection();
		android.os.Process.myPid();
		//Toast.makeText(TabMainActivity.this, "服务被销毁", 0).show();
	}
	
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(1==1){
			Toast.makeText(TabMainActivity.this, "在次点击退出程序",Toast.LENGTH_SHORT).show();
			return true;
		}
		else{
			return super.onKeyDown(keyCode, event);
		}
	}
}

