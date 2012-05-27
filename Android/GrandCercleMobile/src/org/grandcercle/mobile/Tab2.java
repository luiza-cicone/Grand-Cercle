package org.grandcercle.mobile;



import java.util.ArrayList;

import org.grandcercle.mobile.R;


import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

public class Tab2 extends Activity {
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tab2);
        //recherche = (EditText)findViewById(R.id.recherche);
        ArrayList<Feed> feeds = ContainerData.getFeeds();
        for (Feed feed : feeds) {
			Log.i("FeedPlayer",feed.toString());
		}
        ListFeedAdapter lfa = new ListFeedAdapter(this, feeds);
        ListView feedListView = ((ListView)findViewById(R.id.listFeed));
        ((ListView)findViewById(R.id.listFeed)).setAdapter(lfa);
        feedListView.setOnItemClickListener(clickListenerFeed);
	 }
	 
	 private AdapterView.OnItemClickListener clickListenerFeed = new AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				 /* Get the notification manager  */
		         NotificationManager mNotManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

		         /* Create a notification */
		         String MyText = "Grand Cercle : Alerte événement !";
		         Notification mNotification = new Notification(
		                R.drawable.icon,                // An Icon to display
		                MyText,                         // the text to display in the ticker
		                System.currentTimeMillis()       ); // the time for the notification

		         /* Starting an intent */
		         String MyNotifyTitle = "Firstdroid Rocks!!!";
		         String MyNotifiyText  = "Firstdroid: our forum at www.firstdroid.com";
		         //Intent MyIntent = new Intent(getApplicationContext(),parser.class);
		         Intent MyIntent = new Intent();
		         MyIntent.putExtra("extendedTitle", MyNotifyTitle);
		         MyIntent.putExtra("extendedText" , MyNotifiyText);
		         PendingIntent StartIntent = PendingIntent.getActivity(  getApplicationContext(),
		                                                   0,
		                                                   MyIntent,
		                                                   0);

		         /* Set notification message */
		         mNotification.setLatestEventInfo(   getApplicationContext(),
		                                    MyNotifyTitle,
		                                    MyNotifiyText,
		                                    StartIntent);

		         mNotification.ledOnMS  = 200;    //Set led blink (Off in ms)
		         mNotification.ledOffMS = 200;    //Set led blink (Off in ms)
		         mNotification.ledARGB = 40;   	//Set led color

		         /* Sent Notification to notification bar */
		         mNotManager.notify(  0 , mNotification );
				
				
				// Ouverture nouvelle activity
				Intent intent = new Intent(Tab2.this,PageEvent.class);
				// Passage des paramètres
				Bundle bundle = new Bundle();
				//Add the parameters to bundle as
				bundle.putString("titre",((Feed)parent.getItemAtPosition(position)).getTitle());
				bundle.putString("description",((Feed)parent.getItemAtPosition(position)).getDescription());
				//Ajout du Bundle
				intent.putExtras(bundle);
				
				Tab2.this.startActivity(intent);
			}
	    };
}