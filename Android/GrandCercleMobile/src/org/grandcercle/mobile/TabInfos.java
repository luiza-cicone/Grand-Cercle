package org.grandcercle.mobile;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.TextView;

/*
 * Onglet des infos
 */

public class TabInfos extends Activity {
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Récupération du layout xml
        setContentView(R.layout.affichage_infos);
        String description ="Le Grand Cercle, c'est l'un des plus grands BDE de France, à votre service, pour vous offrir des moments inoubliables !<br /> <br /> Le GC, c'est une cinquantaine d'étudiants de toutes les écoles de Grenoble INP qui s'occupent d'organiser les plus gros événements de votre année : la soirée d'intégration, la soirée d'Automne, le Gala, et tant d'autres !<br /> <br /> Mais son rôle, c'est aussi d'assurer le lien entre les différentes écoles et BDE, les élus et les étudiants de Grenoble INP. N'hésitez pas à nous contacter pour toute information !<br /></p>";
        // Conversion du langage html en texte
        Spanned markedUp = Html.fromHtml(description);
        ((TextView)findViewById(R.id.description)).setText(markedUp);
	 }
	 
	 public void onResume() {
		super.onResume();
		GCM.changeTabHost();
		GCM.oldchild = 3;
		View view = findViewById(R.id.bandeau1);
		int color = 0xFF3B3B3B;
		// On grise le bandeau 1
		view.setBackgroundColor(color);
		view = findViewById(R.id.bandeau2);
		// On grise le bandeau 2
		view.setBackgroundColor(color);
	 }
}