package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.LinearLayout;

public class CerclePref extends Activity {
	private ArrayList<String> listCercle;
	private ArrayList<String> listCercleChecked;
	private DataBase dataBase;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.main);
		dataBase = new DataBase(this);
		
		ArrayList<String> prefered = dataBase.getAllPref("prefCercle");
		
        View linearLayout =  findViewById(R.id.cercle);
        listCercle = ContainerData.getListCercles();
		for (int i = 0; i < listCercle.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setText(listCercle.get(i));
			if (prefered.contains(listCercle.get(i))) {
				checkBox.setChecked(true);
			} else {
				checkBox.setChecked(false);
			}
			checkBox.setOnCheckedChangeListener(checkChanged);
			((LinearLayout) linearLayout).addView(checkBox);
		}
		LinearLayout lin = new LinearLayout(this);
		lin.setOrientation(0); // horizontal
		Button buttonOK = new Button(this);
		buttonOK.setText("OK");
		buttonOK.setOnClickListener(OKClicked);
		Button buttonCancel = new Button(this);
		buttonCancel.setText("Annuler");
		buttonCancel.setOnClickListener(CancelClicked);
		
		lin.addView(buttonOK);
		lin.addView(buttonCancel);
	}
	
	private OnCheckedChangeListener checkChanged = new OnCheckedChangeListener() {
		public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
			if (isChecked) {
				listCercleChecked.add((String) buttonView.getText());
			} else {
				listCercleChecked.remove(buttonView.getText());
			}
		}
	};
	
	private OnClickListener OKClicked = new OnClickListener() {
		public void onClick(View v) {
			dataBase.deleteAll("prefCercle");
			dataBase.addListPref("prefCercle","cercle",listCercleChecked);
			finish();
		}
	};
	
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
			finish();
		}
	};
	
}
