package org.grandcercle.mobile;

import org.grandcercle.mobile.R;
import org.grandcercle.mobile.TabEvent;
import org.grandcercle.mobile.TabNews;
import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TabHost;
import android.widget.Toast;

public class GCM extends TabActivity {

	private TabHost tabHost;
	private int [] layoutTab;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		
		//Parsing des fichiers XML
		ContainerData.ParseFiles();
		

		
		tabHost = getTabHost();
		layoutTab = new int[5];
		layoutTab[0] = R.layout.tab_event;
		layoutTab[1] = R.layout.tab_news;
		layoutTab[2] = R.layout.tab_bons_plans;
		layoutTab[3] = R.layout.tab_infos;
		layoutTab[4] = R.layout.tab_param;
		
		
		// Décommentez la ligne suivante pour séparer vos onglets via une image
        //this.tabHost.getTabWidget().setDividerDrawable(R.drawable.separateur);
		
        setupTab("TabEvent", new Intent().setClass(this, TabEvent.class),0);
        setupTab("TabNews", new Intent().setClass(this, TabNews.class),1);
        setupTab("TabBP", new Intent().setClass(this, Tab3.class),2);
		setupTab("TabInfos", new Intent().setClass(this, Tab4.class),3);
		setupTab("TapParam", new Intent().setClass(this, Tab5.class),4);
	}
	
	@Override
	public void onDestroy() {
	    super.onDestroy();
	    System.runFinalizersOnExit(true);
	    System.exit(0);
	}

	private void setupTab(String tag, Intent intent, int layoutTabIndex) {
		tabHost.addTab(tabHost.newTabSpec(tag).setIndicator( createTabView(tabHost.getContext(), layoutTabIndex)).setContent(intent));
	}
	  
	private View createTabView(final Context context, int layoutTabIndex) {
		View view = LayoutInflater.from(context).inflate(layoutTab[layoutTabIndex], null);	
		return view;
	}

}



