package org.grandcercle.mobile;

public class BP extends Item {
	private String image;
	
	public BP(long id, String title, String description, String link, String image) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.link = link;
		this.image = image;
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


	public String toString() {
		return "BP" + super.toString();
	}
}
