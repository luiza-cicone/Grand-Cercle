package gcm.android.parser;

import java.util.ArrayList;

import android.app.Activity;
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
		}
    };

}



