package org.grandcercle.mobile;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.ProgressBar;

public class GCMLaunching extends Activity {
	
	private ProgressBar progressBar;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.loading);

		progressBar = (ProgressBar)findViewById(R.id.progressBar);
		progressBar.setProgress(0);
		new LoadingPage().execute((Void)null);
	}
	
	private class LoadingPage extends AsyncTask<Void,Integer,Void> {
		
		@Override
	    protected Void doInBackground(Void... params) {
			if (this.isConnected()) {
				ContainerData.parseFiles(getApplicationContext());
			} else {
				ContainerData.loadDatas();
			}
			return null;
	    }

		@Override
	    protected void onProgressUpdate(Integer... progress) {
	        progressBar.setProgress(progress[0]);
	    }

		@Override
	    protected void onPostExecute(Void result) {
	        Intent intent = new Intent(GCMLaunching.this,GCM.class);
	        GCMLaunching.this.startActivity(intent);
	    }
		
		public boolean isConnected() {
		    boolean connected = false;

		    ConnectivityManager cm = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
		    if (cm != null) {
		        NetworkInfo[] netInfo = cm.getAllNetworkInfo();
		        for (NetworkInfo ni : netInfo) {
		            if ((ni.getTypeName().equalsIgnoreCase("WIFI")
		                    || ni.getTypeName().equalsIgnoreCase("MOBILE"))
		                    && ni.isConnected() && ni.isAvailable()) {
		                connected = true;
		            }
		        }
		    }
		    return connected;
		}
	}


}
