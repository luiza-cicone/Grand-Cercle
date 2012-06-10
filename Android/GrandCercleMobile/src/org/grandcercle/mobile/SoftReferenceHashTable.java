package org.grandcercle.mobile;

import java.lang.ref.SoftReference;
import java.util.Hashtable;

/*
 * Références sur la table de hashage du cache des images
 * Permet d'ajouter et d'accéder aux données
 */

public class SoftReferenceHashTable<K,V> {
    Hashtable<K, SoftReference<V>> mTable = new Hashtable<K, SoftReference<V>>();
    
    public V put(K key, V value) {
        SoftReference<V> old = mTable.put(key, new SoftReference<V>(value));
        if (old == null)
            return null;
        return old.get();
    }
    
    public V get(K key) {
        SoftReference<V> val = mTable.get(key);
        if (val == null) {
            return null;
		}
        V ret = val.get();
        if (ret == null)
            mTable.remove(key);
        return ret;
    }
}
