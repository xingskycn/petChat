package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.R;

/**
 * 
 * @author chen
 * 
 *  发现页面适配器
 */

public class PetChatAdapter extends AbBaseAdapter{

	private LayoutInflater layoutInflater;
	
	private Context context;
	
	public PetChatAdapter(Context context,List<Map<String, String>> list) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.pet_chat_item, null);
			
			hendler.petChatName=(TextView)convertView.findViewById(R.id.pet_chat_name);
			hendler.petChatDescription=(TextView)convertView.findViewById(R.id.pet_chat_description);
			hendler.petChatTime=(TextView)convertView.findViewById(R.id.pet_chat_time);
			hendler.petChatAttend=(TextView)convertView.findViewById(R.id.pet_chat_attend);
			hendler.petChatComent=(TextView)convertView.findViewById(R.id.pet_chat_comment);
			
			
			hendler.petChatAttend.setOnClickListener(textOnCLick);
			hendler.petChatComent.setOnClickListener(textOnCLick);
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		hendler.petChatName.setText(list.get(position).get("name").toString());
		hendler.petChatDescription.setText(list.get(position).get("description").toString());
		hendler.petChatTime.setText(list.get(position).get("time").toString());
		
		//BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageviewpeople").toString(), R.drawable.test11, hendler.imageviewpeople);
		return convertView;
	}

	class Hendler {
		private TextView textId;
		private TextView petChatName;
		private TextView petChatDescription;
		private TextView petChatTime;
		private ImageView findImageView;
		
		private TextView petChatAttend;
		private TextView petChatComent;
		
	}
	
	private OnClickListener textOnCLick=new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			if(v.getId()==R.id.pet_chat_attend){
				Toast.makeText(context, "我要参加", 0).show();
			}
			if(v.getId()==R.id.pet_chat_comment){
				Toast.makeText(context, "我要评论", 0).show();
			}
			
		}
	};
}
