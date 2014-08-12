package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.adapter.HomeListAdapter;
import com.chonglepet.android.view.staggeredgridgiew.StaggeredGridView;


/**
 * 
 * @author chen
 * 
 * @description 宠物主页面
 */

@SuppressLint("NewApi")
public class HomeActivity extends AbstractBaseActivity implements AbsListView.OnScrollListener {

    private static final String TAG = "StaggeredGridActivity";
    public static final String SAVED_DATA_KEY = "SAVED_DATA";

    private StaggeredGridView mGridView;

    private ArrayList<String> mData;
    
    private HomeListAdapter homeListAdapter;
    
    private List<Map<String, String>> list;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	setContentView(R.layout.home);
        super.onCreate(savedInstanceState);

        inilist();
        mGridView = (StaggeredGridView) findViewById(R.id.grid_view);

        homeListAdapter=new HomeListAdapter(this, list);

        mGridView.setAdapter(homeListAdapter);
        mGridView.setOnScrollListener(this);
    }
    
    @Override
	protected void initHeadTitleLayout() {
		TextView head_left_textview=(TextView)findViewById(R.id.head_left_textview);
		head_left_textview.setVisibility(View.VISIBLE);
		head_left_textview.setText("筛选(全部)");
		head_left_textview.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("附近");
		
		
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.list_icon_select);
		
		head_left_textview.setOnClickListener(this);
		head_right_button.setOnClickListener(this);
	}
    
    @Override
    public void onClick(View v) {
    	if(v.getId()==R.id.head_right_button){
    		Intent intent=new Intent(HomeActivity.this, TabMainActivity.class);
    		intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
			startActivity(intent);
			HomeActivity.this.getParent().overridePendingTransition(R.anim.in_from_left, R.anim.out_to_righ);
    	}
    }

    @Override
    protected void onSaveInstanceState(final Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putStringArrayList(SAVED_DATA_KEY, mData);
    }

    @Override
    public void onScrollStateChanged(final AbsListView view, final int scrollState) {
        Log.d(TAG, "onScrollStateChanged:" + scrollState);
    }

    @Override
    public void onScroll(final AbsListView view, final int firstVisibleItem, final int visibleItemCount, final int totalItemCount) {
        Log.d(TAG, "onScroll firstVisibleItem:" + firstVisibleItem +
                            " visibleItemCount:" + visibleItemCount +
                            " totalItemCount:" + totalItemCount);
        /*// our handling
        if (!mHasRequestedMore) {
            int lastInScreen = firstVisibleItem + visibleItemCount;
            if (lastInScreen >= totalItemCount) {
                Log.e(TAG, "onScroll lastInScreen - so load more");
                Toast.makeText(this, "正在加载中...", Toast.LENGTH_SHORT).show();
                mHasRequestedMore = true;
                onLoadMoreItems();
            }
        }*/
    }

    private void onLoadMoreItems() {
       /* final ArrayList<String> sampleData = SampleData.generateSampleData();
        for (String data : sampleData) {
        }
        // stash all the data in our backing store
        mData.addAll(sampleData);
        // notify the adapter that we can update now
        mHasRequestedMore = false;*/
    }
    
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
    	if(keyCode==KeyEvent.KEYCODE_BACK){
    		Intent intent=new Intent(HomeActivity.this, TabMainActivity.class);
    		intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(intent);
			HomeActivity.this.getParent().overridePendingTransition(R.anim.in_from_left, R.anim.out_to_righ);
    	}
    	return super.onKeyDown(keyCode, event);
    }
    
    private void inilist() {
		list=new ArrayList<Map<String,String>>();
		
		Map<String,String> map=new HashMap<String, String>();
		
		for (int i = 0; i < 5; i++) {
				map=new HashMap<String, String>();
				map.put("image", "lang_test");
				map.put("heigth", "500");
				map.put("sex", "aaaaa");
				map.put("age", "aaaaa");
				map.put("aihao", "aaaaa");
				list.add(map);
				map=new HashMap<String, String>();
				map.put("image", "cat_test");
				map.put("sex", "aaaaa");
				map.put("heigth", "700");
				map.put("age", "aaaaa");
				map.put("aihao", "aaaaa");
				
				list.add(map);
				map=new HashMap<String, String>();
				map.put("image", "cat_test");
				map.put("heigth", "600");
				map.put("sex", "aaaaa");
				map.put("age", "aaaaa");
				map.put("aihao", "aaaaa");
				list.add(map);
				
				map=new HashMap<String, String>();
				map.put("image", "dog_test");
				map.put("sex", "aaaaa");
				map.put("heigth", "500");
				map.put("age", "aaaaa");
				map.put("aihao", "aaaaa");
				list.add(map);
				
				map=new HashMap<String, String>();
				map.put("image", "tuzi_test");
				map.put("sex", "aaaaa");
				map.put("age", "aaaaa");
				map.put("heigth", "600");
				map.put("aihao", "aaaaa");
				list.add(map);
		
		}
	}
}
