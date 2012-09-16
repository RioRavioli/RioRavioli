/*
 * Rio Bacon
 * CSE 332
 * May 8th, 2012
 *
 * Hashtable is a special type of hashtable that stores data, and keeps track of the number
 * of times that the same value gets stored total. 
 */

import java.util.*;

public class Hashtable<E> implements DataCounter<E> {
	private DataCount<E>[] hashtable;
	private int size;
	private Queue<Integer> primeSizes;
	private Comparator<? super E> comparator;
	private Hasher<? super E> hasher;

	/*
	 * Constructs a new Hashtable, where key values are compared and hashed using the given
	 * comparator and hasher.
	 */
	public Hashtable(Comparator<? super E> c, Hasher<? super E> h) {
		primeSizes = new LinkedList<Integer>(Arrays.asList(11, 23, 47, 109, 211, 419, 1009, 
					2011, 4007, 8011, 16007, 32009, 64007, 120011, 240007, 480013, 960017, 
					1869169, 3647339, 7367197, 15484279, 32451169, 67866301, 141649087));
		hashtable = (DataCount<E>[]) new DataCount[primeSizes.remove()];
		size = 0;
		comparator = c;
		hasher = h;
	}

	/*
	 * Increments the count for the given data element. If it is not in the table, it is added
	 * to the table.
	 */
	public void incCount(E data){
		if (hashtable.length / 2 < size) {
			rehash();
		}
		int hashcode = hasher.hash(data);
		int probeCount = 0;
		while (true) {
			int index = (hashcode + probeCount * probeCount) % hashtable.length;
			if (hashtable[index] == null) {
				//hashtable at index is empty
				hashtable[index] = new DataCount<E>(data, 1); 
				size++;
				return;
			} else if (comparator.compare(hashtable[index].data, data) == 0) {
				//hashtable at index has same data
				hashtable[index].count++;
				return;
			} else {
				//hashtable at index has other data
				probeCount++;
			}
		}
	}

	/*
	 * Returns the size of the hashtable.
	 */
	public int getSize() {
		return size;
	}

	/*
	 * Returns the count of the given data element.
	 */
	public int getCount(E data) {
		int hashcode = hasher.hash(data);
		int probeCount = 0;
		while (true) {
			int index = (hashcode + probeCount * probeCount) % hashtable.length;
			if (hashtable[index] == null) {
				//hashtable at index is empty
				return 0;
			} else if (comparator.compare(hashtable[index].data, data) == 0) {
				//hashtable at index has same data
				return hashtable[index].count;
			} else {
				//hashtable at index has other data
				probeCount++;
			}
		}
	}

	/*
	 * Returns a SimpleIterator that iterates through this hashtable.
	 */
	public SimpleIterator<DataCount<E>> getIterator() {
		return new SimpleIterator<DataCount<E>>() {
			int index = 0;

			public boolean hasNext() {
				updateIndex();
				return index != hashtable.length;
			}

			public DataCount<E> next() {
				if (!hasNext()) {
					throw new java.util.NoSuchElementException();
				}
				DataCount<E> data = hashtable[index];
				index++;
				return data;
			}

			private void updateIndex() {
				while (index < hashtable.length && hashtable[index] == null) {
					index++;
				}	
			}
		};
	}

	//rehashes values to a larger hashtable.
	private void rehash(){
		DataCount<E>[] newHashtable = (DataCount<E>[]) new DataCount[primeSizes.remove()];
		SimpleIterator<DataCount<E>> iterator = getIterator(); 
		while (iterator.hasNext()) {
			DataCount<E> data = iterator.next();
			int hashcode = hasher.hash(data.data);
			int probeCount = 0;
			while (true) {
				int index = (hashcode + probeCount * probeCount) % newHashtable.length;
				if (newHashtable[index] == null) {
					//hashtable at index is empty
					newHashtable[index] = data;
					break;
				} else {
					//hashtable at index has other data
					probeCount++;
				}
			}
		}
		hashtable = newHashtable;
	}
}

