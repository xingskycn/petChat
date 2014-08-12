

package com.chonglepet.android.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.activity.PetFriendActivity;
import com.chonglepet.activity.R;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author chen
 * 
 * 宠友动态页面适配器
 */

public class FindFriendListAdapter extends BaseAdapter{
	
	private Context context;

	private LayoutInflater layoutInflater;
	
	private static FriendListItemAdapter itemAdapter;
	
	private List<Map<String, Object>> list;
	
	private static List<Map<String, String>> listItems;
	
	public FindFriendListAdapter(Context context,List<Map<String, Object>> list) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		this.list=list;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.find_friend_item, null);
			
			hendler.findImageView=(ImageView)convertView.findViewById(R.id.find_friend_title_image);
			hendler.newsTime=(TextView)convertView.findViewById(R.id.find_friend_textView_time);
			hendler.friendComment=(Button)convertView.findViewById(R.id.friend_comment_button);
			hendler.newsUserNmae=(TextView)convertView.findViewById(R.id.newUserName);
			hendler.newsDetail=(TextView)convertView.findViewById(R.id.newsDetail);
			
			hendler.friendComment.setId(position);
			hendler.listView = (ListView) convertView.findViewById(R.id.expandedListView1);
			
			convertView.setTag(hendler);
			hendler.friendComment.setOnClickListener(onClickListener);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		listItems= (List<Map<String, String>>) list.get(position).get("item");
		
		itemAdapter=new FriendListItemAdapter(context,listItems);
		hendler.listView.setAdapter(itemAdapter);
		hendler.newsTime.setText(list.get(position).get("newsTime").toString());
		hendler.newsUserNmae.setText(list.get(position).get("newsUserName").toString());
		hendler.newsDetail.setText(list.get(position).get("newsDetail").toString());
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("newsImage").toString(), R.drawable.test11, hendler.findImageView);
		return convertView;
	}

	class Hendler {
		private TextView newsUserNmae;
		private TextView newsDetail;
		private TextView newsTime;
		private ImageView findImageView;
		private Button friendComment;
		
		private ListView listView;
		
	}
	
	private int buttonId;
	private OnClickListener onClickListener=new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			PetFriendActivity.onCommentClick();
			buttonId=v.getId();
		}
	};
	
	public static void refreshAdapter(String content){
		Map<String, String> mapItem=new HashMap<String, String>();
		mapItem.put("name", content);
		mapItem.put("imageUrl", "chongle");
		listItems.add(mapItem);
		itemAdapter.notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}
	
}
