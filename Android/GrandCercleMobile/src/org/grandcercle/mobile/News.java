package org.grandcercle.mobile;

public class News {
	private long id;
	private String title;
	private String description;
	private String link;
	private String pubDate;
	private String author;
	private String group;
	private String logo;
	
	
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

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getLink() {
		return link;
	}
	
	public void setLink(String link) {
		this.link = link;
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


	@Override
	public String toString() {
		return "News [author=" + author + ", pubDate=" + pubDate + ", title="
				+ title + "]";
	}
}
