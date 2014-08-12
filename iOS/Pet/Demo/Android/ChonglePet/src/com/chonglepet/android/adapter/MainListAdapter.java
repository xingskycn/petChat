

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
 *  主页面适配器
 */

public class MainListAdapter extends ListPullToRefreshAdaper{

	private Context context;
	private LayoutInflater layoutInflater;
	
	public MainListAdapter(Context context,List<Map<String, String>> list) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		addList(list);
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.activity_main_list_item, null);
			
			hendler.textName=(TextView)convertView.findViewById(R.id.textName);
			hendler.textTitle=(TextView)convertView.findViewById(R.id.textTitle);
			hendler.textSummer=(TextView)convertView.findViewById(R.id.textSummer);
			hendler.miaoshu=(TextView)convertView.findViewById(R.id.miaoshu);
			hendler.imageView=(ImageView)convertView.findViewById(R.id.imageview);
			hendler.imageviewpeople=(ImageView)convertView.findViewById(R.id.imageviewpeople);
			
			convertView.setTag(hendler);
			
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		hendler.textName.setText(list.get(position).get("textName").toString());
		hendler.textTitle.setText(list.get(position).get("textTitle").toString());
		hendler.textSummer.setText(list.get(position).get("textSummer").toString());
		hendler.miaoshu.setText(list.get(position).get("miaoshu").toString());
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageview").toString(), R.drawable.test11, hendler.imageView);
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageviewpeople").toString(), R.drawable.test11, hendler.imageviewpeople);
		return convertView;
	}

	class Hendler {
		private TextView textName;
		private TextView textTitle;
		private TextView textSummer;
		private TextView miaoshu;
		private ImageView imageView;
		
		private ImageView imageviewpeople;
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
