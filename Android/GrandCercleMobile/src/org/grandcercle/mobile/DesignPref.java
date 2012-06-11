package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioGroup;

/*
 * Classe qui gère le menu des préférences du design
 */

public class DesignPref extends Activity {
	private DataBase dataBase;
	private ArrayList<String> colors;
	private Integer[] position;
	private String ColorChecked;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		// Récupération du layout xml
		setContentView(R.layout.design_pref);
		// Création d'une instance de base de données
		dataBase = DataBase.getInstance();
		ColorChecked = new String();
		// Récupération du design courant
		String prefered = dataBase.getPref("prefDesign","design");
		RadioGroup radiogroup = (RadioGroup) findViewById(R.id.design);
		if (prefered.equals("Noir")) {
			radiogroup.check(R.id.Noir);
		} else if(prefered.equals("Ensimag")) {
			radiogroup.check(R.id.Ensimag);
		} else if (prefered.equals("Phelma")) {
			radiogroup.check(R.id.Phelma);
		} else if (prefered.equals("Ense3")) {
			radiogroup.check(R.id.Ense3);
		} else if (prefered.equals("Pagora")) {
			radiogroup.check(R.id.Pagora);
		} else if (prefered.equals("GI")) {
			radiogroup.check(R.id.GI);
		} else if (prefered.equals("CPP")) {
			radiogroup.check(R.id.CPP);
		} else if (prefered.equals("Esisar")) {
			radiogroup.check(R.id.Esisar);
		}
		colors = ContainerData.getListColors();
		position = new Integer[colors.size()];
		position[0] = R.id.Noir;
		position[1]= R.id.Ensimag;
		position[2]= R.id.Phelma;
		position[3]= R.id.Ense3;
		position[4]= R.id.Pagora;
		position[5]= R.id.GI;
		position[6]= R.id.CPP;
		position[7]= R.id.Esisar;
        
        View buttonOk = this.findViewById(R.id.boutonOk);
     // Listener sur le bouton ok
		buttonOk.setOnClickListener(OKClicked);
	}
	
	// Listener privé lançant toutes les actions nécessaires
	// après la validation des préférences.
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			View radiogroup = findViewById(R.id.design);
			int k = ((RadioGroup) radiogroup).getCheckedRadioButtonId();
			int i = 0;
			while (position[i]!=k) {
				i++;
			}
			ColorChecked =colors.get(i);
			dataBase.deleteAll("prefDesign");
			// Mise à jour de la base de données avec la nouvelle couleur selectionnée
			dataBase.addPref("prefDesign","design",ColorChecked);
			finish();
		}
	};
}