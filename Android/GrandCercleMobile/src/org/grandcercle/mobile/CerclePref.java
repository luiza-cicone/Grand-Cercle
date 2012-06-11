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
 * Classe représentant l'activité liée au choix de préférence de cercles
 */

public class CerclePref extends Activity {
	private ArrayList<String> listCercle;
	private ArrayList<String> listCercleChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		// Récupération du layout xml
		setContentView(R.layout.cercle_pref);
		// Création d'une instance de base de données
		dataBase = DataBase.getInstance();
		listCercleChecked = new ArrayList<String>();
		// Récupération de la liste des préférences associée aux cercles
		ArrayList<String> prefered = dataBase.getAllPref("prefCercle","cercle");
		
		// Récupération de l'id du cadre qui contient toutes les checkbox des préférences
        View linearLayout = findViewById(R.id.cercle);
        listCercle = ContainerData.getListCercles();
        // Création des checkbox associées à chaque cercle 
        listCheckBox = new ArrayList<CheckBox>();
		for (int i = 0; i < listCercle.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setPadding(80, 0, 0, 0);
			checkBox.setWidth(470);
			checkBox.setText(listCercle.get(i));
			// La checkbox est à true si le cercle considéré 
			// est contenu dans la liste des préférences
			if (prefered.contains(listCercle.get(i))) {
				checkBox.setChecked(true);
			// sinon elle n'est pas cochée
			} else {
				checkBox.setChecked(false);
			}
			listCheckBox.add(checkBox);
			((ViewGroup) linearLayout).addView(checkBox);
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
					listCercleChecked.add(listCercle.get(i));
				}
			}
			dataBase.deleteAll("prefCercle");
			// Mise à jour de la base de données avec les nouveaux cercles cochés.
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
