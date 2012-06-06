package org.grandcercle.mobile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import android.content.Context;
import android.util.Log;

public class ContainerData {
	
	static public Context context;
	static private ArrayList<News> listNews;
	private static ArrayList<Event> listEvent;
	private static ArrayList<Event> listEventOld;
	private static ArrayList<BP> listBP;
	private static HashMap<String,ArrayList<Event>> hashEvent;
	private static HashMap<String,ArrayList<Event>> hashEventOld;
	private static ArrayList<String> listCercles;
	private static ArrayList<String> listClubs;
	private static ArrayList<String> listTypes;
	private static Context appContext;
	private static DataBase dataBase;
	private static String URL_CERCLES = "http://www.grandcercle.org/cercles/data.xml";
	private static String URL_CLUBS = "http://www.grandcercle.org/clubs/data.xml";
	private static String URL_TYPES = "http://www.grandcercle.org/types/data.xml";
	private static String URL_NEWS = "http://www.grandcercle.org/news/data.xml";
	private static String URL_EVENT = "http://www.grandcercle.org/evenements/data.xml";
	private static String URL_EVENTOLD = "http://www.grandcercle.org/evenements/data-old.xml";
	private static String URL_BP = "http://www.grandcercle.org/bons-plans/data.xml";
	
	
	public ContainerData() {
	}

	public static void saveXMLFiles() {
		ArrayList<String> listURL = new ArrayList<String>();
		listURL.add(URL_CERCLES);
		listURL.add(URL_CLUBS);
		listURL.add(URL_TYPES);
		listURL.add(URL_NEWS);
		listURL.add(URL_EVENT);
		listURL.add(URL_EVENTOLD);
		listURL.add(URL_BP);
		String [] nameFiles = {"cercles.gcm","clubs.gcm","types.gcm","news.gcm","event.gcm","eventOld.gcm","BP.gcm"};
		Iterator<String> it = listURL.iterator();
		int i = 0;
		while (it.hasNext()) {
			saveXML(it.next(),nameFiles[i]);
			i++;
		}
	}
		
