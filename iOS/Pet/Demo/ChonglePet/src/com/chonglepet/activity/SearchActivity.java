package com.chonglepet.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import com.chonglepet.android.abstractactivity.AbstractBaseActivity;

/**
 * 
 * @author chen
 * 
 *  宠聊群组搜索界面
 */

public class SearchActivity extends AbstractBaseActivity{
	
	private Spinner spinner;
	
	private RadioGroup radioGroup;
	
	private Button selectSureButton;
	
	public static int animalType=-1;
	
	public static String animalSex=null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		setContentView(R.layout.group_search);
		super.onCreate(savedInstanceState);
		
		/*spinner = (Spinner) findViewById(R.id.select_Spinner);
		ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
		        R.array.planets_array, android.R.layout.simple_spinner_item);
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		spinner.setAdapter(adapter);
		spinner.setOnItemSelectedListener(spinnerOnitemSelectListener);
		
		radioGroup=(RadioGroup)findViewById(R.id.select_radio_group);
		radioGroup.setOnCheckedChangeListener(myOnCheckChangeListener);
		
		selectSureButton=(Button)findViewById(R.id.select_sure_button);
		selectSureButton.setOnClickListener(this);*/
	}
	
	@Override
	protected void initHeadTitleLayout() {
		TextView head_left_textview=(TextView)findViewById(R.id.head_left_textview);
		head_left_textview.setVisibility(View.VISIBLE);
		head_left_textview.setText("取消");
		head_left_textview.setOnClickListener(this);
		
		TextView head_center_textview=(TextView)findViewById(R.id.head_center_textview);
		head_center_textview.setVisibility(View.VISIBLE);
		head_center_textview.setText("群组搜索");
	}

	@Override
	public void onClick(View v) {
		if(v.getId()==R.id.head_left_textview){
			finish();
			overridePendingTransition(R.anim.out_center, R.anim.out_from_righ);
		}
		if(selectSureButton==v){
			finish();
			overridePendingTransition(R.anim.out_center, R.anim.out_from_righ);
		}
		
	}
}
