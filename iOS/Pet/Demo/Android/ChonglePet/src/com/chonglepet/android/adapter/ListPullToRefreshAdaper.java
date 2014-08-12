package com.chonglepet.android.adapter;

import java.util.HashMap;
import java.util.Map;

import android.graphics.Bitmap;
import android.view.View;
import android.view.ViewGroup;


/**
 * 
 * @author 陈永兵
 *
 * 下拉刷新列表适配器
 */
public class ListPullToRefreshAdaper extends AbBaseAdapter {

    public static Map<String, Bitmap> mMapImgs=new HashMap<String, Bitmap>();
	
    public void addImag(String string,Bitmap bitmap){
    	mMapImgs.put(string, bitmap);
    }
    
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		return null;
	}

}
