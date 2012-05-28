package org.grandcercle.mobile;



import java.util.ArrayList;

import org.grandcercle.mobile.R;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class ListEventAdapter extends BaseAdapter {

	// les données à afficher
	private ArrayList<Event> listEvent;
	
	/* Le LayoutInflater permet de parser un layout XML et de 
	 * le transcoder en IHM Android. Pour respecter la classe 
	 * BaseAdapter
	 */
	private LayoutInflater inflater;
	
	public ListEventAdapter(Context context,ArrayList<Event> listEvent) {
		inflater = LayoutInflater.from(context);
		this.listEvent = listEvent;
	}
	
	/* il nous faut spécifier la méthode "getCount()". 
	 * Cette méthode permet de connaître le nombre d'items présent 
	 * dans la liste. Dans notre cas, il faut donc renvoyer le nombre
	 * de personnes contenus dans "mListP".
	 */
	public int getCount() {
		return listEvent.size();
	}

	// Permet de retourner un objet contenu dans la liste
	public Object getItem(int index) {
		return listEvent.get(index);
	}

	public long getItemId(int index) {
		return this.listEvent.get(index).getId();
		
	}
	
	/* Le paramètre "convertView" permet de recycler les élements 
	 * de notre liste. En effet, l'opération pour convertir un layout 
	 * XML en IHM standard est très couteuse pour la plateforme Android. 
	 * On nous propose ici de réutiliser des occurences créées qui ne sont 
	 * plus affichées. Donc si ce paramètre est "null" alors, il faut "inflater" 
	 * notre layout XML, sinon on le réutilise
	 */
	public View getView(int position, View convertView, ViewGroup parent){
		EventView ev;		
		
		if (convertView == null) {
			ev = new EventView();
			convertView = inflater.inflate(R.layout.feed_view, null);

			ev.group = (TextView)convertView.findViewById(R.id.group);			
			ev.title = (TextView)convertView.findViewById(R.id.title);
			ev.pubDate = (TextView)convertView.findViewById(R.id.pub_date);
			convertView.setTag(ev);

		} else {
			ev = (EventView) convertView.getTag();
		}						
		ev.group.setText(listEvent.get(position).getGroup());
		ev.pubDate.setText(listEvent.get(position).getPubDate());
		ev.title.setText(listEvent.get(position).getTitle());
		
		return convertView;
	}

}
