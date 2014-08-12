package com.chonglepet.android.adapter;

import java.util.List;
import java.util.Map;

import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;


public abstract class AbBaseAdapter extends BaseAdapter{
	
	protected List<Map<String, String>> list;
	
	public void addList(List<Map<String, String>> list) {
		this.list=list;
	}

	public void clearList(){
		list.clear();
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
		return null;
	}
	
}
