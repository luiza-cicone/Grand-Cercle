package org.grandcercle.mobile;

import android.os.Parcel;
import android.os.Parcelable;

public abstract class Item implements Parcelable {
	protected long id;
	protected String title;
	protected String description;
	protected String link;
	protected String pubDate;
	protected String author;
	protected String group;
	protected String logo;
	
	public int describeContents() {
		return 0;
	}

	public void writeToParcel(Parcel dest, int flags) {}
	
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
		return "[author=" + author + ", pubDate=" + pubDate + ", title="
				+ title + "]";
	}
	
}
