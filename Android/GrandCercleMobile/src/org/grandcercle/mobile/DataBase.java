package org.grandcercle.mobile;

import java.util.ArrayList;
import java.util.Iterator;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DataBase extends SQLiteOpenHelper {
	private static String TABLE_NUMRUN = "numRun";
	private static String TABLE_CERCLE = "prefCercle";
	private static String TABLE_CLUB = "prefClub";
	private static String TABLE_TYPE = "prefType";
	
	private ArrayList<String> listCercle;
	private ArrayList<String> listClub;
	private ArrayList<String> listType;

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
		
		db.execSQL("CREATE TABLE "+TABLE_CERCLE+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, cercle VARCHAR NOT NULL);");
		/*Iterator<String> itCercle = listCercle.iterator();
		while (itCercle.hasNext()) {
			db.execSQL("INSERT INTO " + TABLE_CERCLE + "(cercle) values("+itCercle.next()+")");
		}*/
		
		db.execSQL("CREATE TABLE "+TABLE_CLUB+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, club VARCHAR NOT NULL);");
		/*Iterator<String> itClub = listClub.iterator();
		while (itClub.hasNext()) {
			db.execSQL("INSERT INTO " + TABLE_CLUB + "(club) values("+itClub.next()+")");
		}*/
		
		db.execSQL("CREATE TABLE "+TABLE_TYPE+
				" (id INTEGER PRIMARY KEY AUTOINCREMENT, type VARCHAR NOT NULL);");
		/*Iterator<String> itType = listType.iterator();
		while (itType.hasNext()) {
			db.execSQL("INSERT INTO " + TABLE_TYPE + "(type) values("+itType.next()+")");
		}*/
	}
	
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CERCLE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_CLUB);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_TYPE);
		onCreate(db);
	}
	
	/*public void incrementNumRun() {
		int cpt = getNumRun();
		cpt++;
		SQLiteDatabase db = this.getWritableDatabase();
		ContentValues value = new ContentValues();
		value.put("cpt",cpt);
		db.insert(TABLE_NUMRUN,null,value);
		db.close();
	}
	
	public int getNumRun() {
		SQLiteDatabase db = this.getReadableDatabase();
		String query = "SELECT MAX(cpt) FROM numRun";
		Cursor cursor = db.rawQuery(query,null);
		if (cursor.moveToNext()) {
			return cursor.getInt(0);
		}
		return 0;
	}*/
	
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
		return list;
	}
	
	/*public int getNumber(String table) {
		String countQuery = "SELECT * FROM" + table;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(countQuery,null);
		cursor.close();
		return cursor.getCount();
	}*/
	
	public void deleteAll(String table){
	    SQLiteDatabase db = this.getWritableDatabase();
	    String delete = "DELETE FROM " + table + ";";
	    db.rawQuery(delete, null);
	}

	
}
