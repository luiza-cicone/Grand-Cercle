package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ProgressBar;
import android.widget.Toast;


public class ClubPref extends Activity {
	private ArrayList<String> listClub;
	private ArrayList<String> listClubChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.club_pref);
		dataBase = DataBase.getInstance();
		listClubChecked = new ArrayList<String>();
		ArrayList<String> prefered = dataBase.getAllPref("prefClub","club");
		
        View scrollview =  findViewById(R.id.club);
        listClub = ContainerData.getListClubs();
        listCheckBox = new ArrayList<CheckBox>();
        for (int i = 0; i < listClub.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setPadding(80, 0, 0, 0);
			checkBox.setWidth(470);
			checkBox.setText(listClub.get(i));
			
			if (prefered.contains(listClub.get(i))) {
				checkBox.setChecked(true);
			} else {
				checkBox.setChecked(false);
			}
			listCheckBox.add(checkBox);
			((ViewGroup) scrollview).addView(checkBox);
		}
		View buttonOk = this.findViewById(R.id.boutonOk);
		buttonOk.setOnClickListener(OKClicked);
	}

	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			for (int i=0; i<listCheckBox.size(); i++) {
				if (listCheckBox.get(i).isChecked()) {
					listClubChecked.add(listClub.get(i));
				}
			}
			dataBase.deleteAll("prefClub");
			dataBase.addListPref("prefClub","club",listClubChecked);
			LayoutInflater inflater = getLayoutInflater();
			View layout = inflater.inflate(R.layout.toast_parse, (ViewGroup) findViewById(R.id.toast_layout_root));
			Toast toast = new Toast(getApplicationContext());
			toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
			toast.setDuration(Toast.LENGTH_SHORT);
			toast.setView(layout);
			toast.show();
			progressBarParse = (ProgressBar)findViewById(R.id.progressBarParse);
			new ParsingProcessing().execute((Void)null);
			finish();
		}
	};
	
	private class ParsingProcessing extends AsyncTask<Void,Integer,Void> {
		
		@Override
	    protected Void doInBackground(Void... params) {
			ContainerData.parseEvent();
			return null;
	    }

		@Override
	    protected void onProgressUpdate(Integer... progress) {
	        progressBarParse.setProgress(progress[0]);
	    }

		@Override
	    protected void onPostExecute(Void result) {}
	}
}
