package org.grandcercle.mobile;


import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

public class PageBP extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.description_bons_plans);
		
		// Recuperation des paramètres
		Bundle param = this.getIntent().getExtras();
		((TextView)findViewById(R.id.title)).setText(param.getString("titre"));
		Spanned markedUp = Html.fromHtml(param.getString("description"));
		((TextView)findViewById(R.id.description)).setText(markedUp);
		//TextView t2 = (TextView) findViewById(R.id.link);
	    //t2.setMovementMethod(LinkMovementMethod.getInstance());

		((TextView)findViewById(R.id.link)).setText(param.getString("link"));
		
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.image),param.getString("image"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
	}
	
}