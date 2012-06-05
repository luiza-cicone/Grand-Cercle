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
		TextView cercle = (TextView)findViewById(R.id.Cercles);
		cercle.setOnClickListener((OnClickListener) clickListenerPrefCercle);
		TextView club = (TextView)findViewById(R.id.Clubs);
		club.setOnClickListener((OnClickListener) clickListenerPrefClub);
		
	
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
}
