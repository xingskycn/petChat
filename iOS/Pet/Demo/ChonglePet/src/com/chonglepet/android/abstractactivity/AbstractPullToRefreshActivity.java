package com.chonglepet.android.abstractactivity;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.os.Bundle;
import android.text.format.DateUtils;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;

import com.chonglepet.activity.CommonConfig;
import com.chonglepet.activity.R;
import com.chonglepet.android.adapter.ListPullToRefreshAdaper;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * 
 * @author chen
 * 
 * @description  用于下拉刷新   上啦加载更多
 */
public class AbstractPullToRefreshActivity extends AbstractBaseActivity{

	protected PullToRefreshListView mainListView; 
	
	protected ListPullToRefreshAdaper listPullToRefreshAdaper;  
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		
		initView();
		initAdapter();
		initListView();
		super.onCreate(savedInstanceState);
	}
	
	/**
	 * 重写次方法  可以设置你想要的layout
	 */
	public void initView() {
		setContentView(R.layout.pulltorefresh);
	}
	
	/**
	 * 重写次方法  可以设置你想要的适配器
	 */
	public void initAdapter() {
		listPullToRefreshAdaper=new ListPullToRefreshAdaper();
	}
	
	/**
	 * 初始化listview
	 */
	public void initListView() {
		mainListView=(PullToRefreshListView)findViewById(R.id.mainListView);
		initAdapter();
		mainListView.setAdapter(listPullToRefreshAdaper);
		initListItemClickListener();
		initPullToRefreshlistenerMode();
	}
	
	protected void initPullToRefreshlistenerMode(){
		mainListView.setMode(PullToRefreshBase.Mode.BOTH);
    	initPullToRefreshListeners();
    }

    protected void initPullToRefreshListeners()
    {
    	//设置下拉  上拉监听事件
    	mainListView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<ListView>()
        {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView)
            {
                String label = DateUtils.formatDateTime(getApplicationContext(), System.currentTimeMillis(),
                                                        DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_ABBREV_ALL);

                // 更新时间
                refreshView.getLoadingLayoutProxy().setLastUpdatedLabel(label);
                
                String reFreshingLable=getApplication().getString(R.string.refresh_refreshing_label);
                String releaseLabel=getApplication().getString(R.string.refresh_release_label);
                String pullLabel=getApplication().getString(R.string.refresh_pull_label);
                refreshView.getLoadingLayoutProxy().setRefreshingLabel(reFreshingLable); //加载显示的文字
                refreshView.getLoadingLayoutProxy().setReleaseLabel(releaseLabel); //下拉显示的文字
                refreshView.getLoadingLayoutProxy().setPullLabel(pullLabel); //下拉一点显示的文字
              
                onRefresh();
            }
            @Override
            public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView)
            {
                String label = DateUtils.formatDateTime(getApplicationContext(), System.currentTimeMillis(),
                                                        DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_ABBREV_ALL);

                // 更新时间
               /* refreshView.getLoadingLayoutProxy().setLastUpdatedLabel(label);
                refreshView.getLoadingLayoutProxy().setRefreshingLabel("aaaaaa"); //加载显示的文字
                refreshView.getLoadingLayoutProxy().setReleaseLabel("ddddddddd"); //下拉显示的文字
                refreshView.getLoadingLayoutProxy().setPullLabel("ssss"); //下拉一点显示的文字
*/                onLoadMore();
            }
        });
    	resetLoadMoreListener();
    }

   /**
    *  这个方法在滑动的时候会调用   监听滑动事件
    */
   protected void resetLoadMoreListener()
   {
	   mainListView.setOnScrollListener(new AbsListView.OnScrollListener()
       {
           @Override
           public void onScrollStateChanged(AbsListView view, int scrollState)
           {
           }

           @Override
           public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount)
           {
           		//toastShow("在滑动"+firstVisibleItem+" "+visibleItemCount+" "+totalItemCount);
               // ==的话，滑动太快根本没有回调
           }
       });
   }
    
	
	private void initListItemClickListener(){
		mainListView.setOnItemClickListener(new AdapterView.OnItemClickListener()
		{
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id)
			{
				OnListItemClickListener(parent, view, position, id);
			}
		});
	}
	
	protected void OnListItemClickListener(AdapterView<?> parent, View view, int position, long id) {
		toastShow("点击item了");
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		/**switch 必须是final  类型  不然会报错*/
		switch (taskId) {
		case CommonConfig.TASK_LIST_MAIN:
			listPullToRefreshAdaper.clearList();
			onTaskSucceededListMain(jsonTokener);
			break;

		case CommonConfig.TASK_REFRESH_LIST:
			//清楚所有的数据
			listPullToRefreshAdaper.clearList();
			onTaskSucceededListRefresh(jsonTokener);
			listPullToRefreshAdaper.notifyDataSetChanged();
			//这句代码  是用来取消那个转圈的
			mainListView.onRefreshComplete();
			break;
		case CommonConfig.TASK_LOADER_MORE:
			
			OnTaskSucceededListLodingMore(jsonTokener);
			listPullToRefreshAdaper.notifyDataSetChanged();
			mainListView.onRefreshComplete();
			break;
		}
		//super.onTaskRequestSuccess(taskId, jsonTokener);
	}

	public void onRefresh() {
		
	}

	public void onLoadMore() {
		
	}

	/** 加载数据完成   如果不需要对数据做什么处理的话   可以不需要重写次方法*/
	protected void onTaskSucceededListMain(JSONTokener jsonObject){
		addListContentDate(jsonObject);
	}
	
	/** 下拉刷新数据完成   如果不需要对数据做什么处理的话   可以不需要重写次方法*/
	protected void onTaskSucceededListRefresh(JSONTokener jsonObject){
		addListContentDate(jsonObject);
	}
	
	/** 加载更多数据完成   如果不需要对数据做什么处理的话   可以不需要重写次方法*/
	protected void OnTaskSucceededListLodingMore(JSONTokener jsonObject){
		addListContentDate(jsonObject);
	}
	
	/** 把数据保存到list里面   如果不需要对数据做什么处理的话   可以不需要重写次方法*/
	protected void addListContentDate(JSONTokener jsonObject) {
		if(jsonObject!=null&&!jsonObject.equals("")){
			//listPullToRefreshAdaper.addList(jsonObject);
		}
	}
}

