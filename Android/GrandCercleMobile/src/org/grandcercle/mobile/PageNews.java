package org.grandcercle.mobile;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

/*
 * Classe représentant le détail d'une news
 */

public class PageNews extends Activity {
	private DataBase dataBase;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.description_news);
		View view = findViewById(R.id.bandeau);
		int color ;
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		if (prefered.equals("Noir")) {
			color = 0xFF3B3B3B;
			view.setBackgroundColor(color);
		} else if(prefered.equals("Ensimag")) {
			color = 0xFF96BE0F;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Phelma")) {
			color = 0xFFBE141E;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Ense3")) {
			color = 0xFF004B9B;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Pagora")) {
			color = 0xFFF09600;
			view.setBackgroundColor(color);
		} else if (prefered.equals("GI")) {
			color = 0xFF0096D7;
			view.setBackgroundColor(color);
		} else if (prefered.equals("CPP")) {
			color = 0xFFFFCD00;
			view.setBackgroundColor(color);
		} else if (prefered.equals("Esisar")) {
			color = 0xFF96147D;
			view.setBackgroundColor(color);
		}
		
		// Recuperation des paramètres
		Bundle param = this.getIntent().getExtras();
		((TextView)findViewById(R.id.title)).setText(param.getString("titre"));
		Spanned markedUp = Html.fromHtml(param.getString("description"));
		((TextView)findViewById(R.id.description)).setText(markedUp);
		
		((TextView)findViewById(R.id.group)).setText(param.getString("group"));
		((TextView)findViewById(R.id.PubDate)).setText(param.getString("datepublication"));

		// Récupération du logo du groupe publiant la news.
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.logo),param.getString("logo"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
	}
	
}
