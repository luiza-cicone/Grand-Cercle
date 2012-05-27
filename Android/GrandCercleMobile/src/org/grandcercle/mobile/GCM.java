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
		
		tabHost = getTabHost();
		
		// Décommentez la ligne suivante pour séparer vos onglets via une image
        //this.tabHost.getTabWidget().setDividerDrawable(R.drawable.tab_divider);

        setupTab("Evenement", "tab1", new Intent().setClass(this, Tab1.class));
        setupTab("News", "tab2", new Intent().setClass(this, Tab2.class));
        setupTab("Calendrier", "tab3", new Intent().setClass(this, Tab3.class));
        setupTab("Boutique", "tab4", new Intent().setClass(this, Tab4.class));
        setupTab("Infos", "tab5", new Intent().setClass(this, Tab5.class));
	}
	
	  private void setupTab(String name, String tag, Intent intent) {
			tabHost.addTab(tabHost.newTabSpec(tag).setIndicator( createTabView(tabHost.getContext(), name)).setContent(intent));
		}
	  
	  private static View createTabView(final Context context, final String text) {
			View view = LayoutInflater.from(context).inflate(R.layout.tab_item, null);
			TextView tv = (TextView) view.findViewById(R.id.tabsText);
			tv.setText(text);

			return view;
		}
	  
/*	private OnClickListener clickListenerTab = new OnClickListener() {
		public void onClick(View v) {
			setContentView(R.layout.tab);
		}
	};*/
}



