package org.grandcercle.mobile;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.TypedArray;
import android.preference.ListPreference;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ListView;

public class ListPreferenceMultiSelect extends ListPreference {
	private String separator;
	private static final String DEFAULT_SEPARATOR = "OV=I=XseparatorX=I=VO"; 
	private String checkAllKey = null;
	private boolean[] mClickedDialogEntryIndices;
	private ArrayList<String> list;
	private CharSequence[] entryValues; 
	private CharSequence[] entries;
	//private DataBase dataBase;

	
	// Constructor
	public ListPreferenceMultiSelect(Context context, AttributeSet attrs) {
        super(context,attrs);
        TypedArray a = context.obtainStyledAttributes(attrs,R.styleable.ListPreferenceMultiSelect);
        checkAllKey = a.getString(R.styleable.ListPreferenceMultiSelect_checkAll);
        String s = a.getString(R.styleable.ListPreferenceMultiSelect_separator);
        if (s != null) {
        	separator = s;
        } else {
        	separator = DEFAULT_SEPARATOR;
        }

        String cle = this.getKey();
    	if (cle.equals("ListPrefClubs")) {
    		list = ContainerData.getListClubs();
    	} else if (cle.equals("ListPrefCercles")) {
    		list = ContainerData.getListCercles();
    	} else {
    		list = ContainerData.getListTypes();
    	}
    	entries= new String[list.size()];
    	entryValues = new String[list.size()];
    	// Initialize the array of boolean to the same size as number of entries
        mClickedDialogEntryIndices = new boolean[list.size()];
       
        // counts the number of launching of the application to initialize the array of boolean
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
        int c = prefs.getInt("numRun",0);
        if (c == 1) {
        	for (int i = 0; i<list.size(); i++) {
        		mClickedDialogEntryIndices[i] = true;
        	}
        }
    }
	
	@Override
    public void setEntries(CharSequence[] entries) {
    	super.setEntries(entries);
    	// Initialize the array of boolean to the same size as number of entries
        mClickedDialogEntryIndices = new boolean[list.size()];
    }
    
    public ListPreferenceMultiSelect(Context context) {
        this(context, null);
    }

    @Override
    protected void onPrepareDialogBuilder(Builder builder) {

    	entryValues = BuildEntryValues();
    	entries = BuildEntries();

        if (entries == null || entryValues == null || entries.length != entryValues.length ) {
            throw new IllegalStateException(
                    "ListPreference requires an entries array and an entryValues array which are both the same length");
        }
        restoreCheckedEntries();
        builder.setMultiChoiceItems(entries, mClickedDialogEntryIndices, 
                new DialogInterface.OnMultiChoiceClickListener() {
					public void onClick(DialogInterface dialog, int which, boolean val) {
						if( isCheckAllValue( which ) == true ) {
							checkAll( dialog, val );
						}
						mClickedDialogEntryIndices[which] = val;
					}
        });
    }
    
    private CharSequence[] BuildEntries() {
    	CharSequence[] e = new String[list.size()];
    	Iterator<String> it = list.iterator();
    	int i = 0;
    	while (it.hasNext()) {
            e[i] = it.next();
            i++;
        }
    	return e;
    }
    
    private CharSequence[] BuildEntryValues() {
    	CharSequence[] temp = new String[list.size()];
    	int i = 0;
    	while (i<list.size()) {
            temp[i] = Integer.toString(i);
            i++;
        }
    	return temp;
    }
    
    private boolean isCheckAllValue( int which ){
    	final CharSequence[] entry = getEntryValues();
    	if(checkAllKey != null) {
			return entry[which].equals(checkAllKey);
		}
    	return false;
    }
    
    private void checkAll( DialogInterface dialog, boolean val ) {
    	ListView lv = ((AlertDialog) dialog).getListView();
		int size = lv.getCount();
		for(int i = 0; i < size; i++) {
	        lv.setItemChecked(i, val);
	        mClickedDialogEntryIndices[i] = val;
	    }
    }

    public String[] parseStoredValue(CharSequence val) {
		if ( "".equals(val) ) {
			return null;
		}
		else {
			return ((String)val).split(separator);
		}
    }
    
    private void restoreCheckedEntries() {
    	CharSequence[] entryV = getEntryValues();
    	
    	// Explode the string read in sharedpreferences
    	String[] vals = parseStoredValue(getValue());
    	
    	if ( vals != null ) {
    		List<String> valuesList = Arrays.asList(vals);		
        	for ( int i=0; i<entryV.length; i++ ) {
        		CharSequence entry = entryV[i];
            	if ( valuesList.contains(entry) ) {
        			mClickedDialogEntryIndices[i] = true;
        		}
        	}
    	}
    	/*CharSequence[] entryV = getEntryValues();
    	String[] vals = parseStoredValue(getValue());
    	
    	
    	ArrayList<String> listChecked = null;
    	String key = getKey();
    	if (key.equalsIgnoreCase("ListPrefCercles")) {
    		listChecked = dataBase.getAllPref("prefCercle");
    	} else if (key.equalsIgnoreCase("ListPrefClubs")) {
    		listChecked = dataBase.getAllPref("prefClub");
    	}
    	if (listChecked != null && vals != null) {
    		for (int i = 0; i<listChecked.size(); i++) {
    			CharSequence entry = entryV[i];
    			if (listChecked.contains(entry)) {
    				mClickedDialogEntryIndices[i] = true;
    			}
    		}
    	}*/
    }

	@Override
    protected void onDialogClosed(boolean positiveResult) {
//        super.onDialogClosed(positiveResult);
		ArrayList<String> values = new ArrayList<String>();
        
    	CharSequence[] entry = getEntryValues();
        if (positiveResult && entry != null) {
        	for ( int i=0; i<entry.length; i++ ) {
        		if (mClickedDialogEntryIndices[i] == true) {
        			// Don't save the state of check all option - if any
        			String val = (String) entry[i];
        			if( checkAllKey == null || (val.equals(checkAllKey) == false) ) {
        				values.add(val);
        			}
        		}
        	}

            if (callChangeListener(values)) {
        		setValue(join(values, separator));
            	/*String key = getKey();
            	if (key.equalsIgnoreCase("ListPrefCercles")) {
            		dataBase.addListPref("prefCercle","cercle",values);
            	} else if (key.equalsIgnoreCase("ListPrefClubs")) {
            		dataBase.addListPref("prefClub","club",values);
            	}*/
            }
        }
    }
	
	// Credits to kurellajunior on this post http://snippets.dzone.com/posts/show/91
	protected static String join( Iterable< ? extends Object > pColl, String separator )
    {
        Iterator< ? extends Object > oIter;
        if ( pColl == null || ( !( oIter = pColl.iterator() ).hasNext() ) )
            return "";
        StringBuilder oBuilder = new StringBuilder( String.valueOf( oIter.next() ) );
        while ( oIter.hasNext() )
            oBuilder.append( separator ).append( oIter.next() );
        return oBuilder.toString();
    }
	
	// TODO: Would like to keep this static but separator then needs to be put in by hand or use default separator "OV=I=XseparatorX=I=VO"...
	/**
	 * 
	 * @param straw String to be found
	 * @param haystack Raw string that can be read direct from preferences
	 * @param separator Separator string. If null, static default separator will be used
	 * @return boolean True if the straw was found in the haystack
	 */
	public static boolean contains( String straw, String haystack, String separator ){
		if( separator == null ) {
			separator = DEFAULT_SEPARATOR;
		}
		String[] vals = haystack.split(separator);
		for( int i=0; i<vals.length; i++){
			if(vals[i].equals(straw)){
				return true;
			}
		}
		return false;
	}
}