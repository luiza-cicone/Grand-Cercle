package org.grandcercle.mobile;




import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;


public class TabBP extends Activity {
	
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.affichage_bons_plans);
        ArrayList<BP> listBP = ContainerData.getlistBP();
        
        if (listBP != null) {
	        ListBPAdapter lbpa = new ListBPAdapter(this,listBP);
	        ListView feedListView = ((ListView)findViewById(R.id.listFeed));
	        ((ListView)findViewById(R.id.listFeed)).setAdapter(lbpa);
	        feedListView.setOnItemClickListener(clickListenerBP);
        } else {
        	Toast.makeText(TabBP.this,"Pas de bons plans !",Toast.LENGTH_LONG).show();
        }
		
	 }
	 private AdapterView.OnItemClickListener clickListenerBP = new AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent intent = new Intent(TabBP.this,PageBP.class);
				// Passage des paramètres
				Bundle bundle = new Bundle();
				//Add the parameters to bundle as
				bundle.putString("titre",((BP)parent.getItemAtPosition(position)).getTitle());
				bundle.putString("description",((BP)parent.getItemAtPosition(position)).getDescription());
				bundle.putString("image",((BP)parent.getItemAtPosition(position)).getImage());
				bundle.putString("link",((BP)parent.getItemAtPosition(position)).getLink());
				
				//bundle.putString("link",((News)parent.getItemAtPosition(position)).getLink());
				//Ajout du Bundle
				intent.putExtras(bundle);
				
				TabBP.this.startActivity(intent);
			}
	 };
	
}
			