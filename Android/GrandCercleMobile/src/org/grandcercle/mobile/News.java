package org.grandcercle.mobile;

public class News extends Item {

	
	public News(long id, String title, String description, String link, String pubDate, 
			String author, String group, String logo) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.link = link;
		this.pubDate = pubDate;
		this.author = author;
		this.group = group;
		this.logo = logo;
	}
	
	
	public News() {
		super();
	}

	public String toString() {
		return "News" + super.toString();
	}
}
