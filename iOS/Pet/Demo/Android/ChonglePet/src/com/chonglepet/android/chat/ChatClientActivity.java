package com.chonglepet.android.chat;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.ChatManager;
import org.jivesoftware.smack.ChatManagerListener;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smackx.filetransfer.FileTransfer;
import org.jivesoftware.smackx.filetransfer.FileTransfer.Status;
import org.jivesoftware.smackx.filetransfer.FileTransferListener;
import org.jivesoftware.smackx.filetransfer.FileTransferManager;
import org.jivesoftware.smackx.filetransfer.FileTransferRequest;
import org.jivesoftware.smackx.filetransfer.IncomingFileTransfer;
import org.jivesoftware.smackx.filetransfer.OutgoingFileTransfer;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Color;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.speech.RecognizerIntent;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.activity.CommonConfig;
import com.chonglepet.activity.ImageActivity;
import com.chonglepet.activity.R;
import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.biaoqing.ExpressionsUtil;
import com.chonglepet.android.entity.Parameter;
import com.chonglepet.android.image.BitmapHelper;
import com.chonglepet.android.utils.DBHelper;
import com.chonglepet.android.view.LayoutLinearLine;

/**
 * @author chen
 * 
 * @description  聊天页面 
 */

public class ChatClientActivity extends AbstractBaseActivity implements OnClickListener{

	private MyAdapter adapter;
	private List<Msg> listMsg = new ArrayList<Msg>();
	private String pUSERID;
	private EditText msgText;
	private ProgressBar pb;
	
	private String localTempImgDir="chongle/image";
	private String localTempImgFileName="photo1.jpg";
	
	private Bitmap bitmap1=null;
	
	public final int GET_IMAGE_VIA_CAMERA=1;
	public final int GET_IMAGE_PHOTO=3;
	public final int VOICE_RECOGNITION_REQUEST_CODE=5;
	public final int VEDIO_CODE=6;
	
	private Chat newchat;
	private Chat newchat1;
	
	private Dialog dialog;
	
	private DBHelper dbHelper;
	
	private static String beforeMessge="";

	private static String beforeMessgeTime="";
	
	/////////////////////////////////////////////
	private ViewPager viewPager;
	private ArrayList<GridView> listGridviews;
	private Button rightBtn;
	private Button voiceBtn;
	private Button keyboardBtn;
	private Button biaoqingBtn;
	private Button biaoqingfocuseBtn;
	private LinearLayout ll_fasong;
	private LinearLayout ll_yuyin;
	private EditText mEditTextContent;
	
	public class Msg {
		String userid;
		String msg;
		String date;
		String from;

		public Msg(String userid, String msg, String date, String from) {
			this.userid = userid;
			this.msg = msg;
			this.date = date;
			this.from = from;
		}
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("私聊");
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.formclient);
		super.onCreate(savedInstanceState);
		
		dbHelper=DBHelper.getInstance(this);
		dbHelper.open();
		//获取Intent传过来的用户名
		this.pUSERID = getIntent().getStringExtra("USERID");

		initListChatDate();
		
		ListView listview = (ListView) findViewById(R.id.formclient_listview);
		listview.setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL);
		
		this.adapter = new MyAdapter(this);
		listview.setAdapter(adapter);
		
		//获取文本信息
		this.msgText = (EditText) findViewById(R.id.formclient_text);
		this.pb = (ProgressBar) findViewById(R.id.formclient_pb);
		
		//表情有关的////////////////////////////////
		ll_fasong = (LinearLayout) findViewById(R.id.ll_fasong);
		ll_yuyin = (LinearLayout) findViewById(R.id.ll_yuyin);
		
		// 创建ViewPager
		viewPager = (ViewPager) findViewById(R.id.viewpager);
		/*// 个人信息
		rightBtn = (Button) findViewById(R.id.right_btn);
		rightBtn.setOnClickListener(this);
		// 语音
		voiceBtn = (Button) findViewById(R.id.chatting_voice_btn);
		voiceBtn.setOnClickListener(this);*/
		// 键盘
		keyboardBtn = (Button) findViewById(R.id.chatting_keyboard_btn);
		keyboardBtn.setOnClickListener(this);
		// 表情
		biaoqingBtn = (Button) findViewById(R.id.chatting_biaoqing_btn);
		biaoqingBtn.setOnClickListener(this);
		/*biaoqingfocuseBtn = (Button) findViewById(R.id.chatting_biaoqing_focuse_btn);
		biaoqingfocuseBtn.setOnClickListener(this);*/

		mEditTextContent = (EditText) findViewById(R.id.formclient_text);
		
		ExpressionsUtil.getInstance(this,mEditTextContent);
		listGridviews=ExpressionsUtil.listGridviews;
		viewPager.setAdapter(mPagerAdapter);
		
		
		
		//消息监听
		ChatManager cm = XmppTool.getConnection().getChatManager();
		//发送消息给water-pc服务器water（获取自己的服务器，和好友）
