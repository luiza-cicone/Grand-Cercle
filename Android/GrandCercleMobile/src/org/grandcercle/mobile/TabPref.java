package org.grandcercle.mobile;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioGroup;
import android.widget.TextView;

public class TabPref extends Activity {
	private DataBase dataBase;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.prefs);
		
		
		// layout Cercles
		TextView cercle = (TextView)findViewById(R.id.Cercles);
		cercle.setOnClickListener((OnClickListener) clickListenerPrefCercle);
		
		// layout Clubs
		TextView club = (TextView)findViewById(R.id.Clubs);
		club.setOnClickListener((OnClickListener) clickListenerPrefClub);
		
		// layout Types
		TextView type = (TextView)findViewById(R.id.Types);
		type.setOnClickListener((OnClickListener) clickListenerPrefType);
		
		TextView design = (TextView)findViewById(R.id.Design);
		design.setOnClickListener((OnClickListener) clickListenerPrefDesign);
	}

	public void onResume() {
		super.onResume();
		View view = findViewById(R.id.bandeau);
		int color ;
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		if (prefered.equals("Noir")) {
			color = 0xFF000000;
			view.setBackgroundColor(color);
		} else if(prefered.equals("Ensimag")) {
			color = 0xFF96BE0F;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Phelma")) {
			color = 0xFFBE141E;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Ense3")) {
			color = 0xFF004B9B;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Pagora")) {
			color = 0xFFF09600;
			view.setBackgroundColor(color);
		} else if (prefered.equals("GI")) {
			color = 0xFF0096D7;
			view.setBackgroundColor(color);
		} else if (prefered.equals("CPP")) {
			color = 0xFFFFCD00;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Esisar")) {
			color = 0xFF96147D;
			view.setBackgroundColor(color);
		}
	}
	
	private View.OnClickListener clickListenerPrefCercle = new View.OnClickListener() {
		public void onClick(View view) {
			// lancement de l'activité correspondant aux préférences liées aux cercles
			Intent intent = new Intent(TabPref.this,CerclePref.class);		
			TabPref.this.startActivity(intent);
		}
    };
    
    private View.OnClickListener clickListenerPrefDesign = new View.OnClickListener() {
    	public void onClick(View view) {	
			// lancement de l'activité correspondant aux préférences liées aux clubs
			Intent intent = new Intent(TabPref.this,DesignPref.class);	
			TabPref.this.startActivity(intent);
		}
    };
    
    private View.OnClickListener clickListenerPrefClub = new View.OnClickListener() {
		public void onClick(View view) {	
			// lancement de l'activité correspondant aux préférences liées aux clubs
			Intent intent = new Intent(TabPref.this,ClubPref.class);		
			TabPref.this.startActivity(intent);
		}
    };
    private View.OnClickListener clickListenerPrefType = new View.OnClickListener() {
		public void onClick(View view) {	
			// lancement de l'activité correspondant aux préférences liées aux types d'événements
			Intent intent = new Intent(TabPref.this,TypesPref.class);		
			TabPref.this.startActivity(intent);
		}
    };
}
