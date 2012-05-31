package org.grandcercle.mobile;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.widget.Toast;

public class Preferences extends PreferenceActivity implements OnSharedPreferenceChangeListener {

	SharedPreferences pref;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		//setContentView(R.layout.main);
		addPreferencesFromResource(R.xml.prefs);
		pref = getPreferenceManager().getSharedPreferences();
		pref.registerOnSharedPreferenceChangeListener(this);
	}

	public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
		Toast.makeText(this, key + ":" + sharedPreferences.getString(key, ""), Toast.LENGTH_LONG).show();
		
	}

}
