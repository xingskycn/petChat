package com.chonglepet.activity;

import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;


/**
 * 
 * @author chen
 *
 */
public class CommonConfig {

	public static int mobileWidth;
	
	public static int mobieHeigth;
	
	public static int mobieDpi;
	
	public static SharedPreferences sharedPreferences=null;
	
	public static Editor editor=null;
	
	//sd卡下面的图片保存路径
	public static String localTempImgDir="chongle/image";
	
	public static String mainUrl="http://173.255.221.74";
	
	//欢迎页面URL
	public static String startAppUrl=mainUrl+"/xampp/petAPI/startApp/android.php";
	
	//主页URL
	public static String mainPageUrl=mainUrl+"/xampp/petAPI/petList/homePage_android.php";
	
	//宠物详情URL
	public static String petDetailUrl=mainUrl+"/xampp/petAPI/petDetails/android.php";
	
	//图片上传
	public static String imageUpload=mainUrl+"/xampp/petAPI/chattingMgr/add_chattingImages_android.php";
	
	//获得视频的URL
	public static String addUploadVedioUrl=mainUrl+"/xampp/petAPI/videoMgr/getMainVideo_android.php";
	//筛选页面URL
	public static String selectUrl=mainUrl+"/xampp/petAPI/petList/filterSexType_android.php";
	//宠友动态
	public static String petFriendUrl=mainUrl+"/xampp/petAPI/petNews/petNews_Android.php";
	//宠聊群组
	public static String petGroupUrl=mainUrl+"/xampp/petAPI/petGroupList/petGroupList_Android.php";
	//聊天喊话类型
	public static String petCallUrltype=mainUrl+"/xampp/petAPI/shoutMgr/shoutType_android.php";
	//聊天喊话信息
	public static String petCallUrlInfo=mainUrl+"/xampp/petAPI/shoutMgr/shoutInfo_andorid.php";
	//聊天喊话评论
	public static String petCallUrlAdd=mainUrl+"/xampp/petAPI/shoutMgr/shoutInfo_android_add.php";
	//俱乐部
	public static String petClubUrl=mainUrl+"/xampp/petAPI/petClubList/petClubList_android.php";
	//游戏
	public static String petGameUrl=mainUrl+"/xampp/petAPI/gameMgr/gameMgr_android.php";
	//活动 
	public static String petActivityUrl=mainUrl+"/xampp/petAPI/eventMgr/eventList_android.php";
	//设置修改头像  上传头像
	public static String petUploadImageTitleUrl="http://173.255.221.74/xampp/petAPI/settings/upload_file_android.php";
	//设置信息读取
	public static String petSetInfoUrl="http://173.255.221.74/xampp/petAPI/settings/info_android.php";
	//设置信息修改
	public static String petSetInfoUpdateUrl="http://173.255.221.74/xampp/petAPI/settings/infoUpdate_android.php";
	//设置信息添加图片
	public static String petSetInfoAddImageUrl="http://173.255.221.74/xampp/petAPI/settings/infoUpdate_android.php";
	//设置信息上传视频
	public static String petSetInfoUploadVedioUrl="http://173.255.221.74/xampp/petAPI/videoMgr/videoUpload_android.php";
	//设置信息播放视频
	public static String petSetInfoPlayeVedioUrl="http://173.255.221.74/xampp/petAPI/videoMgr/getMainVideo.php";
	
	
	
	
	
	//欢迎页
	public final static int STARTAPP_TASK=0;
	//首页
	public final static int MAIN_LIST_TASK=1; 
	//宠物详情
	public final static int PET_DETAIL_TASK=2;
	//图片上传
	public final static int IMAGE_UPLOAD=3;
	//图片上传主人
	public final static int OWNER_IMAGE_UPLOAD=17;
	//图片上传宠物
	public final static int PET_IMAGE_UPLOAD=18;
	//视频上传
	public final static int PET_VEDIO_UPLOAD=4;
	//筛选
	public final static int PET_SELECT_TASK=5;
	//宠友动态
	public final static int PET_FRIEND_TASK=6;
	//宠聊群组
	public final static int PET_GROUP_TASK=7;
	//聊天喊话一
	public final static int PET_CALL_TYPE_TASK=8;
	//聊天喊话二
	public final static int PET_CALL_INFO_TASK=9;
	//聊天喊话三
	public final static int PET_CALL_ADD_TASK=10;
	//俱乐部
	public final static int PET_CLUB_TASK=14;
	//游戏
	public final static int PET_GAME_TASK=15;
	//活动 
	public final static int PET_ACTIVITY_TASK=16;
	//设置信息读取 
	public final static int PET_SETINFO_TASK=17;
	//设置信息修改 
	public final static int PET_SETINFO_UPDATE_TASK=18;
	//设置信息添加图片
	public final static int PET_SETINFO_ADDIMAGE_TASK=19;
	//设置信息上传视频
	public final static int PET_SETINFO_UPLOAD_VEDIO_TASK=20;
	//设置信息播放视频
	public final static int PET_SETINFO_PLAYE_VEDIO_TASK=21;
		
	
	//加载列表数据
	public final static int TASK_LIST_MAIN=11;
	//加载下拉刷新
	public final static int TASK_REFRESH_LIST=12;
	//加载更多
	public final static int TASK_LOADER_MORE=13;
	
	
}
