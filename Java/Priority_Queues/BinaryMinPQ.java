package tools;

import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 *  The BinaryMinPQ class represents a priority queue of generic keys.
 *  It supports the usual insert and delete-the-minimum
 *  operations, along with methods for peeking at the minimum key,
 *  testing if the priority queue is empty, and iterating through
 *  the keys.
 *  
 *  This implementation uses a binary heap. All operations are using half exchanges,
 *  in order to reduce the number of memory access
 *  The insert and delete-the-minimum operations take
 *  logarithmic time.
 *  The min, size, and is-empty operations take constant time.
 *  Construction takes time proportional to the specified capacity or the number of
 *  items used to initialize the data structure.
 *
 *  @author Tristan Claverie
 */
@SuppressWarnings("unchecked")
public class BinMinPQ<Key> implements Iterable<Key> {
	private int N;							// Number of elements currently on the queue
	private Key[] pq;						// Array storing the Priority Queue
	private final Comparator<Key> comp;		// A Comparator over the keys
	
	/**
	 * Constructs an empty Priority Queue
	 */
	public BinMinPQ() {
		pq = (Key[]) new Object[2];
		comp = new MyComparator();
	}
	
	/**
	 * Constructs an empty Priority Queue with the given Comparator
	 * 
	 * @param C a Comparator over the keys
	 */
	public BinMinPQ(Comparator<Key> C) {
		pq = (Key[]) new Object[2];
		comp = C;
	}
	
	/**
	 * Initializes a Priority Queue with the specified array
	 * 
	 * @param a an array of Keys
	 */
	public BinMinPQ(Key[] a) {
		N = a.length;
		comp = new MyComparator();
		pq = (Key[]) new Object[N+1];
		for(int i = 0; i < N; pq[i+1] = a[i++]);
		for(int i = N>>1; i > 0; sink(i--));
	}
	
	/**
	 * Initializes a Priority Queue with the specified array and a Comparator
	 * 
	 * @param C a Comparator over the keys
	 * @param a an array of Keys
	 */
	public BinMinPQ(Comparator<Key> C, Key[] a) {
		N = a.length;
		comp = C;
		pq = (Key[]) new Object[N+1];
		for(int i = 0; i < N; pq[i+1] = a[i++]);
		for(int i = N>>1; i > 0; sink(i--));
	}
	
	/**
     * Is the priority queue empty?
     * 
     * @return true if the priority queue is empty; false otherwise
     */
	public boolean isEmpty() {
		return N==0;
	}
	
	/**
     * Returns the number of keys on the priority queue.
     * 
     * @return the number of keys on the priority queue
     */
	public int size() {
		return N;
	}
	
	/**
     * Returns a smallest key on the priority queue.
     * 
     * @return a smallest key on the priority queue
     * 
     * @throws java.util.NoSuchElementException if priority queue is empty
     */
	public Key minKey() {
		if (isEmpty()) throw new NoSuchElementException("Priority Queue is empty");
		return pq[1];
	}
	
	/**
     * Adds a new key to the priority queue.
     * 
     * @param key the key to add to the priority queue
     * 
     * @throws java.util.IllegalArgumentException if the key is null
     */
	public void insert(Key key) {
		if (key == null) throw new IllegalArgumentException("Can't insert a null key");
		if (N+1 == pq.length) resize(N<<1);
		pq[++N] = key;
		swim(N);
	}
	
	/**
     * Removes and returns a smallest key on the priority queue.
     * 
     * @return the smallest key on the priority queue
     * 
     * @throws java.util.NoSuchElementException if the priority queue is empty
     */
	public Key delMin() {
		if (isEmpty()) throw new NoSuchElementException("Priority Queue is empty");
		Key k = pq[1];
		pq[1] = pq[N];
		pq[N--] = null;
		int leaf = sinkAll(1);
		swim(leaf);
		if (N == (pq.length-1)>>2 && N != 0) resize(N<<1);
		return k;
	}
	
	/*******************************
	 * General helper function
	 ******************************/
	
	//Compares two keys
	private boolean greater(int i, int j) {
		if (pq[i] == null) return true;
		if (pq[j] == null) return false;
		return comp.compare(pq[i], pq[j]) > 0;
	}
	
	/*******************************
	 * Functions for moving downward and upward
	 ******************************/
	
	//Moves a key upward
	private void swim(int i) {
		Key k = pq[i];
		while(i > 1 && comp.compare(k, pq[i>>1]) < 0) {
			pq[i] = pq[i>>1];
			i = i>>1;
		}
		pq[i] = k;
	}
	
	//Moves a key downward
	private void sink(int i) {
		int j = i;
		Key k = pq[i];
		while(i <= N>>1) {
			j = i<<1;
			if (j < N && greater(j, j+1)) j++;
			if (comp.compare(pq[j], k) > 0) break;
			pq[i] = pq[j];
			i = j;
		}
		pq[i] = k;
	}
	
	//Moves a key all the way to a leaf and returns the index of the leaf
	private int sinkAll(int i) {
		int j;
		Key k = pq[i];
		while(i <= N>>1) {
			j = i<<1;
			if (greater(j, j+1)) j++;
			pq[i] = pq[j];
			i = j;
		}
		pq[i] = k;
		return i;
	}
	
	/*******************************
	 * Function for maintaining the array of keys
	 ******************************/
	
	//Resizes the array to the specified capacity
	private void resize(int n) {
		Key[] array = (Key[]) new Object[n+1];
		for(int i = 1; i <= N; array[i] = pq[i++]);
		pq = array;
	}
	
	/*******************************
	 * Iterator
	 ******************************/
	
	/**
     * Returns an iterator that iterates over the keys on the priority queue
     * in ascending order.
     * The iterator doesn't implement remove() since it's optional.
     * iterator() : Worst case is O(n)
	 * next() : 	Worst case is O(log(n))
	 * hasNext() : 	Worst case is O(1)
	 * 
     * @return an iterator that iterates over the keys in ascending order
     */
	@Override
	public Iterator<Key> iterator() {
		return new MyIterator();
	}
	
	private class MyIterator implements Iterator<Key> {
		BinMinPQ<Key> copy;
		
		public MyIterator() {
			copy = new BinMinPQ<>(comp);
			Key[] array = (Key[]) new Object[N+1];
			for (int i = 1; i <= N; array[i] = pq[i++]);
			copy.N = N;
			copy.pq = array;
		}
		
		@Override
		public boolean hasNext() {
			return !copy.isEmpty();
		}
		
		@Override
		public Key next() {
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
