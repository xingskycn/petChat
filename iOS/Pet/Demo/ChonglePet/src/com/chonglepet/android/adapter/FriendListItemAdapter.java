

package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author chen
 * 
 *  宠友动态子listview页面适配器
 */

public class FriendListItemAdapter extends AbBaseAdapter{

	
	private LayoutInflater layoutInflater;
	
	public FriendListItemAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	class Hendler {
		private TextView itemTextView;
		private ImageView itemImageView;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView= layoutInflater.inflate(R.layout.find_friend_list_items, null);
			hendler.itemImageView=(ImageView)convertView.findViewById(R.id.list_item_iamge);
			hendler.itemTextView=(TextView)convertView.findViewById(R.id.list_item_content);
			
			
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		hendler.itemTextView.setText(list.get(position).get("name").toString());
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageUrl").toString(), R.drawable.logo_120, hendler.itemImageView);
		return convertView;
	}
	
}
