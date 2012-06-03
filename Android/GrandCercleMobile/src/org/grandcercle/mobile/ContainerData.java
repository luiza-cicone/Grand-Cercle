package org.grandcercle.mobile;

import java.io.IOException;
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
	
	public ContainerData() {

	}

	
	public static void parseFiles(){
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
		URL urlNews = null;
		try {
			urlNews = new URL("http://www.grandcercle.org/news/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEvent = null;
		try {
			urlEvent = new URL("http://www.grandcercle.org/evenements/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlEventOld = null;
		try {
			urlEventOld = new URL("http://www.grandcercle.org/evenements/data-old.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlBP = null;
		try {
			urlBP = new URL("http://www.grandcercle.org/bons-plans/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlCercles = null;
		try {
			urlCercles = new URL("http://www.grandcercle.org/cercles/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		URL urlClubs = null;
		try {
			urlClubs = new URL("http://www.grandcercle.org/clubs/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		/* 
		 * Le handler sera gestionnaire du fichier XML c'est à dire que c'est lui qui sera chargé
		 * des opérations de parsing.
		 */
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
		
		
		DefaultHandler handlerEvent = new ParserXMLHandlerEvent();
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
		
		DefaultHandler handlerEventOld = new ParserXMLHandlerEvent();
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
}

