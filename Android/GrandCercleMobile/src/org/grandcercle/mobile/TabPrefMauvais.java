package org.grandcercle.mobile;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceGroup;
import android.widget.Toast;

public class TabPrefMauvais extends PreferenceActivity implements OnSharedPreferenceChangeListener {
	static SharedPreferences pref;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);

		pref = getPreferenceManager().getSharedPreferences();
		pref.registerOnSharedPreferenceChangeListener(this);
		addPreferencesFromResource(R.xml.prefs);
		int c = pref.getInt("numRun",0);
		c++;
		pref.edit().putInt("numRun",c).commit();
	}
	
	/*protected void OnPause() {
		if(!isFinishing()){
			int c = pref.getInt("numRun",0);
			c--;
			pref.edit().putInt("numRun",c).commit();
		}
	}*/

	/*private PreferenceScreen createPreferenceHierarchy(String name, ArrayList<String> list) { 
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
	
	/*public static Preference findPreferenceByKey(SharedPreferences prefs, String key) {
	    for (int i = 0; i < ((PreferenceGroup) prefs).getPreferenceCount(); i++) {
	        Preference pref = ((PreferenceGroup) prefs).getPreference(i);
	        if (pref.hasKey() && pref.getKey().equals(key)) {
	            return pref;
	        }
	    }
	    return null;
	}*/
}
