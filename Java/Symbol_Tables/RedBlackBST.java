package main;

/**
 * RedBlackBST class implements a lightweight version of
 * a standard red-black BST.
 * It supports the methods get, put and delete in O(log N)
 * worst-case time.
 * 
 * The nodes are implemented using an array of childs and a color,
 * there is no such thing as a parent pointer.
 * This is pimarily Julienne Walker's structure on eternallyconfuzzled.com,
 * which I used in order to improve the implementation of deletion.
 * 
 * The get method is implemented using a simple search in a BST.
 * The put method is implemented recursively in the bottom-up way,
 * which is todays's standard for a red-black BST.
 * The delete method is implemented recursively in a top-down way.
 * Its peculiarity is that its core is only 24 lines long, while usual
 * implementations easily go over 100.
 * The basic idea is simply to make the current node or its child a
 * red one, because deleting a red node is easy.
 * This is achieved in only one-pass, that is after deletion of the
 * leaf there is no need to fixup the tree.
 * 
 * I believe this implementation is slightly slower than a usual one because
 * the number of rotations during a delete operation is not bounded, whereas
 * it is limited to 3 in a usual implementation.
 * However, given the gain in simplicity and space, this is a little drawback.
 * 
 * Compared to left-leaning red-black BSTs, it should do slightly better (not tested)
 * because there is no reshaping of the tree while moving up, and the number of
 * compares is also lower (only one compare per level down).
 * 
 * A detailed analysis of the two implementation is given here in terms of LOCs :
 * ******************************************************************************
 * 
 * The LLRB BST version used is the one found at http://algs4.cs.princeton.edu/33balanced/RedBlackBST.java.html,
 * but cleaned in order to keep the exact same statements as this one (no assertion or
 * track of the size of the tree, no exceptions thrown). We will focus only on the put and delete methods
 * 
 * Plus, a method length include its prototype, for example the following would account
 * for 3 LOCs :
 * public String foo() {
 *     return "bar";
 * }
 * 
 * 
 * Left-Leaning Red Black BST
 * **************************
 * 
 * The implementation relies on several helper functions :
 * isRed : 3
 * rotateRight : 8
 * rotateLeft : 8
 * flipColors : 5
 * balance : 6
 * moveRedLeft : 9
 * moveRedRight : 8
 * min(node) : 4
 * deleteMin(node) : 7
 * 
 * insertion :
 * put(key,val) : 4
 * put(node,key,val) : 11
 * 
 * Insertion is 15 lines long and makes use of 4 helper which amount
 * for 24 lines (isRed, rotateRight, rotateLeft, flipColors)
 * 
 * deletion :
 * delete(key) : 6
 * delete(node, key) : 22
 * 
 * Deletion is 28 lines long in total and makes use of 9 helpers,
 * which amount for 58 lines (isRed, rotateRight, rotateLeft, flipColors,
 * balance, moveRedLeft, moveRedRight, min, deleteMin)
 * 
 * This red-black BST
 * ******************
 * 
 * It makes use of several helper functions :
 * isRed : 3
 * cmpToDir : 3
 * rotate : 8
 * flipColors : 5
 * min(node) : 4
 * blacken : 4
 * rotateDel : 7
 * 
 * insertion :
 * put(key, val) : 4
 * put(node, key, val) : 18
 * 
 * Insertion represents a total of 22 LOCs, and use 4 helpers
 * which amount for 19 lines (isRed, cmpToDir, rotate, flipColors)
 * 
 * deletion :
 * delete(key) : 6
 * delete(node, key) : 24
 * 
 * Deletion represents a total of 30 LOCs, and use 7 helpers
 * which amount for 34 lines
 * 
 * ********************
 * The number of lines needed for insertion are roughly the same, however
 * the big difference comes from the deletion operation, which is lower with this
 * implementation.
 * I would finally add that this implementation does not search for the existence of
 * a node before entering the delete operation (the case is handled properly),
 * therefore it saves log N compares.
 * 
 * 
 * @author Tristan Claverie
 *
 * @param <Key>
 * @param <Value>
 */
public class RedBlackBST<Key extends Comparable<Key>, Value> {
    
    // Red and black colors
    private static final boolean RED = true;
    private static final boolean BLACK = false;

    private Node<Key, Value> root; // root of the BST
    
    private class Node<Key, Value> {
        Key key;       // key
        Value val;     // value coupled with key
        Node<Key, Value>[] childs; // links to the childs subtrees
        boolean color; // color of the parent link
        
        @SuppressWarnings("unchecked")
        public Node(Key key, Value val) {
            this.key = key;
            this.val = val;
            this.color = RED;
            this.childs = (Node<Key, Value>[]) new Node[2];
        }
    }
    
    /** 
     * Creates a new symbol table
     */
    public RedBlackBST() {}
    
    /**
     * Get value associated with key
     * @param k the key
     * @return the value associated, null is non-existant
     */
    public Value get(Key k) {
        Node<Key,Value> x = search(root, k);
        if (x == null) return null;
        return x.val;
    }
    
