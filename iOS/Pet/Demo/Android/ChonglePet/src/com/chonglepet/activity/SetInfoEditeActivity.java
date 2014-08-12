package com.chonglepet.activity;

import java.io.File;

import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
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
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;


/**
 * 
 * @author chen
 * 
 * @description 用于编辑个人资料页面
 */
public class SetInfoEditeActivity  extends AbstractBaseActivity implements OnClickListener{
	
	//private ImageView ownerImageView,petImageView;
	
	private Dialog showDialog;
	
	private String localTempImgFileName="photo.jpg";
	
	private final int GET_IMAGE_VIA_CAMERA=1;
	
	public final int GET_IMAGE_PHOTO=2;
	
	//private int isOwnerOrPetDialog=1; //判断是谁的dialog
	
	private EditText owner_name_editext,
					 owner_sex_editext,
					 owner_sigin_editext,
					 pet_name_editext,
					 pet_sex_editext,
					 pet_age_editext;
	
	private Button set_updateinfo_button,
				   set_addImage_button;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.setinfo_edite);
		super.onCreate(savedInstanceState);
		
		
		owner_name_editext=(EditText)findViewById(R.id.owner_name_editext);
		owner_sex_editext=(EditText)findViewById(R.id.owner_sex_editext);
		owner_sigin_editext=(EditText)findViewById(R.id.owner_sigin_editext);
		pet_name_editext=(EditText)findViewById(R.id.pet_name_editext);
		pet_sex_editext=(EditText)findViewById(R.id.pet_sex_editext);
		pet_age_editext=(EditText)findViewById(R.id.pet_age_editext);
		
		set_updateinfo_button=(Button)findViewById(R.id.set_updateinfo_button);
		set_addImage_button=(Button)findViewById(R.id.set_addImage_button);
		
		set_updateinfo_button.setOnClickListener(this);
		set_addImage_button.setOnClickListener(this);
		
	}
	
	@Override
	protected void initHeadTitleLayout() {
		Button head_left_button=(Button)findViewById(R.id.head_left_button);
		head_left_button.setVisibility(View.VISIBLE);
		head_left_button.setBackgroundResource(R.drawable.test22);
		head_left_button.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("个人信息");
		
	}

	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.head_left_button){
			finish();
			overridePendingTransition(R.anim.out_center, R.anim.out_from_righ);
		}
		if(v==set_updateinfo_button){
			showGetPhotoDialog();
		}
		if(v==set_addImage_button){
			showGetPhotoDialog();
		}
		if(v.getId()==R.id.look_head_button){
			Intent intent=new Intent(SetInfoEditeActivity.this, ImageActivity.class);
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
		        	Toast.makeText(SetInfoEditeActivity.this, "没有找到储存目录",Toast.LENGTH_LONG).show();  
		        } 
	        }else{ 
	        	Toast.makeText(SetInfoEditeActivity.this, "没有储存卡",Toast.LENGTH_LONG).show(); 
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
					
					File f=new File(Environment.getExternalStorageDirectory() 
							+"/"+CommonConfig.localTempImgDir+"/"+localTempImgFileName); 
					showDialog.dismiss();
					Bundle extras = data.getExtras();
					Bitmap bitmap = (Bitmap) extras.get("data");
					
					/*if(isOwnerOrPetDialog==1)
						ownerImageView.setImageBitmap(bitmap);
					else
						petImageView.setImageBitmap(bitmap);
					*/
					break;
							
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
					/* 
					 if(isOwnerOrPetDialog==1)
						 ownerImageView.setImageBitmap(bitmap);
					 else
						 petImageView.setImageBitmap(bitmap);*/
					break;
				
				default:
					break;
			}
		}
	}
	
}
