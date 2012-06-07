package org.grandcercle.mobile;




import android.app.Activity;
import android.os.Bundle;


public class Tab4 extends Activity {
	 @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tab4);
	 }
	 
	 public void onResume() {
		super.onResume();
		int color = 0xFFFFFFFF;
		GCM.changeTabHost(color);
		GCM.oldchild = 3;
	 }
}