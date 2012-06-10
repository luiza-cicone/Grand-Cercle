package org.grandcercle.mobile;

import android.graphics.drawable.Drawable;
import android.widget.ImageView;

/*
 * Interface pour le cache des images
 */

public interface UrlImageViewCallback {
    void onLoaded(ImageView imageView, Drawable loadedDrawable, String url, boolean loadedFromCache);
}
