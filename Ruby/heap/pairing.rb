# PairingHeap implements a min-oriented priority queue using
# a pairing heap. It provides the usual insert and del_min
# methods, plus a union one to merge (destructively !!) two heaps.
#
# The pairing heap is one of the fastest priority queues around
# Though it relies on pointers, its implementation is very easy
# and short. In practice it competes with binary and multiway heap
#
# Author:: Tristan Claverie
# License:: MIT
class PairingHeap

    # Size of the heap
    # Head of the heap (contains the min element)
    attr_reader :size, :head

    # Initializes an empty heap
    def initialize
        @size = 0
        @head = nil
    end

    # Insert a new element into the heap
    def insert(elt)
        x = Node.new(elt)
        @head = meld_roots(@head, x)
        @size += 1
    end

    # Merges (destructively) two heaps together
    def union(other_heap)
        @head = meld_roots(@head, other_heap.head)
        @size += other_heap.size
    end

    # Deletes the minimum of the heap and returns it
    def del_min
        min_elt = @head.value
        @size -= 1
        if not @head.left
            @head = nil
            return min_elt
        end
        merge_pairs(@head.left)
        return min_elt
    end

    # Is the heap empty ?
    def empty?
        @size == 0
    end

    protected

    # Merges two nodes together
    def meld_roots(x, y)
        return y if not x
        return x if not y
        if (x.value <=> y.value) < 0
            return link(x, y)
        end
        return link(y, x)
    end

    # I was sad when I noticed that I couldn't make this function recursive
    # because of ruby's call stack
    # However, I put it there because the recursive two-pass is a model of elegance
    # So here we go :
    # def merge_pairs(x)
    #     return x if not x.right
    #     return meld_roots(x, x.right) if not x.right.right
    #     return meld_roots(merge_pairs(x.right.right), meld_roots(x, x.right))
    # end
    # And it works fine ! (if not for this damn call stack)
    def merge_pairs(x)
        old, y, z = nil, nil, nil
        # UGLY
        while x
            y = x.right.right if x.right
            z = meld_roots(x, x.right)
            z.right = old
            old = z
            break if y == x
            x = y
        end

        # EVEN MORE UGLY
        @head = nil
        while old
            y = old.right
            @head = meld_roots(@head, old)
            old = y
        end
    end

    # Assuming x holds a lower value than y,
    # links y to x
    def link(x, y)
        y.right = x.left
        x.left = y
        return x
    end

    # Node holds information about
    # a node in a pairing heap
    # It uses the standard left-child right-sibling
    # representation
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node
        # Left if the first child of the node
        # Right is the sibling oh this node
        # Value is the value contained by this node
        attr_accessor :left, :right, :value

        # Initializes a new node
        def initialize(value)
            @value = value
            @left = nil
            @right = nil
        end
    end

end
