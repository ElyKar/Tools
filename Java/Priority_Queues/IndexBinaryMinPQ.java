package tools;

import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 *  The IndexBinaryMinPQ class represents an indexed priority queue of generic keys.
 *  It supports the usual insert and delete-the-minimum
 *  operations, along with delete and change-the-key 
 *  methods. In order to let the client refer to keys on the priority queue,
 *  an integer between 0 and NMAX-1 is associated with each key ; the client
 *  uses this integer to specify which key to delete or change.
 *  It also supports methods for peeking at the minimum key,
 *  testing if the priority queue is empty, and iterating through
 *  the keys.
 *  
 *  This implementation uses a binary heap along with an array to associate
 *  keys with integers in the given range. All operations are using half exchanges,
 *  in order to reduce the number of memory access.
 *  The insert, delete-the-minimum, delete,
 *  change-key, decrease-key, and increase-key
 *  operations take logarithmic time.
 *  The is-empty, size, min-index, min-key, and key-of
 *  operations take constant time.
 *  
 *  Construction takes time proportional to the specified capacity.
 *  If an array is given, construction takes linearithmic time.
 *  
 *  @author Tristan Claverie
 */

@SuppressWarnings("unchecked")
public class IndexBinaryMinPQ<Key> implements Iterable<Integer> {
	private int N; 							//Number of elements currently in the queue
	private int NMAX;						//Maximum number of elements in the queue
	private Key[] keys;						//Array of keys
	private int[] pq;						//Array representing the Priority Queue
	private int[] qp;						//qp[pq[i]] = pq[qp[i]] = i
	private final Comparator<Key> comp;		//Comparator over the keys
	
	
	/**
     * Initializes an empty indexed priority queue with indices between 0 and NMAX-1
     * Worst case is O(n)
     * 
     * @param NMAX number of keys in the priority queue, index from 0 to NMAX-1
     * 
     * @throws java.util.IllegalArgumentException if N <= 0
     */
	public IndexBinaryMinPQ(int NMAX) {
		if (NMAX <= 0) throw new IllegalArgumentException("Size of the Priority Queue must be stricly superior to 0");
		this.NMAX = NMAX;
		comp = new MyComparator();
		keys = (Key[]) new Object[NMAX+1];
		pq = new int[NMAX+1];
		qp = new int[NMAX+1];
		for (int i = 1; i <= NMAX; i++) {
			qp[i] = -1;
		}
	}
	
	/**
     * Initializes an empty indexed priority queue with indices between 0 and NMAX-1
     * Worst case is O(n)
     * 
     * @param NMAX number of keys in the priority queue, index from 0 to NMAX-1
     * @param C a Comparator over the keys
     * 
     * @throws java.util.IllegalArgumentException if NMAX <= 0
     * @throws java.util.IllegalArgumentException if C is null
     */
	public IndexBinaryMinPQ(int NMAX, Comparator<Key> C) {
		if (NMAX <= 0) throw new IllegalArgumentException("Size of the Priority Queue must be stricly superior to 0");
		if (C == null) throw new IllegalArgumentException("Comparator must be not null");
		this.NMAX = NMAX;
		comp = C;
		keys = (Key[]) new Object[NMAX+1];
		pq = new int[NMAX+1];
		qp = new int[NMAX+1];
		for (int i = 1; i <= NMAX; i++) {
			pq[i] = -1;
		}
	}
	
	/**
     * Initializes an empty indexed priority queue with indices between 0 and NMAX-1
     * Worst case is O(nlog(n))
     * 
     * @param NMAX number of keys in the priority queue, index from 0 to NMAX-1
     * @param a an array of keys
     * 
     * @throws java.util.IllegalArgumentException if NMAX <= 0
     * @throws java.util.IllegalArgumentException if a is null
     * @throws java.util.IllegalArgumentException if a.length > NMAX
     */
	public IndexBinaryMinPQ(int NMAX, Key[] a) {
		if (NMAX <= 0) throw new IllegalArgumentException("Size of the Priority Queue must be stricly superior to 0");
		if (a == null) throw new IllegalArgumentException("Array must not be null");
		if (a.length > NMAX) throw new IllegalArgumentException("Can't insert more elements than the specified size of the Priority Queue");
		this.NMAX = NMAX;
		comp = new MyComparator();
		keys = (Key[]) new Object[NMAX+1];
		pq = new int[NMAX+1];
		qp = new int[NMAX+1];
		for (int i = 1; i <= NMAX; i++) {
			pq[i] = -1;
		}
		for (int i = 0; i < a.length; i++) {
			insert(i, a[i]);
		}
	}
	
