package org.grandcercle.mobile;

import java.io.IOException;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.text.method.ScrollingMovementMethod;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

public class PageNews extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.description_news);
		
		// Recuperation des paramètres
		Bundle param = this.getIntent().getExtras();
		((TextView)findViewById(R.id.title)).setText(param.getString("titre"));
		Spanned markedUp = Html.fromHtml(param.getString("description"));
		((TextView)findViewById(R.id.description)).setText(markedUp);
		
		((TextView)findViewById(R.id.group)).setText(param.getString("group"));
		((TextView)findViewById(R.id.PubDate)).setText(param.getString("datepublication"));

		ImageView logo = (ImageView)findViewById(R.id.logo);

		try {
			SaveImageFromUrl.setImage(logo,param.getString("logo"));
		} catch (IOException e) {
			e.printStackTrace();	

		}

		
	}
	
}
