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

public class CerclePref extends Activity {
	private ArrayList<String> listCercle;
	private ArrayList<String> listCercleChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.cercle_pref);

		dataBase = DataBase.getInstance();
		listCercleChecked = new ArrayList<String>();
		ArrayList<String> prefered = dataBase.getAllPref("prefCercle","cercle");
		
        View linearLayout = findViewById(R.id.cercle);
        listCercle = ContainerData.getListCercles();
        listCheckBox = new ArrayList<CheckBox>();
		for (int i = 0; i < listCercle.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setPadding(80, 0, 0, 0);
			checkBox.setWidth(470);
			checkBox.setText(listCercle.get(i));
			
			if (prefered.contains(listCercle.get(i))) {
				checkBox.setChecked(true);
			} else {
				checkBox.setChecked(false);
			}
			listCheckBox.add(checkBox);
			((ViewGroup) linearLayout).addView(checkBox);
		}
		View buttonOk = this.findViewById(R.id.boutonOk);
		buttonOk.setOnClickListener(OKClicked);
		View buttonCancel = this.findViewById(R.id.boutonAnnuler); 
		buttonCancel.setOnClickListener(CancelClicked);
	}
	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			for (int i=0; i<listCheckBox.size(); i++) {
				if (listCheckBox.get(i).isChecked()) {
					listCercleChecked.add(listCercle.get(i));
				}
			}
			dataBase.deleteAll("prefCercle");
			dataBase.addListPref("prefCercle","cercle",listCercleChecked);
	
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
	
	
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
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
