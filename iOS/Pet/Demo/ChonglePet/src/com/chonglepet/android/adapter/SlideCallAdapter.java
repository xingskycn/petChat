

package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.activity.SlideCallActivity;
import com.chonglepet.android.image.BitmapHelper;

/**
 * 
 * @author chen
 * 
 *  发现页面适配器
 */

public class SlideCallAdapter extends BaseAdapter{

	private Context context;

	private LayoutInflater layoutInflater;
	
	private static SlideCallListItemAdapter itemAdapter;
	
	private List<Map<String, Object>> list;
	
	private static List<Map<String, String>> listItems;
	
	public SlideCallAdapter(Context context,List<Map<String, Object>> list) {
		this.context=context;
		this.layoutInflater=LayoutInflater.from(context);
		this.list=list;
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
			hendler.call_comment=(Button)convertView.findViewById(R.id.call_comment);
			hendler.listView = (ListView) convertView.findViewById(R.id.expandedListView1);
			
			hendler.call_comment.setOnClickListener(commentOnClick);
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		listItems= (List<Map<String, String>>) list.get(position).get("comments");
		
		itemAdapter=new SlideCallListItemAdapter(context,listItems);
		hendler.listView.setAdapter(itemAdapter);
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageUrl").toString(), R.drawable.owner_test, hendler.slide_call_image);
		hendler.slide_petName.setText(list.get(position).get("userName").toString());
		hendler.slide_time.setText(list.get(position).get("time").toString());
		hendler.slide_content.setText(list.get(position).get("content").toString());
		
		BitmapHelper.getInstance().loadImage(null, list.get(position).get("imageUrl").toString(), R.drawable.owner_test, hendler.slide_image);
		return convertView;
	}

	class Hendler {
		private TextView slide_petName;
		private TextView slide_time;
		private TextView slide_content;
		private ImageView slide_call_image;
		private ImageView slide_image;
		private Button call_comment;
		
		private ListView listView;
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
	
	private OnClickListener commentOnClick=new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			SlideCallActivity callActivity=(SlideCallActivity)context;
			callActivity.addShoutInfo();
		}
	};
}
