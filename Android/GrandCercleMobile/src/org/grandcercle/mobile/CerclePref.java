package org.grandcercle.mobile;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;

public class CerclePref extends Activity {
	private ArrayList<String> listCercle;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.main);
        View linearLayout =  findViewById(R.id.cercle);

		for (int i = 0; i < listCercle.size(); i++) {
			CheckBox checkBox = new CheckBox(this);
			checkBox.setText(listCercle.get(i));
			//checkBox.setChecked(true);
			//if(checkBox.isChecked());
			((LinearLayout) linearLayout).addView(checkBox);
		}
		LinearLayout lin = new LinearLayout(this);
		lin.setOrientation(0);
		Button button = new Button(this);
		button.setText("OK");
	}
	
	
}
