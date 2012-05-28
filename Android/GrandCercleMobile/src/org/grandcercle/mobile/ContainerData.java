package org.grandcercle.mobile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
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
	
	public ContainerData() {

	}

	
	public static void ParseFiles(){
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
		URL url = null;
		try {
			url = new URL("http://www.grandcercle.org/news/data.xml");
		} catch (MalformedURLException e1) {
			e1.printStackTrace();
		}
		
		/* 
		 * Le handler sera gestionnaire du fichier XML c'est à dire que c'est lui qui sera chargé
		 * des opérations de parsing.
		 */
		DefaultHandler handler = new ParserXMLHandler();
		try {
			// On parse le fichier XML
			parseur.parse(url.openConnection().getInputStream(), handler);
			
			// On récupère directement la liste des feeds
			listNews = ((ParserXMLHandler) handler).getNews();
			for (News news : listNews) {
				Log.i("Container Data News",news.toString());
			}
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		/*XMLReader xmlReader = null;
		try {
			xmlReader = SAXParserFactory.newInstance().newSAXParser().getXMLReader();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DefaultHandler handler = new ParserXMLHandler();
		xmlReader.setContentHandler(handler);
		try {
			xmlReader.parse(new InputSource(url.openConnection().getInputStream()));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		listNews = ((ParserXMLHandler)xmlReader.getContentHandler()).getNews();*/
	}


	public static ArrayList<News> getNews() {
		return listNews;
	}
}

