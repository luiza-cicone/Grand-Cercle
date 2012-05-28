package org.grandcercle.mobile;



import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.widget.TextView;
import android.widget.ImageView;

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
		ImageView image = (ImageView)findViewById(R.id.logo);
		//((TextView)findViewById(R.id.link)).setText(param.getString("link"));
		/*String imageURL = "http://grandcercle.org/sites/default/files/styles/mobile_small/public/logo_gc_0.png";
		String img="image.jpg";
		
		try {
			SaveImageFromUrl.saveImage(imageURL,img);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		//String temp = (param.getString("logo")).substring(30);
		
		//((TextView)findViewById(R.id.logo)).setText(param.getString(temp));
		
		
	}
	
}
