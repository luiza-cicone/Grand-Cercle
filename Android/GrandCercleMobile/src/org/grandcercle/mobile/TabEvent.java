package org.grandcercle.mobile;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class TabEvent extends Activity {
	
	private ListEventAdapter lea;
	private ArrayList<ImageView> images;
	private HashMap<String,ArrayList<Event>> hashMapEvent;
	private static Set<String> setDates;
	
	private static final String tag = "SimpleCalendarViewActivity";
	private ImageView calendarToJournalButton;
	private Button selectedDayMonthYearButton;
	private Button currentMonth;
	private ImageView prevMonth;
	private ImageView nextMonth;
	private GridView calendarView;
	private GridCellAdapter adapter;
	private Calendar _calendar;
	private int month, year;
	private static boolean ev=false;

	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.affichage_event);

		
		ArrayList<Event> listEvent = ContainerData.getEvent();
		
		// Attributs de la liste
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
		
		// Attributs du calendrier
		hashMapEvent = ContainerData.getEventInHashMap();
		setDates = hashMapEvent.keySet();
		
		_calendar = Calendar.getInstance(Locale.getDefault());
		month = _calendar.get(Calendar.MONTH) + 1;
		year = _calendar.get(Calendar.YEAR);
		Log.d(tag, "Calendar Instance:= " + "Month: " + month + " " + "Year: " + year);

		selectedDayMonthYearButton = (Button) this.findViewById(R.id.selectedDayMonthYear);
		//selectedDayMonthYearButton.setText("");

		prevMonth = (ImageView) this.findViewById(R.id.prevMonth);
		prevMonth.setOnClickListener(prevORnextMonthClicked);

		currentMonth = (Button) this.findViewById(R.id.currentMonth);
		SimpleDateFormat s;
		s = new SimpleDateFormat("MMMM yyyy",Locale.FRANCE)	;	
		
		currentMonth.setText(s.format(_calendar.getTime()));

		nextMonth = (ImageView) this.findViewById(R.id.nextMonth);
		nextMonth.setOnClickListener(prevORnextMonthClicked);

		calendarView = (GridView) this.findViewById(R.id.calendar);

		// Initialised
		adapter = new GridCellAdapter(getApplicationContext(), R.id.calendar_day_gridcell, month, year);
		adapter.notifyDataSetChanged();
		calendarView.setAdapter(adapter);
		if (!ev) {
			ListView feedListViewDay = ((ListView)findViewById(R.id.listFeedDay));
			((ListView)findViewById(R.id.listFeedDay)).setAdapter(lea);
			feedListViewDay.setOnItemClickListener(clickListenerFeed);
		}
		
	}
	
	public static Set<String> getSetDates() {
		return setDates;
	}

	
	private void setGridCellAdapterToDate(int month, int year)
	{
		adapter = new GridCellAdapter(getApplicationContext(), R.id.calendar_day_gridcell, month, year);
		_calendar.set(year, month - 1, _calendar.get(Calendar.DAY_OF_MONTH));
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
				//Log.d(tag, "Setting Prev Month in GridCellAdapter: " + "Month: " + month + " Year: " + year);
				setGridCellAdapterToDate(month, year);
			}
			if (v == nextMonth) {
				if (month > 11) {
					month = 1;
					year++;
				} else {
					month++;
				}
				//Log.d(tag, "Setting Next Month in GridCellAdapter: " + "Month: " + month + " Year: " + year);
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
			bundle.putString("time",lea.getItem(images.indexOf(v)).getTime());
			bundle.putString("lieu",lea.getItem(images.indexOf(v)).getLieu());
			bundle.putString("logo",lea.getItem(images.indexOf(v)).getLogo());
			bundle.putString("group",lea.getItem(images.indexOf(v)).getGroup());
			//Ajout du Bundle
			intent.putExtras(bundle);
			
			TabEvent.this.startActivity(intent);
		}
	};
	
	
	
	
	
	public class GridCellAdapter extends BaseAdapter implements OnClickListener {
		private static final String tag = "GridCellAdapter";
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
		private TextView num_events_per_day;
		private final HashMap eventsPerMonthMap;
		private final SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MMM-yyyy");
		private Set<String> dateEvents;
		private String currentDayNumber;
		private String currentMonthNumber;
		private String currentYearNumber;
		private String currentDate; // dd-MM-yyyy

		// Days in Current Month
		public GridCellAdapter(Context context, int textViewResourceId, int month, int year) {
			super();
			this._context = context;
			this.list = new ArrayList<String>();
			this.month = month;
			this.year = year;
			this.dateEvents = getSetDates();

			//Log.d(tag, "==> Passed in Date FOR Month: " + month + " " + "Year: " + year);
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
			
			//Log.d(tag, "New Calendar:= " + calendar.getTime().toString());
			//Log.d(tag, "CurrentDayOfWeek :" + getCurrentWeekDay());
			//Log.d(tag, "CurrentDayOfMonth :" + getCurrentDayOfMonth());

			// Print Month
			printMonth(month, year);

			// Find Number of Events
			eventsPerMonthMap = findNumberOfEventsPerMonth(year, month);
		}
		
		private String getMonthAsString(int i) {
			return months[i];
		}

		private String getWeekDayAsString(int i) {
			return weekdays[i];
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
			int leadSpaces = 0;
			int daysInPrevMonth = 0;
			int prevMonth = 0;
			int prevYear = 0;
			int nextMonth = 0;
			int nextYear = 0;
			boolean blue = false;

			int currentMonth = mm - 1;
			String currentMonthName = getMonthAsString(currentMonth);
			
			// current date with "dd-MM-yyyy" format
			String today = this.getCurrentDate();
			
			String monthNumber = String.valueOf(mm);
			if (monthNumber.length() == 1) {
				monthNumber = "0"+monthNumber;
			}
			String yearNumber = String.valueOf(yy);
			
			String month = monthNumber+"-"+yearNumber;
			if (today.contains(month)) {
				// today is contained in the month that is printed
				blue = true;
			}
			
			daysInMonth = getNumberOfDaysOfMonth(currentMonth);

			//Log.d(tag, "Current Month: " + " " + currentMonthName + " having " + daysInMonth + " days.");

			// Gregorian Calendar : MINUS 1, set to FIRST OF MONTH
			GregorianCalendar cal = new GregorianCalendar(yy, currentMonth, 1);
			//Log.d(tag, "Gregorian Calendar:= " + cal.getTime().toString());

			if (currentMonth == 11) {
				prevMonth = currentMonth - 1;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
				nextMonth = 0;
				prevYear = yy;
				nextYear = yy + 1;
				//Log.d(tag, "*->PrevYear: " + prevYear + " PrevMonth:" + prevMonth + " NextMonth: " + nextMonth + " NextYear: " + nextYear);
			}
			else if (currentMonth == 0) {
				prevMonth = 11;
				prevYear = yy - 1;
				nextYear = yy;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
				nextMonth = 1;
				//Log.d(tag, "**--> PrevYear: " + prevYear + " PrevMonth:" + prevMonth + " NextMonth: " + nextMonth + " NextYear: " + nextYear);
			} else {
				prevMonth = currentMonth - 1;
				nextMonth = currentMonth + 1;
				nextYear = yy;
				prevYear = yy;
				daysInPrevMonth = getNumberOfDaysOfMonth(prevMonth);
				//Log.d(tag, "***---> PrevYear: " + prevYear + " PrevMonth:" + prevMonth + " NextMonth: " + nextMonth + " NextYear: " + nextYear);
			}

			// Compute how much to leave before before the first day of the
			// month.
			// getDay() returns 0 for Sunday.
			int currentWeekDay = cal.get(Calendar.DAY_OF_WEEK) - 1;
			trailingSpaces = currentWeekDay;

			//Log.d(tag, "Week Day:" + currentWeekDay + " is " + getWeekDayAsString(currentWeekDay));
			//Log.d(tag, "No. Trailing space to Add: " + trailingSpaces);
			//Log.d(tag, "No. of Days in Previous Month: " + daysInPrevMonth);

			if (cal.isLeapYear(cal.get(Calendar.YEAR)) && mm == 1) {
				++daysInMonth;
			}

			// Trailing Month days
			for (int i = 0; i < trailingSpaces; i++) {
					//Log.d(tag, "PREV MONTH:= " + prevMonth + " => " + getMonthAsString(prevMonth) + " " + String.valueOf((daysInPrevMonth - trailingSpaces + DAY_OFFSET) + i));
				list.add(String.valueOf((daysInPrevMonth - trailingSpaces + DAY_OFFSET) + i) + "-GREY" + "-" + getMonthAsString(prevMonth) + "-" + prevYear);
			}

			// Current Month Days
			for (int i = 1; i <= daysInMonth; i++) {
				//Log.d(currentMonthName, String.valueOf(i) + " " + getMonthAsString(currentMonth) + " " + yy);
				if (i == getCurrentDayOfMonth()) {
						list.add(String.valueOf(i) + "-BLUE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
				} else {
					list.add(String.valueOf(i) + "-WHITE" + "-" + getMonthAsString(currentMonth) + "-" + yy);
				}
			}

			// Leading Month days
			for (int i = 0; i < list.size() % 7; i++) {
				//Log.d(tag, "NEXT MONTH:= " + getMonthAsString(nextMonth));
				list.add(String.valueOf(i + 1) + "-GREY" + "-" + getMonthAsString(nextMonth) + "-" + nextYear);
			}
		}

		/**
		 * NOTE: YOU NEED TO IMPLEMENT THIS PART Given the YEAR, MONTH, retrieve
		 * ALL entries from a SQLite database for that month. Iterate over the
		 * List of All entries, and get the dateCreated, which is converted into
		 * day.
		 * 
		 * @param year
		 * @param month
		 * @return
		 */
		private HashMap findNumberOfEventsPerMonth(int year, int month) {
			HashMap map = new HashMap<String, Integer>();
			// DateFormat dateFormatter2 = new DateFormat();
			//						
			// String day = dateFormatter2.format("dd", dateCreated).toString();
			//
			// if (map.containsKey(day))
			// {
			// Integer val = (Integer) map.get(day) + 1;
			// map.put(day, val);
			// }
			// else
			// {
			// map.put(day, 1);
			// }
			return map;
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
			gridcell.setOnClickListener(this);

			// ACCOUNT FOR SPACING

			//Log.d(tag, "Current Day: " + getCurrentDayOfMonth());
			String[] day_color = list.get(position).split("-");
			String theday = day_color[0];
			String themonth = day_color[2];
			String theyear = day_color[3];
			if ((!eventsPerMonthMap.isEmpty()) && (eventsPerMonthMap != null)) {
				if (eventsPerMonthMap.containsKey(theday)) {
						num_events_per_day = (TextView) row.findViewById(R.id.num_events_per_day);
						Integer numEvents = (Integer) eventsPerMonthMap.get(theday);
						num_events_per_day.setText(numEvents.toString());
				}
			}

			// Set the Day GridCell
			gridcell.setText(theday);
			gridcell.setTag(theday + "-" + themonth + "-" + theyear);
			//Log.d(tag, "Setting GridCell " + theday + "-" + themonth + "-" + theyear);

			
			// convert string "dd-Month-yyyy" to format "dd-MM-yyyy"
			/*String date = theday + "-" + this.getMonthNumberAsString(themonth) + "-" + theyear;
			Log.d("date = ",date);
			if (dateEvents.contains(date)) {
				gridcell.setTextColor(Color.RED);
			} else {*/
			if (day_color[1].equals("GREY")) {
				gridcell.setTextColor(Color.LTGRAY);
			}
			if (day_color[1].equals("WHITE")) {
				gridcell.setTextColor(Color.WHITE);
			}
			if (day_color[1].equals("BLUE")) {
				gridcell.setTextColor(getResources().getColor(R.color.static_text_color));
			}
			return row;
		}
		
		public void onClick(View view) {
			String date_month_year = (String) view.getTag();
			selectedDayMonthYearButton.setText(date_month_year);
			if (date_month_year.equalsIgnoreCase("2-June-2012")) {
				ev = true;
				Intent intent = new Intent(TabEvent.this,TabEvent.class);
				TabEvent.this.startActivity(intent);
				selectedDayMonthYearButton.setText(date_month_year);
			}

			try {
				Date parsedDate = dateFormatter.parse(date_month_year);
				//Log.d(tag, "Parsed Date: " + parsedDate.toString());

			} catch (ParseException e) {
				e.printStackTrace();
			}
		}

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