

package com.chonglepet.android.adapter;

import java.lang.reflect.Field;
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
 *  发现页面适配器
 */

public class PetGameAdapter extends AbBaseAdapter{

	private LayoutInflater layoutInflater;
	
	public PetGameAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.pet_game_item, null);
			
			hendler.findImageView=(ImageView)convertView.findViewById(R.id.pet_chat_Image);
			hendler.findTextView=(TextView)convertView.findViewById(R.id.pet_chat_textView);
			
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		hendler.findTextView.setText(list.get(position).get("name").toString());
		
		//hendler.findImageView.setImageResource(getDrawable(list.get(position).get("image").toString()));
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("image").toString(), R.drawable.logo_120, hendler.findImageView);
		return convertView;
	}

	class Hendler {
		private TextView textId;
		private TextView findTextView;
		private ImageView findImageView;
		
	}
	
	private int getDrawable(String imageurl){
		 Class drawable  =  R.drawable.class;
		 Field field = null;
		 int iamgeId =0;
         try {
             field = drawable.getField(imageurl);
             iamgeId = field.getInt(field.getName());
         } catch (Exception e) {
         }          

		return iamgeId;
	}
}
