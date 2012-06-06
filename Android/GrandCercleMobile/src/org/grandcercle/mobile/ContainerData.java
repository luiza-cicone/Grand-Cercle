package org.grandcercle.mobile;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import android.content.Context;

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
	
	public ContainerData() {
	}

	public static void parseFiles(Context ctx){
		appContext = ctx;
		//DataBase.getInstance().deleteAll("parsedDatas");
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
		String pathCercles = "http://www.grandcercle.org/cercles/data.xml";
		try {
			urlCercles = new URL(pathCercles);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlClubs = null;
		String pathClubs = "http://www.grandcercle.org/clubs/data.xml";
		try {
			urlClubs = new URL(pathClubs);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlTypes = null;
		String pathTypes = "http://www.grandcercle.org/types/data.xml";
		try {
			urlTypes = new URL(pathTypes);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlNews = null;
		String pathNews = "http://www.grandcercle.org/news/data.xml";
		try {
			urlNews = new URL(pathNews);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEvent = null;
		String pathEvent = "http://www.grandcercle.org/evenements/data.xml";
		try {
			urlEvent = new URL(pathEvent);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEventOld = null;
		String pathEventOld = "http://www.grandcercle.org/evenements/data-old.xml";
		try {
			urlEventOld = new URL(pathEventOld);
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlBP = null;
		String pathBP = "http://www.grandcercle.org/bons-plans/data.xml";
		try {
			urlBP = new URL(pathBP);
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
		
		/*dataBase = DataBase.getInstance();
		dataBase.storeTextToDataBase(pathCercles,"cercles");
		dataBase.storeTextToDataBase(pathClubs,"clubs");
		dataBase.storeTextToDataBase(pathTypes,"types");
		dataBase.storeTextToDataBase(pathNews,"news");
		dataBase.storeTextToDataBase(pathEvent,"event");
		dataBase.storeTextToDataBase(pathEventOld,"eventOld");
		dataBase.storeTextToDataBase(pathBP,"bonsPlans");*/
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
			String path = "http://www.grandcercle.org/evenements/data.xml";
			urlEvent = new URL(path);
			DataBase.getInstance().deleteEvent();
			DataBase.getInstance().storeTextToDataBase(path,"event");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		// On définit les url des fichiers XML
		URL urlEventOld = null;
		try {
			String path = "http://www.grandcercle.org/evenements/data-old.xml";
			urlEventOld = new URL(path);
			DataBase.getInstance().deleteEvent();
			DataBase.getInstance().storeTextToDataBase(path,"eventOld");
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
	
	
	// récupère les données dans la base de donnée
	public static void loadOldData(Context ctx) {
		appContext = ctx;
		
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
		
		// cercles
		InputStream isCercles = DataBase.getInstance().getParsed("cercles");
		DefaultHandler handlerCercles = new ParserXMLHandlerAsso();
		try {
			// On parse le fichier XML
			parseur.parse(isCercles, handlerCercles);
			
			// On récupère directement la liste des feeds
			listCercles = ((ParserXMLHandlerAsso) handlerCercles).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		InputStream isClubs = DataBase.getInstance().getParsed("clubs");
		DefaultHandler handlerClubs = new ParserXMLHandlerAsso();
		try {
			// On parse le fichier XML
			parseur.parse(isClubs, handlerClubs);
			
			// On récupère directement la liste des feeds
			listClubs = ((ParserXMLHandlerAsso) handlerClubs).getListAssos();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		InputStream isTypes = DataBase.getInstance().getParsed("types");
		DefaultHandler handlerTypes = new ParserXMLHandlerType();
		try {
			// On parse le fichier XML
			parseur.parse(isTypes, handlerTypes);
			
			// On récupère directement la liste des feeds
			listTypes = ((ParserXMLHandlerType) handlerTypes).getListType();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		InputStream isNews = DataBase.getInstance().getParsed("news");
		DefaultHandler handlerNews = new ParserXMLHandlerNews();
		try {
			// On parse le fichier XML
			parseur.parse(isNews, handlerNews);
			
			// On récupère directement la liste des feeds
			listNews = ((ParserXMLHandlerNews) handlerNews).getListNews();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		InputStream isEvent = DataBase.getInstance().getParsed("event");
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(isEvent, handlerEvent);
			
			// On récupère directement la liste des feeds
			listEvent = ((ParserXMLHandlerEvent) handlerEvent).getListEvent();
			hashEvent = ((ParserXMLHandlerEvent) handlerEvent).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		InputStream isEventOld = DataBase.getInstance().getParsed("eventOld");
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent(appContext);
		try {
			// On parse le fichier XML
			parseur.parse(isEventOld, handlerEventOld);
			
			// On récupère directement la liste des feeds
			listEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getListEvent();
			hashEventOld = ((ParserXMLHandlerEvent) handlerEventOld).getHashEvent();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		InputStream isBP = DataBase.getInstance().getParsed("bonsPlans");
		DefaultHandler handlerBP = new ParserXMLHandlerBP();
		try {
			// On parse le fichier XML
			parseur.parse(isBP, handlerBP);
			
			// On récupère directement la liste des feeds
			listBP = ((ParserXMLHandlerBP) handlerBP).getListBP();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
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
		temp.add("Papet");
		temp.add("GI");
		temp.add("CPP");
		temp.add("Esisar");
		return temp;
	}
	
	public static Context getAppContext() {
		return appContext;
	}
	
}

