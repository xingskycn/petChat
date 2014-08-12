package com.chonglepet.android.view;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnChildClickListener;
import android.widget.ExpandableListView.OnGroupClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.R;

/**
 * 自定义ExplandableListView
 * @author陈
 */
public class MyExplandableListView extends ExpandableListView 
			implements OnChildClickListener,OnGroupClickListener{
	
	ExpandInfoAdapter adapter;
	private Context context_;
	
	String[] str_group_items_=null;
	String[][] str_child_items_=null;
	
	
	public MyExplandableListView(Context context) {
		super(context);
		context_ = context;
		/* 隐藏默认箭头显示 */
		this.setGroupIndicator(null);
		/* 隐藏垂直滚动条 */
		this.setVerticalScrollBarEnabled(false);
		
		/* 监听child，group点击事件 */
		this.setOnChildClickListener(this);
		this.setOnGroupClickListener(this);
		
		setCacheColorHint(Color.TRANSPARENT);
		setDividerHeight(0);
		setChildrenDrawnWithCacheEnabled(false);
		setGroupIndicator(null);
		
		/*隐藏选择的黄色高亮*/
		ColorDrawable drawable_tranparent_ = new ColorDrawable(Color.TRANSPARENT);
		setSelector(drawable_tranparent_);
		
		/*设置adapter
		adapter = new ExpandInfoAdapter();
		setAdapter(adapter);*/
		
	}
	
	
	
    
	public MyExplandableListView(Context context, AttributeSet attrs) {
		this(context);
	}

	public void addExpandListDate(String[] str_group_items_,String[][] str_child_items_){
		this.str_group_items_=str_group_items_;
		this.str_child_items_=str_child_items_;
		
		/*设置adapter*/
		adapter = new ExpandInfoAdapter();
		setAdapter(adapter);
	}


	@SuppressLint("ResourceAsColor")
	public class ExpandInfoAdapter extends BaseExpandableListAdapter {
	    	LinearLayout mGroupLayout;
    	
		@Override
		public Object getChild(int groupPosition, int childPosition) {
			return str_child_items_[groupPosition][childPosition];
		}

		@Override
		public long getChildId(int groupPosition, int childPosition) {
			return childPosition;
		}
		@Override
		public int getChildrenCount(int groupPosition) {
			return str_child_items_[groupPosition].length;
		}
		@Override
		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView,
				ViewGroup parent) {
			
			String groupName = null;
			String number=null;
			String discription=null;
			try {
				String json=str_child_items_[groupPosition][childPosition];
				JSONObject object=new JSONObject(json);
				JSONObject jsonObject=object.getJSONObject("groups");
				groupName = jsonObject.getString("groupName");
				number=jsonObject.getString("number");
				discription=jsonObject.getString("discription");
				
				TextView txt_child;
				if(null == convertView){
					convertView = LayoutInflater.from(context_).inflate(R.layout.pet_groupchat_child_item, null);  
				}
				TextView child_line=(TextView)convertView.findViewById(R.id.child_line);
				//判断是否是最后一项，最后一项设计特殊的背景
				if(isLastChild){
					child_line.setVisibility(View.GONE);
				} else {
					child_line.setVisibility(View.VISIBLE);
				}
				convertView.getBackground().setAlpha(200);//0~255透明度值
				
				TextView groupSize=(TextView)convertView.findViewById(R.id.groupSize);
				TextView groupDescription=(TextView)convertView.findViewById(R.id.groupDescription);
				txt_child = (TextView)convertView.findViewById(R.id.pet_chat_textView);
				txt_child.setText(groupName);
				groupSize.setText(number);
				groupDescription.setText(discription);
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return convertView;
		}
				
		@Override
		public Object getGroup(int groupPosition) {
			return str_group_items_[groupPosition];
		}

		@Override
		public int getGroupCount() {
			return str_group_items_.length;
		}

		@Override
		public long getGroupId(int groupPosition) {
			return groupPosition;
		}

		@Override
		public View getGroupView(int groupPosition, boolean isExpanded,  View convertView, ViewGroup parent) {
			String teamName = null;
			String distance=null;
			try {
				String json=str_group_items_[groupPosition];
				JSONObject object=new JSONObject(json);
				JSONObject jsonObject=object.getJSONObject("groups");
				teamName = jsonObject.getString("teamName");
				distance=jsonObject.getString("distance");
			
				TextView txt_group;
				TextView group_distance;
				if(null == convertView){
					convertView = LayoutInflater.from(context_).inflate(R.layout.pet_groupchat_group_item, null);  
					
				}
				ImageView imageView=(ImageView)convertView.findViewById(R.id.group_image);
				ImageView imageViewAddress=(ImageView)convertView.findViewById(R.id.group_address_image);
				group_distance=(TextView)convertView.findViewById(R.id.group_distance);
				txt_group = (TextView)convertView.findViewById(R.id.id_group_txt);
				ImageView imageViewJiantou=(ImageView)convertView.findViewById(R.id.group_jiantou_image);
				TextView group_line=(TextView)convertView.findViewById(R.id.group_line);
				
				/*判断是否group张开，来分别设置背景图*/
				if(isExpanded){
					convertView.setBackgroundResource(R.drawable.expandlinbg_press);
					imageView.setBackgroundResource(R.drawable.group_icon_press);
					imageViewAddress.setBackgroundResource(R.drawable.address_icon_press);
					txt_group.setTextColor(getResources().getColor(R.color.group_team_color));
					group_distance.setTextColor(getResources().getColor(R.color.group_team_color));
					imageViewJiantou.setBackgroundResource(R.drawable.up_jiantou);
					group_line.setVisibility(View.GONE);
				}else{
					convertView.setBackgroundColor(Color.TRANSPARENT);
					imageView.setBackgroundResource(R.drawable.group_icon);
					imageViewAddress.setBackgroundResource(R.drawable.address_icon);
					txt_group.setTextColor(Color.WHITE);
					group_distance.setTextColor(Color.WHITE);
					imageViewJiantou.setBackgroundResource(R.drawable.down_jiantou);
					group_line.setVisibility(View.VISIBLE);
				}
				
				txt_group.setText(teamName);
				group_distance.setText(distance);
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return convertView;
			
		}
		
	        @Override
		public boolean isChildSelectable(int arg0, int arg1) {
			return true;
		}
		
		@Override
		public boolean hasStableIds() {
			return false;
		}

	}
	
	@Override
	public boolean onChildClick(ExpandableListView parent, View v,
			int groupPosition, int childPosition, long id) {
		Toast.makeText(getContext(), "hi，你竟然点击了第" + (groupPosition + 1) + "组的第" + (childPosition + 1) + "条！", Toast.LENGTH_LONG).show();
		return false;
	}
	
	@Override
	public boolean onGroupClick(ExpandableListView parent, View v,
			int groupPosition, long id) {
		return false;
	}
}
