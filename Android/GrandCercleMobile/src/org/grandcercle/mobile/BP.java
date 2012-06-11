package org.grandcercle.mobile;

/* 
 * Classe représentant un élément bons plans
 */

public class BP extends Item {
	private String image;
	private String summary;
	
	public BP(long id, String title, String description, String link, String image, String summary) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.link = link;
		this.image = image;
		this.summary = summary;
	}
	
	
	public BP() {
		super();
	}

	public String getImage() {
		return image;
	}


	public void setImage(String image) {
		this.image = image;
	}


	public String getSummary() {
		return summary;
	}


	public void setSummary(String summary) {
		this.summary = summary;
	}


	public String toString() {
		return "BP" + super.toString();
	}
}