	public static void copyPipe(InputStream in, OutputStream out, int bufSizeHint) {
		int read = -1;
		byte[] buf = new byte[bufSizeHint];
		try {
			while ((read = in.read(buf, 0, bufSizeHint)) >= 0) {
				out.write(buf, 0, read);
			}
			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}	
	
	public static void saveXML(String fromURL, String toFile) {
		try {
	        //set the download URL, a url that points to a file on the internet
	        //this is the file to be downloaded
	        URL url = new URL(fromURL);

	        //create the new connection
	        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

	        //set up some things on the connection
	        urlConnection.setRequestMethod("GET");
	        urlConnection.setDoOutput(true);

	        //and connect!
	        urlConnection.connect();

	        //set the path where we want to save the file
	        //in this case, going to save it on the root directory of the
	        //sd card.
	        //File root = new File("/data/data/org.grandcercle.mobile/files/");
	        File root = new File("data/data/");
	        root.getParentFile().mkdirs();
	        root.createNewFile();

	        		//getExternalStorageDirectory();
	        //create a new file, specifying the path, and the filename
	        //which we want to save the file as.
	        File file = new File(root,toFile);

	        //this will be used to write the downloaded data into the file we created
	        FileOutputStream fileOutput = new FileOutputStream(file);
	        //this will be used in reading the data from the internet
	        InputStream inputStream = urlConnection.getInputStream();

	        //this is the total size of the file
	        int totalSize = urlConnection.getContentLength();
	        //variable to store total downloaded bytes
	        int downloadedSize = 0;

	        //create a buffer...
	        byte[] buffer = new byte[1024];
	        int bufferLength = 0; //used to store a temporary size of the buffer

	        //now, read through the input buffer and write the contents to the file
	        while ( (bufferLength = inputStream.read(buffer)) > 0 ) {
	                //add the data in the buffer to the file in the file output stream (the file on the sd card
	                fileOutput.write(buffer, 0, bufferLength);
	                //add up the size so we know how much is downloaded
	                downloadedSize += bufferLength;
	        }
	        //close the output stream when done
	        fileOutput.close();

		//catch some possible errors...
		} catch (MalformedURLException e) {
		        e.printStackTrace();
		} catch (IOException e) {
		        e.printStackTrace();
		}
		
		
		
		
		
		
		/*URL from = null;
		try {
			from = new URL(fromURL);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		File to = new File(toFile);
		
		BufferedInputStream urlin = null;
		BufferedOutputStream fout = null;
		  try {
		      int bufSize = 8 * 1024;
		      urlin = new BufferedInputStream(
		              from.openConnection().getInputStream(),
		              bufSize);
		      fout = new BufferedOutputStream(new FileOutputStream(to), bufSize);
		      copyPipe(urlin, fout, bufSize);
		  }
		  catch (IOException e) {
		      e.printStackTrace();
		  }
		  catch (SecurityException e) {
			  e.printStackTrace();
		  }
		  finally {
		      if (urlin != null) {
		          try {
		              urlin.close();
		          }
		          catch (IOException e) {
		        	  e.printStackTrace();
		          }
		      }
		      if (fout != null) {
		          try {
		              fout.close();
		          }
		          catch (IOException e) {
		        	  e.printStackTrace();
		          }
		      }
		  }*/
	  }

	
	public static void parseFiles(Context ctx){
		appContext = ctx;

		// On passe par une classe factory pour obtenir une instance de sax
		SAXParserFactory fabrique = SAXParserFactory.newInstance();
		SAXParser parseur = null;
		try {
			// On "fabrique" une instance de SAXParser
			parseur = fabrique.newSAXParser();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		
		// On définit les url des fichiers XML
		URL urlCercles = null;
		try {
			urlCercles = new URL(URL_CERCLES);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlClubs = null;
		try {
			urlClubs = new URL(URL_CLUBS);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlTypes = null;
		try {
			urlTypes = new URL(URL_TYPES);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlNews = null;
		try {
			urlNews = new URL(URL_NEWS);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEvent = null;
		try {
			urlEvent = new URL(URL_EVENT);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEventOld = null;
		try {
			urlEventOld = new URL(URL_EVENTOLD);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlBP = null;
		try {
			urlBP = new URL(URL_BP);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		/* 
		 * Le handler sera gestionnaire du fichier XML c'est à dire que c'est lui qui sera chargé
		 * des opérations de parsing.
		 */
		
		DefaultHandler handlerCercles = new ParserXMLHandlerAsso();
		try {
			// On parse le fichier XML
			parseur.parse(urlCercles.openConnection().getInputStream(), handlerCercles);
			
			// On récupère directement la liste des feeds
			listCercles = ((ParserXMLHandlerAsso) handlerCercles).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerClubs = new ParserXMLHandlerAsso();
		try {
			// On parse le fichier XML
			parseur.parse(urlClubs.openConnection().getInputStream(), handlerClubs);
			
			// On récupère directement la liste des feeds
			listClubs = ((ParserXMLHandlerAsso) handlerClubs).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		DefaultHandler handlerTypes = new ParserXMLHandlerType();
		try {
			// On parse le fichier XML
			parseur.parse(urlTypes.openConnection().getInputStream(), handlerTypes);
			
			// On récupère directement la liste des feeds
			listTypes = ((ParserXMLHandlerType) handlerTypes).getListType();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		
		DefaultHandler handlerNews = new ParserXMLHandlerNews();
		try {
			// On parse le fichier XML
			parseur.parse(urlNews.openConnection().getInputStream(), handlerNews);
			
			// On récupère directement la liste des feeds
			listNews = ((ParserXMLHandlerNews) handlerNews).getListNews();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(urlEvent.openConnection().getInputStream(), handlerEvent);
			
			// On récupère directement la liste des feeds
			listEvent = ((ParserXMLHandlerEvent) handlerEvent).getListEvent();
			hashEvent = ((ParserXMLHandlerEvent) handlerEvent).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(urlEventOld.openConnection().getInputStream(), handlerEventOld);
			
			// On récupère directement la liste des feeds
			listEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getListEvent();
			hashEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerBP = new ParserXMLHandlerBP();
		try {
			// On parse le fichier XML
			parseur.parse(urlBP.openConnection().getInputStream(), handlerBP);
			
			// On récupère directement la liste des feeds
			listBP = ((ParserXMLHandlerBP) handlerBP).getListBP();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void parseEvent(){
		// On passe par une classe factory pour obtenir une instance de sax
		SAXParserFactory fabrique = SAXParserFactory.newInstance();
		SAXParser parseur = null;
		try {
			// On "fabrique" une instance de SAXParser
			parseur = fabrique.newSAXParser();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		
		// On définit les url des fichiers XML
		URL urlEvent = null;
		try {
			urlEvent = new URL(URL_EVENT);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		// On définit les url des fichiers XML
		URL urlEventOld = null;
		try {
			urlEventOld = new URL(URL_EVENTOLD);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(urlEvent.openConnection().getInputStream(), handlerEvent);
			
			// On récupère directement la liste des feeds
			listEvent = ((ParserXMLHandlerEvent) handlerEvent).getListEvent();
			hashEvent = ((ParserXMLHandlerEvent) handlerEvent).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(urlEventOld.openConnection().getInputStream(), handlerEventOld);
			
			// On récupère directement la liste des feeds
			listEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getListEvent();
			hashEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	public static void loadDatas() {
		Log.d("ContainerData","loadDatas => à implémenter !");
	}
	

	public static ArrayList<News> getNews() {
		return listNews;
	}

	public static ArrayList<Event> getEvent() {
		return listEvent;
	}
	
	public static ArrayList<Event> getEventOld() {
		return listEventOld;
	}
	
	public static HashMap<String,ArrayList<Event>> getEventInHashMap() {
		if (hashEventOld != null && hashEvent != null) {
			hashEvent.putAll(hashEventOld);
		} else if (hashEventOld != null) {
			return hashEventOld;
		}
		return hashEvent;
	}
	
	public static ArrayList<BP> getlistBP() {
		return listBP;
	}

	public static ArrayList<String> getListCercles() {
		return listCercles;
	}
	
	public static ArrayList<String> getListClubs() {
		return listClubs;
	}
	
	public static ArrayList<String> getListTypes() {
		return listTypes;
	}
	
	public static ArrayList<String> getListColors(){
		ArrayList<String> temp = new ArrayList<String>();
		temp.add("Noir");
		temp.add("Ensimag");
		temp.add("Phelma");
		temp.add("Ense3");
		temp.add("Pagora");
		temp.add("GI");
		temp.add("CPP");
		temp.add("Esisar");
		return temp;
	}
	
	public static Context getAppContext() {
		return appContext;
	}
	
}

