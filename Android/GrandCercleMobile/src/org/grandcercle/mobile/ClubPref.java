package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;


public class ClubPref extends Activity {
	private ArrayList<String> listClub;
	private ArrayList<String> listClubChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.club_pref);
		//dataBase = new DataBase(this);
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
			
			if (dataBase.getNumRun() == 1) {
				checkBox.setChecked(true);
			} else if (prefered.contains(listClub.get(i))) {
				checkBox.setChecked(true);
			} else {
				checkBox.setChecked(false);
			}
			listCheckBox.add(checkBox);
			((ViewGroup) scrollview).addView(checkBox);
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
					listClubChecked.add(listClub.get(i));
				}
			}
			dataBase.addListPref("prefClub","club",listClubChecked);
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
