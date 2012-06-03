package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class PageEvent extends Activity {
	private final static String BASE_CALENDAR_URI_PRE_2_2 = "content://calendar";
	private final static String BASE_CALENDAR_URI_2_2 = "content://com.android.calendar";
	
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
		
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.image),param.getString("image"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_ONE_WEEK);
		UrlImageViewHelper.setUrlDrawable((ImageView)findViewById(R.id.logo),param.getString("logo"),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
		
		((Button)findViewById(R.id.addCal)).setOnClickListener(addCalClicked);
	}
	
	// Cherche le "chemin" du calendrier calName dans la mémoire du téléphone
	public Uri getCalendarUriBase(String calName) {
	    Uri calendars = Uri.parse(BASE_CALENDAR_URI_PRE_2_2 + "/calendars/" + calName);
	    try {
	        Cursor managedCursor = managedQuery(calendars, null, null, null, null);
	        if (managedCursor != null) {
	            return calendars;
	        }
	        else {
	            calendars = Uri.parse(BASE_CALENDAR_URI_2_2 + "/calendars/" + calName);
	            managedCursor = managedQuery(calendars, null, null, null, null);

	            if (managedCursor != null) {
	                return calendars;
	            }
	        }
	    } catch (Exception e) { /* eat any exceptions */ }

	    return null; // No working calendar URI found
	}
	
	public ArrayList<UserCalendar> getUserCalendars() {
		String[] projection = new String[] { "_id", "name" };
		Uri calendars = getCalendarUriBase("events");
		//Cursor managedCursor = managedQuery(calendars, projection,"selected=1", null, null);
		Cursor managedCursor = managedQuery(calendars, projection, null, null, null);
		ArrayList<UserCalendar> listCal = null;
		if (managedCursor.moveToFirst()) {
			UserCalendar uCal = new UserCalendar();
			int nameColumn = managedCursor.getColumnIndex("name"); 
			int idColumn = managedCursor.getColumnIndex("_id");
			listCal = new ArrayList<UserCalendar>();
			do {
				uCal.name = managedCursor.getString(nameColumn);
				uCal.id = Integer.parseInt(managedCursor.getString(idColumn));
				listCal.add(uCal);
			} while (managedCursor.moveToNext());
		}
		return listCal;
	}

	
	
	private View.OnClickListener addCalClicked = new View.OnClickListener() {
		public void onClick(View v) {
			
			// récupération noms + ids calendriers
			ArrayList<UserCalendar> listCal = getUserCalendars();
			
			// choix utilisateur. Par défaut : case 0 de l'ArrayList
			
			ContentValues event = new ContentValues();
			event.put("calendar_id", listCal.get(0).id);
			event.put("title", "Event Title");
			event.put("description", "Event Desc");
			event.put("eventLocation", "Event Location");
			long startTime = 10000;
			long endTime = 20000;
			event.put("dtstart", startTime);
			event.put("dtend", endTime);
			try {
				Uri eventsUri = getCalendarUriBase(listCal.get(0).name);
				getContentResolver().insert(eventsUri,event);
				Toast.makeText(PageEvent.this,"Ajout au calendrier : " + listCal.get(0).name,Toast.LENGTH_SHORT).show();
			} catch (Exception e) {
				Toast.makeText(PageEvent.this,"Aucun calendrier disponible !",Toast.LENGTH_SHORT).show();
			}
			
			
			/*ContentResolver cr = getContentResolver();
			Cursor cursor = cr.query(Uri.parse("content://calendar/calendars"), new String[]{ "_id", "displayname" }, null, null, null);
			cursor.moveToFirst();
			String[] CalNames = new String[cursor.getCount()];
			int[] CalIds = new int[cursor.getCount()];
			for (int i = 0; i < CalNames.length; i++) {
			    CalIds[i] = cursor.getInt(0);
			    CalNames[i] = cursor.getString(1);
			    cursor.moveToNext();
			}
			cursor.close();
			
			ContentValues cv = new ContentValues();
			cv.put("calendar_id", CalIds[0]);
			cv.put("title", myTitle);
			cv.put("dtstart", startTime);
			cv.put("dtend", endTime);
			cv.put("eventLocation", myLocation);
			
			URI newevent = cr.insert(Uri.parse("content://calendar/events"), cv);
			*/
			
			/*
			ContentResolver cr = getContentResolver();
			ContentValues values = new ContentValues();
			values.put(CalendarContract.Events.DTSTART, startMillis);
			values.put(CalendarContract.Events.DTEND, endMillis);
			values.put(CalendarContract.Events.TITLE, "Walk The Dog");
			values.put(CalendarContract.Events.DESCRIPTION, "My dog is bored, so we're going on a really long walk!");
			values.put(CalendarContract.Events.CALENDAR_ID, 3);
			Uri uri = cr.insert(CalendarContract.Events.CONTENT_URI, values);
			*/
			
			// Rappel
			/*String eventid = newevent.getPathSegments().get(newevent.getPathSegments().size()-1);
			cv.put("event_id",eventid);
			cv.put("minutes",interval);
			cr.insert(Uri.parse(content://calendar/reminders"),cv);
			=> content://com.android.calendar/events sur Froyo 2.2
			*/
		}
	};
}
