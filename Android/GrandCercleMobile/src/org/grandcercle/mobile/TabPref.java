package org.grandcercle.mobile;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.preference.PreferenceManager;
import android.widget.Toast;

public class TabPref extends PreferenceActivity implements OnSharedPreferenceChangeListener {

	SharedPreferences pref;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		//setContentView(R.layout.main);
		addPreferencesFromResource(R.xml.prefs);
		pref = getPreferenceManager().getSharedPreferences();
		pref.registerOnSharedPreferenceChangeListener(this);
		SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(this);
		String myString = preferences.getString("maPref", "");
	}

	public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
		ContainerData.parseFiles();
		Toast.makeText(this,  key , Toast.LENGTH_LONG).show();	
	}
	
	

}