    /**
     * Recursively search among subtrees to find the
     * node containing k
     */
    private Node<Key,Value> search(Node<Key,Value> node, Key k) {
        if (node == null) return null;
        int cmp = k.compareTo(node.key);
        if (cmp == 0) return node;
        int dir = cmpToDir(cmp);
        return search(node.childs[dir], k);
    }
    
    /**
     * Put couple (k,v) in the symbol table, replace old value
     * with v if k is already present
     * @param k key
     * @param v value
     */
    public void put(Key k, Value v) {
        root = put(root, k, v);
        root.color = BLACK;
    }
    
    /**
     * Helper to insert a node in the symbol table
     */
    private Node<Key,Value> put(Node<Key,Value> node, Key k, Value v) {
        if (node == null) return new Node<Key,Value>(k, v);
        int cmp = k.compareTo(node.key);
        // If the key exists, replace the value
        if (cmp == 0) node.val = v;
        
        else {
            int dir = cmpToDir(cmp);
            // Recursive call
            node.childs[dir] = put(node.childs[dir], k, v);
            
            // Fix up the tree on the way up
            if (isRed(node.childs[dir])) {
                if (isRed(node.childs[dir^1]))
                    flipColors(node);
                else {
                    if (isRed(node.childs[dir].childs[dir^1])) node.childs[dir] = rotate(node.childs[dir], dir);
                    if (isRed(node.childs[dir].childs[dir])) node = rotate(node, dir^1);
                }
            }
        }
        return node;
    }
    
    /**
     * Delete node with key k, do not crash if k is non-existent
     * @param k the key
     */
    public void delete(Key k) {
        if (root == null) return;
        if (!isRed(root.childs[0]) && !isRed(root.childs[1])) root.color = RED;
        root = delete(root, k);
        if (root != null) root.color = BLACK;
    }
    
    /**
     * Recursive call for deletion
     */
    private Node<Key,Value> delete(Node<Key,Value> node, Key k) {
        if (node == null) return null;
        int cmp = k.compareTo(node.key);
        // Hit the key
        if (cmp == 0) {
            if (node.childs[1] == null) return blacken(node.childs[0]);
            // If it is not a leaf, replace the node by its successor and deletes
            // the successor
            Node<Key,Value> x = min(node.childs[1]);
            node.key = x.key;
            node.val = x.val;
            k = node.key;
        }
        
        // Fixup the tree on the way down
        int dir = cmpToDir(cmp);
        if (!isRed(node.childs[dir])) {
            if (isRed(node.childs[dir^1])) {
                if (!isRed(node)) node = rotate(node, dir);
            } else if(node.childs[dir] != null && !isRed(node.childs[dir].childs[0]) && !isRed(node.childs[dir].childs[1])) {
                if (node.childs[dir^1] != null && (isRed(node.childs[dir^1].childs[dir^1]) || isRed(node.childs[dir^1].childs[dir])))
                    node = rotateDel(node, dir);
                else
                    flipColors(node);
            }
        }
        
        // Recursive call
        node.childs[dir] = delete(node.childs[dir], k);
        return node;
    }
    
    /***************************
     * Deletion specific helpers
     **************************/
    
    /**
     * Set the color of a node to black if not null
     * and returns it.
     */
    private Node<Key,Value> blacken(Node<Key,Value> n) {
        if (n != null) n.color = BLACK;
        return n;
    }
    
    /**
     * Minimum node of this subtree
     */
    private Node<Key,Value> min(Node<Key,Value> node) {
        if (node.childs[0] == null) return node;
        return min(node.childs[0]);
    }
    
    /**
     * Special rotation in the case of a deletion
     * It makes a simple or double rotation depending
     * of the context
     */
    private Node<Key,Value> rotateDel(Node<Key,Value> node, int dir) {
        flipColors(node);
        if (isRed(node.childs[dir^1].childs[dir])) node.childs[dir^1] = rotate(node.childs[dir^1], dir^1);
        node = rotate(node, dir);
        flipColors(node);
        return node;
    }
    
    /********************
     * Common helpers
     *******************/
    
    /**
     * Rotates a child around his father
     */
    private Node<Key,Value> rotate(Node<Key,Value> x, int dir) {
        Node<Key,Value> y = x.childs[dir^1];
        x.childs[dir^1] = y.childs[dir];
        y.childs[dir] = x;
        y.color = x.color;
        x.color = RED;
        return y;
    }
    
    /**
     * Flip the colors of the node and its childs
     */
    private void flipColors(Node<Key,Value> x) {
        x.color = !x.color;
        x.childs[0].color = !x.childs[0].color;
        x.childs[1].color = !x.childs[1].color;
    }
    
    /*******************************************
     * General helper functions
     ******************************************/

    /**
     * Check the color of the node
     */
    private boolean isRed(Node<Key,Value> x) {
        return x != null && x.color == RED;
    }
    
    /**
     * From the compareTo result (-1,0,1), decides the direction to
     * take : right child or left child
     */
    private int cmpToDir(int cmp) {
        return cmp >= 0 ? 1 : 0;
    }
    
}

