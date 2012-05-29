package org.grandcercle.mobile;



import java.io.IOException;
import java.util.ArrayList;

import org.grandcercle.mobile.R;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
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
			convertView = inflater.inflate(R.layout.list_event, null);

			ev.group = (TextView)convertView.findViewById(R.id.group);			
			ev.title = (TextView)convertView.findViewById(R.id.title);
			ev.lieu = (TextView)convertView.findViewById(R.id.lieu);
			ev.time = (TextView)convertView.findViewById(R.id.time);
			ev.logo = (ImageView)convertView.findViewById(R.id.logo);
			ev.thumbnail = (ImageView)convertView.findViewById(R.id.thumbnail);
			convertView.setTag(ev);

		} else {
			ev = (EventView) convertView.getTag();
		}
		
		ev.group.setText(listEvent.get(position).getGroup());
		ev.title.setText(listEvent.get(position).getTitle());
		ev.lieu.setText(listEvent.get(position).getLieu());
		ev.time.setText(listEvent.get(position).getTime());
		/*try {
			SaveImageFromUrl.setImage(ev.logo,listEvent.get(position).getLogo());
		} catch (IOException e) {
			e.printStackTrace();
		}*/
		/*try {
			SaveImageFromUrl.setImage(ev.thumbnail,listEvent.get(position).getThumbnail());
		} catch (IOException e) {
			e.printStackTrace();
		}*/
		
		// thumbnail stocké pendant une semaine, logo stocké de manière infinie
		UrlImageViewHelper.setUrlDrawable(ev.thumbnail,listEvent.get(position).getThumbnail(),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_ONE_WEEK,null);
		UrlImageViewHelper.setUrlDrawable(ev.logo,listEvent.get(position).getLogo(),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE,null);
		
		return convertView;
	}

}
