package com.chonglepet.android.biaoqing;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.SimpleAdapter;

import com.chonglepet.activity.R;

/**
 * 
 * @author chen
 * 初始化表情
 */
public class ExpressionsUtil {

	private static Context mContext;
	public static ArrayList<GridView> listGridviews;
	private static int[] expressionImages;
	private static String[] expressionImageNames;
	private static int[] expressionImages1;
	private static String[] expressionImageNames1;
	private static int[] expressionImages2;
	private static String[] expressionImageNames2;
	private static EditText mEditTextContent;
	private static GridView gView1;
	private static GridView gView2;
	private static GridView gView3;
	
	public static void getInstance(Context context,EditText editText){
		mContext=context;
		mEditTextContent=editText;
		// 引入表情
		initViewPager();
	}
	
	private static void initViewPager() {
		expressionImages = Expressions.expressionImgs;
		expressionImageNames = Expressions.expressionImgNames;
		expressionImages1 = Expressions.expressionImgs1;
		expressionImageNames1 = Expressions.expressionImgNames1;
		expressionImages2 = Expressions.expressionImgs2;
		expressionImageNames2 = Expressions.expressionImgNames2;
		
		LayoutInflater inflater = LayoutInflater.from(mContext);
		listGridviews = new ArrayList<GridView>();
		gView1 = (GridView) inflater.inflate(R.layout.grid1, null);
		List<Map<String, Object>> listItems = new ArrayList<Map<String, Object>>();
		// 生成24个表情
		for (int i = 0; i < 24; i++) {
			Map<String, Object> listItem = new HashMap<String, Object>();
			listItem.put("image", expressionImages[i]);
			listItems.add(listItem);
		}

		SimpleAdapter simpleAdapter = new SimpleAdapter(mContext, listItems,
				R.layout.singleexpression, new String[] { "image" },
				new int[] { R.id.image });
		gView1.setAdapter(simpleAdapter);
		gView1.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				Bitmap bitmap = null;
				bitmap = BitmapFactory.decodeResource(mContext.getResources(),
						expressionImages[arg2 % expressionImages.length]);
				ImageSpan imageSpan = new ImageSpan(mContext, bitmap);
				SpannableString spannableString = new SpannableString(
						expressionImageNames[arg2].substring(1,
								expressionImageNames[arg2].length() - 1));
				spannableString.setSpan(imageSpan, 0,
						expressionImageNames[arg2].length() - 2,
						Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
				// 编辑框设置数据
				mEditTextContent.append(spannableString);
			}
		});
		listGridviews.add(gView1);

		gView2 = (GridView) inflater.inflate(R.layout.grid2, null);
		listGridviews.add(gView2);

		gView3 = (GridView) inflater.inflate(R.layout.grid3, null);
		listGridviews.add(gView3);

		iniViewPageExpression();
	}
	
	private static void iniViewPageExpression() {
		
		List<Map<String, Object>> listItems = new ArrayList<Map<String, Object>>();
		// 生成24个表情
		for (int i = 0; i < 24; i++) {
			Map<String, Object> listItem = new HashMap<String, Object>();
			listItem.put("image", expressionImages1[i]);
			listItems.add(listItem);
		}

		SimpleAdapter simpleAdapter = new SimpleAdapter(mContext,
				listItems, R.layout.singleexpression,
				new String[] { "image" }, new int[] { R.id.image });
		gView2.setAdapter(simpleAdapter);
		gView2.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				Bitmap bitmap = null;
				bitmap = BitmapFactory.decodeResource(mContext.getResources(),
						expressionImages1[arg2
								% expressionImages1.length]);
				ImageSpan imageSpan = new ImageSpan(mContext, bitmap);
				SpannableString spannableString = new SpannableString(
						expressionImageNames1[arg2]
								.substring(1,
										expressionImageNames1[arg2]
												.length() - 1));
				spannableString.setSpan(imageSpan, 0,
						expressionImageNames1[arg2].length() - 2,
						Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
				// 编辑框设置数据
				mEditTextContent.append(spannableString);
			}
		});
		
		List<Map<String, Object>> listItems1 = new ArrayList<Map<String, Object>>();
		// 生成24个表情
		for (int i = 0; i < 24; i++) {
			Map<String, Object> listItem = new HashMap<String, Object>();
			listItem.put("image", expressionImages2[i]);
			listItems1.add(listItem);
		}

		SimpleAdapter simpleAdapter1 = new SimpleAdapter(mContext,
				listItems1, R.layout.singleexpression,
				new String[] { "image" }, new int[] { R.id.image });
		gView3.setAdapter(simpleAdapter1);
		gView3.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				Bitmap bitmap = null;
				bitmap = BitmapFactory.decodeResource(mContext.getResources(),
						expressionImages2[arg2
								% expressionImages2.length]);
				ImageSpan imageSpan = new ImageSpan(mContext, bitmap);
				SpannableString spannableString = new SpannableString(
						expressionImageNames2[arg2]
								.substring(1,
										expressionImageNames2[arg2]
												.length() - 1));
				spannableString.setSpan(imageSpan, 0,
						expressionImageNames2[arg2].length() - 2,
						Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
				// 编辑框设置数据
				mEditTextContent.append(spannableString);
			}
		});

	}
}
