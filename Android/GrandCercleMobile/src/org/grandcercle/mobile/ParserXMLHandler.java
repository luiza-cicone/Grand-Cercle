package org.grandcercle.mobile;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


public abstract class ParserXMLHandler extends DefaultHandler {

	// nom des tags XML
	protected final String NODE = "node";
	protected final String TITLE = "title";
	protected final String DESCRIPTION = "description";
	protected final String LINK = "link";
	
	
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
}
