package org.grandcercle.mobile;




import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.widget.TextView;


public class TabInfos extends Activity {
	private DataBase dataBase;
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.affichage_infos);
        String description ="Le Grand Cercle, c'est l'un des plus grands BDE de France, à votre service, pour vous offrir des moments inoubliables !<br /> <br /> Le GC, c'est une cinquantaine d'étudiants de toutes les écoles de Grenoble INP qui s'occupent d'organiser les plus gros événements de votre année : la soirée d'intégration, la soirée d'Automne, le Gala, et tant d'autres !<br /> <br /> Mais son rôle, c'est aussi d'assurer le lien entre les différentes écoles et BDE, les élus et les étudiants de Grenoble INP. N'hésitez pas à nous contacter pour toute information !<br /></p>";
        Spanned markedUp = Html.fromHtml(description);
        ((TextView)findViewById(R.id.description)).setText(markedUp);
	 }
	 
	 public void onResume() {
		super.onResume();
		int color = 0xFFFFFFFF;
		GCM.changeTabHost(color);
		GCM.oldchild = 3;
		View view = findViewById(R.id.bandeau1);
		color = 0xFF222222;
		view.setBackgroundColor(color);
		view = findViewById(R.id.bandeau2);
		view.setBackgroundColor(color);
	 }
}