package org.grandcercle.mobile;

import java.util.ArrayList;
import java.util.Iterator;



import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.CheckBox;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

public class DesignPref extends Activity {
	private DataBase dataBase;
	private ArrayList<String> colors;
	private Integer[] position;
	private String ColorChecked;
	private ArrayList<RadioButton> listRadioButton;
	private ProgressBar progressBarParse;
	
	public void onCreate(Bundle saveInstanceState) {
		super.onCreate(saveInstanceState);
		setContentView(R.layout.design_pref);
		dataBase = DataBase.getInstance();
		ColorChecked = new String();
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
		} else if (prefered.equals("Papet")) {
			radiogroup.check(R.id.Papet);
		} else if (prefered.equals("GI")) {
			radiogroup.check(R.id.GI);
		} else if (prefered.equals("CPP")) {
			radiogroup.check(R.id.CPP);
		} else if (prefered.equals("Esisar")) {
			radiogroup.check(R.id.Esisar);
		}
		colors = ContainerData.getListColors();
		position = new Integer[colors.size()];
		position[0]= R.id.Ensimag;
		position[1]= R.id.Phelma;
		position[2]= R.id.Ense3;
		
		
		
		//RadioGroup rGroup = (RadioGroup)findViewById(R.id.radiogroup);
		// This will get the radiobutton in the radiogroup that is checked
		//RadioButton checkedRadioButton = (RadioButton)rGroup.findViewById(rGroup.getCheckedRadioButtonId());

        
        listRadioButton = new ArrayList<RadioButton>();
        	   
        	/*RadioButton radiobutton = (RadioButton) findViewById(R.id.Ensimag);
			if (prefered.contains(colors.get(0))) {
				radiobutton.setChecked(true);
			} else {
				radiobutton.setChecked(false);
			}
			listRadioButton.add(radiobutton);
			((ViewGroup) radiogroup).addView(radiobutton);
			
			radiobutton = (RadioButton) findViewById(R.id.Phelma);
			if (prefered.contains(colors.get(1))) {
				radiobutton.setChecked(true);
			} else {
				radiobutton.setChecked(false);
			}
			listRadioButton.add(radiobutton);
			((ViewGroup) radiogroup).addView(radiobutton);
			
			radiobutton = (RadioButton) findViewById(R.id.Ense3);
			if (prefered.contains(colors.get(2))) {
				radiobutton.setChecked(true);
			} else {
				radiobutton.setChecked(false);
			}
			listRadioButton.add(radiobutton);
			((ViewGroup) radiogroup).addView(radiobutton);*/
        View buttonOk = this.findViewById(R.id.boutonOk);
		buttonOk.setOnClickListener(OKClicked);
		View buttonCancel = this.findViewById(R.id.boutonAnnuler); 
		buttonCancel.setOnClickListener(CancelClicked);
	}
	
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
			dataBase.addPref("prefDesign","design",ColorChecked);
			LayoutInflater inflater = getLayoutInflater();
			View layout = inflater.inflate(R.layout.toast_parse, (ViewGroup) findViewById(R.id.toast_layout_root));
			Toast toast = new Toast(getApplicationContext());
			toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
			toast.setDuration(Toast.LENGTH_SHORT);
			toast.setView(layout);
			toast.show();
			progressBarParse = (ProgressBar)findViewById(R.id.progressBarParse);
			new ParsingProcessing().execute((Void)null);
			finish();
		}
	};
	
	
	private OnClickListener CancelClicked = new OnClickListener() {
		public void onClick(View v) {
			finish();
		}
	};
	
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