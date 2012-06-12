package org.grandcercle.mobile;

/*
 * Classe abstraite gérant une information quelconque (event, news, bp)
 */

public abstract class Item {
	protected long id;
	protected String title;
	protected String description;
	protected String link;
	
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

	@Override
	public String toString() {
		return "[title=" + title + "]";
	}
	
}
