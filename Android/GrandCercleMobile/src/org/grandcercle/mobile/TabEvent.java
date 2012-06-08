package org.grandcercle.mobile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class TabEvent extends Activity {
	
	private ListEventAdapter lea;
	private ArrayList<ImageView> images;
	private static HashMap<String,ArrayList<Event>> hashMapEvent;
	private static Set<String> setDates;
	private Button selectedDayMonthYearButton;
	private Button currentMonth;
	private ImageView prevMonth;
	private ImageView nextMonth;
	private GridView calendarView;
	private GridCellAdapter adapter;
	private Calendar _calendar;
	private int month, year;
	private DataBase dataBase;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.affichage_event);
	}
	
	// Méthode rappelé quand on revient sur l'onglet événements après avoir touché aux préférences
	public void onResume() {
		super.onResume();
		int color = 0xFFFFFFFF;
		GCM.changeTabHost(color);
		GCM.oldchild = 0;
		View view = findViewById(R.id.selectedDayMonthYear);
		dataBase = DataBase.getInstance();
		String prefered = dataBase.getPref("prefDesign","design");
		if (prefered.equals("Noir")) {
			color = 0xFF222222;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_gris));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_gris));
		} else if(prefered.equals("Ensimag")) {
			color = 0xFF96BE0F;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_ensimag));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_ensimag));
		} else if (prefered.equals("Phelma")) {
			color = 0xFFBE141E;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_phelma));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_phelma));
		} else if (prefered.equals("Ense3")) {
			color = 0xFF004B9B;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_ense3));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_ense3));
		} else if (prefered.equals("Pagora")) {
			color = 0xFFF09600;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_pagora));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_pagora));
		} else if (prefered.equals("GI")) {
			color = 0xFF0096D7;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_gi));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_gi));
		} else if (prefered.equals("CPP")) {
			color = 0xFFFFCD00;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_cpp));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_cpp));
		} else if (prefered.equals("Esisar")) {
			color = 0xFF96147D;
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_esisar));
			view = findViewById(R.id.currentMonth);
			view.setBackgroundDrawable(getResources().getDrawable(R.drawable.calendar_bar_esisar));
		}
		ArrayList<Event> listEvent = ContainerData.getEvent();
		ArrayList<Event> listEventOld = ContainerData.getEventOld();
		hashMapEvent = ContainerData.getEventInHashMap();
		
		if (listEvent == null && listEventOld == null) {
			Toast.makeText(TabEvent.this,"Pas d'événements !",Toast.LENGTH_LONG).show();
		} else if (listEvent == null) {
			Toast.makeText(TabEvent.this,"Pas d'événements à venir !",Toast.LENGTH_LONG).show();
		}
		
		
		// Attributs de la liste
		if (listEvent != null) {
			lea = new ListEventAdapter(this,listEvent);
			ListView feedListView = ((ListView)findViewById(R.id.listFeed));
			((ListView)findViewById(R.id.listFeed)).setAdapter(lea);
			feedListView.setOnItemClickListener(clickListenerFeed);
			
			// Attributs des 4 prochains evenements
			// tableau des date* a attribuer
			ArrayList<TextView> dates = new ArrayList<TextView>(4);
			dates.add(0,(TextView)findViewById(R.id.date0));
			dates.add(1,(TextView)findViewById(R.id.date1));
			dates.add(2,(TextView)findViewById(R.id.date2));
			dates.add(3,(TextView)findViewById(R.id.date3));
			// tableau des image* a attribuer
			images = new ArrayList<ImageView>(4);
			images.add(0,(ImageView)findViewById(R.id.image0));
			images.add(1,(ImageView)findViewById(R.id.image1));
			images.add(2,(ImageView)findViewById(R.id.image2));
			images.add(3,(ImageView)findViewById(R.id.image3));
			
			int eventNumber = 0;
			Event currentEvent;
			while (eventNumber < 4 && eventNumber < listEvent.size()) {
				currentEvent = listEvent.get(eventNumber);
				dates.get(eventNumber).setText(currentEvent.getDate());
				UrlImageViewHelper.setUrlDrawable(images.get(eventNumber),currentEvent.getImage(),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_THREE_DAYS);
				images.get(eventNumber).setOnClickListener(imageClicked);
				eventNumber ++;
			}
			
			
		}
		// Attributs du calendrier
		
		if (listEvent != null || listEventOld != null) {
			setDates = hashMapEvent.keySet();
		}
		
		_calendar = Calendar.getInstance(Locale.getDefault());
		month = _calendar.get(Calendar.MONTH) + 1;
		year = _calendar.get(Calendar.YEAR);

		selectedDayMonthYearButton = (Button) this.findViewById(R.id.selectedDayMonthYear);

		prevMonth = (ImageView) this.findViewById(R.id.prevMonth);
		prevMonth.setOnClickListener(prevORnextMonthClicked);

		currentMonth = (Button) this.findViewById(R.id.currentMonth);
		SimpleDateFormat s;
		s = new SimpleDateFormat("MMMM yyyy",Locale.FRANCE)	;	
		
		currentMonth.setText(s.format(_calendar.getTime()));
		nextMonth = (ImageView) this.findViewById(R.id.nextMonth);
		nextMonth.setOnClickListener(prevORnextMonthClicked);

		calendarView = (GridView) this.findViewById(R.id.calendar);
	
		
		adapter = new GridCellAdapter(getApplicationContext(), R.id.calendar_day_gridcell, month, year);
		adapter.notifyDataSetChanged();
		calendarView.setAdapter(adapter);
	}
	
	public static Set<String> getSetDates() {
		return setDates;
	}

	
	private void setGridCellAdapterToDate(int month, int year) {
		adapter = new GridCellAdapter(getApplicationContext(), R.id.calendar_day_gridcell, month, year);
		_calendar.set(year,month-1,1);
		SimpleDateFormat s;
		s = new SimpleDateFormat("MMMM yyyy",Locale.FRANCE)	;
		currentMonth.setText(s.format(_calendar.getTime()));
		adapter.notifyDataSetChanged();
		calendarView.setAdapter(adapter);
	}

	
	
	private View.OnClickListener prevORnextMonthClicked = new View.OnClickListener() {
		
		public void onClick(View v) {
			if (v == prevMonth) {
				if (month <= 1) {
					month = 12;
					year--;
				} else {
					month--;
				}
				setGridCellAdapterToDate(month, year);
			}
			if (v == nextMonth) {
				if (month > 11) {
					month = 1;
					year++;
				} else {
					month++;
				}
				setGridCellAdapterToDate(month, year);
			}
		}
	};
	
	private AdapterView.OnItemClickListener clickListenerFeed = new AdapterView.OnItemClickListener() {
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			// Ouverture nouvelle activity
			Intent intent = new Intent(TabEvent.this,PageEvent.class);
			// Passage des paramètres
			Bundle bundle = new Bundle();
			//Add the parameters to bundle as
			bundle.putString("titre",((Event)parent.getItemAtPosition(position)).getTitle());
			bundle.putString("description",((Event)parent.getItemAtPosition(position)).getDescription());
			bundle.putString("image",((Event)parent.getItemAtPosition(position)).getImage());
			bundle.putString("day",((Event)parent.getItemAtPosition(position)).getDay());
			bundle.putString("date",((Event)parent.getItemAtPosition(position)).getDate());
			bundle.putString("eventDate",((Event)parent.getItemAtPosition(position)).getEventDate());
			bundle.putString("time",((Event)parent.getItemAtPosition(position)).getTime());
			bundle.putString("lieu",((Event)parent.getItemAtPosition(position)).getLieu());
			bundle.putString("logo",((Event)parent.getItemAtPosition(position)).getLogo());
			bundle.putString("group",((Event)parent.getItemAtPosition(position)).getGroup());
			//Ajout du Bundle
			intent.putExtras(bundle);
			
			TabEvent.this.startActivity(intent);
		}
	};
	
	private View.OnClickListener imageClicked = new View.OnClickListener() {
		public void onClick(View v) {
			// Ouverture nouvelle activity
			Intent intent = new Intent(TabEvent.this,PageEvent.class);
			// Passage des paramètres
			Bundle bundle = new Bundle();
			//Add the parameters to bundle as
			bundle.putString("titre",lea.getItem(images.indexOf(v)).getTitle());
			bundle.putString("description",lea.getItem(images.indexOf(v)).getDescription());
			bundle.putString("image",lea.getItem(images.indexOf(v)).getImage());
			bundle.putString("day",lea.getItem(images.indexOf(v)).getDay());
			bundle.putString("date",lea.getItem(images.indexOf(v)).getDate());
			bundle.putString("eventDate",lea.getItem(images.indexOf(v)).getEventDate());
			bundle.putString("time",lea.getItem(images.indexOf(v)).getTime());
			bundle.putString("lieu",lea.getItem(images.indexOf(v)).getLieu());
			bundle.putString("logo",lea.getItem(images.indexOf(v)).getLogo());
			bundle.putString("group",lea.getItem(images.indexOf(v)).getGroup());
			//Ajout du Bundle
			intent.putExtras(bundle);
			
			TabEvent.this.startActivity(intent);
		}
	};
	
	
	
	
	
	public class GridCellAdapter extends BaseAdapter {
		private final Context _context;

		private final List<String> list;
		private static final int DAY_OFFSET = 1;
		private final String[] weekdays = new String[]{"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
		private final String[] months = {"Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Decembre"};
		private final int[] daysOfMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
		private final int month, year;
		private int daysInMonth, prevMonthDays;
		private int currentDayOfMonth;
		private int currentMonth;
		private int currentYear;
		private int currentWeekDay;
		private Button gridcell;	
		private Set<String> dateEvents;
		private String currentDayNumber;
		private String currentMonthNumber;
		private String currentYearNumber;
		private String currentDate; // dd-MM-yyyy

		// Jour du mois courant
		public GridCellAdapter(Context context, int textViewResourceId, int month, int year) {
			super();
			this._context = context;
			this.list = new ArrayList<String>();
			this.month = month;
			this.year = year;
			
			this.dateEvents = getSetDates();
			
			// nouvelle instance du calendrier
			Calendar calendar = Calendar.getInstance();
			setCurrentDayOfMonth(calendar.get(Calendar.DAY_OF_MONTH));
			setCurrentMonth(calendar.get(Calendar.MONTH));
			setCurrentYear(calendar.get(Calendar.YEAR));
			setCurrentWeekDay(calendar.get(Calendar.DAY_OF_WEEK));
			
			currentDayNumber = String.valueOf(getCurrentDayOfMonth());
			if (currentDayNumber.length() == 1) {
				currentDayNumber = "0"+currentDayNumber;
			}
			currentMonthNumber = String.valueOf(getCurrentMonth()+1);
			if (currentMonthNumber.length() == 1) {
				currentMonthNumber = "0"+currentMonthNumber;
			}
			currentYearNumber = String.valueOf(getCurrentYear());
			if (currentYearNumber.length() == 1) {
				currentYearNumber = "0"+currentYearNumber;
			}
			currentDate = currentDayNumber+"-"+currentMonthNumber+"-"+currentYearNumber;

			// Affichage du mois
			printMonth(month, year);	
		}
		
		private String getMonthAsString(int i) {
			return months[i];
		}

		private int getNumberOfDaysOfMonth(int i) {
			return daysOfMonth[i];
		}

		public String getItem(int position) {
			return list.get(position);
		}

		
		public int getCount() {
			return list.size();
		}
		
		public String getMonthNumberAsString(String m) {
			if (m.equalsIgnoreCase("Janvier")) {
				return "01";
			}
			if (m.equalsIgnoreCase("Fevrier")) {
				return "02";
			}
			if (m.equalsIgnoreCase("Mars")) {
				return "03";
			}
			if (m.equalsIgnoreCase("Avril")) {
				return "04";
			}
			if (m.equalsIgnoreCase("Mai")) {
				return "05";
			}
			if (m.equalsIgnoreCase("Juin")) {
				return "06";
			}
			if (m.equalsIgnoreCase("Juillet")) {
				return "07";
			}
			if (m.equalsIgnoreCase("Août")) {
				return "08";
			}
			if (m.equalsIgnoreCase("Septembre")) {
				return "09";
			}
			if (m.equalsIgnoreCase("Octobre")) {
				return "10";
			}
			if (m.equalsIgnoreCase("Novembre")) {
				return "11";
			}
			return "12";
			
		}

		/**
		 * Prints Month
		 * 
		 * @param mm
		 * @param yy
		 */
		private void printMonth(int mm, int yy) {
			// The number of days to leave blank at
			// the start of this month.
			int trailingSpaces = 0;
			int daysInPrevMonth = 0;
			int prevMonth = 0;
			int prevYear = 0;
			int nextMonth = 0;
			int nextYear = 0;
			boolean todayInActualMonth = false;
			boolean cour = false;

			int currentMonth = mm - 1;
			
			// date courante sous le format "dd-MM-yyyy"
			String today = this.getCurrentDate();
			
			String monthNumber = String.valueOf(mm);
			if (monthNumber.length() == 1) {
				monthNumber = "0"+monthNumber;
			}
			String yearNumber = String.valueOf(yy);
			
			String month = monthNumber+"-"+yearNumber;
			if (today.contains(month)) {
				todayInActualMonth = true;
			}
			
			daysInMonth = getNumberOfDaysOfMonth(currentMonth);

			

			// Gregorian Calendar : MINUS 1, set to FIRST OF MONTH
			GregorianCalendar cal = new GregorianCalendar(yy, currentMonth, 1);
			

			if (currentMonth == 11) {
				prevMonth = currentMonth - 1;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
				nextMonth = 0;
				prevYear = yy;
				nextYear = yy + 1;
			} else if (currentMonth == 0) {
				prevMonth = 11;
				prevYear = yy - 1;
				nextYear = yy;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
				nextMonth = 1;
			} else {
				prevMonth = currentMonth - 1;
				nextMonth = currentMonth + 1;
				nextYear = yy;
				prevYear = yy;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
			}

			// Compute how much to leave before before the first day of the
			// month.
			// getDay() returns 0 for Sunday.
			int currentWeekDay = cal.get(Calendar.DAY_OF_WEEK) - 1;
			trailingSpaces = currentWeekDay;
			
			if (cal.isLeapYear(cal.get(Calendar.YEAR)) && mm == 1) {
				++daysInMonth;
			}

			// Trailing Month days
			for (int i = 0; i < trailingSpaces; i++) {
				list.add(String.valueOf((daysInPrevMonth - trailingSpaces + DAY_OFFSET) + i) + "-GREY" + "-" + getMonthAsString(prevMonth) + "-" + prevYear);	
			}

			// Current Month Days
			for (int i = 1; i <= daysInMonth; i++) {
				String date = getDateDay(i,mm,yy);
				if (i == getCurrentDayOfMonth() && todayInActualMonth) {
					cour = true;
				}
				
				if (dateEvents != null) {
					if (cour && dateEvents.contains(date)) {
						list.add(String.valueOf(i) + "-RED" + "-" + getMonthAsString(currentMonth) + "-" + yy);
						cour = false;
					} else if (cour) {
						list.add(String.valueOf(i) + "-BLUE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
						cour = false;
					} else if (dateEvents.contains(date)) {
						list.add(String.valueOf(i) + "-ORANGE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
					} else {
						list.add(String.valueOf(i) + "-WHITE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
					}
				} else {
					if (cour) {
						list.add(String.valueOf(i) + "-BLUE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
						cour = false;
					} else {
						list.add(String.valueOf(i) + "-WHITE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
					}
				}
			}
			// Leading Month days
			for (int i = 0; i < list.size() % 7; i++) {
				list.add(String.valueOf(i + 1) + "-GREY" + "-" + getMonthAsString(nextMonth) + "-" + nextYear);
			}
			
		}
		
		public String getDateDay(int d, int m, int y) {
			String dayNumber = String.valueOf(d);
			if (dayNumber.length() == 1) {
				dayNumber = "0"+dayNumber;
			}
			String monthNumber = String.valueOf(m);
			if (monthNumber.length() == 1) {
				monthNumber = "0"+monthNumber;
			}
			String yearNumber = String.valueOf(y);
			return dayNumber+"-"+monthNumber+"-"+yearNumber;
		}

		public long getItemId(int position) {
			return position;
		}

		
		public View getView(int position, View convertView, ViewGroup parent) {
			View row = convertView;
			if (row == null) {
				LayoutInflater inflater = (LayoutInflater) _context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				row = inflater.inflate(R.layout.calendar_day_gridcell, parent, false);
			}

			// Get a reference to the Day gridcell
			gridcell = (Button) row.findViewById(R.id.calendar_day_gridcell);
			gridcell.setOnClickListener(dayClicked);

			// ACCOUNT FOR SPACING

			String[] day_color = list.get(position).split("-");
			String theday = day_color[0];
			String themonth = day_color[2];
			String theyear = day_color[3];

			// Set the Day GridCell
			gridcell.setText(theday);
			gridcell.setTag(theday + "-" + themonth + "-" + theyear);

			
			if (day_color[1].equals("GREY")) {
				gridcell.setTextColor(Color.LTGRAY);
			}
			if (day_color[1].equals("WHITE")) {
				gridcell.setTextColor(Color.WHITE);
			}
			if (day_color[1].equals("BLUE")) {
				gridcell.setTextColor(getResources().getColor(R.color.static_text_color));
			}
			if (day_color[1].equals("ORANGE")) {
				gridcell.setTextColor(Color.rgb(255,140,0));
			}
			if (day_color[1].equals("RED")) {
				gridcell.setTextColor(Color.RED);
			}
			return row;
		}
		
		
		private View.OnClickListener dayClicked = new View.OnClickListener() {
			public void onClick(View view) {
				String dayMonthYear = (String)view.getTag();
				int index0 = dayMonthYear.indexOf("-");
				String sub = dayMonthYear.substring(index0+1);
				int index1 = sub.indexOf("-");
				String day = dayMonthYear.substring(0,index0);
				String month = dayMonthYear.substring(index0+1,index0+index1+1);
				String year = dayMonthYear.substring(index0+index1+2,dayMonthYear.length());
				selectedDayMonthYearButton.setText(dayMonthYear);
				
				if (day.length() == 1) {
					day = "0"+day;
				}
				
				if (month.equalsIgnoreCase("Janvier")) {
					month = "01";
				}
				if (month.equalsIgnoreCase("Fevrier")) {
					month = "02";
				}
				if (month.equalsIgnoreCase("Mars")) {
					month = "03";
				}
				if (month.equalsIgnoreCase("Avril")) {
					month = "04";
				}
				if (month.equalsIgnoreCase("Mai")) {
					month = "05";
				}
				if (month.equalsIgnoreCase("Juin")) {
					month = "06";
				}
				if (month.equalsIgnoreCase("Juillet")) {
					month = "07";
				}
				if (month.equalsIgnoreCase("Août")) {
					month = "08";
				}
				if (month.equalsIgnoreCase("Septembre")) {
					month = "09";
				}
				if (month.equalsIgnoreCase("Octobre")) {
					month = "10";
				}
				if (month.equalsIgnoreCase("Novembre")) {
					month = "11";
				}
				if (month.equalsIgnoreCase("Decembre")) {
					month = "12";
				}
				
				String date = day+"-"+month+"-"+year;
				Toast t;
				if (dateEvents != null) {
					if (hashMapEvent.containsKey(date)) {
						// affichage de la liste des événements
						ArrayList<Event> listEvCal = hashMapEvent.get(date);
						ListEventAdapter listCalAdapter = new ListEventAdapter(view.getContext(),listEvCal);
						// On récupère la vue contenant les événements
						ListView feedListViewCal = ((ListView)findViewById(R.id.listFeedDay));
						((ListView)findViewById(R.id.listFeedDay)).setAdapter(listCalAdapter);
						feedListViewCal.setOnItemClickListener(clickListenerFeed);
						if (listEvCal.size() > 1) {
							t = Toast.makeText(TabEvent.this, listEvCal.size() + " événements pour le jour sélectionné", Toast.LENGTH_SHORT);
						} else {
							t = Toast.makeText(TabEvent.this, "1 événement pour le jour séléctionné", Toast.LENGTH_SHORT);
						}
					} else {
						t = Toast.makeText(TabEvent.this, "Aucun événement pour le jour sélectionné", Toast.LENGTH_SHORT);
						((ListView)findViewById(R.id.listFeedDay)).setAdapter(null);
					}
				} else {
					t = Toast.makeText(TabEvent.this, "Aucun événement pour le jour sélectionné", Toast.LENGTH_SHORT);
				}
				t.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, 170);
				t.show();
			}
		};

		public int getCurrentDayOfMonth() {
			return currentDayOfMonth;
		}

		private void setCurrentDayOfMonth(int currentDayOfMonth) {
			this.currentDayOfMonth = currentDayOfMonth;
		}
		
		public int getCurrentMonth() {
			return currentMonth;
		}

		private void setCurrentMonth(int currentMonth) {
			this.currentMonth = currentMonth;
		}
		
		public int getCurrentYear() {
			return currentYear;
		}

		private void setCurrentYear(int currentYear) {
			this.currentYear = currentYear;
		}
		
		public void setCurrentWeekDay(int currentWeekDay) {
			this.currentWeekDay = currentWeekDay;
		}
		
		public int getCurrentWeekDay() {
			return currentWeekDay;
		}
		
		public String getCurrentDate() {
			return currentDate;
		}
	}
}