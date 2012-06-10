package org.grandcercle.mobile;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

/*
 * Parser sur les bons plans
 */

public class ParserXMLHandlerBP extends ParserXMLHandler {
	private final String IMAGE = "image";
	private final String SUMMARY = "summary";
	
	// Array list d'evenements
	private ArrayList<BP> listBP;
	
	// Boolean permettant de savoir si nous sommes à l'intérieur d'une news
	private boolean inBP;

	// Feed courant
	private BP currentBP;
	
	
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
		listBP = new ArrayList<BP>();
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
		
		// Nous avons rencontré un tag NADE, il faut donc instancier un nouvel BP		
		if (localName.equalsIgnoreCase(NODE)){
			this.currentBP = new BP();
			inBP = true;
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
		
		if (localName.equalsIgnoreCase(TITLE)){
			if(inBP) {				
				// Les caractères sont dans l'objet buffer
				this.currentBP.setTitle(buffer.toString());				
				buffer = null;
			}
		}
		if(localName.equalsIgnoreCase(DESCRIPTION)){
			if(inBP) {				
				this.currentBP.setDescription(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(LINK)){
			if(inBP) {				
				this.currentBP.setLink(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(IMAGE)) {
			if (inBP) {
				this.currentBP.setImage(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(SUMMARY)) {
			if (inBP) {
				this.currentBP.setSummary(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(NODE)){		
			listBP.add(currentBP);
			inBP = false;
		}
	}
	// cette méthode nous permettra de récupérer les données
	public ArrayList<BP> getListBP(){
		if (listBP.isEmpty()) {
			return null;
		}
		return listBP;
	}
}
