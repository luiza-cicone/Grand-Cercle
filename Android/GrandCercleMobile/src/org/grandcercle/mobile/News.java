package org.grandcercle.mobile;

public class News extends Item {
	private String pubDate;
	private String author;
	private String group;
	private String logo;
	
	//Constructeur
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
	
	public String getPubDate() {
		return pubDate;
	}


	public void setPubDate(String pubDate) {
		this.pubDate = pubDate;
	}


	public String getAuthor() {
		return author;
	}


	public void setAuthor(String author) {
		this.author = author;
	}


	public String getGroup() {
		return group;
	}


	public void setGroup(String group) {
		this.group = group;
	}


	public String getLogo() {
		return logo;
	}


	public void setLogo(String logo) {
		this.logo = logo;
	}

	public String toString() {
		return "News" + super.toString();
	}
}
