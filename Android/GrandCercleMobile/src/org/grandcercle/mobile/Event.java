package org.grandcercle.mobile;

public class Event extends Item {
	private String pubDate;
	private String author;
	private String group;
	private String logo;
	private String type;
	private String day;
	private String date;
	private String time;
	private String thumbnail;
	private String image;
	private String lieu;
	private String paf;
	private String pafSansCVA;
	private String eventDate;
	
	public Event(long id, String title, String description, String link, String pubDate, String author, 
			String group, String logo, String type, String day, String date, String time, 
			String thumbnail, String image, String lieu, String paf, String pafSansCVA, String eventDate) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.link = link;
		this.pubDate = pubDate;
		this.author = author;
		this.group = group;
		this.logo = logo;
		this.type = type;
		this.day = day;
		this.date = date;
		this.time = time;
		this.thumbnail = thumbnail;
		this.image = image;
		this.lieu = lieu;
		this.paf = paf;
		this.pafSansCVA = pafSansCVA;
		this.eventDate = eventDate;
	}
	
	public Event() {
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
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getLieu() {
		return lieu;
	}

	public void setLieu(String lieu) {
		this.lieu = lieu;
	}

	public String getPaf() {
		return paf;
	}

	public void setPaf(String paf) {
		this.paf = paf;
	}

	public String getPafSansCVA() {
		return pafSansCVA;
	}

	public void setPafSansCVA(String pafSansCVA) {
		this.pafSansCVA = pafSansCVA;
	}
	
	public String getEventDate() {
		return eventDate;
	}

	public void setEventDate(String eventDate) {
		this.eventDate = eventDate;
	}

	@Override
	public String toString() {
		return "Event [type=" + type + ", day=" + day + ", date=" + date + ", time=" + time + 
				", lieu=" + lieu + "paf=" + paf + "]" + super.toString();
	}
}
