package org.grandcercle.mobile;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ListBPAdapter extends BaseAdapter {

	// les données à afficher
	private ArrayList<BP> listBP;
	
	/* Le LayoutInflater permet de parser un layout XML et de 
	 * le transcoder en IHM Android. Pour respecter la classe 
	 * BaseAdapter
	 */
	private LayoutInflater inflater;
	
	public ListBPAdapter(Context context,ArrayList<BP> listBP) {
		inflater = LayoutInflater.from(context);
		this.listBP = listBP;
	}
	
	/* il nous faut spécifier la méthode "getCount()". 
	 * Cette méthode permet de connaître le nombre d'items présent 
	 * dans la liste. Dans notre cas, il faut donc renvoyer le nombre
	 * de personnes contenus dans "mListP".
	 */
	public int getCount() {
		return listBP.size();
	}

	// Permet de retourner un objet contenu dans la liste
	public BP getItem(int index) {
		return listBP.get(index);
	}

	public long getItemId(int index) {
		return this.listBP.get(index).getId();
		
	}
	
	/* Le paramètre "convertView" permet de recycler les élements 
	 * de notre liste. En effet, l'opération pour convertir un layout 
	 * XML en IHM standard est très couteuse pour la plateforme Android. 
	 * On nous propose ici de réutiliser des occurences créées qui ne sont 
	 * plus affichées. Donc si ce paramètre est "null" alors, il faut "inflater" 
	 * notre layout XML, sinon on le réutilise
	 */
	public View getView(int position, View convertView, ViewGroup parent){
		BPView bpv;		
		
		if (convertView == null) {
			bpv = new BPView();
			convertView = inflater.inflate(R.layout.cell_bons_plans,null);

			bpv.title = (TextView)convertView.findViewById(R.id.title);			
			bpv.description = (TextView)convertView.findViewById(R.id.description);
			bpv.image = (ImageView)convertView.findViewById(R.id.image);
			convertView.setTag(bpv);

		} else {
			bpv = (BPView)convertView.getTag();
		}
		
		bpv.title.setText(listBP.get(position).getTitle());
		bpv.description.setText(listBP.get(position).getDescription());
		// image stockée infiniement, car BP ont une grande durée de vie
		UrlImageViewHelper.setUrlDrawable(bpv.image,listBP.get(position).getImage(),R.drawable.loading,UrlImageViewHelper.CACHE_DURATION_INFINITE);
		
		return convertView;
	}

}
