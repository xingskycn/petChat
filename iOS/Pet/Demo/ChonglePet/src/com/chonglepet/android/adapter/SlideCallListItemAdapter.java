

package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.chonglepet.activity.R;

/**
 * 
 * @author chen
 * 
 *  聊天喊话子listview页面适配器
 */

public class SlideCallListItemAdapter extends AbBaseAdapter{

	
	private LayoutInflater layoutInflater;
	
	public SlideCallListItemAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	class Hendler {
		private TextView itemUserName;
		private TextView itemContent;
		private TextView itemTime;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView= layoutInflater.inflate(R.layout.slide_call_list_items, null);
			hendler.itemUserName=(TextView)convertView.findViewById(R.id.slide_call_userName);
			hendler.itemContent=(TextView)convertView.findViewById(R.id.slide_call_content);
			hendler.itemTime=(TextView)convertView.findViewById(R.id.slide_call_time);
			
			
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		hendler.itemUserName.setText(list.get(position).get("userName").toString());
		hendler.itemContent.setText(list.get(position).get("content").toString());
		hendler.itemTime.setText(list.get(position).get("time").toString());
		return convertView;
	}
	
}
