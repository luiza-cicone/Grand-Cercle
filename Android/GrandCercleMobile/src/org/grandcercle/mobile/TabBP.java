package org.grandcercle.mobile;




import java.util.Calendar;
import java.util.Locale;

import org.grandcercle.mobile.R;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;


public class TabBP extends Activity {
	
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.affichage_bons_plans);
        ArrayList<BP> listBP = ContainerData.getlistBP();
        
        ListBPAdapter lna = new ListBPAdapter(this,listBP);
        ListView feedListView = ((ListView)findViewById(R.id.listFeed));
        ((ListView)findViewById(R.id.listFeed)).setAdapter(lna);
        //feedListView.setOnItemClickListener(clickListenerFeed);
		
	 }

	
}