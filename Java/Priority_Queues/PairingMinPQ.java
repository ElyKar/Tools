package tools;

import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;


/**
 *  The PairingMinPQ class represents a priority queue of generic keys.
 *  It supports the usual insert and delete-the-minimum
 *  operations, along with methods for peeking at the minimum key,
 *  testing if the priority queue is empty, and iterating through
 *  the keys.
 *  
 *  This implementation uses a binary tree representation with two pointers.
 *  The delete-the-minimum operations take amortized logarithmic time.
 *  The insert, min, size, and is-empty operations take constant time.
 *  Construction takes time proportional to the number of
 *  items used to initialize the data structure.
 *
 *  @author Tristan Claverie
 */

public class PairingMinPQ<Key> implements Iterable<Key> {
	private Node head;						//Head of the Priority Queue
	private int size;						//Number of elements currently on the queue
	private final Comparator<Key> comp;		//A Comparator over the keys
	
	//Represents a Node of the heap
	private class Node {
		Key key;							//Key stored in this node
		Node child, sibling;				//Child and sibling of this node
	}
	
	/**
	 * Constructs an empty Priority Queue
	 * Worst case is O(1)
	 */
	public PairingMinPQ() {
		comp = new MyComparator();
	}
	
	/**
	 * Constructs an empty Priority Queue with the given Comparator
	 * Worst case is O(1)
	 * 
	 * @param C a Comparator over the keys
	 */
	public PairingMinPQ(Comparator<Key> C) {
		comp = C;
	}
	
	/**
	 * Initializes a Priority Queue with the specified array
	 * Worst case is O(n)
	 * 
	 * @param a an array of Keys
	 */
	public PairingMinPQ(Key[] a) {
		comp = new MyComparator();
		for (Key k : a) insert(k);
	}
	
	/**
	 * Initializes a Priority Queue with the specified array and a Comparator
	 * Worst case is O(n)
	 * 
	 * @param C a Comparator over the keys
	 * @param a an array of Keys
	 */
	public PairingMinPQ(Comparator<Key> C, Key[] a) {
		comp = C;
		for (Key k : a) insert(k);
	}
	
	/**
     * Is the priority queue empty?
     * Worst case is O(1)
     * 
     * @return true if the priority queue is empty; false otherwise
     */
	public boolean isEmpty() {
		return size==0;
	}
	
	/**
     * Returns the number of keys on the priority queue.
     * Worst case is O(1)
     * 
     * @return the number of keys on the priority queue
     */
	public int size() {
		return size;
	}
	
	/**
     * Returns a smallest key on the priority queue.
     * Worst case is O(1)
     * 
     * @return a smallest key on the priority queue
     * 
     * @throws java.util.NoSuchElementException if priority queue is empty
     */
	public Key minKey() {
		if (isEmpty()) throw new NoSuchElementException();
		return head.key;
	}
	
	/**
     * Adds a new key to the priority queue.Worst case is O(1)
     * 
     * @param key the key to add to the priority queue
     * 
     * @throws java.util.IllegalArgumentException if the key is null
     */
	public void insert(Key k) {
		if (k == null) throw new IllegalArgumentException("Given key mut not be null");
		Node insert = new Node();
		insert.key = k;
		head = meld(head, insert);
		size++;
	}
	
	/**
     * Removes and returns a smallest key on the priority queue.
     * Worst case is O(log(n)) (amortized)
     * 
     * @return the smallest key on the priority queue
     * 
     * @throws java.util.NoSuchElementException if the priority queue is empty
     */
	public Key delMin() {
		if (isEmpty()) throw new NoSuchElementException();
		Key min = head.key;
		head = mergePairs(head.child);
		size--;
		return min;
	}
	
	/**
	 * Merges two heap together and returns the result.
	 * The two heaps are destroyed in the process.
	 * Worst case is O(1)
	 * 
	 * @param that a Pairing heap
	 * 
	 * @return the union of the two heaps
	 * 
	 * @throws java.util.IllegalArgumentException if the heap is null
	 */
	public PairingMinPQ<Key> union(PairingMinPQ<Key> that) {
		if (that == null) throw new IllegalArgumentException();
		this.head = meld(this.head, that.head);
		this.size += that.size;
		return this;
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
	private Node meld(Node x, Node y) {
		if (x == null) return y;
		if (y == null) return x;
		return greater(x.key, y.key) ? link(y, x) : link(x, y);
	}
	
	//Two-pass algorithm
	private Node mergePairs(Node x) {
		if (x == null) return null;
		if (x.sibling == null) return x;
		return meld(mergePairs(x.sibling.sibling), meld(x, x.sibling));
	}
	
	//Assuming the child holds a greater key than root,
	//the root becomes the parent of the child
	private Node link(Node root, Node child) {
		child.sibling = root.child;
		root.child = child;
		return root;
	}

	/*******************************
	 * Iterator
	 ******************************/
	
	/**
     * Returns an iterator that iterates over the keys on the priority queue
     * in ascending order.
     * The iterator doesn't implement remove() since it's optional.
     * iterator() : Worst case is O(n)
	 * next() : 	Worst case is O(log(n)) (amortized)
	 * hasNext() : 	Worst case is O(1)
	 * 
     * @return an iterator that iterates over the keys in ascending order
     */
	@Override
	public Iterator<Key> iterator() {
		return new MyIterator();
	}
	
	private class MyIterator implements Iterator<Key> {
		PairingMinPQ<Key> copy;
		
		public MyIterator() {
			copy = new PairingMinPQ<>(comp);
			copy.head = clone(head);
		}
		
		private Node clone(Node x) {
			if (x == null) return null;
			Node node = new Node();
			node.key = x.key;
			node.sibling = clone(x.sibling);
			node.child = clone(x.child);
			return node;
		}
		
		public boolean hasNext() {
			return !copy.isEmpty();
		}
		
		public Key next() {
			return copy.delMin();
		}
		
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
			return ((Comparable<Key>) key1).compareTo(key2);
		}
	}

}
