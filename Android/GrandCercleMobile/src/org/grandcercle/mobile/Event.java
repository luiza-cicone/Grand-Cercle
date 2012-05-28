package org.grandcercle.mobile;

public class Event extends News {
	private String type;
	private String day;
	private String date;
	private String time;
	private String thumbnail;
	private String image;
	private String lieu;
	private float paf;
	private float pafSansCVA;
	
	public Event(long id, String title, String description, String link, String pubDate, String author, 
			String group, String logo, String type, String day, String date, String time, 
			String thumbnail, String image, String lieu, float paf, float pafSansCVA) {
		super(id,title,description,link,pubDate,author,group,logo);
		this.type = type;
		this.day = day;
		this.date = date;
		this.time = time;
		this.thumbnail = thumbnail;
		this.image = image;
		this.lieu = lieu;
		this.paf = paf;
		this.pafSansCVA = pafSansCVA;
	}
	
	public Event(News n, String type, String day, String date, String time, 
			String thumbnail, String image, String lieu, float paf, float pafSansCVA) {
		super(n.getId(),n.getTitle(),n.getDescription(),n.getLink(),
				n.getPubDate(),n.getAuthor(),n.getGroup(),n.getLogo());
		this.type = type;
		this.day = day;
		this.date = date;
		this.time = time;
		this.thumbnail = thumbnail;
		this.image = image;
		this.lieu = lieu;
		this.paf = paf;
		this.pafSansCVA = pafSansCVA;
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

	public float getPaf() {
		return paf;
	}

	public void setPaf(float paf) {
		this.paf = paf;
	}

	public float getPafSansCVA() {
		return pafSansCVA;
	}

	public void setPafSansCVA(float pafSansCVA) {
		this.pafSansCVA = pafSansCVA;
	}
	
	@Override
	public String toString() {
		return super.toString()+"Event [type=" + type + ", day=" + day + ", date="
				+ date + ", time=" + time + ", lieu=" + lieu + "paf=" + paf + "]";
	}
}
