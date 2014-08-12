

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
 *  发现页面适配器
 */

public class SlideCallAdapter extends AbBaseAdapter{

	private LayoutInflater layoutInflater;
	
	public SlideCallAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.slidecall_item, null);
			
			hendler.slide_call_image=(ImageView)convertView.findViewById(R.id.slide_call_image);
			hendler.slide_petName=(TextView)convertView.findViewById(R.id.slide_petName);
			hendler.slide_time=(TextView)convertView.findViewById(R.id.slide_time);
			hendler.slide_content=(TextView)convertView.findViewById(R.id.slide_content);
			hendler.slide_image=(ImageView)convertView.findViewById(R.id.slide_image);
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageUrl").toString(), R.drawable.test11, hendler.slide_call_image);
		hendler.slide_petName.setText(list.get(position).get("userName").toString());
		hendler.slide_time.setText(list.get(position).get("time").toString());
		hendler.slide_content.setText(list.get(position).get("content").toString());
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageUrl").toString(), R.drawable.test11, hendler.slide_image);
		return convertView;
	}

	class Hendler {
		private TextView slide_petName;
		private TextView slide_time;
		private TextView slide_content;
		private ImageView slide_call_image;
		private ImageView slide_image;
		
	}
}
