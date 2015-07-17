package tools;

import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 *  The IndexPairingMinPQ class represents an indexed priority queue of generic keys.
 *  It supports the usual insert and delete-the-minimum
 *  operations, along with delete and change-the-key 
 *  methods. In order to let the client refer to keys on the priority queue,
 *  an integer between 0 and NMAX-1 is associated with each key ; the client
 *  uses this integer to specify which key to delete or change.
 *  It also supports methods for peeking at the minimum key,
 *  testing if the priority queue is empty, and iterating through
 *  the keys.
 *  
 *  This implementation uses a child-sibling representation
 *  with another pointer which points either to the parent node or to the
 *  left sibling
 *  The delete-the-minimum operation is implemented with the two pass algorithm
 *  The delete-the-minimum, delete, change-key, and increase-key
 *  operations take amortized logarithmic time.
 *  The insert, decrease-key, is-empty, size, min-index, min-key, and key-of
 *  operations take constant time.
 *  
 *  Construction takes time proportional to the specified capacity.
 *  
 *  @author Tristan Claverie
 */

@SuppressWarnings("unchecked")
public class IndexPairingMinPQ<Key> implements Iterable<Integer> {
	private int size;							//Number of elements currently on the queue
	private Node<Key> head;						//Head of the queue
	private final Comparator<Key> comp;			//A Comparator over the keys
	private Node<Key>[] keys;					//Associates an index to a Node

	//Represents the nodes of the heap
	private class Node<Key> {
		Key key;					//Key stored in the node
		Node<Key> child, sibling;	//Child and sibling of this node
		Node<Key> previous;			//Either the parent or the left sibling, depending on the position of this node
		int index;					//Index associated with the key
		
		public Node(int i, Key k) {
			index = i;
			key = k;
		}
	}
	
