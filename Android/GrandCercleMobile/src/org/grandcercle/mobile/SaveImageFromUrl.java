package org.grandcercle.mobile;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.ImageView;



public class SaveImageFromUrl {
	
	public static ImageView setImage(ImageView view, String url) throws IOException {
		final URLConnection conn = new URL(url).openConnection();
		conn.connect();
		final InputStream is = conn.getInputStream();
	 
		final BufferedInputStream bis = new BufferedInputStream(is, 100000);
	 
		final Bitmap bm = BitmapFactory.decodeStream(bis);
		bis.close();
		is.close();
		view.setImageBitmap(bm);
		return view;
	}

}