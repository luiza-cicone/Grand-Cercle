package org.grandcercle.mobile;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

public class TabPref extends Activity {
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.prefs);
		// onglet Cercles
		TextView cercle = (TextView)findViewById(R.id.Cercles);
		cercle.setOnClickListener((OnClickListener) clickListenerPrefCercle);
		
		// onglet Clubs
		TextView club = (TextView)findViewById(R.id.Clubs);
		club.setOnClickListener((OnClickListener) clickListenerPrefClub);
		
		// onglet Types
		TextView type = (TextView)findViewById(R.id.Types);
		type.setOnClickListener((OnClickListener) clickListenerPrefType);
	}
	
	public void onPause() {
		super.onPause();
		DataBase.getInstance().incrementNumRun();
	}
	
	private View.OnClickListener clickListenerPrefCercle = new View.OnClickListener() {
		public void onClick(View view) {	
			Intent intent = new Intent(TabPref.this,CerclePref.class);		
			TabPref.this.startActivity(intent);
		}
    };
    
    private View.OnClickListener clickListenerPrefClub = new View.OnClickListener() {
		public void onClick(View view) {	
			Intent intent = new Intent(TabPref.this,ClubPref.class);		
			TabPref.this.startActivity(intent);
		}
    };
    private View.OnClickListener clickListenerPrefType = new View.OnClickListener() {
		public void onClick(View view) {	
			Intent intent = new Intent(TabPref.this,TypesPref.class);		
			TabPref.this.startActivity(intent);
		}
    };
}
