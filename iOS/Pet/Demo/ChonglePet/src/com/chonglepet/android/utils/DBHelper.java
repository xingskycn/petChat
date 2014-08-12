package com.chonglepet.android.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DBHelper extends SQLiteOpenHelper {
	private static Context context = null;
	private static DBHelper instance = null;
	private SQLiteDatabase db = null;

	/**
	 * 数据库名
	 */
	private static final String DATABASE_NAME = "Chongle.db";

	private static final int DATABASE_VERSION = 1;

	/**
	 * 设置记录
	 */
	private static final String DATABASE_TABLE_GROUPCHAT = "groupchat";
	private static final String DATABASE_TABLE_CHAT = "chat";
	
	/**
	 * 建表语句
	 */
	private static final String DATABASE_CREATE_GROUPCHAT = "create table groupchat (id integer primary key autoincrement, "
			+ "groupName nvarchar(50), titleImage varchar(200), chatTime varchar(50), chatContent varchar(500), type varchar(10));";
	private static final String DATABASE_CREATE_CHAT = "create table chat (id integer primary key autoincrement, "
			+ "name nvarchar(50), friendName nvarchar(50), titleImage varchar(200), chatTime varchar(50), chatContent varchar(500), type varchar(10));";


	private DBHelper(Context ctx) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}

	public static DBHelper getInstance(Context ctx) {
		if (null == instance) {
			context = ctx;
			instance = new DBHelper(context);
		}
		return instance;
	}

	/**
	 * 建表
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL(DATABASE_CREATE_GROUPCHAT);
		db.execSQL(DATABASE_CREATE_CHAT);
		instance.db = db;
	}

	/**
	 * 版本更新
	 */
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE_GROUPCHAT);
		db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE_CHAT);
		
		onCreate(db);
	}

	/**
	 * 删表
	 */
	public void onDrop(SQLiteDatabase db) {
		db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE_GROUPCHAT);
		db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE_CHAT);

		onCreate(db);
	}

	/**
	 * ---打开数据库---
	 * 
	 * @return
	 * @throws SQLException
	 */
	public SQLiteDatabase open() throws SQLException {
		db = instance.getWritableDatabase();
		return db;
	}

	/**
	 * ---关闭数据库---
	 */
	public void close() {
		instance.close();
	}
	
	/**
	 * ---添加Groupchat---
	 */
	public void insertTable_GroupChat(String groupName, String titleImage, String chatTime, String chatContent,String type) {
		ContentValues vs = new ContentValues();
		vs.put("groupName", groupName);
		vs.put("titleImage", titleImage);
		vs.put("chatTime", chatTime);
		vs.put("chatContent", chatContent);
		vs.put("type", type);
		db.insert(DATABASE_TABLE_GROUPCHAT, null, vs);
	}

	/**
	 * ---添加chat---
	 */
	public void insertTable_Chat(String name, String friendName, String titleImage, String chatTime, String chatContent,String type) {
		ContentValues vs = new ContentValues();
		vs.put("name", name);
		vs.put("friendName", friendName);
		vs.put("titleImage", titleImage);
		vs.put("chatTime", chatTime);
		vs.put("chatContent", chatContent);
		vs.put("type", type);
		db.insert(DATABASE_TABLE_CHAT, null, vs);
	}

	/**
	 * 删除Chat
	 */
	public void deleteTable_Users(String name) {
		db.delete(DATABASE_TABLE_CHAT, " name = ? ", new String[] { name });
	}

	/**
	 * 删除groupChat
	 */
	public void deleteTable_Image(String groupName) {
		db.delete(DATABASE_TABLE_GROUPCHAT, " groupName = ? ", new String[] { groupName });
	}
	
	/**
	 * 根据群名查询群聊表
	 * @param valueKey
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 */
	public List<Map<String, String>> queryTable_GroupChat(String[] valueKey) throws IllegalArgumentException, IllegalAccessException {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> map = null;
		Cursor c = db.query(DATABASE_TABLE_GROUPCHAT, new String[] { "groupName", "titleImage", "chatTime", "chatContent","type"}, "groupName=?", valueKey, null, null, null);
		if (null != c && c.moveToFirst()) {
			do {
				map = new HashMap<String, String>();
				String groupName = c.getString(c.getColumnIndex("groupName"));
				String titleImage = c.getString(c.getColumnIndex("titleImage"));
				String chatTime = c.getString(c.getColumnIndex("chatTime"));
				String chatContent = c.getString(c.getColumnIndex("chatContent"));
				String type = c.getString(c.getColumnIndex("type"));
				
				map.put("groupName", groupName);
				map.put("titleImage", titleImage);
				map.put("chatTime", chatTime);
				map.put("chatContent", chatContent);
				map.put("type", type);
				list.add(map);
			} while (c.moveToNext());
		}
		return list;
	}
	

	/**
	 * 修改Chat
	 */
	public void updateTable_Chat(String name, String friendName, String titleImage, String chatTime, String chatContent,String type) {
		ContentValues vs = new ContentValues();
		vs.put("name", name);
		vs.put("friendName", friendName);
		vs.put("titleImage", titleImage);
		vs.put("chatTime", chatTime);
		vs.put("chatContent", chatContent);
		vs.put("type", type);
		db.update(DATABASE_TABLE_CHAT, vs, " name = ? ", new String[] { name });
	}
	
	/**
	 * 查询Chat   根据好友名称查询
	 */
	public List<Map<String, String>> queryTable_Chat(String[] valueKey) throws IllegalArgumentException, IllegalAccessException {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> map = null;
		Cursor c = db.query(DATABASE_TABLE_CHAT, new String[] { "name", "friendName", "titleImage", "chatTime", "chatContent","type"}, "name=?", valueKey, null, null, null);
		if (null != c && c.moveToFirst()) {
			do {
				map = new HashMap<String, String>();
				// 把查询得到的数据放入集合
				String name = c.getString(c.getColumnIndex("name"));
				String friendName = c.getString(c.getColumnIndex("friendName"));
				String titleImage = c.getString(c.getColumnIndex("titleImage"));
				String chatTime = c.getString(c.getColumnIndex("chatTime"));
				String chatContent = c.getString(c.getColumnIndex("chatContent"));
				String type = c.getString(c.getColumnIndex("type"));
				
				map.put("name", name);
				map.put("friendName", friendName);
				map.put("titleImage", titleImage);
				map.put("chatTime", chatTime);
				map.put("chatContent", chatContent);
				map.put("type", type);
				list.add(map);
			} while (c.moveToNext());
		}
		return list;
	}

}