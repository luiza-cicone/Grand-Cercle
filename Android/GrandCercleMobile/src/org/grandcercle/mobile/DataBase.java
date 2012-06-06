package org.grandcercle.mobile;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Iterator;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;


public class DataBase extends SQLiteOpenHelper {
	private static String TABLE_CERCLE = "prefCercle";
	private static String TABLE_CLUB = "prefClub";
	private static String TABLE_TYPE = "prefType";
	private static String TABLE_DESIGN = "prefDesign";
	private static String TABLE_PARSE = "parsedDatas";
	private ArrayList<String> listCercle;
	private ArrayList<String> listClub;
	private ArrayList<String> listType;
	private String design;

	/** Create a helper object for the Events database */
	private DataBase() {		
		super(ContainerData.getAppContext(), "GCM_DB", null, 2);
	}
	
	private static class DataBaseHolder { 
		public static final DataBase instance = new DataBase();
	}
		 
	public static DataBase getInstance() {
		return DataBaseHolder.instance;
	}
	
	@Override
	public void onCreate(SQLiteDatabase db) {
		// Initialisation des listes
		listCercle = ContainerData.getListCercles();
		listClub = ContainerData.getListClubs();
		listType = ContainerData.getListTypes();
		design = "Noir";
	
		db.execSQL("CREATE TABLE "+TABLE_CERCLE+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, cercle VARCHAR NOT NULL);");
		Iterator<String> itCercle = listCercle.iterator();
		ContentValues valueCercle = new ContentValues();
		while (itCercle.hasNext()) {
			valueCercle.put("cercle",itCercle.next());
			db.insert(TABLE_CERCLE,null,valueCercle);
		}
		
		db.execSQL("CREATE TABLE "+TABLE_CLUB+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, club VARCHAR NOT NULL);");
		Iterator<String> itClub = listClub.iterator();
		ContentValues valueClub = new ContentValues();
		while (itClub.hasNext()) {
			valueClub.put("club",itClub.next());
			db.insert(TABLE_CLUB,null,valueClub);
		}
		
		
		db.execSQL("CREATE TABLE "+TABLE_TYPE+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, type VARCHAR NOT NULL);");
		Iterator<String> itType = listType.iterator();
		ContentValues valueType = new ContentValues();
		while (itType.hasNext()) {
			valueType.put("type",itType.next());
			db.insert(TABLE_TYPE,null,valueType);
		}
		
		db.execSQL("CREATE TABLE "+TABLE_DESIGN+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, design VARCHAR NOT NULL);");
		ContentValues valueDesign = new ContentValues();
			valueDesign.put("design",design);
			db.insert(TABLE_DESIGN,null,valueDesign);
			
		db.execSQL("CREATE TABLE "+TABLE_PARSE+
				" (id VARCHAR NOT NULL PRIMARY KEY , data VARCHAR NOT NULL);");
	}
	
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CERCLE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CLUB);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_TYPE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_DESIGN);
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
	
	public ArrayList<String> getAllPref(String table, String key) {
		ArrayList<String> list = new ArrayList<String>();
		String query = "SELECT DISTINCT " + key + " FROM " + table;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(query,null);
		
		if (cursor.moveToFirst()) {
			do {
				String name = cursor.getString(0);
				list.add(name);
			} while (cursor.moveToNext());
		}
		db.close();
		return list;
	}
	
	public String getPref(String table, String key) {
		String string = new String();
		String query = "SELECT DISTINCT " + key + " FROM " + table;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(query,null);
		if (cursor.moveToFirst()) {
			string = cursor.getString(0);
		}
		db.close();
		return string;
	}
	
	public void deleteAll(String table){
	    SQLiteDatabase db = this.getWritableDatabase();
	    db.delete(table,null,null);
	    db.close();
	}
	
	public void storeTextToDataBase(String url,String key) {
        URL website = null;
        StringBuilder response = new StringBuilder();
		try {
			website = new URL(url);
			URLConnection connection = null;
			connection = website.openConnection();
			BufferedReader in = null;
			in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
       		String inputLine;
			while ((inputLine = in.readLine()) != null) {
			    response.append(inputLine);
			}
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		String data = response.toString();
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues value = new ContentValues();
        value.put(key,data);
		db.insert(TABLE_PARSE,null,value);
    }
	
	public void deleteEvent() {
		SQLiteDatabase db = this.getReadableDatabase();
	    db.delete(TABLE_PARSE,"id=event",null);
	    db.close();
	}
	
	public void deleteEventOld() {
		SQLiteDatabase db = this.getReadableDatabase();
	    db.delete(TABLE_PARSE,"id=eventOld",null);
	    db.close();
	}
	
	public InputStream getParsed(String key) {
		String string = new String();
		String query = "SELECT DISTINCT " + key + " FROM " + TABLE_PARSE;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(query,null);
		if (cursor.moveToFirst()) {
			string = cursor.getString(0);
		}
		db.close();
		return new ByteArrayInputStream(string.getBytes());
	}

}
