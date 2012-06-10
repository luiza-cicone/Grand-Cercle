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
        setContentView(R.layout.affichage_news);
        
        ArrayList<News> listNews = ContainerData.getNews();
        
        // Construction de la liste de news
        if (listNews != null) {
        	ListNewsAdapter lna = new ListNewsAdapter(this,listNews);
        	ListView feedListView = ((ListView)findViewById(R.id.listFeed));
	        ((ListView)findViewById(R.id.listFeed)).setAdapter(lna);
	        feedListView.setOnItemClickListener(clickListenerFeed);
        } else {
        	Toast.makeText(TabNews.this,"Pas de news !",Toast.LENGTH_LONG).show();
        }
       
        
	}
	 public void onResume() {
		 super.onResume();
		 int color = 0xFFFFFFFF;
		 GCM.changeTabHost(color);
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