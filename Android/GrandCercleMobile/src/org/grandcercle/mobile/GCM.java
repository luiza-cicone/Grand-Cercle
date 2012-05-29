package org.grandcercle.mobile;


import org.grandcercle.mobile.R;
import org.grandcercle.mobile.Tab1;
import org.grandcercle.mobile.Tab2;
import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;


import android.widget.TabHost;


import android.widget.TextView;

public class GCM extends TabActivity {
    /** Called when the activity is first created. */

	
	private TabHost tabHost;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		//Parsing des fichiers XML
		ContainerData.ParseFiles();
		
		tabHost = getTabHost();
		
		// Décommentez la ligne suivante pour séparer vos onglets via une image
        //this.tabHost.getTabWidget().setDividerDrawable(R.drawable.tab_divider);
		Intent intent = new Intent().setClass(this, Tab1.class);
		//intent.getAction();
		//tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator( "Evenement",getResources().getDrawable(R.drawable.deals)).setContent(intent));
        setupTab("Evenement", "tab1", new Intent().setClass(this, Tab1.class));
		//intent = new Intent().setClass(this, Tab2.class);
		//tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator( "News",getResources().getDrawable(R.drawable.news)).setContent(intent));
        setupTab("News", "tab2", new Intent().setClass(this, Tab2.class));
		//intent = new Intent().setClass(this, Tab3.class);
		//tabHost.addTab(tabHost.newTabSpec("tab3").setIndicator( "Calendrier",getResources().getDrawable(R.drawable.calendar)).setContent(intent));
        setupTab("Calendrier", "tab3", new Intent().setClass(this, Tab3.class));
		//intent = new Intent().setClass(this, Tab4.class);
		//tabHost.addTab(tabHost.newTabSpec("tab4").setIndicator( "Boutique",getResources().getDrawable(R.drawable.settings)).setContent(intent));
        setupTab("Boutique", "tab4", new Intent().setClass(this, Tab4.class));
		//intent = new Intent().setClass(this, Tab5.class);
		//tabHost.addTab(tabHost.newTabSpec("tab5").setIndicator( "Info",getResources().getDrawable(R.drawable.search)).setContent(intent));
        setupTab("Infos", "tab5", new Intent().setClass(this, Tab5.class));
        
        
        /*tabHost.setOnTabChangedListener(
        		new TabHost.OnTabChangeListener (){
        		public void onTabChanged(String tabId){
        			Toast.makeText(GCM.this, "L’onglet avec l’identifiant : "+ tabId + " a été cliqué", Toast.LENGTH_SHORT).show();

        		}
        	}
        );*/

	}
	
	  private void setupTab(String name, String tag, Intent intent) {
			tabHost.addTab(tabHost.newTabSpec(tag).setIndicator( createTabView(tabHost.getContext(), name)).setContent(intent));
		}
	  
	  private static View createTabView(final Context context, final String text) {
			View view = LayoutInflater.from(context).inflate(R.layout.tab_item, null);	
			TextView tv = (TextView) view.findViewById(R.id.tabsText);
			//ImageView im = (ImageView) view.findViewById(R.drawable.calendar);
			tv.setText(text);
			//(im.getResources().getIdentifier(text, "drawable", "org.grandcercle.mobile"));
			return view;
		}
	  
/*	private OnClickListener clickListenerTab = new OnClickListener() {
		public void onClick(View v) {
			setContentView(R.layout.tab);
		}
	};*/
}



