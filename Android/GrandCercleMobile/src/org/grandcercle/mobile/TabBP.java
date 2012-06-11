package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

/*
 * Onglet bons plans
 */

public class TabBP extends Activity {
	
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Récupération du layout xml
        setContentView(R.layout.affichage_bons_plans);
        ArrayList<BP> listBP = ContainerData.getlistBP();
        
        // On construit la liste de news
        if (listBP != null) {
	        ListBPAdapter lbpa = new ListBPAdapter(this,listBP);
	        // Récupération de la liste de cellules de bons plans
	        ListView feedListView = ((ListView)findViewById(R.id.listFeed));
	        // Mise en forme
	        feedListView.setAdapter(lbpa);
	        // Listener permet de clicker sur un élément de la liste
	        feedListView.setOnItemClickListener(clickListenerBP);
        } else {
        	Toast.makeText(TabBP.this,"Pas de bons plans !",Toast.LENGTH_LONG).show();
        }
		
	 }
	 
	 public void onResume() {
		super.onResume();
		GCM.changeTabHost();
		GCM.oldchild = 2;
	 }
	 
	 // Listener privé gérant l'action à associer à un click sur un élément de la liste
	 private AdapterView.OnItemClickListener clickListenerBP = new AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent intent = new Intent(TabBP.this,PageBP.class);
				// Passage des paramètres
				Bundle bundle = new Bundle();
				//Ajout des paramètres dans le bundle
				bundle.putString("titre",((BP)parent.getItemAtPosition(position)).getTitle());
				bundle.putString("description",((BP)parent.getItemAtPosition(position)).getDescription());
				bundle.putString("image",((BP)parent.getItemAtPosition(position)).getImage());
				bundle.putString("link",((BP)parent.getItemAtPosition(position)).getLink());
				
				//Ajout du Bundle
				intent.putExtras(bundle);
				
				TabBP.this.startActivity(intent);
			}
	 };
	
}
			