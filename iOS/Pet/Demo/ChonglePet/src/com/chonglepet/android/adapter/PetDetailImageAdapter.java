package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chonglepet.activity.R;

public class PetDetailImageAdapter extends BaseAdapter{

	private Context context;
	private List<Map<String, String>> list;
	private LayoutInflater layoutInflater;
	
	public PetDetailImageAdapter(Context context,List<Map<String, String>> list) {
		this.layoutInflater=LayoutInflater.from(context);
		this.list=list;
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
			convertView=layoutInflater.inflate(R.layout.activity_pet_details_image_item, null);
			
			/*hendler.headSection=(LinearLayout)convertView.findViewById(R.id.head_section);
			hendler.findImageView=(ImageView)convertView.findViewById(R.id.pet_chat_Image);
			hendler.clubGroupSize=(TextView)convertView.findViewById(R.id.pet_club_groupSize);
			hendler.clubRoupName=(TextView)convertView.findViewById(R.id.pet_club_roupName);
			hendler.groupDescription=(TextView)convertView.findViewById(R.id.groupDescription);
			*/
			convertView.setTag(hendler);
		}
		else{
			hendler=(Hendler) convertView.getTag();
		}
		
		/*hendler.clubRoupName.setText(list.get(position).get("name").toString());
		hendler.clubGroupSize.setText(list.get(position).get("groupSize").toString());
		hendler.groupDescription.setText(list.get(position).get("groupDescription").toString());
		*/
		//hendler.findImageView.setImageResource(getDrawable(list.get(position).get("image").toString()));
		//BitmapHelper.getInstance().loadImage(null, list.get(position).get("image").toString(), R.drawable.owner_test, hendler.findImageView);
		return convertView;
	}

	class Hendler {
		private LinearLayout headSection;
		private TextView clubGroupSize;
		private TextView clubRoupName;
		private TextView groupDescription;
		private ImageView findImageView;
		
	}

}
