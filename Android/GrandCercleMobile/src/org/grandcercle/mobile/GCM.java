package org.grandcercle.mobile;

import java.util.ArrayList;

import org.grandcercle.mobile.R;
import org.grandcercle.mobile.TabEvent;
import org.grandcercle.mobile.TabNews;
import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.MeasureSpec;


import android.widget.ImageView;
import android.widget.TabHost;


import android.widget.TextView;

public class GCM extends TabActivity {
    /** Called when the activity is first created. */

	private TabHost tabHost;
	//private int [] imageTab;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		//Parsing des fichiers XML
		ContainerData.ParseFiles();
		
		tabHost = getTabHost();
		/*imageTab = new int[5];
		imageTab[0] = R.drawable.calendar;
		imageTab[1] = R.drawable.news;
		imageTab[2] = R.drawable.deals;
		imageTab[3] = R.drawable.settings;
		imageTab[4] = R.drawable.search;*/
		
		// Décommentez la ligne suivante pour séparer vos onglets via une image
        //this.tabHost.getTabWidget().setDividerDrawable(R.drawable.separateur);
		//Intent intent = new Intent().setClass(this, Tab1.class);
		//intent.getAction();
		//tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator( "Evenement",getResources().getDrawable(R.drawable.deals)).setContent(intent));
        setupTab("Evenements", "TabEvent", new Intent().setClass(this, TabEvent.class),0);
		//intent = new Intent().setClass(this, Tab2.class);
		//tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator( "News",getResources().getDrawable(R.drawable.news)).setContent(intent));
        setupTab("News", "TabNews", new Intent().setClass(this, TabNews.class),1);
		//intent = new Intent().setClass(this, Tab3.class);
		//tabHost.addTab(tabHost.newTabSpec("tab3").setIndicator( "Calendrier",getResources().getDrawable(R.drawable.calendar)).setContent(intent));
        setupTab("Calendrier", "tab3", new Intent().setClass(this, Tab3.class),2);
		//intent = new Intent().setClass(this, Tab4.class);
		//tabHost.addTab(tabHost.newTabSpec("tab4").setIndicator( "Boutique",getResources().getDrawable(R.drawable.settings)).setContent(intent));
        setupTab("Boutique", "tab4", new Intent().setClass(this, Tab4.class),3);
		//intent = new Intent().setClass(this, Tab5.class);
		//tabHost.addTab(tabHost.newTabSpec("tab5").setIndicator( "Info",getResources().getDrawable(R.drawable.search)).setContent(intent));
        setupTab("Infos", "tab5", new Intent().setClass(this, Tab5.class),4);
	}
	
	private void setupTab(String name, String tag, Intent intent, int imageTabIndex) {
		tabHost.addTab(tabHost.newTabSpec(tag).setIndicator( createTabView(tabHost.getContext(), name, imageTabIndex)).setContent(intent));
	}
	  
	private View createTabView(final Context context, final String text, int imageTabIndex) {
		View view = LayoutInflater.from(context).inflate(R.layout.tab_item, null);	
		((TextView)view.findViewById(R.id.tabsText)).setText(text);
		//((ImageView)findViewById(R.drawable.calendar);
		//((ImageView)findViewById(R.id.icone)).setImageResource(imageTab[imageTabIndex]);

		//(im.getResources().getIdentifier(text, "drawable", "org.grandcercle.mobile"));
		return view;
	}
	
	/*public Bitmap getBitmapFromView(ImageView iv) {
		iv.setDrawingCacheEnabled(true);        
	    iv.buildDrawingCache(true);
	 
	    // creates immutable clone 
	    Bitmap bitmap = Bitmap.createBitmap(iv.getDrawingCache());
	 
	    iv.setDrawingCacheEnabled(false); // clear drawing cache
		
		return bitmap;
	}*/

}



