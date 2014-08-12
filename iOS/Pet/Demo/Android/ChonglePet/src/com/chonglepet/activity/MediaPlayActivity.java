package com.chonglepet.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnBufferingUpdateListener;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

/**
 *  播放网络视频
 *  @author 陈永兵
 *  
 */
public class MediaPlayActivity extends Activity implements OnClickListener,
													  OnBufferingUpdateListener,//网络缓冲数据流变化的时候唤起的播放事件
													  OnCompletionListener,//当媒体资源在播放的时候到达终点时唤起的播放事件
													  MediaPlayer.OnPreparedListener,
													  SurfaceHolder.Callback //回调函数
													  ,OnSeekBarChangeListener  //调音监听器
													  {

	
	private ImageButton play,flashPlaye,flashBack; // 暂停  播放    快进   快退按钮

	private SurfaceView surfaceView; //显示媒体
	
	private SurfaceHolder surfaceHolder;  //控制显示媒体
	
	//控制栏
	private LinearLayout layout_control;
	
	private LinearLayout layout_progress;
	
	private LinearLayout linear_center;  //显示播放那一栏
	
	private LinearLayout linercenter_top;
	
	private LinearLayout linear_progress;   //加载框
	
	private LinearLayout mediaplayprogress; //播放错误时提示文本
	
	private MediaPlayer mediaPlayer;  //播放媒体
	
	private String path;  //路径
	
	private boolean boTing=true;  //播放状态
	
	private int num;  //播放位置
	
	private int count=0; //点击屏幕次数
	
	private int firstcount=0; //开线程第一次点击次数
	
	private SeekBar seekBar; //播放进度条
	
	private TextView showTime; //显示时间组件
	
	private MyThread mythread; //线程控制
	
	private SeekBar sound;//声音控制
	
	private int soundId;  //声音进度
	
	private int videoLength; //截取拖动进度条

	private boolean f=true; 
	
	private int hint=5000;  //按钮隐藏时间
	
	private TextView allTime; //显示视频总时间
	
	private AudioManager audioManager;  //设备管理者
	
	private int maxVulume,currentVulume;  //最大音量  和当前音量
	
	private boolean issound=true;    //是否有声音（静音）
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		//无标题
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		//获得硬件加速
		this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
								  WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		//禁止黑屏
		this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
								WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		
		setContentView(R.layout.activity_media);
		
		//获取系统音量管理
		audioManager=(AudioManager)getSystemService(Context.AUDIO_SERVICE);
		
		Intent intent= getIntent();
		/*path=intent.getStringExtra("mediaUrl");
		if (path != null && path.startsWith("/")){
			path = "http://" + GlobalValue.SERVICE_HOST + path;
		}*/
		
		play=(ImageButton)findViewById(R.id.pause);
		layout_control=(LinearLayout)findViewById(R.id.layout_control);
		layout_progress=(LinearLayout)findViewById(R.id.layout_progress);
		linear_center=(LinearLayout)findViewById(R.id.linercenter);
		linercenter_top=(LinearLayout)findViewById(R.id.linercenter_top);
		linear_progress=(LinearLayout)findViewById(R.id.progressbar);
		mediaplayprogress=(LinearLayout)findViewById(R.id.mediaplayprogress);
		
		//init();
		
		seekBar=(SeekBar)findViewById(R.id.seekbar);
		showTime=(TextView)findViewById(R.id.showTime);
		flashPlaye=(ImageButton)findViewById(R.id.flashPlaye);
		flashBack=(ImageButton)findViewById(R.id.flashBack);
		
		sound=(SeekBar)findViewById(R.id.sound);
		surfaceView=(SurfaceView)findViewById(R.id.surfaceView);
		
		allTime=(TextView)findViewById(R.id.allTime);
		
		surfaceHolder=surfaceView.getHolder();
		
		//设置回调函数
		surfaceHolder.addCallback(this);
		//设置风格
		surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		
		//设置按键监听
		play.setOnClickListener(this);
		
		flashPlaye.setOnClickListener(this);
		
		flashBack.setOnClickListener(this);
		
		//设置屏幕点击
		surfaceView.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				
				if(MotionEvent.ACTION_DOWN==event.getAction()){
					
					linear_center.setVisibility(View.VISIBLE);
					linercenter_top.setVisibility(View.VISIBLE);
					count++;
					if(count==1){
						//count==1 就开线程去做判断     避免每次点击的时候都去开线程
						firstcount=count;
						new MyThreadHide().start();
					}
					
				}
				
				return false;
			}
		});
		
		sound.setOnSeekBarChangeListener(this);
		
		seekBar.setOnSeekBarChangeListener(new MySeekbar());
	}
	
	
	private void playVideo(){
		
		try {
			surfaceView.setBackgroundDrawable(null);
			linear_progress.setVisibility(View.GONE);
			
			//设置时间监听
			mediaPlayer.setOnBufferingUpdateListener(this);
			mediaPlayer.setOnCompletionListener(this);
			mediaPlayer.setOnPreparedListener(this);
			mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
			seekBar.setMax(mediaPlayer.getDuration());
			
			maxVulume=audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);  //获取系统最大音量  
			sound.setMax(maxVulume);
			currentVulume=audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);  //获得当前音量
			sound.setProgress(10);
			//设置当前播放音量
			soundId=sound.getProgress();
			mediaPlayer.setVolume(30,30);
			
			mythread=new MyThread();
			mythread.start();
			//handle.sendEmptyMessage(0*13);
			int n=mediaPlayer.getDuration(); //获得持续时间
			seekBar.setMax(n);
			n=n/1000;
			int m=n/60;
			int h=m/60;
			int s=n%60;
			m=m%60;

			//总长度
			if(h>1){
				allTime.setText(String.format("%02d:%02d:%02d", h,m,s));
			}
			else{
				allTime.setText(String.format("%02d:%02d", m,s));
			}
			mediaPlayer.start();
			
			//播放的时候开去隐藏下面那一栏
			new MyThreadHide().start();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	class MyThreadPlay extends Thread{
		@Override
		public void run() {
			// TODO Auto-generated method stub
			mediaPlayer=new MediaPlayer();
			try {
				//设置媒体文件路径
				mediaPlayer.setDataSource("http://173.255.221.74/xampp/petAPI/videoMgr/upload/15679_test.mp4");
				//设置通过surfaceview来显示画面
				mediaPlayer.setDisplay(surfaceHolder);
				mediaPlayer.prepare(); //准备
				
				handler.sendEmptyMessage(0x16);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				handler.sendEmptyMessage(0x17);
			}
		}
	}
	
	class MyThreadHide extends Thread{
		@Override
		public void run() {
			try {
				sleep(hint);
				//如果count在5秒之内没有发生变化   就去隐藏
				if(firstcount==count){
					handler.sendEmptyMessage(0x15);
					hint=5000;
					count=0;
					firstcount=0;
				}
				//如果count在5秒之内发生变化了   那就重新去开线程  直到这5秒之内不在点击surfaceview了   就去隐藏
				else{
					firstcount=count;
					hint=3000;  //设置线程休眠3秒
					new MyThreadHide().start();
				}
				
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	class MyThread extends Thread{

		@Override
		public void run() {
			// TODO Auto-generated method stub
			handler.sendEmptyMessage(0x11);
			if(f){
				try {
					sleep(1000);
					handler.sendEmptyMessage(0x12);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}
	
	Handler handler=new Handler(){
		
		public void handleMessage(android.os.Message msg) {
			
			if(msg.what==0x11){
				
				if(MediaPlayActivity.this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_PORTRAIT){
					layout_control.setVisibility(View.VISIBLE);
					layout_progress.setVisibility(View.VISIBLE);
				}
				if(MediaPlayActivity.this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE){
					layout_control.setVisibility(View.GONE);
					layout_progress.setVisibility(View.GONE);
				}
			};
			if(msg.what==0x12){
				if(mediaPlayer!=null){
					//当从播放的界面跳到其他界面的时候，总是爆出MediaPlayer.getCurrentPosition IllegalStateException的错误。
					//后来想了一下，是因为播放器所在的Activity已经进入OnStop状态，再让后台调整音乐进度条的服务获取进度条(MediaPlayer.getCurrentPosition)肯定不合法。
					num=mediaPlayer.getCurrentPosition();
				}
				seekBar.setProgress(num);
				//为十分秒赋值
				num=num/1000;
				int minute=num/60;
				int hour=minute/60;
				int second=num%60;
				minute=minute%60;
				
				//播放进度
				if(hour>1){
					showTime.setText(String.format("%02d:%02d:%02d", hour,minute,second));
				}
				else{
					showTime.setText(String.format("%02d:%02d", minute,second));
				}
				handler.sendEmptyMessage(0x12);
			}
			if(msg.what==0x15){
				linear_center.setVisibility(View.INVISIBLE);
				linercenter_top.setVisibility(View.INVISIBLE);
			}
			if(msg.what==0x16){
				playVideo();
			}
			if(msg.what==0x17){
				mediaplayprogress.setVisibility(View.VISIBLE);
				linear_progress.setVisibility(View.GONE);
			}
		};
	};
	
	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		// TODO Auto-generated method stub
		
		new MyThreadPlay().start();

	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPrepared(MediaPlayer mp) {
		// TODO Auto-generated method stub
	}

	//播放完之后   可以播放下一部影片    或者到停止页面
	@Override
	public void onCompletion(MediaPlayer mp) {
		// TODO Auto-generated method stub
		//Toast.makeText(MediaPlayActivity.this, videoLength+"播放玩调用的事件", 0).show();
		mediaPlayer.seekTo(1);
		mediaPlayer.pause();
		/*mediaPlayer.release();       这里有个bug   不能清屏
		mediaPlayer=null;*/

		surfaceView.setBackgroundResource(R.drawable.button1);
		boTing=false;
		play.setImageResource(R.drawable.play_button_pressed);
	}

	@Override
	public void onBufferingUpdate(MediaPlayer mp, int percent) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if(v==play){
			count++;
			if(boTing){
				surfaceView.setBackgroundDrawable(null);
				play.setImageResource(R.drawable.play_button_pressed);
				if(mediaPlayer!=null){
					mediaPlayer.pause();
				}
				boTing=false;
			}
			else{
				surfaceView.setBackgroundDrawable(null);
				play.setImageResource(R.drawable.pause_button_pressed);
				if(mediaPlayer!=null){
					mediaPlayer.start();
				}
				boTing=true;
			}
		}
		//快进
		if(v==flashPlaye){
			count++;
			int i=mediaPlayer.getCurrentPosition()+5000;
			mediaPlayer.seekTo(i);
			seekBar.setProgress(i);
		}
		//快退
		if(v==flashBack){
			count++;
			int j=mediaPlayer.getCurrentPosition()-5000;
			mediaPlayer.seekTo(j);
			seekBar.setProgress(j);
		}
		//静音
		/*if(v==imageView){
			if(issound){
				imageView.setImageResource(R.drawable.audio_volume_muted);
				audioManager.setStreamMute(AudioManager.STREAM_MUSIC, true);
				issound=false;
			}else{
				imageView.setImageResource(R.drawable.audio_mediu);
				audioManager.setStreamMute(AudioManager.STREAM_MUSIC, false);
				issound=true;
			}
		}*/
	}

	//音量调节
	@Override
	public void onProgressChanged(SeekBar seekBar, int progress,
			boolean fromUser) {
		count++;
	}

	@Override
	public void onStartTrackingTouch(SeekBar seekBar) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onStopTrackingTouch(SeekBar seekBar) {
		//音量等于0的时候，会出异常
		if(seekBar.getProgress()==0){
			audioManager.setStreamMute(AudioManager.STREAM_MUSIC, true);
			sound.setProgress(0);
		}
		else{
			audioManager.setStreamMute(AudioManager.STREAM_MUSIC, false);
			// TODO Auto-generated method stub
			audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, seekBar.getProgress(), 0);
			currentVulume=audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
			sound.setProgress(currentVulume);
			//设置当前播放音量
			soundId=sound.getProgress();
			//mediaPlayer.setVolume(soundId,soundId);
			
		}
	}
	
	class MySeekbar implements OnSeekBarChangeListener{

		@Override
		public void onProgressChanged(SeekBar seekBar, int progress,
				boolean fromUser) {
			// TODO Auto-generated method stub
			//得到seekbar的进度    
			/*MainActivity.this.seekBar.setProgress(progress);
			videoLength=MainActivity.this.seekBar.getProgress();*/
		}

		@Override
		public void onStartTrackingTouch(SeekBar seekBar) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onStopTrackingTouch(SeekBar seekBar) {
			// TODO Auto-generated method stub
			videoLength=seekBar.getProgress();
			//Toast.makeText(MediaPlayActivity.this, videoLength+"", 0).show();
			mediaPlayer.seekTo(videoLength);
		}
		
	}
	
//	public void init() {
//		// TODO Auto-generated method stub
//		
//		if(this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_PORTRAIT){
//			//Toast.makeText(MainActivity.this, "树", 0).show();
//			layout_control.setVisibility(View.VISIBLE);
//			layout_progress.setVisibility(View.VISIBLE);
//		}
//		if(this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE){
//			//Toast.makeText(MainActivity.this, "横", 0).show();
//			layout_control.setVisibility(View.GONE);
//			layout_progress.setVisibility(View.GONE);
//		}
//	}

	//设置了android:configChanges="orientation|keyboardHidden|screenSize"  切屏时不会执行各个生命周期，orientation|keyboardHidden这个的话  还会执行的各个生命周期
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		// TODO Auto-generated method stub
		super.onConfigurationChanged(newConfig);
		if(this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_PORTRAIT){
			//Toast.makeText(MainActivity.this, "树", 0).show();
			layout_control.setVisibility(View.VISIBLE);
			layout_progress.setVisibility(View.VISIBLE);
		}
		if(this.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE){
			//Toast.makeText(MainActivity.this, "横", 0).show();
			layout_control.setVisibility(View.GONE);
			layout_progress.setVisibility(View.GONE);
		}
	}
	
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		//Toast.makeText(MediaPlayActivity.this, "onPause", 0).show();
		if(mediaPlayer!=null){
			play.setImageResource(R.drawable.play_button_pressed);
			mediaPlayer.pause();
			boTing=false;
		}
		super.onPause();
	}
	
	@Override
	protected void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
		//Toast.makeText(MediaPlayActivity.this, "stop", 0).show();
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		
		if(keyCode==KeyEvent.KEYCODE_BACK){
			//Toast.makeText(MediaPlayActivity.this, "onKeyDown", 0).show();
			if(mediaPlayer!=null){
				mediaPlayer.release();
				mediaPlayer=null;
			}
		}
		
		return super.onKeyDown(keyCode, event);
	}
}
