Priority Queues are partially ordered data structures.
They are very interesting when you have to implement Prim's or Dijkstra's algorithm,
as both of them rely on such data structures.

Here are the functions provided.
(For the worst-case running time, please refer to the source code directly.)

# BinomialMinPQ<Key>, MultiwayMinPQ<Key>, FibonacciMinPQ<Key>

-boolean isEmpty()
-int size()
-void insert(Key key)
-Key minKey()
-Key delMin()
-Iterator<Key> iterator()
-*MinPQ<Key> union(*MinPQ<Key> that) (only for Binomial and Fibonacci)

# IndexBinomialMinPQ<Key>, IndexMultiwayMinPQ<Key>, IndexFibonacciMinPQ<Key>

-boolean isEmpty()
-boolean contains(int i)
-long size()
-void insert(int i, Key key)
-int minIndex()
-Key minKey()
-int delMin()
-Key keyOf(int i)
-void changeKey(int i, Key key)
-void decreaseKey(int i, Key key)
-void increaseKey(int i, Key key)
-void delete(int i)
-Iterator<Integer> iterator()-
