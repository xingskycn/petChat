

package com.chonglepet.android.adapter;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author chen
 * 
 *  发现页面适配器
 */

public class PetClubAdapter extends AbBaseAdapter{
	
	private Context context;

	private LayoutInflater layoutInflater;
	
	public PetClubAdapter(Context context,List<Map<String, String>> list) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.pet_club_item, null);
			
			hendler.headSection=(LinearLayout)convertView.findViewById(R.id.head_section);
			hendler.findImageView=(ImageView)convertView.findViewById(R.id.pet_chat_Image);
			hendler.findTextView=(TextView)convertView.findViewById(R.id.pet_chat_textView);
			
			
			String lable=list.get(position).get("head").toString();
			String firstLable=list.get(0).get("head").toString();
			if(position==0){
				setSection(hendler.headSection, lable);
			}
			else{
				String preLable=list.get(position).get("head").toString();
				if(!firstLable.equals(preLable)&&preLable!=null&&!preLable.equals("")){
					setSection(hendler.headSection, preLable);
				}
				else{
					hendler.headSection.setVisibility(View.GONE);
				}
			}
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		hendler.findTextView.setText(list.get(position).get("name").toString());
		
		//hendler.findImageView.setImageResource(getDrawable(list.get(position).get("image").toString()));
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("image").toString(), R.drawable.test11, hendler.findImageView);
		return convertView;
	}

	class Hendler {
		private LinearLayout headSection;
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
	
	private void setSection(LinearLayout header, String label) {  
		TextView text = new TextView(context);  
		header.setBackgroundColor(0xffaabbcc);  
		text.setTextColor(Color.WHITE);  
		text.setText(label);  
		text.setTextSize(20);  
		text.setPadding(5, 0, 0, 0);  
		text.setGravity(Gravity.CENTER_VERTICAL);  
		header.addView(text);  
	}
}
