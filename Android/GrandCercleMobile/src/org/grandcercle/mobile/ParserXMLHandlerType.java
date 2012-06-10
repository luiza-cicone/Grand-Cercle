package org.grandcercle.mobile;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/*
 * Parser sur les types (soirées, sport,...)
 */

public class ParserXMLHandlerType extends DefaultHandler {

	protected final String GROUP = "group";
	
	// Array list d'Type, au format String
	private ArrayList<String> listType;

	// Feed courant
	private String currentType;
	
	// Buffer permettant de contenir les données d'un tag XML
	protected StringBuffer buffer;
	
	@Override
	public void processingInstruction(String target, String data) throws SAXException {		
		super.processingInstruction(target, data);
	}
	
	
	/* Tout ce qui est dans l'arborescence mais n'est pas partie  
	 * intégrante d'un tag, déclenche la levée de cet événement.  
	 * En général, cet événement est donc levé tout simplement 
	 * par la présence de texte entre la balise d'ouverture et 
	 * la balise de fermeture
	 */ 
	public void characters(char[] ch,int start, int length)	throws SAXException{		
		String lecture = new String(ch,start,length);
		if (buffer != null) {
			buffer.append(lecture);      		
		}
	}
	
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
		listType = new ArrayList<String>();
	}
	
	/* 
	 * Fonction étant déclenchée lorsque le parser trouve un tag XML
	 * C'est cette méthode que nous allons utiliser pour instancier un nouveau feed
 	*/
	@Override
	public void startElement(String uri, String localName, String name,	Attributes attributes) throws SAXException {
		// Nous réinitialisons le buffer a chaque fois qu'il rencontre un node
		buffer = new StringBuffer();
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
			this.currentType = buffer.toString();
			listType.add(currentType);
			buffer = null;
		}
	}
	// cette méthode nous permettra de récupérer les données
	public ArrayList<String> getListType(){
		return listType;
	}
	
}
