

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

/**
 * 
 * @author chen
 * 
 *  发现页面适配器
 */

public class SlideCallTypeAdapter extends AbBaseAdapter{

	private LayoutInflater layoutInflater;
	
	public SlideCallTypeAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.slidecall_type_item, null);
			
			hendler.shoutTypeId=(TextView)convertView.findViewById(R.id.shoutTypeId);
			hendler.findTextView=(TextView)convertView.findViewById(R.id.shoutTypeName);
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		hendler.shoutTypeId.setText(list.get(position).get("shoutTypeId").toString());
		hendler.findTextView.setText(list.get(position).get("shoutTypeName").toString());
		
		return convertView;
	}

	class Hendler {
		private TextView shoutTypeId;
		private TextView findTextView;
		private ImageView findImageView;
		
	}
	
	/*private int getDrawable(String imageurl){
		 Class drawable  =  R.drawable.class;
		 Field field = null;
		 int iamgeId =0;
         try {
             field = drawable.getField(imageurl);
             iamgeId = field.getInt(field.getName());
         } catch (Exception e) {
         }          

		return iamgeId;
	}*/
}
