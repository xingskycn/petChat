package com.chonglepet.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractPullToRefreshActivity;
import com.chonglepet.android.adapter.HomeListAdapter;
import com.chonglepet.android.adapter.MainListAdapter;
import com.chonglepet.android.view.staggeredgridgiew.StaggeredGridView;
import com.handmark.pulltorefresh.library.PullToRefreshBase;


/**
 * 
 * @author chen
 * 
 * @description 宠物主页面
 */
public class MainActivity extends AbstractPullToRefreshActivity implements AbsListView.OnScrollListener{
	
	private MainListAdapter adapter;
	
	private List<Map<String, String>> list=new ArrayList<Map<String,String>>();
	
	private StaggeredGridView mGridView;
	
	private HomeListAdapter homeListAdapter;
	
	private List<Map<String, String>> homeList;
	
	private LinearLayout main_list_layout,home_list_layout;
	
	private Button head_right_button_home;
	
	private Dialog dialog;
	
	private boolean isListPage=true; //是否为list页面还是瀑布流页面 
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		if(SelectionActivity.animalSex!=null&&SelectionActivity.animalType>=0){
			onRequireRequestDate(SelectionActivity.animalSex, SelectionActivity.animalType);
		}
	}
	
	/**
	 * 根据条件进行筛选
	 * @param animalSex
	 * @param animalType
	 */
	public void onRequireRequestDate(String animalSex, int animalType) {
		String requestHttpKey="petList_filterSexType";
		String values="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"LBSInfo\":" +
				"{\"lbsTime\":\"2014-05-28 05:07:03 +0000\",\"longitude\":\"121.428604\"," +
				"\"latitude\":\"31.187460\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":" +
				"\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"},\"filtersInfo\":" +
				"{\"Sex\":\""+animalSex+"\",\"Type\":"+animalType+"}}";
		/*StringBuffer value=new StringBuffer("{\"apiInfo\":{\"version\":\"");
		value.append(BaseApplication.versionCode+"\",");
		value.append("\"appName\":\""+BaseApplication.versionName);
		value.append("\"},\"LBSInfo\":{\"lbsTime\":\""+BaseApplication.lbsTime);
		value.append("\",\"longitude\":\""+BaseApplication.longitude);
		value.append("\",\"latitude\":\""+BaseApplication.latitude);
		value.append("\"},\"cellsInfo\":{\"userID\":\""+BaseApplication.userID);
		value.append("\",\"UUID\":\""+BaseApplication.clientUUID);
		value.append("}\",\"filtersInfo\":{\"Sex\":\""+animalSex+"\",\"Type\":\""+animalType+"");
		value.append("\"}}");
		*/
		onRequsetViewDateList(CommonConfig.PET_SELECT_TASK, CommonConfig.selectUrl, requestHttpKey, values);
	}
	
	@Override
	public void initView() {
		setContentView(R.layout.activity_main);
		
		initHomeListLayout();
		main_list_layout=(LinearLayout)findViewById(R.id.main_list_layout);
		home_list_layout=(LinearLayout)findViewById(R.id.home_list_layout);
	}
	@SuppressLint("NewApi")
	private void initHomeListLayout() {
	    inilist();
        mGridView = (StaggeredGridView) findViewById(R.id.grid_view);
        homeListAdapter=new HomeListAdapter(this, homeList);

        mGridView.setAdapter(homeListAdapter);
        mGridView.setOnScrollListener(this);
        
       /* mGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				toastShow("aaaaaaa");
				
			}
		});*/

	}
	
	@Override
	public void initAdapter() {
		adapter=new MainListAdapter(this, list);
		listPullToRefreshAdaper=adapter;
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
		
		
		head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setBackgroundResource(R.drawable.image_look_select);
		
		head_right_button_home=(Button)findViewById(R.id.head_right_button_home);
		head_right_button_home.setBackgroundResource(R.drawable.list_icon_select);
		
		head_left_textview.setOnClickListener(this);
		head_right_button.setOnClickListener(this);
		head_right_button_home.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		//
		if(v.getId()==R.id.head_right_button){
			main_list_layout.setVisibility(View.GONE);
			home_list_layout.setVisibility(View.VISIBLE);
			head_right_button.setVisibility(View.GONE);
			head_right_button_home.setVisibility(View.VISIBLE);
			isListPage=false;
		}
		if(v.getId()==R.id.head_right_button_home){
			main_list_layout.setVisibility(View.VISIBLE);
			home_list_layout.setVisibility(View.GONE);
			head_right_button_home.setVisibility(View.GONE);
			head_right_button.setVisibility(View.VISIBLE);
			isListPage=true;
		}
		//跳入到筛选页面
		if(v.getId()==R.id.head_left_textview){
			if(isListPage){
				Intent intent=new Intent(MainActivity.this, SelectionActivity.class);
				startActivity(intent);
				MainActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
			}
			else{
				showDialogSelect();
			}
		}
		if(v.getId()==R.id.close){
			dialog.dismiss();
		}
	};
	
	StringBuffer value=null;
	
	@Override
	protected void initRequestListDate() {
		/*value="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15678\",\"UUID\":" +
				"\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"},\"LBSInfo\":{\"lbsTime\":\"2014-05-20 23:25:43 +0000\",\"longitude\":" +
				"\"121.434311\",\"latitude\":\"31.227341\"}}";
		*/
		value=new StringBuffer("{\"apiInfo\":{\"version\":\"");
		value.append(BaseApplication.versionCode+"\",");
		value.append("\"appName\":\""+BaseApplication.versionName);
		value.append("\"},\"LBSInfo\":{\"lbsTime\":\""+BaseApplication.lbsTime);
		value.append("\",\"longitude\":\""+BaseApplication.longitude);
		value.append("\",\"latitude\":\""+BaseApplication.latitude);
		value.append("\"},\"cellsInfo\":{\"userID\":\""+BaseApplication.userID);
		value.append("\",\"UUID\":\""+BaseApplication.clientUUID);
		value.append("\"}}");

		onRequsetViewDateList(CommonConfig.TASK_LIST_MAIN,CommonConfig.mainPageUrl,"petList_homePage",value.toString());
	}
	
	@Override
	public void onLoadMore() {
		onRequsetViewDateList(CommonConfig.TASK_LOADER_MORE,CommonConfig.mainPageUrl,"petList_homePage",value.toString());
	}
	
	@Override
	public void onRefresh() {
		onRequsetViewDateList(CommonConfig.TASK_REFRESH_LIST,CommonConfig.mainPageUrl,"petList_homePage",value.toString());
	}
	
	@Override
	protected void initPullToRefreshlistenerMode() {
		mainListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
		super.initPullToRefreshListeners();
	}
	
	
	@Override
	protected void OnListItemClickListener(AdapterView<?> parent, View view,
			int position, long id) {
		ListView listView=(ListView)parent;
		Map<String, Object> map=(HashMap<String, Object>)listView.getItemAtPosition(position);
		
		//跳入到详情页面
		Intent intent=new Intent(MainActivity.this, PetDetailsActivity.class);
		startActivity(intent);
		MainActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
	}

	@Override
	public void onTaskRequestStart(int taskId) {

	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		super.onTaskRequestSuccess(taskId, jsonObject);
		
		switch (taskId) {
		case CommonConfig.PET_SELECT_TASK:
			listPullToRefreshAdaper.clearList();
			addListContentDate(jsonObject);
			listPullToRefreshAdaper.notifyDataSetChanged();
			
			break;

		default:
			break;
		}
	};
	
	@Override
	protected void addListContentDate(JSONTokener jsonObject) {
		
		Map<String, String> map;
		
		try {
			/*JSONTokener jsonTokener=new JSONTokener(str);
			JSONObject jsonObject=null;
			if(jsonTokener!=null){
				jsonObject=(JSONObject)jsonTokener.nextValue();
			}*/
			if(jsonObject!=null){
				JSONObject object=(JSONObject) jsonObject.nextValue();
				
				JSONArray jsonArray=object.getJSONArray("petList");
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsonObjectPet=jsonArray.getJSONObject(i);
					String petId=jsonObjectPet.getString("petID");
					String petName=jsonObjectPet.getString("petName");
					
					//这里测试    到时候删掉循环
					for (int j = 0; j < 3; j++) {
					
					map=new HashMap<String, String>();
					map.put("textName", petName);
					
					map.put("textTitle", jsonObjectPet.getString("petNickName"));
					map.put("textSummer", jsonObjectPet.getString("userName"));
					map.put("miaoshu", jsonObjectPet.getString("userSign"));
					map.put("imageview", jsonObjectPet.getString("petImageUrl"));
					map.put("imageviewpeople", jsonObjectPet.getString("userImageUrl"));
					list.add(map);
						
					}
				}
			}
			listPullToRefreshAdaper.addList(list);
			listPullToRefreshAdaper.notifyDataSetChanged();
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
	
	}
	
	private void showDialogSelect() {
		View dialogView=(View)LayoutInflater.from(this).inflate(R.layout.select_dialog, null);
		
		Button closeButton=(Button) dialogView.findViewById(R.id.close);
		closeButton.setOnClickListener(this);
		
		dialog=new Dialog(this, R.style.CustomProgressDialog);
		dialog.setContentView(dialogView);
		dialog.setCanceledOnTouchOutside(false);
		dialog.show();

	}

	@Override
	public void onScroll(AbsListView arg0, int arg1, int arg2, int arg3) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onScrollStateChanged(AbsListView arg0, int arg1) {
		// TODO Auto-generated method stub
		
	}
	
	 private void inilist() {
		 homeList=new ArrayList<Map<String,String>>();
			
			Map<String,String> map=new HashMap<String, String>();
			
			for (int i = 0; i < 5; i++) {
					map=new HashMap<String, String>();
					map.put("image", "lang_test");
					map.put("heigth", "500");
					map.put("sex", "aaaaa");
					map.put("age", "aaaaa");
					map.put("aihao", "aaaaa");
					homeList.add(map);
					map=new HashMap<String, String>();
					map.put("image", "cat_test");
					map.put("sex", "aaaaa");
					map.put("heigth", "700");
					map.put("age", "aaaaa");
					map.put("aihao", "aaaaa");
					
					homeList.add(map);
					map=new HashMap<String, String>();
					map.put("image", "cat_test");
					map.put("heigth", "600");
					map.put("sex", "aaaaa");
					map.put("age", "aaaaa");
					map.put("aihao", "aaaaa");
					homeList.add(map);
					
					map=new HashMap<String, String>();
					map.put("image", "cat_test");
					map.put("sex", "aaaaa");
					map.put("heigth", "500");
					map.put("age", "aaaaa");
					map.put("aihao", "aaaaa");
					homeList.add(map);
					
					map=new HashMap<String, String>();
					map.put("image", "tuzi_test");
					map.put("sex", "aaaaa");
					map.put("age", "aaaaa");
					map.put("heigth", "600");
					map.put("aihao", "aaaaa");
					homeList.add(map);
			
			}
		}
}
