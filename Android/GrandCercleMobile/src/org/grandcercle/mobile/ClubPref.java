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

/*
 * Classe représentant l'activité liée au choix de préférence de clubs
 */

public class ClubPref extends Activity {
	private ArrayList<String> listClub;
	private ArrayList<String> listClubChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		// Récupération du layout xml
		setContentView(R.layout.club_pref);
		// Création d'une instance de base de données
		dataBase = DataBase.getInstance();
		listClubChecked = new ArrayList<String>();
		// Récupération de la liste des préférences associée aux cercles
		ArrayList<String> prefered = dataBase.getAllPref("prefClub","club");
		// On récupère une scroll view dû au nombre important de 
		// clubs et associations
        View scrollview =  findViewById(R.id.club);
        listClub = ContainerData.getListClubs();
        listCheckBox = new ArrayList<CheckBox>();
        // Construction des checkboxs associées à chaque club
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
		// Listener sur le bouton ok
		buttonOk.setOnClickListener(OKClicked);
	}

	// Listener privé lançant toutes les actions nécessaires
	// après la validation des préférences.
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			// Mise à jour de la liste des checkboxes cochées.
			for (int i=0; i<listCheckBox.size(); i++) {
				if (listCheckBox.get(i).isChecked()) {
					listClubChecked.add(listClub.get(i));
				}
			}
			dataBase.deleteAll("prefClub");
			// Mise à jour de la base de données avec les nouveaux cercles cochés.
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
