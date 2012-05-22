package gcm.android.parser;

import java.util.ArrayList;

import javax.xml.parsers.SAXParserFactory;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

public class FeedPlayer extends Activity {
    /** Called when the activity is first created. */
	
	private ListView feedListView;
	private EditText recherche;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        recherche = (EditText)findViewById(R.id.recherche);
        ArrayList<Feed> feeds = ContainerData.getFeeds();
        for (Feed feed : feeds) {
			Log.i("FeedPlayer",feed.toString());
		}
        ListFeedAdapter lfa = new ListFeedAdapter(this, feeds);
        feedListView = ((ListView)findViewById(R.id.listFeed));
        ((ListView)findViewById(R.id.listFeed)).setAdapter(lfa);
        feedListView.setOnItemClickListener(clickListenerFeed);
    }
    
    private AdapterView.OnItemClickListener clickListenerFeed = new AdapterView.OnItemClickListener() {
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			setContentView(R.layout.content_view);

			((TextView)findViewById(R.id.title)).setText(((Feed)parent.getItemAtPosition(position)).getTitle());
			((TextView)findViewById(R.id.description)).setText(((Feed)parent.getItemAtPosition(position)).getDescription());
		
			
			 /* Get the notification manager  */
	         NotificationManager mNotManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

	         /* Create a notification */
	         String MyText = "Text inside: By Firstdroid.com";
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
	         mNotification.ledARGB = 40;   //Set led color

	         /* Sent Notification to notification bar */
	         mNotManager.notify(  0 , mNotification );
		}
    };

}



