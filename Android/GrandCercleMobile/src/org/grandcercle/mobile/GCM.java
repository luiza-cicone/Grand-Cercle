package org.grandcercle.mobile;

import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TabHost;

/*
 * Classe principale qui gère les onglets
 */

public class GCM extends TabActivity {

	private static TabHost tabHost;
	private int [] layoutTab;
	private static DataBase dataBase;
	static int oldchild;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		tabHost = getTabHost();
		layoutTab = new int[5];
		layoutTab[0] = R.layout.tab_event;
		layoutTab[1] = R.layout.tab_news;
		layoutTab[2] = R.layout.tab_bons_plans;
		layoutTab[3] = R.layout.tab_infos;
		layoutTab[4] = R.layout.tab_param;
		
		
		// Décommentez la ligne suivante pour séparer vos onglets via une image
		
        //this.tabHost.getTabWidget().setDividerDrawable(null);
		
        setupTab("TabEvent", new Intent().setClass(this, TabEvent.class),0);
        setupTab("TabNews", new Intent().setClass(this, TabNews.class),1);
        setupTab("TabBP", new Intent().setClass(this, TabBP.class),2);
		setupTab("TabInfos", new Intent().setClass(this, TabInfos.class),3);
		//setupTab("TabPref", new Intent().setClass(this, TabPref.class),4);
		setupTab("TabPref",new Intent().setClass(this,TabPref.class),4);
		//this.tabHost.getTabWidget().setDividerDrawable(R.drawable.tab_divider);
		
	}
	
	@Override
	public void onDestroy() {
	    super.onDestroy();
	    System.runFinalizersOnExit(true);
	    System.exit(0);
	}

	public void onResume() {
		super.onResume();
		tabHost = getTabHost();
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		//view = tabHost.getCurrentTabView();
		int color ;
		//for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
	        
		if (prefered.equals("Noir")) {
		     color = 0xFF222222;
		     for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
	        	tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if(prefered.equals("Ensimag")) {
			color = 0xFF96BE0F;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("Phelma")) {
			color = 0xFFBE141E;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("Ense3")) {
			color = 0xFF004B9B;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("Pagora")) {
			color = 0xFFF09600;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("GI")) {
			color = 0xFF0096D7;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("CPP")) {
			color = 0xFFFFCD00;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
       		tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
		} else if (prefered.equals("Esisar")) {
			color = 0xFF96147D;
			for(int i=0;i<tabHost.getTabWidget().getChildCount();i++){
				tabHost.getTabWidget().getChildAt(i).setBackgroundColor(color);
			}
		}
		
		color = 0xFFFFFFFF;
		tabHost.getCurrentTabView().setBackgroundColor(color);
		//tabHost.getCurrentTabView().setBackgroundColor()
		//view.refreshDrawableState();	
	}
	
	public static void changeTabHost(int newcolor) {
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		//view = tabHost.getCurrentTabView();
		int color ;
		//for(int i=0;i<tabHost.getTabWidget().getChildCount();i++)
	        
		if (prefered.equals("Noir")) {
		    color = 0xFF222222;
	        tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if(prefered.equals("Ensimag")) {
			color = 0xFF96BE0F;
        	tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("Phelma")) {
			color = 0xFFBE141E;
        	tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("Ense3")) {
			color = 0xFF004B9B;
        	tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("Pagora")) {
			color = 0xFFF09600;
        	tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("GI")) {
			color = 0xFF0096D7;
			tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("CPP")) {
			color = 0xFFFFCD00;
			tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		} else if (prefered.equals("Esisar")) {
			color = 0xFF96147D;
			tabHost.getTabWidget().getChildAt(oldchild).setBackgroundColor(color);
		}
		
		tabHost.getCurrentTabView().setBackgroundColor(newcolor);
	}
	
	// inclut l'onglet dans la barre d'onglets en haut de l'écran
	private void setupTab(String tag, Intent intent, int layoutTabIndex) {
		tabHost.addTab(tabHost.newTabSpec(tag).setIndicator( createTabView(tabHost.getContext(), layoutTabIndex)).setContent(intent));
	}
	 
	// créé la vue associée à l'onglet considéré
	private View createTabView(final Context context, int layoutTabIndex) {
		View view = LayoutInflater.from(context).inflate(layoutTab[layoutTabIndex], null);
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		if (prefered.equals("Noir")) {
			view.setBackgroundResource(R.color.black);
		} else if(prefered.equals("Ensimag")) {
			view.setBackgroundResource(R.color.Ensimag);
		} else if (prefered.equals("Phelma")) {
			view.setBackgroundResource(R.color.Phelma);
		} else if (prefered.equals("Ense3")) {
			view.setBackgroundResource(R.color.Ense3);
		} else if (prefered.equals("Pagora")) {
			view.setBackgroundResource(R.color.Pagora);
		} else if (prefered.equals("GI")) {
			view.setBackgroundResource(R.color.GI);
		} else if (prefered.equals("CPP")) {
			view.setBackgroundResource(R.color.CPP);
		} else if (prefered.equals("Esisar")) {
			view.setBackgroundResource(R.color.Esisar);
		}
		view.refreshDrawableState();
		//view.setBackgroundResource(R.color.Ensimag);
		return view;
	}

}



