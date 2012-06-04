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
		cercle.setOnClickListener((OnClickListener) clickListenerPref);
	
}
	
	private View.OnClickListener clickListenerPref = new View.OnClickListener() {
		public void onClick(View view) {	
			Intent intent = new Intent(TabPref.this,CerclePref.class);
			// Ouverture nouvelle activity
			/*if (position == 0) { 
				Intent intent = new Intent(TabPref.this,.class);
			// Passage des paramètres
			Bundle bundle = new Bundle();
			//Add the parameters to bundle as
			bundle.putString("titre",((News)parent.getItemAtPosition(position)).getTitle());
			bundle.putString("description",((News)parent.getItemAtPosition(position)).getDescription());
			bundle.putString("auteur",((News)parent.getItemAtPosition(position)).getAuthor());
			bundle.putString("datepublication",((News)parent.getItemAtPosition(position)).getPubDate());
			bundle.putString("group",((News)parent.getItemAtPosition(position)).getGroup());
			bundle.putString("logo",((News)parent.getItemAtPosition(position)).getLogo());
			//bundle.putString("link",((News)parent.getItemAtPosition(position)).getLink());
			//Ajout du Bundle
			intent.putExtras(bundle);*/
			
			TabPref.this.startActivity(intent);
		}
    };
}
