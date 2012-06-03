package org.grandcercle.mobile;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

public class NotificationGCM extends Activity {	
	
	public void sendNotification(Context context, Class<?> cls, String title, String text) {
		// context = getApplicationContext dans l'appel à la méthode
		// cls = NomDeLaClasse.class dans l'appel à la méthode
		
		/* Get the notification manager  */
	    NotificationManager mNotManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
	
	    /* Create a notification */
	    String smallText = "Grand Cercle : Alerte événement !";
	    Notification mNotification = new Notification(
	           R.drawable.logo_gc,                	// An Icon to display
	           smallText,                         	// the text to display in the ticker
	           System.currentTimeMillis()       ); 	// the time for the notification
	
	    /* Starting an intent */
	    Intent MyIntent = new Intent(context,cls);
	    //Intent MyIntent = new Intent();
	    MyIntent.putExtra("title",title);
	    MyIntent.putExtra("text",text);
	    PendingIntent StartIntent = PendingIntent.getActivity(  getApplicationContext(),
	                                              0,
	                                              MyIntent,
	                                              0);
	
	    /* Set notification message */
	    mNotification.setLatestEventInfo(   getApplicationContext(),
	                               title,
	                               text,
	                               StartIntent);
	
	    mNotification.ledOnMS  = 200;    //Set led blink (Off in ms)
	    mNotification.ledOffMS = 200;    //Set led blink (Off in ms)
	    mNotification.ledARGB = 40;   	//Set led color
	
	    /* Sent Notification to notification bar */
	    mNotManager.notify(  0 , mNotification );
	}
}
