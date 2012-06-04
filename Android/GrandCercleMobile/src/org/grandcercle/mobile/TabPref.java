package org.grandcercle.mobile;

import java.util.ArrayList;
import java.util.Iterator;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.preference.CheckBoxPreference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.widget.Toast;

public class TabPref extends PreferenceActivity implements OnSharedPreferenceChangeListener {
	private ArrayList<String> listCercles;
	private static ArrayList<String> listClubs;
	SharedPreferences pref;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		//setContentView(R.layout.main);
		
		listCercles = ContainerData.getListCercles();
		listClubs = ContainerData.getListClubs();
		addPreferencesFromResource(R.xml.prefs);
		PreferenceManager.setDefaultValues(TabPref.this, R.xml.prefs, false);
		pref = getPreferenceManager().getSharedPreferences();
		pref.registerOnSharedPreferenceChangeListener(this);
	    //setPreferenceScreen(createPreferenceHierarchy());


		//SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(this);
		//String myString = preferences.getString("PrefList", "");
	}
	
	
	/*private PreferenceScreen createPreferenceHierarchy() { 
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
        PreferenceCategory inlinePrefCat = new PreferenceCategory(this);
        inlinePrefCat.setTitle(name);
        root.addPreference(inlinePrefCat);
        Iterator<String> it = list.iterator();
        String Temp;
        while (it.hasNext()) {
	        CheckBoxPreference checkboxPref = new CheckBoxPreference(this);
	        Temp = it.next();
	        checkboxPref.setKey(Temp);
	        checkboxPref.setTitle(Temp);
	        inlinePrefCat.addPreference(checkboxPref);
        }
		return root;
	}*/



	public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
		ContainerData.parseFiles();
		Toast.makeText(this,  key , Toast.LENGTH_LONG).show();	
	}
	
	public ArrayList<String> getListCercles() {
			return listCercles;
	}
	
	public ArrayList<String> getListClub() {
		return listClubs;
}
}
