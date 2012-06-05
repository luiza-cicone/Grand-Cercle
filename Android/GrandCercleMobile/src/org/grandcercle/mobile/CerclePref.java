package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;

public class CerclePref extends Activity {
	private ArrayList<String> listCercle;
	private ArrayList<String> listCercleChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	
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
			ContainerData.parseEvent();
			finish();
		}
	};
	
	
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
			finish();
		}
	};
	
}
