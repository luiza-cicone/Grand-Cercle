package org.grandcercle.mobile;

import java.io.IOException;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.widget.ImageView;
import android.widget.TextView;

public class PageEvent extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.description_event);
		
		// Recuperation des paramètres
		Bundle param = this.getIntent().getExtras();
		((TextView)findViewById(R.id.title)).setText(param.getString("titre"));
		Spanned markedUp = Html.fromHtml(param.getString("description"));
		((TextView)findViewById(R.id.description)).setText(markedUp);
		
		((TextView)findViewById(R.id.day)).setText(param.getString("day"));
		((TextView)findViewById(R.id.date)).setText(param.getString("date"));
		((TextView)findViewById(R.id.time)).setText(param.getString("time"));
		((TextView)findViewById(R.id.lieu)).setText(param.getString("lieu"));
		((TextView)findViewById(R.id.group)).setText(param.getString("group"));
		
		/*ImageView logo = (ImageView)findViewById(R.id.logo);
		try {
			SaveImageFromUrl.setImage(logo,param.getString("logo"));
		} catch (IOException e) {
			e.printStackTrace();	

		}*/
		
		/*ImageView image = (ImageView)findViewById(R.id.image);
		try {
			SaveImageFromUrl.setImage(image,param.getString("image"));
		} catch (IOException e) {
			e.printStackTrace();	

		}*/
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.image), param.getString("image"), R.drawable.loading,null);
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.logo),param.getString("logo"), R.drawable.loading, null);
	}
}