	/**
     * Initializes an empty indexed priority queue with indices between 0 and NMAX-1
     * Worst case is O(nlog(n))
     * 
     * @param NMAX number of keys in the priority queue, index from 0 to NMAX-1
     * @param a an array of keys
     * @param C a Comparator over the keys
     * 
     * @throws java.util.IllegalArgumentException if NMAX <= 0
     * @throws java.util.IllegalArgumentException if a is null
     * @throws java.util.IllegalArgumentException if C is null
     * @throws java.util.IllegalArgumentException if a.length > NMAX
     */
	public IndexBinaryMinPQ(int NMAX, Key[] a, Comparator<Key> C) {
		if (NMAX <= 0) throw new IllegalArgumentException("Size of the Priority Queue must be stricly superior to 0");
		if (a == null) throw new IllegalArgumentException("Array must not be null");
		if (a.length > NMAX) throw new IllegalArgumentException("Can't insert more elements than the specified size of the Priority Queue");
		if (C == null) throw new IllegalArgumentException("Comparator must not be null");
		this.NMAX = NMAX;
		comp = C;
		keys = (Key[]) new Object[NMAX+1];
		pq = new int[NMAX+1];
		qp = new int[NMAX+1];
		for (int i = 1; i <= NMAX; i++) {
			pq[i] = -1;
		}
		for (int i = 0; i < a.length; i++) {
			insert(i, a[i]);
		}
	}
	
	/**
	 * Number of elements currently on the priority queue
	 * Worst case is O(1)
	 * 
	 * @return the number of elements on the priority queue
	 */
	public int size() {
		return N;
	}
	
	/**
	 * Whether the priority queue is empty
	 * Worst case is O(1)
	 * 
	 * @return true if the priority queue is empty, false if not
	 */
	public boolean isEmpty() {
		return N==0;
	}
	
