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

public class TypesPref extends Activity {
	private ArrayList<String> listTypes;
	private ArrayList<String> listTypesChecked;
	private DataBase dataBase;
	private ArrayList<CheckBox> listCheckBox;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.type_pref);
		//dataBase = new DataBase(this);
		dataBase = DataBase.getInstance();
		listTypesChecked = new ArrayList<String>();
		ArrayList<String> prefered = dataBase.getAllPref("prefType","type");
		
        View linearlayout =  findViewById(R.id.type);
        listTypes = ContainerData.getListTypes();
        listCheckBox = new ArrayList<CheckBox>();
        for (int i = 0; i < listTypes.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setPadding(80, 0, 0, 0);
			checkBox.setWidth(470);
			checkBox.setText(listTypes.get(i));
			
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
			dataBase.addListPref("prefType","type",listTypesChecked);
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
