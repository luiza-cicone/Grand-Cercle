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
 * Classe représentant l'activité liée au choix de préférence de types
 */

public class TypesPref extends Activity {
	private ArrayList<String> listTypes;
	private ArrayList<String> listTypesChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.type_pref);
		
		// récupération de l'instance de l'unique base de données
		dataBase = DataBase.getInstance();
		listTypesChecked = new ArrayList<String>();
		// récupération de la liste de préférence
		ArrayList<String> prefered = dataBase.getAllPref("prefType","type");
		
		// récupération du layout associé aux types
        View linearlayout =  findViewById(R.id.type);
        
        listTypes = ContainerData.getListTypes();
        listCheckBox = new ArrayList<CheckBox>();
        for (int i = 0; i < listTypes.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setPadding(80, 0, 0, 0);
			checkBox.setWidth(470);
			checkBox.setText(listTypes.get(i));
			// comparaison entre la liste complète des types et
			// la liste des préférences
			if (prefered.contains(listTypes.get(i))) {
				checkBox.setChecked(true);
			} else {
				checkBox.setChecked(false);
			}
			listCheckBox.add(checkBox);
			((ViewGroup) linearlayout).addView(checkBox);
		}
		View buttonOk = this.findViewById(R.id.boutonOk);
		buttonOk.setOnClickListener(OKClicked);
	}
	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			// Construction de la nouvelle liste des préférences.
			for (int i=0; i<listCheckBox.size(); i++) {
				if (listCheckBox.get(i).isChecked()) {
					listTypesChecked.add(listTypes.get(i));
				}
			}
			dataBase.deleteAll("prefType");
			// Mise à jour de la base de donnée avec la nouvelle liste des préférences
			dataBase.addListPref("prefType","type",listTypesChecked); 
			dataBase.addListPref("prefType","type",listTypesChecked);
			LayoutInflater inflater = getLayoutInflater();
			View layout = inflater.inflate(R.layout.toast_parse, (ViewGroup) findViewById(R.id.toast_layout_root));
			Toast toast = new Toast(getApplicationContext());
			toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
			toast.setDuration(Toast.LENGTH_SHORT);
			toast.setView(layout);
			toast.show();
			progressBarParse = (ProgressBar)findViewById(R.id.progressBarParse);
			new ParsingProcessing().execute((Void)null);
			// Fin de l'activité
			finish();
		}
	};
	
	// classe privée qui permet de reparser les données en provenance du site
	// en prenant en compte les préférences de l'utilisateur
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
