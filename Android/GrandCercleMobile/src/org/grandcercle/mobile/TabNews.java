package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TabHost;
import android.widget.Toast;

/*
 * Onglet des news
 */

public class TabNews extends Activity {
	TabHost tabHost;
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Récupération du layout xml
        setContentView(R.layout.affichage_news);
        // Récupération de la liste de news prise sur le site
        ArrayList<News> listNews = ContainerData.getNews();
        
        // Construction de la liste de news
        if (listNews != null) {
        	ListNewsAdapter lna = new ListNewsAdapter(this,listNews);
        	ListView feedListView = ((ListView)findViewById(R.id.listFeed));
	        ((ListView)findViewById(R.id.listFeed)).setAdapter(lna);
	        feedListView.setOnItemClickListener(clickListenerFeed);
        } else {
        	// On informe à l'utilisateur qu'il n'y a aucune news
        	Toast.makeText(TabNews.this,"Pas de news !",Toast.LENGTH_LONG).show();
        }
       
        
	}
	 public void onResume() {
		 super.onResume();
		 GCM.changeTabHost();
		 GCM.oldchild = 1;
	 }
	 
	 private AdapterView.OnItemClickListener clickListenerFeed = new AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {				
				// Ouverture nouvelle activity
				Intent intent = new Intent(TabNews.this,PageNews.class);
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
				intent.putExtras(bundle);
				
				TabNews.this.startActivity(intent);
			}
	    };
	    
}