package org.grandcercle.mobile;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

/*
 * Parser pour les cercles et les clubs
 * A appeler en deux fois, séparément sur les fichiers cercles et clubs
 */

public class ParserXMLHandlerAsso extends ParserXMLHandler {
	private final String GROUP = "group";
	
	// Array list d'asso, au format String
	private ArrayList<String> listAssos;
	
	// Boolean permettant de savoir si nous sommes à l'intérieur d'une news
	private boolean inAsso;

	// Feed courant
	private String currentAsso;
	
	
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
		listAssos = new ArrayList<String>();
	}
	
	/* 
	 * Fonction étant déclenchée lorsque le parser trouve un tag XML
	 * C'est cette méthode que nous allons utiliser pour instancier un nouveau feed
 	*/
	@Override
	public void startElement(String uri, String localName, String name,	Attributes attributes) throws SAXException {
		// Nous réinitialisons le buffer a chaque fois qu'il rencontre un node
		buffer = new StringBuffer();		
		
		// Ci dessous, localName contient le nom du tag rencontré
		
		// Nous avons rencontré un tag NODE, il faut donc instancier un nouvel BP		
		if (localName.equalsIgnoreCase(NODE)){
			inAsso = true;
		}
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
		if (localName.equalsIgnoreCase(GROUP)) {
			if (inAsso) {
				this.currentAsso = buffer.toString();
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(NODE)){		
			listAssos.add(currentAsso);
			inAsso = false;
		}
	}
	// cette méthode nous permettra de récupérer les données
	public ArrayList<String> getListAssos(){
		return listAssos;
	}
}
