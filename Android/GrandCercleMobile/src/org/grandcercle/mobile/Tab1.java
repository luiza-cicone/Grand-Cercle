package org.grandcercle.mobile;

import java.util.ArrayList;

import org.grandcercle.mobile.R;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class Tab1 extends Activity {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.tab1);
		ArrayList<Event> listEvent = ContainerData.getEvent();
		
		ListEventAdapter lfa = new ListEventAdapter(this,listEvent);
		ListView feedListView = ((ListView)findViewById(R.id.listFeed));
		((ListView)findViewById(R.id.listFeed)).setAdapter(lfa);
		feedListView.setOnItemClickListener(clickListenerFeed);
	}
	
	private AdapterView.OnItemClickListener clickListenerFeed = new AdapterView.OnItemClickListener() {
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			// Ouverture nouvelle activity
			Intent intent = new Intent(Tab1.this,PageEvent.class);
			// Passage des paramètres
			Bundle bundle = new Bundle();
			//Add the parameters to bundle as
			bundle.putString("titre",((Event)parent.getItemAtPosition(position)).getTitle());
			bundle.putString("description",((Event)parent.getItemAtPosition(position)).getDescription());
			bundle.putString("image",((Event)parent.getItemAtPosition(position)).getImage());
			bundle.putString("day",((Event)parent.getItemAtPosition(position)).getDay());
			bundle.putString("date",((Event)parent.getItemAtPosition(position)).getDate());
			bundle.putString("time",((Event)parent.getItemAtPosition(position)).getTime());
			bundle.putString("lieu",((Event)parent.getItemAtPosition(position)).getLieu());
			bundle.putString("logo",((Event)parent.getItemAtPosition(position)).getLogo());
			bundle.putString("group",((Event)parent.getItemAtPosition(position)).getGroup());
			//Ajout du Bundle
			intent.putExtras(bundle);
			
			Tab1.this.startActivity(intent);
		}
	};
}