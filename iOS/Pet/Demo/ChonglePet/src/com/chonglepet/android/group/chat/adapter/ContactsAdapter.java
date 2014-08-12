package com.chonglepet.android.group.chat.adapter;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.entity.User;

/**
 * 联系人列表数据适配器类
 * @author chen
 */
public class ContactsAdapter extends BaseAdapter {
	private Context context;
	private List<User> userinfos;

	public ContactsAdapter(Context context, List<User> userinfos) {
		super();
		this.context = context;
		this.userinfos = userinfos;
	}

	@Override
	public int getCount() {
		return userinfos.size();
	}

	@Override
	public Object getItem(int position) {
		return userinfos.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Hendle hendle=null;
		User user = userinfos.get(position);
		if(convertView==null){
			hendle=new Hendle();
			convertView=LayoutInflater.from(context).inflate(R.layout.chat_contacts_item, null);
			hendle.contacts_name=(TextView)convertView.findViewById(R.id.contacts_name);
			hendle.contacts_account=(TextView)convertView.findViewById(R.id.contacts_account);
			
			convertView.setTag(hendle);
		}
		else{
			hendle=(Hendle) convertView.getTag();
		}
		hendle.contacts_name.setText(user.getUser());
		hendle.contacts_account.setText(user.getName());
		
		return convertView;
	}
	
	class Hendle{
		TextView contacts_name;
		TextView contacts_account;
	}
}
