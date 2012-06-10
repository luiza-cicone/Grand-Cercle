package org.grandcercle.mobile;

import android.graphics.drawable.Drawable;

/*
 * Singleton représentant la table de hashage pour le cache des images
 */

public final class UrlImageCache extends SoftReferenceHashTable<String, Drawable> {

    private static UrlImageCache mInstance = new UrlImageCache();
    
    public static UrlImageCache getInstance() {
        return mInstance;
    }
    
    private UrlImageCache() {}
}
