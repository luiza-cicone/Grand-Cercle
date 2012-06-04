package org.grandcercle.mobile;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.widget.Toast;

public class TabPref extends PreferenceActivity implements OnSharedPreferenceChangeListener {
	SharedPreferences pref;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		//setContentView(R.layout.main);
		addPreferencesFromResource(R.xml.prefs);
		//PreferenceManager.setDefaultValues(TabPref.this, R.xml.prefs, false);
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
	
}
