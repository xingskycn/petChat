package com.chonglepet.android.group.chat;

import java.util.ArrayList;
import java.util.List;

import org.jivesoftware.smackx.muc.MultiUserChat;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.group.chat.adapter.MemberAdapter;

/**
 * 
 * @author chen
 *  群成员列表
 */

public class GroupInfoActivity extends AbstractBaseActivity implements OnClickListener{

	private String TAG = "GroupInfoActivity";
	
	private MultiUserChat userChat;

	private List<String> roomMember = new ArrayList<String>();
	
	private ListView memberInfoListview;
	
	private MemberAdapter adapter;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.group_info);
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setText("返回");
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("群成员");
	}
	
	@Override
	public void onClick(View v) {
		if(R.id.head_left_button==v.getId()){
			finish();
			overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
		}
		
	}
}
