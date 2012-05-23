package gcm.android.parser;

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

public class ContainerData {	
	
	static public Context context;
	
	public ContainerData() {

	}

	
	public static ArrayList<Feed> getFeeds(){
		// On passe par une classe factory pour obtenir une instance de sax
		SAXParserFactory fabrique = SAXParserFactory.newInstance();
		SAXParser parseur = null;
		ArrayList<Feed> feeds = null;
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
			url = new URL("http://www.grandcercle.org/news/rss.xml");
			//url = new URL("http://thibault-koprowski.fr/feed");
			//url = new URL("http://www.lequipe.fr/rss/actu_rss.xml");
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
			feeds = ((ParserXMLHandler) handler).getData();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// On la retourne l'array list
		return feeds;
	}

}
