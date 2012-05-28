package org.grandcercle.mobile;

import java.util.ArrayList;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

public class ParserXMLHandlerEvent extends ParserXMLHandler {
	private final String TYPE = "type";
	private final String DAY = "day";
	private final String DATE = "date";
	private final String TIME = "time";
	private final String THUMBNAIL ="thumbnail";
	private final String IMAGE = "image";
	private final String LIEU = "lieu";
	private final String PAF = "paf";
	private final String PAFSANSCVA = "pafSansCVA";
	
	// Array list d'evenements
	private ArrayList<Event> listEvent;
	
	// Boolean permettant de savoir si nous sommes à l'intérieur d'une news
	private boolean inEvent;

	// Feed courant
	private Event currentEvent;
	
	
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
		listEvent = new ArrayList<Event>();
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
		
		// Nous avons rencontré un tag NADE, il faut donc instancier un nouvel Event		
		if (localName.equalsIgnoreCase(NODE)){
			this.currentEvent = new Event();
			inEvent = true;
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
			if(inEvent) {				
				// Les caractères sont dans l'objet buffer
				this.currentEvent.setTitle(buffer.toString());				
				buffer = null;
			}
		}
		if(localName.equalsIgnoreCase(DESCRIPTION)){
			if(inEvent) {				
				this.currentEvent.setDescription(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(LINK)){
			if(inEvent) {				
				this.currentEvent.setLink(buffer.toString());				
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(PUBDATE)){	
			if(inEvent) {				
				this.currentEvent.setPubDate(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(AUTHOR)){
			if(inEvent) {				
				this.currentEvent.setAuthor(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(GROUP)){
			if(inEvent) {				
				this.currentEvent.setGroup(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(LOGO)){
			if(inEvent) {				
				this.currentEvent.setLogo(buffer.toString());				
				buffer = null;	
			}
		}
		if (localName.equalsIgnoreCase(TYPE)) {
			if (inEvent) {
				this.currentEvent.setType(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(DAY)) {
			if (inEvent) {
				this.currentEvent.setDay(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(DATE)) {
			if (inEvent) {
				this.currentEvent.setDate(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(TIME)) {
			if (inEvent) {
				this.currentEvent.setTime(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(THUMBNAIL)) {
			if (inEvent) {
				this.currentEvent.setThumbnail(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(IMAGE)) {
			if (inEvent) {
				this.currentEvent.setImage(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(LIEU)) {
			if (inEvent) {
				this.currentEvent.setLieu(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(PAF)) {
			if (inEvent) {
				this.currentEvent.setPaf(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(PAFSANSCVA)) {
			if (inEvent) {
				this.currentEvent.setPafSansCVA(buffer.toString());
				buffer = null;
			}
		}
		if (localName.equalsIgnoreCase(NODE)){		
			listEvent.add(currentEvent);
			inEvent = false;
		}
	}
	// cette méthode nous permettra de récupérer les données
	public ArrayList<Event> getListEvent(){
		return listEvent;
	}
}