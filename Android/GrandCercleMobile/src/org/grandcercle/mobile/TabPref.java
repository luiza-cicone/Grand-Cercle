package org.grandcercle.mobile;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

/*
 * Onglet des paramètres
 */

public class TabPref extends Activity {
	
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
		
		// Layout Design
		TextView design = (TextView)findViewById(R.id.Design);
		design.setOnClickListener((OnClickListener) clickListenerPrefDesign);
	}

	public void onResume() {
		super.onResume();
		// On colore l'onglet sélectionné en blanc et on restaure la couleur de l'ancien onglet.
		GCM.changeTabHost();
		// on met à jour l'ancien onglet
		GCM.oldchild = 4;
		View view = findViewById(R.id.bandeau);
		int color = 0xFF3B3B3B;
		// Le premier bandeau est grisé
		view.setBackgroundColor(color);
		// Le deuxieme bandeau est grisé
		view = findViewById(R.id.bandeau2);
		view.setBackgroundColor(color);
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