	/**
     * Initializes an empty indexed priority queue with indices between 0 and NMAX-1
     * Worst case is O(n)
     * 
     * @param NMAX number of keys in the priority queue, index from 0 to NMAX-1
     * 
     * @throws java.util.IllegalArgumentException if N <= 0
     */
	public IndexPairingMinPQ(int NMAX) {
		if (NMAX <= 0) throw new IllegalArgumentException("Specified capacity must be strictly positive");
		comp = new MyComparator();
		keys = (Node<Key>[]) new Node[NMAX];
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
	public IndexPairingMinPQ(int NMAX, Comparator<Key> C) {
		if (NMAX <= 0) throw new IllegalArgumentException("Specified capacity must be strictly positive");
		if (C == null) throw new IllegalArgumentException("Specified Comparator must not be null");
		comp = C;
		keys = (Node<Key>[]) new Node[NMAX];
	}
	
	/**
	 * Number of elements currently on the priority queue
	 * Worst case is O(1)
	 * 
	 * @return the number of elements on the priority queue
	 */
	public int size() {
		return size;
	}
	
	/**
	 * Whether the priority queue is empty
	 * Worst case is O(1)
	 * 
	 * @return true if the priority queue is empty, false if not
	 */
	public boolean isEmpty() {
		return size==0;
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
		if(i < 0 || i >= keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		return keys[i] != null;
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
		if(i < 0 || i >= keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (!contains(i) ) throw new NoSuchElementException();
		return keys[i].key;
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
		if (head == null) throw new NoSuchElementException("Priority Queue is empty");
		return head.key;
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
		if (head == null) throw new NoSuchElementException("Priority Queue is empty");
		return head.index;
	}
	
	/**
	 * Associates a key with an index
	 * Worst case is O(1)
	 * 
	 * @param i an index
	 * @param key a Key associated with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.IllegalArgumentException if the index is already in the queue
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void insert(int i, Key k) {
		if (k == null) throw new IllegalArgumentException("Specified key must not be null");
		if (i < 0 || i > keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (contains(i)) throw new IllegalArgumentException("Index is already is the queue");
		Node<Key> insert = new Node<Key>(i, k);
		keys[i] = insert;
		head = meld(head, insert);
		size++;
	}
	
	/**
	 * Deletes the minimum key
	 * Worst case is O(log(n)) (amortized)
	 * 
	 * @throws java.util.NoSuchElementException if the priority queue is empty
	 * 
	 * @return the index associated with the minimum key
	 */
	public int delMin() {
		if (head == null) throw new NoSuchElementException("Priority Queue is empty");
		int min = head.index;
		keys[min] = null;
		head = mergePairs(head.child);
		if (head != null) head.previous = null;
		size--;
		return min;
	}
	
	/**
	 * Decreases the key associated with index i to the given key
	 * Worst case is O(1)
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the given key is greater than the current key
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void decreaseKey(int i, Key k) {
		if (k == null) throw new IllegalArgumentException("Specified key must not be null");
		if (i < 0 || i > keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (!contains(i)) throw new IllegalArgumentException("Specified index has no key associated with");
		if (comp.compare(keys[i].key, k) < 0) throw new IllegalArgumentException("Specified key is not stricly lower the the existing one");
		keys[i].key = k;
		if (head.index != i) {
			head = meld(head, cut(keys[i]));
		}
	}
	
	/**
	 * Increases the key associated with index i to the given key
	 * Worst case is O(log(n)) (amortized)
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the given key is lower than the current key
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void increaseKey(int i, Key k) {
		if (k == null) throw new IllegalArgumentException("Specified key must not be null");
		if (i < 0 || i > keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (!contains(i)) throw new IllegalArgumentException("Specified index has no key associated with");
		if (comp.compare(keys[i].key, k) > 0) throw new IllegalArgumentException("Specified key is not stricly greater the the existing one");
		delete(i);
		insert(i, k);
	}
	
	/**
	 * Changes the key associated with index i to the given key
	 * Worst case is O(log(n)) (amortized)
	 * 
	 * @param i an index
	 * @param key the key to associate with i
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the index has no key associated with
	 * @throws java.util.IllegalArgumentException if the key is null
	 */
	public void changeKey(int i, Key k) {
		if (k == null) throw new IllegalArgumentException("Specified key must not be null");
		if (i < 0 || i > keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (!contains(i)) throw new IllegalArgumentException("Specified index has no key associated with");
		if (comp.compare(k, keys[i].key) > 0) increaseKey(i, k);
		else 								  decreaseKey(i, k);
	}
	
	/**
	 * Deletes the key associated the given index
	 * Worst case is O(log(n)) (amortized)
	 * 
	 * @param i an index
	 * 
	 * @throws java.lang.IndexOutOfBoundsException if the specified index is invalid
	 * @throws java.util.NoSuchElementException if the given index has no key associated with
	 */
	public void delete(int i) {
		if (i < 0 || i > keys.length) throw new IndexOutOfBoundsException("Specified index is invalid");
		if (!contains(i)) throw new IllegalArgumentException("Specified index has no key associated with");
		if (head.index == i) head = null;
		head = meld(head, mergePairs(cut(keys[i]).child));
		if(head != null) head.previous = null;
		keys[i] = null;
		size--;
	}
	
	/*******************************
	 * General helper function
	 ******************************/
	
	//Compares two keys
	private boolean greater(Key k1, Key k2) {
		if (k1 == null) return false;
		if (k2 == null) return true;
		return comp.compare(k1, k2) > 0;
	}
	
	//Links two nodes together
	private Node<Key> meld(Node<Key> x, Node<Key> y) {
		if (x == null) return y;
		if (y == null) return x;
		return greater(x.key, y.key) ? link(y, x) : link(x, y);
	}
	
	//Two pass algorithm
	private Node<Key> mergePairs(Node<Key> x) {
		if (x == null) return null;
		if (x.sibling == null) return x;
		return meld(mergePairs(x.sibling.sibling), meld(x, x.sibling));
	}
	
	//Assuming the child holds a greater key than root,
	//the root becomes the parent of the child
	private Node<Key> link(Node<Key> root, Node<Key> child) {
		child.sibling = root.child;
		if (root.child != null) root.child.previous = child;
		root.child = child;
		child.previous = root;
		return root;
	}
	
	//Removes the specified node from the list it belongs to
	//and returns its
	private Node<Key> cut(Node<Key> toCut) {
		if (toCut.previous == null) return toCut;
		if (toCut.sibling != null) toCut.sibling.previous = toCut.previous;
		if (toCut.previous.child == toCut) {
			toCut.previous.child = toCut.sibling;
		} else {
			toCut.previous.sibling = toCut.sibling;
		}
		return toCut;
	}
	
	/*******************************
	 * Iterator
	 ******************************/

	@Override
	public Iterator<Integer> iterator() {
		return new MyIterator();
	}
	
	/**
     * Returns an iterator that iterates over the keys on the priority queue
     * in ascending order and returns the indexes associated with.
     * The iterator doesn't implement remove() since it's optional.
     * iterator() : Worst case is O(n)
	 * next() : 	Worst case is O(log(n)) (amortized)
	 * hasNext() : 	Worst case is O(1)
	 * 
     * @return an iterator that iterates over the keys in ascending order
     */
	private class MyIterator implements Iterator<Integer> {
		IndexPairingMinPQ<Key> copy;
		
		public MyIterator() {
			copy = new IndexPairingMinPQ<Key>(keys.length, comp);
			for (Node<Key> node : keys) {
				if (node != null) copy.insert(node.index, node.key); 
			}
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
	
	/*******************************
	 * Comparator
	 ******************************/
	
	//default Comparator
	private class MyComparator implements Comparator<Key> {
		@Override
		public int compare(Key key1, Key key2) {
			return ((Comparable<Key>) key1).compareTo(key2);
		}
	}

}