//		final Chat newchat = cm.createChat(this.pUSERID+"@water-pc", null);
		
		//发送消息.createChat("用户名"+"@"+"服务器", null);
		//发送文件.createOutgoingFileTransfer("用户名"+"@"+"服务器"+"版本（如果是手机/Smack）""/Spark 2.6.3");  
		newchat = cm.createChat("13712345678@chongle.com", null);
		newchat1 = cm.createChat("13122500140@chongle.com", null);
		//final Chat newchat1 = cm.createChat("chai@water-pc", null);
		//final Chat newchat2 = cm.createChat("huang@water-pc", null);
		
		cm.addChatListener(new ChatManagerListener() {
			@Override
			public void chatCreated(Chat chat, boolean able) 
			{
				chat.addMessageListener(new MessageListener() {
					@Override
					public void processMessage(Chat chat2, Message message)
					{
						Log.v("--tags--", "--tags-form--"+message.getFrom());
						Log.v("--tags--", "--tags-message--"+message.getBody());
						//收到来自water-pc服务器water的消息（获取自己的服务器，和好友）
						if(message.getFrom().contains(pUSERID+"@water-pc"))
						{
							//获取用户、消息、时间、IN
							String[] args = new String[] { pUSERID, message.getBody(), TimeRender.getDate(), "IN" };
							
							//在handler里取出来显示消息
							android.os.Message msg = handler.obtainMessage();
							msg.what = 1;
							msg.obj = args;
							msg.sendToTarget();
							//dbHelper.insertTable_Chat(pUSERID, "张三", "aaaa.jpg", "2222-4-12", messageContext,"OUT");
						}
						else
						{
							//message.getFrom().cantatins(获取列表上的用户，组，管理消息);
							//获取用户、消息、时间、IN
							Date date=new Date(System.currentTimeMillis());
							String time=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(date);
							beforeMessgeTime=TimeRender.getDate();
							String[] args = new String[] { message.getFrom(), message.getBody(), TimeRender.getDate(), "IN" };
							String str=message.toXML();
							System.out.println(str);
							//在handler里取出来显示消息
							android.os.Message msg = handler.obtainMessage();
							msg.what = 1;
							msg.obj = args;
							msg.sendToTarget();
							
							if(!beforeMessge.equals(message.getBody())){
								beforeMessge=message.getBody();
								//beforeMessgeTime=message.
								dbHelper.insertTable_Chat(pUSERID, "张三", "aaaa.jpg", "2222-4-12", message.getBody(),"IN");
							}
						}
						
					}
				});
			}
		});

		//图片
		Button chat_button_iamge = (Button) findViewById(R.id.formclient_iamge);
		chat_button_iamge.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) 
			{
				
				View dialogView=LayoutInflater.from(ChatClientActivity.this).inflate(R.layout.dialog_image_button, null);
				dialog=new Dialog(ChatClientActivity.this,R.style.CustomProgressDialog);
				dialog.setTitle("aaaaaaaaaaaaaa");
				dialog.setContentView(dialogView);
				dialog.setCanceledOnTouchOutside(true);
				dialog.show();
				
				Button buttonPaizhao=(Button) dialogView.findViewById(R.id.button_paizhao);
				Button buttonPhoto=(Button) dialogView.findViewById(R.id.button_photo_select);
				Button buttonCamera=(Button)dialogView.findViewById(R.id.button_Camera);
				
				buttonPaizhao.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						//先验证手机是否有sdcard 
				        String status=Environment.getExternalStorageState(); 
				        if(status.equals(Environment.MEDIA_MOUNTED)) 
				        { 
					        try { 
					        	File dir=new File(Environment.getExternalStorageDirectory() + "/"+localTempImgDir);  
						        if(!dir.exists())dir.mkdirs(); 
						        //这样拍照下来的图片会比较大
						       /* Intent intent=new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE); 
						        //拍照之后的图片会保存在sd卡下面   重复拍照会覆盖之前那张
						        File f=new File(dir, localTempImgFileName);//localTempImgDir和localTempImageFileName是自己定义的名字 
						        Uri u=Uri.fromFile(f); 
						        //将图片保存至SDcard，相机返回后直接在SDcard读取图片，这样可以解决获取的图片太小的问题。
						        intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0); 
						        intent.putExtra(MediaStore.EXTRA_OUTPUT, u); */
						        
						        //这个拍照下来的图片比较小
						        Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
						        startActivityForResult(intent, GET_IMAGE_VIA_CAMERA); 
					        } catch (ActivityNotFoundException  e) { 
					        	Toast.makeText(ChatClientActivity.this, "没有找到储存目录",Toast.LENGTH_LONG).show();  
					        } 
				        }else{ 
				        	Toast.makeText(ChatClientActivity.this, "没有储存卡",Toast.LENGTH_LONG).show(); 
				        } 
						
					}
				});
				buttonPhoto.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						Intent picture = new Intent(Intent.ACTION_PICK,android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
						startActivityForResult(picture, GET_IMAGE_PHOTO);
						
					}
				});
				buttonCamera.setOnClickListener(new View.OnClickListener() {
					//调用摄像功能
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
						intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 0.9);
						//限制时长
						intent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 5);
						//限制大小
						intent.putExtra(MediaStore.EXTRA_SIZE_LIMIT, 1024*1024);
						startActivityForResult(intent, VEDIO_CODE);
					}
				});
				
				/*AlertDialog.Builder builder=new AlertDialog.Builder(ChatClientActivity.this);
				builder.setTitle("ssssss");
				builder.setMessage("aaaaaa");
				builder.show();*/
			}			
		});
		//发送消息
		Button btsend = (Button) findViewById(R.id.formclient_btsend);
		btsend.setOnClickListener(this);
		
		//语言
		Button buttonLanguage=(Button)findViewById(R.id.formclient_language);
		buttonLanguage.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				 try {  
					//通过Intent传递语音识别的模式，开启语音
					 Intent intent=new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
					 //语言模式和自由模式的语音识别  
					 intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
					 //提示开启语言
					 intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "开始语言");
					 //开始语言识别
					 startActivityForResult(intent, VOICE_RECOGNITION_REQUEST_CODE);
				} catch (Exception e) {  
					e.printStackTrace();  
					showDialog();  
				}
			}
		});
		//发送表情
		Button buttonFeelButton=(Button)findViewById(R.id.chatting_keyboard_btn);
		buttonFeelButton.setOnClickListener(this);
		
		//接受文件
		FileTransferManager fileTransferManager = new FileTransferManager(XmppTool.getConnection());
		fileTransferManager.addFileTransferListener(new RecFileTransferListener());
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		//返回
		case R.id.head_left_button:
			finish();
			overridePendingTransition(R.anim.in_center, R.anim.out_from_righ);
			break;
		case R.id.formclient_btsend:
			//获取text文本
			String msg = msgText.getText().toString();
			sendMessage(msg);
			viewPager.setVisibility(View.GONE);
			break;
		// 语音
		/*case R.id.chatting_keyboard_btn:
			voiceBtn.setVisibility(View.GONE);
			keyboardBtn.setVisibility(View.VISIBLE);
			ll_fasong.setVisibility(View.GONE);
			ll_yuyin.setVisibility(View.VISIBLE);
			break;
		// 键盘
		case R.id.chatting_keyboard_btn:
			voiceBtn.setVisibility(View.VISIBLE);
			keyboardBtn.setVisibility(View.GONE);
			ll_fasong.setVisibility(View.VISIBLE);
			ll_yuyin.setVisibility(View.GONE);
			break;*/
		// 表情
		case R.id.chatting_biaoqing_btn:
			//biaoqingBtn.setVisibility(View.GONE);
			//biaoqingfocuseBtn.setVisibility(View.VISIBLE);
			viewPager.setVisibility(View.VISIBLE);
			break;
		}
	}
	
	private void initListChatDate() {
		try {
			List<Map<String, String>> list=dbHelper.queryTable_Chat(new String[]{pUSERID});
			for (Iterator iterator = list.iterator(); iterator.hasNext();) {
				Map<String, String> map = (Map<String, String>) iterator.next();
				listMsg.add(new Msg(map.get("name"), map.get("chatContent"), map.get("titleImage"), map.get("type")));
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}
	
	//提示语言错误框
	private void showDialog() {

		AlertDialog.Builder builder = new AlertDialog.Builder(ChatClientActivity.this);  
		builder.setMessage("语言提示");  
		builder.setTitle("语言出错了");  
		builder.setNegativeButton("确定",  
				new android.content.DialogInterface.OnClickListener() {  
			@Override  
			public void onClick(DialogInterface dialog, int which) {  
				/*dialog.dismiss();  
				Uri uri = Uri.parse(getApplication().getString(R.string.voice_url));  
				Intent it = new Intent(Intent.ACTION_VIEW, uri);  
				startActivity(it);  */
			}  
		});  
		builder.setPositiveButton("取消",  
				new android.content.DialogInterface.OnClickListener() {  
			@Override  
			public void onClick(DialogInterface dialog, int which) {  
				dialog.dismiss();  
			}  
		});  
		builder.create().show();  
	}

	/**
	 * 发送消息
	 * @param messageContext
	 * @return null
	 */
	private void sendMessage(String messageContext) {
		
		if(messageContext.length() > 0){
			//发送消息
			listMsg.add(new Msg(pUSERID, messageContext, TimeRender.getDate(), "OUT"));
			//刷新适配器
			adapter.notifyDataSetChanged();
			dbHelper.insertTable_Chat(pUSERID, "张三", "aaaa.jpg", "2222-4-12", messageContext,"OUT");
			try {
				//发送消息给xiaowang
				newchat.sendMessage(messageContext);
				newchat1.sendMessage(messageContext);
				//newchat2.sendMessage(msg);*/
			} 
			catch (XMPPException e)
			{
				e.printStackTrace();
			}
		}
		else
		{
			Toast.makeText(ChatClientActivity.this, "请输入信息", Toast.LENGTH_SHORT).show();
		}
		//清空text
		msgText.setText("");
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		//发送附件
		if(requestCode==2 && resultCode==2 && data!=null){
			
			String filepath = data.getStringExtra("filepath");
			if(filepath.length() > 0)
			{
				sendFile(filepath);
			}
		}
		if(resultCode==RESULT_OK ) 
		{ 
			switch(requestCode) 
			{ 
				case GET_IMAGE_VIA_CAMERA: 
					File f=new File(Environment.getExternalStorageDirectory() 
					+"/"+localTempImgDir+"/"+localTempImgFileName); 
					try { 
						dialog.dismiss();
						Bundle extras = data.getExtras();
						Bitmap b = (Bitmap) extras.get("data");
						int w=b.getWidth();
						int h=b.getHeight();
						b=ThumbnailUtils.extractThumbnail(b, 200, 200);
						OutputStream outputStream=new FileOutputStream(f);
						b.compress(CompressFormat.JPEG, 100, outputStream);
						outputStream.flush();
						outputStream.close();
						
						
//					   Uri u = 
//					   Uri.parse(android.provider.MediaStore.Images.Media.insertImage(getContentResolver(), 
//					   f.getAbsolutePath(), null, null)); 
//					   //u就是拍摄获得的原始图片的uri 
//					   bitmap1=MediaStore.Images.Media.getBitmap(this.getContentResolver(), u);
	
					   //bitmap1=ThumbnailUtils.extractThumbnail(bitmap1, 20, 20);
					   
					   String imageUrl=Environment.getExternalStorageDirectory() 
								+"/"+localTempImgDir+"/"+localTempImgFileName;
					   uploadImage(imageUrl);
					   
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} 
					break;
				case GET_IMAGE_PHOTO:
					 dialog.dismiss();
					 Uri selectedImage = data.getData();
					 String[] filePathColumns={MediaStore.Images.Media.DATA};
					 Cursor cursor = this.getContentResolver().query(selectedImage, filePathColumns, null,null, null);
					 cursor.moveToFirst();
					 String imgNo = cursor.getString(0); // 图片编号   sd卡下的路径
					/* String imgPath = cursor.getString(1); // 图片文件路径 
					 String imgSize = cursor.getString(2); // 图片大小 
					 String imgName = cursor.getString(3); // 图片文件名 
*/					 cursor.close(); 
					 Options options = new BitmapFactory.Options(); 
					 options.inJustDecodeBounds = false; 
					 options.inSampleSize = 10; 
					 
					 uploadImage(imgNo);
					 
					
					break;
					
				case VOICE_RECOGNITION_REQUEST_CODE:
					 //取得语音的字符  
		            ArrayList<String> results=data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);  
		              
		            String resultString="";  
		            for(int i=0;i<results.size();i++){  
		                resultString+=results.get(i);  
		            }  
		            Toast.makeText(this, resultString, 1).show();  
					break;
					
				case VEDIO_CODE:
					Uri videoUri = data.getData();
					Cursor cursor2 = managedQuery(videoUri, null, null, null, null);
					cursor2.moveToFirst();//这个必须加，否则下面读取会报错
					int num = cursor2.getCount();
					String recordedVideoFilePath = cursor2.getString(cursor2.getColumnIndex(MediaStore.Video.Media.DATA));
					//int recordedVideoFileSize = cursor2.getInt(cursor2.getColumnIndex(MediaStore.Video.Media.SIZE));
					///storage/sdcard0/照相机/Camera/VID_20140604_122836.3gp
					uploadVedio(recordedVideoFilePath);
					break;
			}
			
		} 
		
	}
	
	//发送图片的     发送图片到服务器   返回一个图片的URL    之后发送过去   
	protected void uploadImage(String iamgeUrl){
		String imageUrl=null;
		List<Parameter> params=new ArrayList<Parameter>();
		params =new ArrayList<Parameter>();
		Parameter parameter=new Parameter();
		parameter.setRequestHttpKey("add_chattingImages");
		parameter.setValue("{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}");
		params.add(parameter);
		
		parameter=new Parameter();
		parameter.setRequestHttpKey("chatting_images");
		parameter.setValue(iamgeUrl);
		params.add(parameter);
		onRequestImageUpload(CommonConfig.PET_IMAGE_UPLOAD, CommonConfig.imageUpload, params);
		
	}
	//发送视频的     发送视频到服务器   返回一个图片的URL    之后发送过去   
	private void uploadVedio(String iamgeUrl){
		
		List<Parameter> params=new ArrayList<Parameter>();
		params =new ArrayList<Parameter>();
		Parameter parameter=new Parameter();
		parameter.setRequestHttpKey("get_mainVideo_android");
		parameter.setValue("{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"}}");
		params.add(parameter);
		
//		parameter=new Parameter();
//		parameter.setRequestHttpKey("chatting_images");
//		parameter.setValue(iamgeUrl);
//		params.add(parameter);
//		onRequestVedioUpload(CommendConfig.PET_VEDIO__UPLOAD, CommendConfig.addUploadVedioUrl, params);
		
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonTokener) {
		try {
			JSONObject jsonObject=(JSONObject)jsonTokener.nextValue();
			switch (taskId) {
			case CommonConfig.PET_IMAGE_UPLOAD:
					if(jsonObject!=null&&jsonObject.length()>0){
						String imageUrl=jsonObject.getString("imageUrl");
						if(imageUrl!=null&&!imageUrl.equals(""))
							sendMessage(imageUrl);
					}
				break;
				
			case CommonConfig.PET_VEDIO_UPLOAD:
					String mainVideoUrl=jsonObject.getString("mainVideoUrl");
					System.out.println(mainVideoUrl);
				break;
	
			default:
				break;
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		super.onTaskRequestSuccess(taskId, jsonTokener);
	}
	
	private void sendFile(String filepath) {
		// ServiceDiscoveryManager sdm = new ServiceDiscoveryManager(connection);
		
		final FileTransferManager fileTransferManager = new FileTransferManager(XmppTool.getConnection());
		//发送给water-pc服务器，water（获取自己的服务器，和好友）   //发送文件.createOutgoingFileTransfer("用户名"+"@"+"服务器"+"版本（如果是手机/Smack）""/Spark 2.6.3");
		final OutgoingFileTransfer fileTransfer = fileTransferManager.createOutgoingFileTransfer(this.pUSERID+"@water-pc/Spark 2.6.3");				
		
		final File file = new File(filepath);
		
		try 
		{
			fileTransfer.sendFile(file, "Sending");
		} 
		catch (Exception e) 
		{
			Toast.makeText(ChatClientActivity.this,"发送失败!",Toast.LENGTH_SHORT).show();
			e.printStackTrace();
		}
		new Thread(new Runnable() {
			@Override
			public void run() 
			{
				try{					
					while (true) 
					{
						Thread.sleep(500L);
						
						Status status = fileTransfer.getStatus();								
						if ((status == FileTransfer.Status.error)
								|| (status == FileTransfer.Status.complete)
								|| (status == FileTransfer.Status.cancelled)
								|| (status == FileTransfer.Status.refused))
						{
							handler.sendEmptyMessage(4);
							break;
						}
						else if(status == FileTransfer.Status.negotiating_transfer)
						{
							//..
						}
						else if(status == FileTransfer.Status.negotiated)
						{							
							//..
						}
						else if(status == FileTransfer.Status.initial)
						{
							//..
						}
						else if(status == FileTransfer.Status.negotiating_stream)
						{							
							//..
						}
						else if(status == FileTransfer.Status.in_progress)
						{
							//进度条显示
							handler.sendEmptyMessage(2);
							
							long p = fileTransfer.getBytesSent() * 100L / fileTransfer.getFileSize();	
							
							android.os.Message message = handler.obtainMessage();
							message.arg1 = Math.round((float) p);
							message.what = 3;
							message.sendToTarget();
							Toast.makeText(ChatClientActivity.this,"发送成功!",Toast.LENGTH_SHORT).show();
						}
					}
				} 
				catch (Exception e) 
				{
					Toast.makeText(ChatClientActivity.this,"发送失败!",Toast.LENGTH_SHORT).show();
					e.printStackTrace();
				}
			}
		}).start();
	}


	private FileTransferRequest request;
	private File file;

	class RecFileTransferListener implements FileTransferListener 
	{
		@Override
		public void fileTransferRequest(FileTransferRequest prequest)
		{
			//接受附件
//			System.out.println("The file received from: " + prequest.getRequestor());
			
			file = new File("mnt/sdcard/" + prequest.getFileName());
			request = prequest;
			handler.sendEmptyMessage(5);
		}
	}

	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) 
		{
							
			switch (msg.what) {
			case 1:
				//获取消息并显示
				String[] args = (String[]) msg.obj;
				listMsg.add(new Msg(args[0], args[1], args[2], args[3]));
				//刷新适配器
				adapter.notifyDataSetChanged();
				break;			
			case 2:
				//附件进度条
				if(pb.getVisibility()==View.GONE){
					pb.setMax(100);
					pb.setProgress(1);
					pb.setVisibility(View.VISIBLE);
				}
				break;
			case 3:
				pb.setProgress(msg.arg1);
				break;
			case 4:
				pb.setVisibility(View.GONE);
				break;
			case 5:
				final IncomingFileTransfer infiletransfer = request.accept();
				
				//提示框
				AlertDialog.Builder builder = new AlertDialog.Builder(ChatClientActivity.this);
				
				builder.setTitle("附件：")
						.setCancelable(false)
						.setMessage("是否接收文件："+file.getName()+"?")
						.setPositiveButton("接受",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog, int id) {
										try 
										{
											infiletransfer.recieveFile(file);
										} 
										catch (XMPPException e)
										{
											Toast.makeText(ChatClientActivity.this,"接收失败!",Toast.LENGTH_SHORT).show();
											e.printStackTrace();
										}
										
										handler.sendEmptyMessage(2);
										
										Timer timer = new Timer();
										TimerTask updateProgessBar = new TimerTask() {
											public void run() {
												if ((infiletransfer.getAmountWritten() >= request.getFileSize())
														|| (infiletransfer.getStatus() == FileTransfer.Status.error)
														|| (infiletransfer.getStatus() == FileTransfer.Status.refused)
														|| (infiletransfer.getStatus() == FileTransfer.Status.cancelled)
														|| (infiletransfer.getStatus() == FileTransfer.Status.complete)) 
												{
													cancel();
													handler.sendEmptyMessage(4);
												} 
												else
												{
													long p = infiletransfer.getAmountWritten() * 100L / infiletransfer.getFileSize();													
													
													android.os.Message message = handler.obtainMessage();
													message.arg1 = Math.round((float) p);
													message.what = 3;
													message.sendToTarget();
													Toast.makeText(ChatClientActivity.this,"接收完成!",Toast.LENGTH_SHORT).show();
												}
											}
										};
										timer.scheduleAtFixedRate(updateProgessBar, 10L, 10L);
										dialog.dismiss();
									}
								})
						.setNegativeButton("取消",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog, int id)
									{
										request.reject();
										dialog.cancel();
									}
								}).show();
				break;
			default:
				break;
			}
		};
	};

	//退出
	@Override
	public void onBackPressed()
	{
		super.onBackPressed();
		/*XmppTool.closeConnection();
		System.exit(0);
		android.os.Process.killProcess(android.os.Process
				.myPid());*/
	}

	class MyAdapter extends BaseAdapter {

		private Context cxt;
		private LayoutInflater inflater;

		public MyAdapter(ChatClientActivity formClient) {
			this.cxt = formClient;
		}

		@Override
		public int getCount() {
			return listMsg.size();
		}

		@Override
		public Object getItem(int position) {
			return listMsg.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) 
		{
			//显示消息的布局：内容、背景、用户、时间
			this.inflater = (LayoutInflater) this.cxt.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			
			//IN,OUT的图片
			if(listMsg.get(position).from.equals("IN"))
			{
				convertView = this.inflater.inflate(R.layout.formclient_chat_in, null);
			}
			else
			{
				convertView = this.inflater.inflate(R.layout.formclient_chat_out, null);
			}
			
			ImageView chat_title_image_left=(ImageView)convertView.findViewById(R.id.chat_title_image_left);
			ImageView chat_title_image_right=(ImageView)convertView.findViewById(R.id.chat_title_image_right);
			TextView useridView = (TextView) convertView.findViewById(R.id.formclient_row_userid);
			TextView dateView = (TextView) convertView.findViewById(R.id.formclient_row_date);
			ImageView formclient_row_image_msg=(ImageView)convertView.findViewById(R.id.formclient_row_image_msg);
			LayoutLinearLine formclient_row_layout=(LayoutLinearLine)convertView.findViewById(R.id.formclient_row_layout);
			
			useridView.setText(listMsg.get(position).userid);
			dateView.setText(listMsg.get(position).date);
			
			final String message=listMsg.get(position).msg;
			if(message!=null&&!message.equals("")){
				if(message.contains(".jpg")||message.contains(".png")){
					formclient_row_image_msg.setVisibility(View.VISIBLE);
					BitmapHelper.getInstance().loadImage(null, message, 0, formclient_row_image_msg);
					formclient_row_image_msg.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							Intent intent=new Intent(ChatClientActivity.this, ImageActivity.class);
							intent.putExtra("imageurl", message);
							startActivity(intent);
						}
					});
				}
				else{
					formclient_row_layout.setVisibility(View.VISIBLE);
					//Expressions.rePlaceStrings(ChatClientActivity.this, formclient_row_layout, message);
					rePlaceStrings(ChatClientActivity.this, formclient_row_layout, message);
					//判断是否为视频的
					//if(message.contains(".mp4")||message.contains(".3gp")){
					/*msgView.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							Intent intent=new Intent(ChatClientActivity.this, MediaPlayActivity.class);
							intent.putExtra("imageurl", "aaaaaa");
							startActivity(intent);
						}
					});*/
					//判断是否为表情
					
				}
			}
			return convertView;
		}
	}
	
	// 填充ViewPager的数据适配器
	PagerAdapter mPagerAdapter = new PagerAdapter() {
		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}
		
		@Override
		public int getCount() {
			return listGridviews.size();
		}
		
		@Override
		public void destroyItem(View container, int position, Object object) {
			((ViewPager) container).removeView(listGridviews.get(position));
		}
		
		@Override
		public Object instantiateItem(View container, int position) {
			((ViewPager) container).addView(listGridviews.get(position));
			return listGridviews.get(position);
		}
	};
	
	/////////////////////////////////////
	/**
	 *  如果一串字符串可能包含表情或没表情
	 * @param context
	 * @param message
	 * @return
	 */
	public static void rePlaceStrings(Context context,LayoutLinearLine layout, String message){
		if(message!=null&&!message.equals("")){
			if(message.contains("f")){
				String imageurl=null;
				String endString=null;
				String beginString=null;
				int count=0;
				int titalLenth=message.length();
				while(true){
					//如果以f开头的
					if(message.startsWith("f")){
						imageurl=message.substring(message.indexOf("f"), message.indexOf("f")+4);
						endString=message.substring(message.indexOf("f")+4);
						message=endString;
						count=imageurl.length()+count;
						int imageId=getDrawable(imageurl);
						//那就是表情
						if(imageId>0){
							addLayoutImageView(layout, context, imageId);
						}
						else{
							addMessage(layout,context,imageurl);
						}
					}
					else{
						if(message.contains("f")){
							beginString=message.substring(0,message.indexOf("f"));
							imageurl=message.substring(message.indexOf("f"), message.indexOf("f")+4);
							endString=message.substring(message.indexOf("f")+4);
							message=endString;
							
							addMessage(layout,context,beginString);
							
							count=beginString.length()+imageurl.length()+count;
							int imageId=getDrawable(imageurl);
							//那就是表情
							if(imageId>0){
								addLayoutImageView(layout, context, imageId);
							}
							else{
								addMessage(layout,context,imageurl);
							}
						}
						else{
							addMessage(layout,context,endString);
							count=message.length()+count;
						}
					}
					if(titalLenth==count){
						break;
					}
				}
			}
			else{
				addMessage(layout,context,message);
			}
		}
	}
	
	private static void addMessage(LayoutLinearLine layout,Context context, String message) {
		if(message.length()<8){
			addLayoutTextView(layout, context, message);
		}
		else{
			for (int i = 0; i < message.length(); i++) {
				addLayoutTextView(layout, context, message.substring(i,i+1));
			}
		}
	}
	
	private static void addLayoutTextView(LayoutLinearLine layout,Context context, String message) {

		LayoutParams params = new LayoutParams(50, LayoutParams.MATCH_PARENT);
		params.setMargins(0, 0, 0,0);
		TextView textView=new TextView(context);
		textView.setText(message);
		textView.setTextColor(Color.BLACK);
		textView.setTextSize(20);
		textView.setPadding(5, 5, 5, 5);
		textView.setLayoutParams(params);
		
		if(message.length()>1){
			layout.setLayoutParams(new LayoutParams(message.length()*80, LayoutParams.WRAP_CONTENT));
		}
		else{
			layout.setLayoutParams(new LayoutParams(600, LayoutParams.WRAP_CONTENT));
		}
		layout.addView(textView);
		
	}
	
	private static void addLayoutImageView(LayoutLinearLine layout,Context context, int imageId) {
		//设置图片大小不起作用
		LayoutParams params = new LayoutParams(160,160);
		params.setMargins(0, 0, 0,0);
		ImageView imageview=new ImageView(context);
		imageview.setImageResource(imageId);
		imageview.setLayoutParams(params);
		
		layout.setLayoutParams(new LayoutParams(600, LayoutParams.WRAP_CONTENT));
		layout.addView(imageview);
	}
	
	private static int getDrawable(String imageurl){
		 Class drawable  =  R.drawable.class;
		 Field field = null;
		 int iamgeId =0;
      try {
          field = drawable.getField(imageurl);
          iamgeId = field.getInt(field.getName());
      } catch (Exception e) {
      }          

		return iamgeId;
	}
	
}