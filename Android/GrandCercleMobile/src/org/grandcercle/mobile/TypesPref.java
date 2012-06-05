package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;

public class TypesPref extends Activity {
	private ArrayList<String> listTypes;
	private ArrayList<String> listTypesChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	
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
		View buttonCancel = this.findViewById(R.id.boutonAnnuler); 
		buttonCancel.setOnClickListener(CancelClicked);
	}
	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			for (int i=0; i<listCheckBox.size(); i++) {
				if (listCheckBox.get(i).isChecked()) {
					listTypesChecked.add(listTypes.get(i));
				}
			}
			dataBase.deleteAll("prefType");
			// on rentre dans la base de données la liste des préférences
			dataBase.addListPref("prefType","type",listTypesChecked); 
			// on parse les données en fonction des préférences
			ContainerData.parseEvent();
			finish();
		}
	};
	
	// Listener du bouton annuler
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
			finish();
		}
	};
	
}
