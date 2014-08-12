

package com.chonglepet.android.adapter;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.chonglepet.activity.MainActivity;
import com.chonglepet.activity.PetDetailsActivity;
import com.chonglepet.activity.R;

/**
 * 
 * @author chen
 * 
 *  主页面home适配器
 */

public class HomeListAdapter extends BaseAdapter{
	
	private List<Map<String, String>> leftList;
	
	private LayoutInflater inflater;
	
	private Context context;
	
	public HomeListAdapter(Context context,List<Map<String, String>> leftList) {
		this.leftList=leftList;
		this.context=context;
		inflater=LayoutInflater.from(context);
	}
	
	@Override
	public int getCount() {
		return leftList.size();
	}
	
	@Override
	public Object getItem(int position) {
		return leftList.get(position);
	}
	
	@Override
	public long getItemId(int position) {
		return position;
	}
	
	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		Hendle hendle=null;
		if(convertView==null){
			hendle=new Hendle();
			convertView=inflater.inflate(R.layout.home_item, null);
			hendle.home_imageview=(ImageView)convertView.findViewById(R.id.home_imageview);
			//hendle.buttom_female=(ImageButton)convertView.findViewById(R.id.buttom_female);
			hendle.layout=(LinearLayout)convertView.findViewById(R.id.home_list_item_headlayout);
			
			convertView.setTag(hendle);
		}
		else{
			hendle=(Hendle)convertView.getTag();
		}
		
		hendle.layout.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//Toast.makeText(context, "ddddddffffffffff: "+position, 0).show();
				//跳入到详情页面
				Intent intent=new Intent(context, PetDetailsActivity.class);
				context.startActivity(intent);
			}
		});
		
		RelativeLayout relativeLayout=(RelativeLayout)convertView.findViewById(R.id.home_list_timeLayout);
		/*LinearLayout linearLayout=(LinearLayout)convertView.findViewById(R.id.list_item_headlayout);
		linearLayout.getBackground().setAlpha(250);*/
		
		Bitmap bitmap=BitmapFactory.decodeResource(context.getResources(), getDrawable(leftList.get(position).get("image").toString()));
	    int heigth=bitmap.getHeight();
	    hendle.home_imageview.getLayoutParams().height=heigth;
	    
	    relativeLayout.getLayoutParams().height=heigth;
	    relativeLayout.getLayoutParams().width=460;
		hendle.home_imageview.setImageResource(getDrawable(leftList.get(position).get("image").toString()));
		return convertView;
	}
	
	class Hendle{
		private ImageView home_imageview;
		private ImageButton buttom_female;
		private LinearLayout layout;
		
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
