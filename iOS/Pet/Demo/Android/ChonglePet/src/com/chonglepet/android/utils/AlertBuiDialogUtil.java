/*package com.chonglepet.android.utils;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.linrunsoft.mgov.android.R;
import com.linrunsoft.mgov.android.jinganmain.SystemSetActivity;
import com.linrunsoft.mgov.android.jinganmain.UpdateService;
import com.linrunsoft.mgov.android.nf.CacheManager;

public class AlertBuiDialogUtil {

	private static AlertDialog.Builder builder;
	
	private static Dialog dialog;
	
	public AlertBuiDialogUtil(Context context) {

	}
	
	public static void CleanlAllCacheDialog(final Context context){
		
		builder=new AlertDialog.Builder(context);
		builder.setTitle("清除缓存");
		builder.setMessage("系统会永久的删除此应用的所有数据。删除的内容包括所有数据库");
		builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				CacheManager.clearAllCache(context);
				SystemSetActivity.cleartext.setText("缓存清理成功");
			}
		});
		builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
		});
		
		builder.show();
	}
	
	public static void UpdateVersionDialog(final Context context){
		//以http开头的就更新
		String versiontitle=FileUtil.locationURL;
		
		if(versiontitle!=null){
			if((versiontitle.substring(0, 7)).contains("http://")){
				
				dialog=new Dialog(context);
				
				View view=LayoutInflater.from(context).inflate(R.layout.activity_version_dialog, null);
				
				TextView textView=(TextView)view.findViewById(R.id.textversiondialog);
				textView.setText(SystemSetActivity.summary);
				Button vsersionok=(Button)view.findViewById(R.id.versionok);
				Button versioncanle=(Button)view.findViewById(R.id.versioncancle);
				
				vsersionok.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						Intent updateIntent = new Intent(context,UpdateService.class);  
	                    updateIntent.putExtra("app_name",  
	                   		 context.getResources().getString(  
	                                    R.string.app_name));  
	                    context.startService(updateIntent);  
	                    
	                    AlertBuiDialogUtil.DownLoaderDialog(context);
	                    dialog.dismiss();
					}
				});
				
				versioncanle.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dialog.dismiss();
					}
				});
				dialog.setTitle("检测到最新版本:");
				dialog.setContentView(view);
				dialog.show();
			}
		}
	}
	
	public static void WithMeDialog(Context context,String version){
		
		View view=LayoutInflater.from(context).inflate(R.layout.activity_withwe, null);
		TextView textView=(TextView) view.findViewById(R.id.withmentextview);
		
		String content="“上海静安”微门户是在“上海静安”门户网站现有资源的基础上,结合手机终端的特点建立起来的静安区人民政府官方移动门户。";
		//String content="当前版本是："+version+"。上海静安门户网站是静安区政府各部门在互联网上政府信息公开和提供在线服务的总平台，是静安区政府各部门网站与公众联络和交流的总窗口。静安门户网站已成为宣传区域形象的窗口、提供政府服务的载体、市民与政府沟通的桥梁。";
		textView.setText(content);
		Button button=(Button)view.findViewById(R.id.buttonwithme);
		dialog=new Dialog(context);
		dialog.setTitle("关于我们");
		dialog.setContentView(view);
		dialog.show();
		
		button.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				dialog.dismiss();
			}
		});
		
	}
	
	public static void DownLoaderDialog(Context context){
		
		builder=new AlertDialog.Builder(context);
		builder.setTitle("下载提示");
		builder.setIcon(R.drawable.jaapp);
		builder.setMessage("我们已经在后台开始下载新版本，请通过系统通知栏了解下载进度并进行安装操作。");
		builder.setPositiveButton("确定", new OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
		});
		
		builder.show();
	}
	
	public static void HttpRequestErrorDialog(Context context){
		builder=new AlertDialog.Builder(context);
		builder.setTitle("下载提示");
		builder.setIcon(R.drawable.jingan);
		builder.setMessage("网络请求异常，请检测网络是否正常！！");
		builder.setPositiveButton("确定", new OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
		});
		
		builder.show();
	}

	public static void SetNetworkDialog(final Context context) {
		// TODO Auto-generated method stub
		 new AlertDialog.Builder(context).setTitle("提示").setMessage("检测到当前无网络，请设置网络连接 ")
		  	.setPositiveButton("立即设置", new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					Intent intent=new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS);
					
					context.startActivity(intent);
				}
			}).setNegativeButton("取消", new DialogInterface.OnClickListener(){

				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					
				}
				
			}).show();
	}
}
*/