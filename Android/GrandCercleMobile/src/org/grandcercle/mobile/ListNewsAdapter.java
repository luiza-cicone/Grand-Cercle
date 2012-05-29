package org.grandcercle.mobile;

import java.util.ArrayList;
import org.grandcercle.mobile.R;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ListNewsAdapter extends BaseAdapter {

	// les données à afficher
	private ArrayList<News> listNews;
	
	/* Le LayoutInflater permet de parser un layout XML et de 
	 * le transcoder en IHM Android. Pour respecter la classe 
	 * BaseAdapter
	 */
	private LayoutInflater inflater;
	
	public ListNewsAdapter(Context context,ArrayList<News> listNews) {
		inflater = LayoutInflater.from(context);
		this.listNews = listNews;
	}
	
	/* il nous faut spécifier la méthode "getCount()". 
	 * Cette méthode permet de connaître le nombre d'items présent 
	 * dans la liste. Dans notre cas, il faut donc renvoyer le nombre
	 * de personnes contenus dans "mListP".
	 */
	public int getCount() {
		return listNews.size();
	}

	// Permet de retourner un objet contenu dans la liste
	public News getItem(int index) {
		return listNews.get(index);
	}

	public long getItemId(int index) {
		return this.listNews.get(index).getId();
		
	}
	
	/* Le paramètre "convertView" permet de recycler les élements 
	 * de notre liste. En effet, l'opération pour convertir un layout 
	 * XML en IHM standard est très couteuse pour la plateforme Android. 
	 * On nous propose ici de réutiliser des occurences créées qui ne sont 
	 * plus affichées. Donc si ce paramètre est "null" alors, il faut "inflater" 
	 * notre layout XML, sinon on le réutilise
	 */
	public View getView(int position, View convertView, ViewGroup parent){
		NewsView nv;		
		
		if (convertView == null) {
			nv = new NewsView();
			convertView = inflater.inflate(R.layout.list_news, null);

			nv.title = (TextView)convertView.findViewById(R.id.title);
			nv.pubDate = (TextView)convertView.findViewById(R.id.pub_date);
			nv.logo = (ImageView)convertView.findViewById(R.id.logo);
			convertView.setTag(nv);

		} else {
			nv = (NewsView)convertView.getTag();
		}						
		nv.pubDate.setText(listNews.get(position).getPubDate());
		nv.title.setText(listNews.get(position).getTitle());
		/*try {
			SaveImageFromUrl.setImage(nv.logo,listNews.get(position).getLogo());
		} catch (IOException e) {
			e.printStackTrace();
		}*/
		
		// logo stocké dans le cache pour une durée infinie
		UrlImageViewHelper.setUrlDrawable(nv.logo,listNews.get(position).getLogo(),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
		return convertView;
	}

}
