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

/*
 * Classe représentant l'ensemble des structures de données
 * ainsi que les méthodes qui permettent de les initialiser.
 * 
 * Comporte aussi les méthodes qui permettent de sauvegarder 
 * les fichiers XML à parser dans la mémoire interne du téléphone
 */

public class ContainerData {
	
	public static Context context;
	private static ArrayList<News> listNews;
	private static ArrayList<Event> listEvent;
	private static ArrayList<Event> listEventOld;
	private static ArrayList<BP> listBP;
	private static HashMap<String,ArrayList<Event>> hashEvent;
	private static HashMap<String,ArrayList<Event>> hashEventOld;
	private static ArrayList<String> listCercles;
	private static ArrayList<String> listClubs;
	private static ArrayList<String> listTypes;
	private static Context appContext;
	
	private static String URL_CERCLES = "http://www.grandcercle.org/cercles/data.xml";
	private static String URL_CLUBS = "http://www.grandcercle.org/clubs/data.xml";
	private static String URL_TYPES = "http://www.grandcercle.org/types/data.xml";
	private static String URL_NEWS = "http://www.grandcercle.org/news/data.xml";
	private static String URL_EVENT = "http://www.grandcercle.org/test/evenements/data.xml";
	private static String URL_EVENTOLD = "http://www.grandcercle.org/evenements/data-old.xml";
	private static String URL_BP = "http://www.grandcercle.org/bons-plans/data.xml";
	
	private static String FILE_CERCLES = "/data/data/org.grandcercle.mobile/files/cercles.gcm";
	private static String FILE_CLUBS = "/data/data/org.grandcercle.mobile/files/clubs.gcm";
	private static String FILE_TYPES = "/data/data/org.grandcercle.mobile/files/types.gcm";
	private static String FILE_NEWS = "/data/data/org.grandcercle.mobile/files/news.gcm";
	private static String FILE_EVENT = "/data/data/org.grandcercle.mobile/files/event.gcm";
	private static String FILE_EVENTOLD = "/data/data/org.grandcercle.mobile/files/eventOld.gcm";
	private static String FILE_BP = "/data/data/org.grandcercle.mobile/files/BP.gcm";
	
	
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
	        URL url = new URL(fromURL);

	        // nouvelle connexion
	        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
	        // paramètres de la connexion
	        urlConnection.setRequestMethod("GET");
	        urlConnection.setDoOutput(true);
	        urlConnection.connect();

	        // chemin du répertoire du fichier
	        File root = new File("/data/data/org.grandcercle.mobile/files/");
	        if (!root.exists()){
	        	root.mkdir();
	        }

	        // création d'un nouveau fichier
	        File file = new File(root,toFile);
	        if (!file.exists()) {
	        	file.createNewFile();
	        }

	        // écrire du fichier dans le répertoire
	        FileOutputStream fileOutput = new FileOutputStream(file);
	        InputStream inputStream = urlConnection.getInputStream();


	        byte[] buffer = new byte[1024];
	        int bufferLength = 0;

	        // lecture du fichier dans le buffer
	        while ( (bufferLength = inputStream.read(buffer)) > 0 ) {
	                fileOutput.write(buffer, 0, bufferLength);
	        }
	        fileOutput.close();


		} catch (MalformedURLException e) {
		        e.printStackTrace();
		} catch (IOException e) {
		        e.printStackTrace();
		}
	}

	public static boolean savedFilesExist() {
		boolean exist = true;
		ArrayList<String> listFiles = new ArrayList<String>();
		listFiles.add(FILE_CERCLES);
		listFiles.add(FILE_CLUBS);
		listFiles.add(FILE_TYPES);
		listFiles.add(FILE_NEWS);
		listFiles.add(FILE_EVENT);
		listFiles.add(FILE_EVENTOLD);
		listFiles.add(FILE_BP);
		Iterator<String> it = listFiles.iterator();
		File f;
		while (it.hasNext()) {
			f = new File(it.next());
			if (!f.exists()) {
	        	exist = false;
	        }
		}
		return exist;
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
		
		/* 
		 * Le handler sera gestionnaire du fichier XML c'est à dire que c'est lui qui sera chargé
		 * des opérations de parsing.
		 */
		
		DefaultHandler handlerCercles = new ParserXMLHandlerAsso();
		File fCercles = new File(FILE_CERCLES);
		try {
			// On parse le fichier XML
			parseur.parse(fCercles, handlerCercles);
			// On récupère directement la liste des feeds
			listCercles = ((ParserXMLHandlerAsso) handlerCercles).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerClubs = new ParserXMLHandlerAsso();
		File fClubs = new File(FILE_CLUBS);
		try {
			// On parse le fichier XML
			parseur.parse(fClubs, handlerClubs);
			// On récupère directement la liste des feeds
			listClubs = ((ParserXMLHandlerAsso) handlerClubs).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		DefaultHandler handlerTypes = new ParserXMLHandlerType();
		File fTypes = new File(FILE_TYPES);
		try {
			// On parse le fichier XML
			parseur.parse(fTypes, handlerTypes);
			// On récupère directement la liste des feeds
			listTypes = ((ParserXMLHandlerType) handlerTypes).getListType();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		
		DefaultHandler handlerNews = new ParserXMLHandlerNews();
		File fNews = new File(FILE_NEWS);
		try {
			// On parse le fichier XML
			parseur.parse(fNews, handlerNews);
			// On récupère directement la liste des feeds
			listNews = ((ParserXMLHandlerNews) handlerNews).getListNews();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent(appContext);
		File fEvent = new File(FILE_EVENT);
		try {
			// On parse le fichier XML
			parseur.parse(fEvent,handlerEvent);
			// On récupère directement la liste des feeds
			listEvent = ((ParserXMLHandlerEvent) handlerEvent).getListEvent();
			hashEvent = ((ParserXMLHandlerEvent) handlerEvent).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent(appContext);
		File fEventOld = new File(FILE_EVENTOLD);
		try {
			// On parse le fichier XML
			parseur.parse(fEventOld,handlerEventOld);
			// On récupère directement la liste des feeds
			listEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getListEvent();
			hashEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerBP = new ParserXMLHandlerBP();
		File fBP = new File(FILE_BP);
		try {
			// On parse le fichier XML
			parseur.parse(fBP, handlerBP);
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
		
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent(appContext);
		File fEvent = new File("/data/data/org.grandcercle.mobile/files/event.gcm");
		try {
			// On parse le fichier XML
			parseur.parse(fEvent,handlerEvent);
			// On récupère directement la liste des feeds
			listEvent = ((ParserXMLHandlerEvent) handlerEvent).getListEvent();
			hashEvent = ((ParserXMLHandlerEvent) handlerEvent).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent(appContext);
		File fEventOld = new File("/data/data/org.grandcercle.mobile/files/eventOld.gcm");
		try {
			// On parse le fichier XML
			parseur.parse(fEventOld,handlerEventOld);
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
		ArrayList<String> listCol = new ArrayList<String>();
		listCol.add("Noir");
		listCol.add("Ensimag");
		listCol.add("Phelma");
		listCol.add("Ense3");
		listCol.add("Pagora");
		listCol.add("GI");
		listCol.add("CPP");
		listCol.add("Esisar");
		return listCol;
	}
	
	public static Context getAppContext() {
		return appContext;
	}
	
}

