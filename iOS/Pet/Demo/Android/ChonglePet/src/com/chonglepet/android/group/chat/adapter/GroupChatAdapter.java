package com.chonglepet.android.group.chat.adapter;

import java.util.List;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.chat.ChatClientActivity;
import com.chonglepet.android.group.chat.MultiRoomActivity.Msg;
import com.chonglepet.android.image.BitmapHelper;

public class GroupChatAdapter extends BaseAdapter {

	private Context context;
	private LayoutInflater inflater;
	private List<Msg> listMessage;

	public GroupChatAdapter(Context context,List<Msg> listMessage) {
		this.context = context;
		this.listMessage=listMessage;
	}

	@Override
	public int getCount() {
		return listMessage.size();
	}

	@Override
	public Object getItem(int position) {
		return listMessage.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) 
	{
		//显示消息的布局：内容、背景、用户、时间
		this.inflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		
		//IN,OUT的图片
		if(listMessage.get(position).from.equals("IN"))
		{
			convertView = this.inflater.inflate(R.layout.formclient_chat_in, null);
		}
		else
		{
			convertView = this.inflater.inflate(R.layout.formclient_chat_out, null);
		}
		
		ImageView chat_title_image_left=(ImageView)convertView.findViewById(R.id.chat_title_image_left);
		ImageView chat_title_image_right=(ImageView)convertView.findViewById(R.id.chat_title_image_right);
		TextView useridView = (TextView) convertView.findViewById(R.id.formclient_row_userid);
		TextView dateView = (TextView) convertView.findViewById(R.id.formclient_row_date);
		LinearLayout formclient_row_layout = (LinearLayout) convertView.findViewById(R.id.formclient_row_layout);
		ImageView formclient_row_image_msg=(ImageView)convertView.findViewById(R.id.formclient_row_image_msg);
		
		useridView.setText(listMessage.get(position).userid);
		dateView.setText(listMessage.get(position).date);
		
		String message=listMessage.get(position).msg;
		if(message.contains(".jpg")||message.contains(".png")){
			formclient_row_image_msg.setVisibility(View.VISIBLE);
			BitmapHelper.getInstance().loadImage(null, message, 0, formclient_row_image_msg);
			formclient_row_image_msg.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
					/*Intent intent=new Intent(ChatClientActivity.this, ImageActivity.class);
					intent.putExtra("imageurl", "aaaaaa");
					startActivity(intent);*/
				}
			});
		}
		else{
			formclient_row_layout.setVisibility(View.VISIBLE);
			TextView msgView=new TextView(context);
			msgView.setText(message);
			msgView.setTextColor(Color.BLACK);
			formclient_row_layout.addView(msgView);
			//if(message.contains(".mp4")||message.contains(".3gp")){
				msgView.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						/*Intent intent=new Intent(ChatClientActivity.this, MediaPlayActivity.class);
						intent.putExtra("imageurl", "aaaaaa");
						startActivity(intent);*/
					}
				});
			//}
		}
		return convertView;
	}
}