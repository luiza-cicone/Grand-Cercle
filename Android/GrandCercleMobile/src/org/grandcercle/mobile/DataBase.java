package org.grandcercle.mobile;

import java.util.ArrayList;
import java.util.Iterator;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DataBase extends SQLiteOpenHelper {
	private static String TABLE_CERCLE = "prefCercle";
	private static String TABLE_CLUB = "prefClub";
	private static String TABLE_TYPE = "prefType";
	
	private ArrayList<String> preferedCercle;
	private ArrayList<String> preferedClub;
	
	/** Create a helper object for the Events database */
	public DataBase(Context ctx) {
		super(ctx, "GCM_DB", null, 2);
	}
	
	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL("CREATE TABLE "+TABLE_CERCLE+
				" (cercle VARCHAR NOT NULL PRIMARY KEY);");
		db.execSQL("CREATE TABLE "+TABLE_CLUB+
				" (club VARCHAR NOT NULL PRIMARY KEY);");
		db.execSQL("CREATE TABLE "+TABLE_TYPE+
				" (type VARCHAR NOT NULL PRIMARY KEY);");
		preferedCercle = ContainerData.getListCercles();
		preferedClub = ContainerData.getListClubs();
		this.addListPref(TABLE_CERCLE,"cercle",preferedCercle);
		this.addListPref(TABLE_CLUB,"club",preferedClub);
	}
	
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CERCLE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CLUB);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_TYPE);
		onCreate(db);
	}
	
	public void addPref(String table, String key, String name) {
		SQLiteDatabase db = this.getWritableDatabase();
		ContentValues value = new ContentValues();
		value.put(key,name);
		db.insert(table,null,value);
		db.close();
	}
	
	public void addListPref(String table, String key, ArrayList<String> listName) {
		SQLiteDatabase db = this.getWritableDatabase();
		ContentValues value = new ContentValues();
		Iterator<String> it = listName.iterator();
		while (it.hasNext()) {
			value.put(key,it.next());
			db.insert(table,null,value);
		}
		db.close();
	}
	
	public void deletePref(String table, String key, String name) {
		SQLiteDatabase db = this.getReadableDatabase();
		String query = "DELETE FROM " + table + " WHERE " + key +"='"+name+"';";
		db.execSQL(query);
		db.close();
	}
	
	public ArrayList<String> getAllPref(String table) {
		ArrayList<String> list = new ArrayList<String>();
		String query = "SELECT * FROM " + table;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(query,null);
		
		if (cursor.moveToFirst()) {
			do {
				String name = cursor.getString(0);
				list.add(name);
			} while (cursor.moveToNext());
		}
		return list;
	}
	
	public int getNumber(String table) {
		String countQuery = "SELECT * FROM" + table;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(countQuery,null);
		cursor.close();
		return cursor.getCount();
	}
	
	public void deleteAll(String table){
	    SQLiteDatabase db = this.getWritableDatabase();
	    String delete = "DELETE FROM " + table + ";";
	    db.rawQuery(delete, null);
	}

	
}
