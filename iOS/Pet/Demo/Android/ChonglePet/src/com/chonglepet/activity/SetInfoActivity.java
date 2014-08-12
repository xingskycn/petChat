package com.chonglepet.activity;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONTokener;

import android.app.Dialog;
import android.content.ActivityNotFoundException;
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
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;
import com.chonglepet.android.entity.Parameter;


/**
 * 
 * @author chen
 * 
 * @description 用于设置页面
 */
public class SetInfoActivity  extends AbstractBaseActivity implements OnClickListener{
	
	private ImageView ownerImageView,petImageView;
	
	private Dialog showDialog;
	
	private String localTempImgFileName="photo.jpg";
	
	private final int GET_IMAGE_VIA_CAMERA=1;
	
	public final int GET_IMAGE_PHOTO=2;
	
	private final int VEDIO_CODE=3;
	
	private int isOwnerOrPetDialog=1; //判断是谁的dialog
	
	private String imageUploadUrl=null;
	
	private Button  set_image_vedio_button,
					set_image_upload_button,
					set_image_player_button,
					set_image_update_button;
	
	private String ownerImagerUrl;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.setinfo);
		super.onCreate(savedInstanceState);
		
		ownerImageView=(ImageView)findViewById(R.id.owner_iamgeview);
		petImageView=(ImageView)findViewById(R.id.pet_iamgeview);
		
		set_image_vedio_button=(Button)findViewById(R.id.set_image_vedio_button);
		set_image_upload_button=(Button)findViewById(R.id.set_image_upload_button);
		set_image_player_button=(Button)findViewById(R.id.set_image_player_button);
		set_image_update_button=(Button)findViewById(R.id.set_image_update_button);
		
		ownerImageView.setOnClickListener(this);
		petImageView.setOnClickListener(this);
		set_image_vedio_button.setOnClickListener(this);
		set_image_upload_button.setOnClickListener(this);
		set_image_player_button.setOnClickListener(this);
		set_image_update_button.setOnClickListener(this);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_right_button=(Button)findViewById(R.id.head_right_button);
		head_right_button.setVisibility(View.VISIBLE);
		head_right_button.setText("编辑");
		head_right_button.setTextColor(Color.BLUE);
		head_right_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("设置");
		
	}
	
	@Override
	protected void initRequestListDate() {
		//设置页面的话     第一次进来必须是从登入界面进来      需要从新startApp
		
		BaseApplication.userID=null;
		
		StringBuffer value=new StringBuffer("{\"apiInfo\":{\"version\":\"");
		value.append(BaseApplication.versionCode+"\",");
		value.append("\"appName\":\""+BaseApplication.versionName);
		value.append("\"},\"LBSInfo\":{\"lbsTime\":\""+BaseApplication.lbsTime);
		value.append("\",\"longitude\":\""+BaseApplication.longitude);
		value.append("\",\"latitude\":\""+BaseApplication.latitude);
		value.append("\"},\"cellsInfo\":{\"userID\":\""+BaseApplication.userID);
		value.append("\",\"UUID\":\""+BaseApplication.clientUUID);
		value.append("\",\"IMEI\":\""+BaseApplication.IMEI);
		value.append("\",\"IMSI\":\""+BaseApplication.IMSI);
		value.append("\",\"phonePlatform\":\""+BaseApplication.phonePlatform);
		value.append("\"},\"mobileInfo\":{\"osName\":\""+BaseApplication.osName);
		value.append("\",\"networkProvider\":\""+BaseApplication.networkProvider);
		value.append("\",\"ipOut\":\""+BaseApplication.ipOut);
		value.append("\",\"timeZone\":\""+BaseApplication.timeZone);
		value.append("\",\"phoneTime\":\""+BaseApplication.phoneTime);
		value.append("\",\"contact\":\""+BaseApplication.contact);
		value.append("\",\"mobileType\":\""+BaseApplication.mobileType);
		value.append("\",\"ipIn\":\""+BaseApplication.ipIn+"\"}}");
		
		onRequsetViewDateList(CommonConfig.STARTAPP_TASK,CommonConfig.startAppUrl,"startApp",value.toString());
	}

	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.head_right_button){
			Intent intent=new Intent(SetInfoActivity.this, SetInfoEditeActivity.class);
			startActivity(intent);
			SetInfoActivity.this.getParent().overridePendingTransition(R.anim.in_from_righ, R.anim.out_center);
		}
		if(v==set_image_vedio_button){
			Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
			intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 0.9);
			//限制时长
			intent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 5);
			//限制大小
			intent.putExtra(MediaStore.EXTRA_SIZE_LIMIT, 1024*1024);
			startActivityForResult(intent, VEDIO_CODE);
		}
		if(v==set_image_upload_button){
			uploadImage(ownerImagerUrl);
		}
		if(v==set_image_player_button){
			Intent intent=new Intent(SetInfoActivity.this, MediaPlayActivity.class);
			intent.putExtra("imageurl", "aaaaaa");
			startActivity(intent);
		}
		if(v==set_image_update_button){
			if(imageUploadUrl!=null){
				List<Parameter> params=new ArrayList<Parameter>();
				params =new ArrayList<Parameter>();
				Parameter parameter=new Parameter();
				parameter.setRequestHttpKey("add_chattingImages");
				parameter.setValue("{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15679\",\"UUID\":\"B96A2E46-FF83-4A70-996F-8E780FEAA707\"}}");
				params.add(parameter);
				
				parameter=new Parameter();
				parameter.setRequestHttpKey("chatting_images");
				parameter.setValue(imageUploadUrl);
				params.add(parameter);
				onRequestImageUpload(CommonConfig.PET_IMAGE_UPLOAD, CommonConfig.imageUpload, params);
			}
		}
		if(v==ownerImageView){
			isOwnerOrPetDialog=1;
			showGetPhotoDialog();
		}
		if(v==petImageView){
			isOwnerOrPetDialog=2;
			showGetPhotoDialog();
		}
		if(v.getId()==R.id.look_head_button){
			Intent intent=new Intent(SetInfoActivity.this, ImageActivity.class);
			intent.putExtra("imageurl", "aaa");
			startActivity(intent);
		}
		if(v.getId()==R.id.scene_photo_button){
			//先验证手机是否有sdcard 
	        String status=Environment.getExternalStorageState(); 
	        if(status.equals(Environment.MEDIA_MOUNTED)) 
	        { 
		        try { 
		        	File dir=new File(Environment.getExternalStorageDirectory() + "/"+CommonConfig.localTempImgDir);  
			        if(!dir.exists())dir.mkdirs(); 
			        //这个拍照下来的图片比较小
			        Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
			        startActivityForResult(intent, GET_IMAGE_VIA_CAMERA); 
		        } catch (ActivityNotFoundException  e) { 
		        	Toast.makeText(SetInfoActivity.this, "没有找到储存目录",Toast.LENGTH_LONG).show();  
		        } 
	        }else{ 
	        	toastShow("没有储存卡"); 
	        } 
			
		}
		if(v.getId()==R.id.photo_choose_button){
			Intent intent=new Intent(Intent.ACTION_GET_CONTENT);
		    intent.addCategory(Intent.CATEGORY_OPENABLE);
		    intent.setType("image/*");
		    intent.putExtra("return-data", true);

			//Intent picture = new Intent(Intent.ACTION_PICK,android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
			startActivityForResult(intent, GET_IMAGE_PHOTO);
		}
	}
	
	private void showGetPhotoDialog() {
		View showDialogView=LayoutInflater.from(this).inflate(R.layout.setinfo_dialog, null);
		
		Button look_head_button=(Button)showDialogView.findViewById(R.id.look_head_button);
		Button scene_photo_button=(Button)showDialogView.findViewById(R.id.scene_photo_button);
		Button photo_choose_button=(Button)showDialogView.findViewById(R.id.photo_choose_button);
		
		look_head_button.setOnClickListener(this);
		scene_photo_button.setOnClickListener(this);
		photo_choose_button.setOnClickListener(this);
		
		showDialog=new Dialog(this, R.style.CustomProgressDialog);
		showDialog.setContentView(showDialogView);
		showDialog.show();
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		
		if(resultCode==RESULT_OK){
			
			switch (requestCode) {
				case GET_IMAGE_VIA_CAMERA:
					
				Bitmap bitmap;
				try {
					File file=new File(Environment.getExternalStorageDirectory() 
							+"/"+CommonConfig.localTempImgDir+"/"+localTempImgFileName); 
					
					Bundle extras = data.getExtras();
					bitmap = (Bitmap) extras.get("data");
					bitmap=ThumbnailUtils.extractThumbnail(bitmap, 200, 200);
					OutputStream outputStream=new FileOutputStream(file);
					bitmap.compress(CompressFormat.JPEG, 100, outputStream);
					outputStream.flush();
					outputStream.close();
					
					showDialog.dismiss();
					imageUploadUrl=file.toString();
					
					if(isOwnerOrPetDialog==1)
						ownerImageView.setImageBitmap(bitmap);
					else
						petImageView.setImageBitmap(bitmap);
					
					break;
					
				} catch (Exception e) {
					e.printStackTrace();
				}
							
				case GET_IMAGE_PHOTO:
					
					 showDialog.dismiss();
					 Uri selectedImage = data.getData();
					 String[] filePathColumns={MediaStore.Images.Media.DATA};
					 Cursor cursor = this.getContentResolver().query(selectedImage, filePathColumns, null,null, null);
					 cursor.moveToFirst();
					 String imgNo = cursor.getString(0); // 图片编号 
					 //String imgPath = cursor.getString(1); // 图片文件路径 
					/* String imgSize = cursor.getString(2); // 图片大小 
					 String imgName = cursor.getString(3); // 图片文件名 
*/					 cursor.close(); 
					 Options options = new BitmapFactory.Options(); 
					 options.inJustDecodeBounds = false; 
					 options.inSampleSize = 10; 
					 Bitmap bitmapPhoto = BitmapFactory.decodeFile(imgNo, options); 
					 
					 bitmap=ThumbnailUtils.extractThumbnail(bitmapPhoto, 120, 100);
					 
					 if(isOwnerOrPetDialog==1)
						 ownerImageView.setImageBitmap(bitmap);
					 else
						 petImageView.setImageBitmap(bitmap);
					break;
					
				case VEDIO_CODE:
					Uri videoUri = data.getData();
					Cursor cursor2 = managedQuery(videoUri, null, null, null, null);
					cursor2.moveToFirst();//这个必须加，否则下面读取会报错
					int num = cursor2.getCount();
					String recordedVideoFilePath = cursor2.getString(cursor2.getColumnIndex(MediaStore.Video.Media.DATA));
					//int recordedVideoFileSize = cursor2.getInt(cursor2.getColumnIndex(MediaStore.Video.Media.SIZE));
					//uploadVedio(recordedVideoFilePath);
					break;
				
				default:
					break;
			}
		}
	}
	
	protected void uploadImage(String iamgeUrl) {
		String addValue="{\"apiInfo\":{\"version\":\"0.800000\",\"appName\":\"Pet\"},\"cellsInfo\":{\"userID\":\"15678\",\"UUID\":\"8DA200A0-FA49-43B1-831D-5ED133BDCD05\"}}";
		uploadImage(CommonConfig.PET_IMAGE_UPLOAD, "add_chattingImages", addValue, "chatting_images", iamgeUrl);
	}
	
	@Override
	public void onTaskRequestSuccess(int taskId, JSONTokener jsonObject) {
		switch (taskId) {
		case CommonConfig.STARTAPP_TASK:
			
			break;
		case CommonConfig.PET_IMAGE_UPLOAD:
			
			break;
		
		default:
			break;
		}
		
	}
	
	
}
