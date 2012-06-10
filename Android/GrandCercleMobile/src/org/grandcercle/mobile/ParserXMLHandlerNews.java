package org.grandcercle.mobile;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

/*
 * Parser sur les news
 */

public class ParserXMLHandlerNews extends ParserXMLHandler {
	
	private final String PUBDATE = "pubDate";
	private final String AUTHOR = "author";
	private final String GROUP = "group";
	private final String LOGO = "logo";
	
	// Array list d'evenements
	private ArrayList<News> listNews;
	
	// Boolean permettant de savoir si nous sommes à l'intérieur d'une news
	private boolean inNews;

	// Feed courant
	private News currentNews;
	
	
	/* Cette méthode est appelée par le parser une et une seule  
	 * fois au démarrage de l'analyse de votre flux xml. 
	 * Elle est appelée avant toutes les autres méthodes de l'interface,  
	 * à l'exception unique, évidemment, de la méthode setDocumentLocator. 
	 * Cet événement devrait vous permettre d'initialiser tout ce qui doit 
	 * l'être avant le début du parcours du document.
	 */ 
	@Override
	public void startDocument() throws SAXException {
		super.startDocument();
		listNews = new ArrayList<News>();
	}
	
	/* 
	 * Fonction étant déclenchée lorsque le parser trouve un tag XML
	 * C'est cette méthode que nous allons utiliser pour instancier un nouveau feed
 	*/
	@Override
	public void startElement(String uri, String localName, String name,	Attributes attributes) throws SAXException {
		// Nous réinitialisons le buffer a chaque fois qu'il rencontre un item
		buffer = new StringBuffer();		
		
		// Ci dessous, localName contient le nom du tag rencontré
		
		// Nous avons rencontré un tag ITEM, il faut donc instancier un nouveau feed		
		if (localName.equalsIgnoreCase(NODE)){
			this.currentNews = new News();
			inNews = true;
		}
		
		/* Pour tous les autres tags, on ne fait aucun traitement pour le moment
		if (localName.equalsIgnoreCase(TITLE)){
			// Nothing to do	
		}
		if (localName.equalsIgnoreCase(LINK)){
			// Nothing to do	
		}
		if (localName.equalsIgnoreCase(PUBDATE)){	
			// Nothing to do	
		}
		if (localName.equalsIgnoreCase(CREATOR)){
			// Nothing to do
		}
		if(localName.equalsIgnoreCase(DESCRIPTION)){
			// Nothing to do	
		}
		*/
	}
	
	 
	/* Fonction étant déclenchée lorsque le parser à parsé 	
	 * l'intérieur de la balise XML La méthode characters  
	 * a donc fait son ouvrage et tous les caractères inclus 
	 * dans la balise en cours sont copiés dans le buffer 
	 * On peut donc tranquillement les récupérer pour compléter
	 * notre objet currentFeed
	 */
	@Override
	public void endElement(String uri, String localName, String name) throws SAXException {		
		
		if (localName.equalsIgnoreCase(TITLE)){
			if(inNews){				
				// Les caractères sont dans l'objet buffer
				this.currentNews.setTitle(buffer.toString());				
				buffer = null;
			}
		}
		if(localName.equalsIgnoreCase(DESCRIPTION)){
			if(inNews){				
				this.currentNews.setDescription(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(LINK)){
			if(inNews){				
				this.currentNews.setLink(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(PUBDATE)){	
			if(inNews){				
				this.currentNews.setPubDate(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(AUTHOR)){
			if(inNews){				
				this.currentNews.setAuthor(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(GROUP)){
			if(inNews){				
				this.currentNews.setGroup(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(LOGO)){
			if(inNews){				
				this.currentNews.setLogo(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(NODE)){		
			listNews.add(currentNews);
			inNews = false;
		}
	}
	// cette méthode nous permettra de récupérer les données
	public ArrayList<News> getListNews(){
		if (listNews.isEmpty()) {
			return null;
		}
		return listNews;
	}
}
