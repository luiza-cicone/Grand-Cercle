package gcm.android.parser;


import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;

public class FeedPlayer extends TabActivity {
    /** Called when the activity is first created. */

	
	private TabHost tabHost;
	private TabSpec tabSpec;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		
		Intent intent = new Intent(this, ActiviteTab.class);
		tabHost = getTabHost();
		
		// ci-dessous : pour mettre un icone dans l'onglet !
		//tabSpec = tabHost.newTabSpec("un").setIndicator("Un",getResources().getDrawable(R.drawable.icon)).setContent(intent);
		tabSpec = tabHost.newTabSpec("un").setIndicator("Un").setContent(intent);
		tabHost.addTab(tabSpec);
		
		tabSpec = tabHost.newTabSpec("deux").setIndicator("Deux").setContent(intent);
		tabHost.addTab(tabSpec);
		
		tabHost.setOnClickListener(clickListenerTab);
	}
	
	private OnClickListener clickListenerTab = new OnClickListener() {
		public void onClick(View v) {
			setContentView(R.layout.tab);
		}
	};
}



