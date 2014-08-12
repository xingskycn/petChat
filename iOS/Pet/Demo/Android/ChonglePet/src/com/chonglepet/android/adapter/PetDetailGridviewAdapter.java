

package com.chonglepet.android.adapter;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.chonglepet.activity.R;
import com.chonglepet.activity.R.drawable;
import com.chonglepet.activity.R.id;
import com.chonglepet.activity.R.layout;
import com.chonglepet.android.image.BitmapHelper;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

/**
 * 
 * @author chen
 * 
 *  宠物详情页面适配器
 */

public class PetDetailGridviewAdapter extends BaseAdapter{

	private Context context;
	
	private List<Map<String, String>> list;
	
	private LayoutInflater layoutInflater;
	
	public static int pageNumber=8;  //每页显示6个
	
	public PetDetailGridviewAdapter(Context context,List<Map<String, String>>  mlist, int page) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		list = new ArrayList<Map<String,String>>();
        int i = page * pageNumber;   
        int iEnd = i+pageNumber;   
        while ((i<mlist.size()) && (i<iEnd)) {   
            list.add(mlist.get(i));
            i++;   
        }   
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

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		Hendler hendler=null;
		if(convertView==null){
			hendler=new Hendler();
			convertView=layoutInflater.inflate(R.layout.activity_gridview_item, null);
			
			hendler.gridviewiamge=(ImageView)convertView.findViewById(R.id.gridviewiamge);
			
			convertView.setTag(hendler);
			
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("gridviewIamge").toString(), R.drawable.test10, hendler.gridviewiamge);
		return convertView;
	}

	class Hendler {
		
		private ImageView gridviewiamge;
		
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
