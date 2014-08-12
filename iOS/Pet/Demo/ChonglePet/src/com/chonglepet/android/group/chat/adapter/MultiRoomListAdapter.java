package com.chonglepet.android.group.chat.adapter;

import java.util.List;

import org.jivesoftware.smackx.packet.DiscoverItems;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.chonglepet.activity.R;

/**
 * 
 * @author chen
 * 房间列表适配器
 *
 */

public class MultiRoomListAdapter extends BaseAdapter {
	private Context context;

	private List<DiscoverItems.Item> roominfos ;

	public MultiRoomListAdapter(Context context, List<DiscoverItems.Item> roominfos) {
		super();
		this.context = context;
		this.roominfos = roominfos;
	}

	@Override
	public int getCount() {
		return roominfos.size();
	}

	@Override
	public Object getItem(int position) {
		return roominfos.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Hendle hendle=null;
		DiscoverItems.Item room = roominfos.get(position);
		if(convertView==null){
			hendle=new Hendle();
			convertView=LayoutInflater.from(context).inflate(R.layout.chat_contacts_item, null);
			hendle.contacts_name=(TextView)convertView.findViewById(R.id.contacts_name);
			hendle.contacts_account=(TextView)convertView.findViewById(R.id.contacts_account);
			hendle.contacts_name.setText(room.getName());
			hendle.contacts_iamge_title=(ImageView)convertView.findViewById(R.id.contact_title_image);
			//hendle.contacts_account.setText(room.getName());
			
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
		ImageView contacts_iamge_title;
	}
}