	/**
	 * Get the key associated with index i
	 * Worst case is O(1)
	 * 
	 * @param i an index
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index is not in the queue
	 * 
	 * @return the key associated with index i
	 */
	public Key keyOf(int i) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Given index not in range");
		if (!contains(i)) throw new NoSuchElementException("Given index is not in the queue");
		return keys[i];
	}
	
	/**
	 * Get the index associated with the minimum key
	 * Worst case is O(1)
	 * 
	 * @throws java.util.NoSuchElementException if the priority queue is empty
	 * 
	 * @return the index associated with the minimum key
	 */
	public int minIndex() {
		if (isEmpty()) throw new NoSuchElementException("Priority Queue is empty");
		return pq[1];
	}
	
	/**
	 * Get the minimum key currently in the queue
	 * Worst case is O(1)
	 * 
	 * @throws java.util.NoSuchElementException if the priority queue is empty
	 * 
	 * @return the minimum key currently in the priority queue
	 */
	public Key minKey() {
		if (isEmpty()) throw new NoSuchElementException("Priority Queue is empty");
		return keys[pq[1]];
	}
	
	/**
	 * Does the priority queue contains the index i ?
	 * Worst case is O(1)
	 * 
	 * @param i an index
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * 
	 * @return true if i is on the priority queue, false if not
	 */
	public boolean contains(int i) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Given index not in range");
		return keys[i] != null;
	}
	
	/**
	 * Associates a key with an index
	 * Worst case is O(log(n))
	 * 
	 * @param i an index
	 * @param key a Key associated with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.IllegalArgumentException if the index is already in the queue
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void insert(int i, Key key) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Given index not in range");
		if (contains(i)) throw new IllegalArgumentException("Index already in the Priority Queue");
		if (key == null) throw new IllegalArgumentException("Given key must not be null");
		keys[i] = key;
		qp[i] = ++N;
		pq[N] = i;
		swim(N, i);
	}
	
	/**
	 * Deletes the minimum key
	 * Worst case is O(log(n))
	 * 
	 * @throws java.util.NoSuchElementException if the priority queue is empty
	 * 
	 * @return the index associated with the minimum key
	 */
	public int delMin() {
		if (N==0) throw new NoSuchElementException("Priority Queue is empty");
		int min = pq[1];
		pq[1] = pq[N--];
		qp[pq[1]] = 1;
		int leaf = sinkAll(1, pq[1]);
		swim(leaf, pq[leaf]);
		qp[min] = -1;
		keys[min] = null;
		return min;
	}
	
	/**
	 * Deletes the key associated the given index
	 * Worst case is O(log(n))
	 * 
	 * @param i an index
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the given index has no key associated with
	 */
	public void delete(int i) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Given index not in range");
		if (!contains(i)) throw new NoSuchElementException("Given index not in the Priority Queue");
		int idx = qp[i];
		pq[idx] = pq[N--];
		qp[pq[idx]] = idx;
		int leaf = sinkAll(idx, pq[idx]);
		swim(leaf, pq[leaf]);
		qp[i] = -1;
		keys[i] = null;
	}
	
	/**
	 * Decreases the key associated with index i to the given key
	 * Worst case is O(log(n))
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the given key is greater than the current key
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void decreaseKey(int i, Key key) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Index not in range");
		if (!contains(i)) throw new NoSuchElementException("Index not in the Priority Queue");
		if (key == null) throw new IllegalArgumentException("Key must not be null");
		if (comp.compare(key, keys[i]) > 0) throw new IllegalArgumentException("Key should be stricly lower than the exisiting ont when calling decreaseKey()");
		keys[i] = key;
		swim(qp[i], i);
	}
	
	/**
	 * Increases the key associated with index i to the given key
	 * Worst case is O(log(n))
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the given key is lower than the current key
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void increaseKey(int i, Key key) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Index not in range");
		if (!contains(i)) throw new NoSuchElementException("Index not in the Priority Queue");
		if (key == null) throw new IllegalArgumentException("Key must not be null");
		if (comp.compare(key, keys[i]) > 0) throw new IllegalArgumentException("Key should be stricly greater than the exisiting ont when calling increaseKey()");
		keys[i] = key;
		int leaf = sinkAll(qp[i], i);
		swim(leaf, i);
	}
	
	/**
	 * Changes the key associated with index i to the given key
	 * Worst case is O(log(n))
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void changeKey(int i, Key key) {
		if (i < 0 || i > NMAX) throw new IndexOutOfBoundsException("Index not in range");
		if (!contains(i)) throw new  NoSuchElementException("Index not in the Priority Queue");
		if (key == null) throw new IllegalArgumentException("Key must not be null");
		Key k = keys[i];
		keys[i] = key;
		int leaf = qp[i];
		if (comp.compare(key, k) > 0) leaf = sinkAll(qp[i], i);
		swim(leaf, pq[leaf]);
	}
	
	/*************************************
	 * General helper function
	 ************************************/
	
	private boolean greater(int i, int j) {
		return comp.compare(keys[i], keys[j]) > 0;
	}
	
	/*************************************
	 * Functions for moving upward and downward
	 ************************************/
	
	//Moves a key upward
	private void swim(int i, int pos) {
		while(i > 1 && greater(pq[i>>1], pos)) {
			pq[i] = pq[i>>1];
			qp[pq[i]] = i;
			i = i>>1;
		}
		pq[i] = pos;
		qp[pos] = i;
	}
	
	//Moves a key all the key to a leaf and returns the position of the leaf
	private int sinkAll(int i, int pos) {
		int j = 0;
		while(i <= N>>1) {
			j = i<<1;
			if (greater(pq[j], pq[j+1])) j++;
			pq[i] = pq[j];
			qp[pq[i]] = i;
			i = j;
		}
		pq[i] = pos;
		qp[pos] = i;
		return i;
	}

	/*************************************
	 * Iterator
	 ************************************/
	
	/**
	 * Get an Iterator over the indexes in the priority queue in ascending order
	 * The Iterator does not implement the remove() method
	 * iterator() : Worst case is O(n)
	 * next() : 	Worst case is O(log(n))
	 * hasNext() : 	Worst case is O(1)
	 * 
	 * @return an Iterator over the indexes in the priority queue in ascending order
	 */
	@Override
	public Iterator<Integer> iterator() {
		return new MyIterator();
	}
	
	private class MyIterator implements Iterator<Integer> {
		IndexBinaryMinPQ<Key> copy;
		
		//Constructor takes linear time
		public MyIterator() {
			copy = new IndexBinaryMinPQ<>(NMAX, comp);
			copy.N = N;
			int[] iqp = new int[N+1];
			int[] ipq = new int[N+1];
			Key[] ikeys = (Key[]) new Object[N+1];
			for (int i = 0; i <= N; i++) {
				iqp[i] = qp[i];
				ipq[i] = pq[i];
				ikeys[i] = keys[i];
			}
			copy.pq = ipq;
			copy.qp = iqp;
			copy.keys = ikeys;
		}
		
		@Override
		public boolean hasNext() {
			return !copy.isEmpty();
		}
		
		@Override
		public Integer next() {
			return copy.delMin();
		}
		
		@Override
		public void remove() {
			throw new UnsupportedOperationException();
		}
	}
	
	/***************************
	 * Comparator
	 **************************/
	
	//default Comparator
	private class MyComparator implements Comparator<Key> {
		@Override
		public int compare(Key key1, Key key2) {
			return ((Comparable<Key>)key1).compareTo(key2);
		}
	}

}
