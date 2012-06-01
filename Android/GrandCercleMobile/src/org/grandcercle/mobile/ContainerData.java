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

public class ContainerData {	
	
	static public Context context;
	static private ArrayList<News> listNews;
	private static ArrayList<Event> listEvent;
	private static ArrayList<BP> listBP;
	private static HashMap<String,ArrayList<Event>> hashEvent;
	
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
		
		// On définit l'url du fichier XML
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
		
		URL urlBP = null;
		try {
			urlBP = new URL("http://www.grandcercle.org/bons-plans/data.xml");
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


	public static ArrayList<News> getNews() {
		return listNews;
	}

	public static ArrayList<Event> getEvent() {
		return listEvent;
	}
	
	public static HashMap<String,ArrayList<Event>> getEventInHashMap() {
		return hashEvent;
	}
	
	public static ArrayList<BP> getlistBP() {
		return listBP;
	}
}

