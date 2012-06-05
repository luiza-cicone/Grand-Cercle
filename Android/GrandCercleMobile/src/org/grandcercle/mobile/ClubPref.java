package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ScrollView;

public class ClubPref extends Activity {
	private ArrayList<String> listClub;
	private ArrayList<String> listClubChecked;
	private DataBase dataBase;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.club_pref);
		//dataBase = new DataBase(this);
		dataBase = DataBase.getInstance();
		listClubChecked = new ArrayList<String>();
		ArrayList<String> prefered = dataBase.getAllPref("prefClub","club");
		
        View scrollview =  findViewById(R.id.club);
        listClub = ContainerData.getListClubs();
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
			checkBox.setOnCheckedChangeListener(checkChanged);
			((ViewGroup) scrollview).addView(checkBox);
		}
		View buttonOk = this.findViewById(R.id.boutonOk);
		buttonOk.setOnClickListener(OKClicked);
		View buttonCancel = this.findViewById(R.id.boutonAnnuler); 
		buttonCancel.setOnClickListener(CancelClicked);
	}
	private OnCheckedChangeListener checkChanged = new OnCheckedChangeListener() {
		public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
			//Log.d("Cercle","buttonView"+buttonView);
			if (isChecked) {
				listClubChecked.add((String) buttonView.getText());
			} else {
				listClubChecked.remove(buttonView.getText());
			}
		}
	};
	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			dataBase.deleteAll("prefClub");
			dataBase.addListPref("prefClub","club",listClubChecked);
			finish();
		}
	};
	
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
			finish();
		}
	};
}