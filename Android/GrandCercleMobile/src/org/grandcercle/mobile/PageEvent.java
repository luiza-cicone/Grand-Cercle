package org.grandcercle.mobile;

import java.util.Calendar;
import java.util.Locale;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

/*
 * Classe représentant le détail d'un événement
 */

public class PageEvent extends Activity {
	private String title;
	private Spanned description;
	private String lieu;
	private String date;
	private String eventDate;
	private DataBase dataBase;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.description_event);
		
		View view = findViewById(R.id.fond_event1);
		int color ;
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		if (prefered.equals("Noir")) {
			color = 0xFF222222;
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
		title = param.getString("titre");
		((TextView)findViewById(R.id.title)).setText(title);
		
		description = Html.fromHtml(param.getString("description"));
		((TextView)findViewById(R.id.description)).setText(description);
		
		((TextView)findViewById(R.id.day)).setText(param.getString("day"));
		
		date = param.getString("date");
		((TextView)findViewById(R.id.date)).setText(date);
		((TextView)findViewById(R.id.time)).setText(param.getString("time"));
		
		lieu = param.getString("lieu");
		((TextView)findViewById(R.id.lieu)).setText(lieu);
		((TextView)findViewById(R.id.group)).setText(param.getString("group"));
		
		eventDate = param.getString("eventDate");
		
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.image),param.getString("image"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_ONE_WEEK);
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.logo),param.getString("logo"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
		
		((ImageView)findViewById(R.id.addCal)).setOnClickListener(addCalClicked);
	}

	public static long convertDateToLong(String d) {
		int index0 = d.indexOf("-");
		String sub = d.substring(index0+1);
		int index1 = sub.indexOf("-");
		String day = d.substring(0,index0);
		String month = d.substring(index0+1,index0+index1+1);
		String year = d.substring(index0+index1+2,d.length());

		Calendar c = Calendar.getInstance(Locale.FRANCE);
		c.set(Calendar.DAY_OF_MONTH, Integer.parseInt(day));
		c.set(Calendar.MONTH, Integer.parseInt(month)-1);
		c.set(Calendar.YEAR, Integer.parseInt(year));
		return c.getTime().getTime();
	}
	
	private View.OnClickListener addCalClicked = new View.OnClickListener() {
		public void onClick(View v) {
			Intent intent = new Intent(Intent.ACTION_EDIT);
			intent.setType("vnd.android.cursor.item/event");

			long beginTime = convertDateToLong(eventDate);
			intent.putExtra("beginTime",beginTime);
			intent.putExtra("endTime",beginTime);
			intent.putExtra("allDay",true);
			if (title !=null) {
				intent.putExtra("title",title);
			} else {
				intent.putExtra("title", "");
			}
			if (description !=null) {
				intent.putExtra("description",description.toString());
			} else {
				intent.putExtra("description", "");
			}
			if (lieu !=null) {
				intent.putExtra("eventLocation",lieu);
			} else {
				intent.putExtra("eventLocation", "");
			}
			startActivity(intent);
		}	
	};
}
