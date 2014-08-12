package com.chonglepet.android.biaoqing;

import java.lang.reflect.Field;

import android.annotation.SuppressLint;
import android.app.ActionBar.LayoutParams;
import android.content.Context;
import android.graphics.Color;
import android.widget.ImageView;
import android.widget.TextView;

import com.chonglepet.activity.R;
import com.chonglepet.android.chat.ChatClientActivity;
import com.chonglepet.android.view.LayoutLinearLine;


/**
 * 
 * @author chen
 * 表情文字处理
 */

@SuppressLint("NewApi")
public class Expressions {

	public static int[] expressionImgs = new int[] { R.drawable.f000,
			R.drawable.f001, R.drawable.f002, R.drawable.f003, R.drawable.f004,
			R.drawable.f005, R.drawable.f006, R.drawable.f007, R.drawable.f008,
			R.drawable.f009, R.drawable.f010, R.drawable.f011, R.drawable.f012,
			R.drawable.f013, R.drawable.f014, R.drawable.f015, R.drawable.f016,
			R.drawable.f017, R.drawable.f018, R.drawable.f019, R.drawable.f020,
			R.drawable.f021, R.drawable.f022, R.drawable.f023 };

	/**
	 * 本地表情
	 */
	public static String[] expressionImgNames = new String[] { "[f000]",
			"[f001]", "[f002]", "[f003]", "[f004]", "[f005]", "[f006]",
			"[f007]", "[f008]", "[f009]", "[f010]", "[f011]", "[f012]",
			"[f013]", "[f014]", "[f015]", "[f016]", "[f017]", "[f018]",
			"[f019]", "[f020]", "[f021]", "[f022]", "[f023]" };
	
	
	
	public static int[] expressionImgs1 = new int[] { R.drawable.f024,
		R.drawable.f025, R.drawable.f026, R.drawable.f027, R.drawable.f028,
		R.drawable.f029, R.drawable.f030, R.drawable.f031, R.drawable.f032,
		R.drawable.f033, R.drawable.f034, R.drawable.f035, R.drawable.f036,
		R.drawable.f037, R.drawable.f038, R.drawable.f039, R.drawable.f040,
		R.drawable.f041, R.drawable.f042, R.drawable.f043, R.drawable.f044,
		R.drawable.f045, R.drawable.f046, R.drawable.f047 };
	
	/**
	 * 本地表情
	 */
	public static String[] expressionImgNames1 = new String[] { "[f024]",
		"[f025]", "[f026]", "[f027]", "[f028]", "[f029]", "[f030]",
		"[f031]", "[f032]", "[f033]", "[f034]", "[f035]", "[f036]",
		"[f037]", "[f038]", "[f039]", "[f040]", "[f041]", "[f042]",
		"[f043]", "[f044]", "[f045]", "[f046]", "[f047]" };
	
	
	
	
	public static int[] expressionImgs2 = new int[] { R.drawable.f048,
		R.drawable.f049, R.drawable.f050, R.drawable.f051, R.drawable.f052,
		R.drawable.f053, R.drawable.f054, R.drawable.f055, R.drawable.f056,
		R.drawable.f057, R.drawable.f058, R.drawable.f059, R.drawable.f060,
		R.drawable.f061, R.drawable.f062, R.drawable.f063, R.drawable.f064,
		R.drawable.f065, R.drawable.f066, R.drawable.f067, R.drawable.f068,
		R.drawable.f069, R.drawable.f070, R.drawable.f071 };
	
	/**
	 * 本地表情
	 */
	public static String[] expressionImgNames2 = new String[] { "[f048]",
		"[f049]", "[f050]", "[f051]", "[f052]", "[f053]", "[f054]",
		"[f055]", "[f056]", "[f057]", "[f058]", "[f059]", "[f060]",
		"[f061]", "[f062]", "[f063]", "[f064]", "[f065]", "[f066]",
		"[f067]", "[f068]", "[f069]", "[f070]", "[f071]" };

	
	/*
	 * 服务器存储的表情名字
	 */
	public static String[] expressionRegImgNames = new String[] { "\\U0001F601",
			"f0asd01", "f00asd2", "fasd003", "f0gf04", "f00fg5", "f0gfdh06",
			"fhjgh007", "f0gh08", "ffgh009", "f010", "f011", "f012", "f013",
			"f014", "f015", "f016", "f017", "f05err18", "f045fd19",
			"f0234sdf20", "fsdfg021", "f0jjjh22", "f0hjh23" };

	/**
	 * 
	 * 在存入数据库时，将表情名字进行替换即字符串数组
	 * 
	 */
	public static String[] replaceStrings(String[] str, String[] str2) {
		String newStr[] = new String[str.length - 1];
		for (int i = 0; i < str.length; i++) {
			newStr[i] = str[i].replace(str[i], str2[i]);
		}
		return newStr;
	}
	
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
							//layout.addView(getImageView(context, imageId));
							aa(context, layout);
						}
						else{
							//layout.addView(getTextView(context, imageurl));
							aa(context, layout);
						}
					}
					else{
						if(message.contains("f")){
							beginString=message.substring(0,message.indexOf("f"));
							imageurl=message.substring(message.indexOf("f"), message.indexOf("f")+4);
							endString=message.substring(message.indexOf("f")+4);
							message=endString;
							
							aa(context, layout);
							//layout.addView(getTextView(context, beginString));
							count=beginString.length()+imageurl.length()+count;
							int imageId=getDrawable(imageurl);
							//那就是表情
							if(imageId>0){
								//layout.addView(getImageView(context, imageId));
								aa(context, layout);
							}
							else{
								//layout.addView(getTextView(context, imageurl));
								aa(context, layout);
							}
						}
						else{
							//layout.addView(getTextView(context, message));
							aa(context, layout);
							count=message.length()+count;
						}
					}
					if(titalLenth==count){
						break;
					}
				}
			}
			else{
				for (int i = 0; i < message.length(); i++) {
					//layout.addView(getTextView(context, message.substring(i, i+1)));
					aa(context, layout);
				}
				//layout.addView(getTextView(context, message));
			}
		}
	}
	
	private static ImageView getImageView(Context context,int imageId){
		ImageView imageview=new ImageView(context);
		imageview.setImageResource(imageId);
		imageview.setLayoutParams(new LayoutParams(80,80));
		return imageview;
	}
	
	private static TextView getTextView(Context context, String message){
		LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.MATCH_PARENT);
		params.setMargins(0, 0, 0,0);
		
		TextView textView=new TextView(context);
		textView.setText(message);
		textView.setTextColor(Color.BLACK);
		textView.setTextSize(20);
		textView.setPadding(5, 5, 5, 5);
		textView.setLayoutParams(params);
		return textView;
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
	
	
	private static void aa(Context context,LayoutLinearLine layout){
		for (int i = 0; i < 5; i++) {
			 LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.MATCH_PARENT);
			 params.setMargins(0, 0, 0,0);
			 TextView txtTag=new TextView(context);
			 txtTag.setTextColor(Color.BLACK);
			 txtTag.setTextSize(20);
			 
			 txtTag.setText("sss");
			 txtTag.setPadding(5, 5, 5, 5);
			 txtTag.setLayoutParams(params);
			 layout.addView(txtTag);
			 
		}
	}
}
