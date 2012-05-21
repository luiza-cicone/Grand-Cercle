package gcm.android.parser;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;

public class FeedPlayer extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        ArrayList<Feed> feeds = ContainerData.getFeeds();
        for (Feed feed : feeds) {
			Log.e("FeedPlayer",feed.toString());
		}
        ListFeedAdapter lfa = new ListFeedAdapter(this, feeds);
        ((ListView)findViewById(R.id.listFeed)).setAdapter(lfa);
        
    }
}
