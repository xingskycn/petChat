package com.chonglepet.android.group.chat.adapter;

import java.util.List;

import org.jivesoftware.smackx.muc.Affiliate;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MemberAdapter extends BaseAdapter {

	private Context context;

	private List<String> roominfos ;

	public MemberAdapter(Context context, List<String> roominfos) {
		super();
		this.context = context;
		this.roominfos = roominfos;
	}

	@Override
	public int getCount() {
		return roominfos.size();
	}

	@Override
	public Object getItem(int position) {
		return roominfos.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	private class ViewHolder {
		TextView name;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup viewGroup) {
		String room = roominfos.get(position);
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			LinearLayout layout = new LinearLayout(context);

			holder.name = new TextView(context);
			layout.setOrientation(LinearLayout.HORIZONTAL);
			layout.addView(holder.name);
			convertView = layout;
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.name.setText(room);
		
		return convertView;
	}
}