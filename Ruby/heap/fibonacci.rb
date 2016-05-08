# FiboHeap implements a min-oriented priority queue using
# a fibonacci heap. It provides the usual insert and del_min
# methods, plus a union one to merge (destructively !!) two heaps.
#
# It has a reputation of being difficult to implement,
# but this is not quite true in my opinion. It's not the
# easiest data structure around, but is for from being the
# most difficult
#
# Author:: Tristan Claverie
# License:: MIT
class FiboHeap
    # Min element of the root list
    attr_accessor :min

    # Size of the heap
    attr_reader :size

    # Initializes an empty heap
    def initialize
        @min = nil
        @size = 0
    end

    # Inserts a node in the heap
    def insert(elt)
        node = Node.new(elt)
        @min = insert_list(node, @min)
        @size += 1
    end

    # Merges (destructively) two heaps together
    def merge(other_heap)
        @min = meld_list(@min, other_heap.min)
        @size += other_heap.size
    end

    # Deletes the min pointer and return the min element
    def del_min
        child = @min.child
        min_elt = @min.value
        @min = cut_list(@min, @min)
        if child
            @min = meld_list(@min, child)
        end
        @size -= 1
        if @size > 1
            coalesce
        elsif @size == 0
            @min = nil
        end
        return min_elt
    end

    # Is the heap empty
    def empty?
        @size == 0
    end

    private

    # Inserts a node in a circular list containing min, returns an updated min
    def insert_list(x, min)
        if not min
            x.right = x
            x.left = x
        else
            x.right = min
            x.left = min.left
            min.left.right = x
            min.left = x
        end
        return (min and (min.value <=> x.value) < 0) ? min : x
    end

    # Meld two root lists together and return the min element of the two
    def meld_list(min_x, min_y)
        return min_y if not min_x
        return min_x if not min_y
        min_x.left.right = min_y.right
        min_y.right.left = min_x.left
        min_x.left = min_y
        min_y.right = min_x
        return (min_x.value <=> min_y.value) < 0 ? min_x : min_y
    end

    # Removes a node from the list containing min
    def cut_list(x, min)
        if x.left == x
            x.left = nil
            x.right = nil
            return nil
        else
            x.left.right = x.right
            x.right.left = x.left
            res = x.left
            x.left = nil
            x.right = nil
        end
        return min == x ? res : min
    end

    # Assuming x holds a lower value than y
    def link(x, y)
        x.child = insert_list(y, x.child)
        x.rank += 1
    end

    # Consolidate the root list
    def coalesce
        h = []
        x = @min
        y, z = nil, nil
        loop do
            y = x
            x = x.right
            while h[y.rank]
                z = h[y.rank]
                y, z = z, y if (y.value <=> z.value) > 0 or (y.value <=> z.value) == 0 and y.rank <= z.rank
                cut_list(z, y)
                link(y, z)
                h[z.rank] = nil
            end
            h[y.rank] = y
            @min = y if (y.value <=> @min.value) <= 0
            break if h[y.right.rank] == y.right
        end
    end

    # Node holds information about
    # a node in a fibonacci heap
    # It uses a three pointers representation
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node
        # Left and right are for the doubly-linked list,
        # Child pointer is the child of this node
        # Rank is similar to that of a binomial's heap rank
        # Value is the value contained by this node
        attr_accessor :left, :right, :child, :value, :rank

        # Initializes a node
        def initialize(value = nil, left = nil, right = nil, child = nil)
            @left = left
            @right = right
            @child = child
            @value = value
            @rank = 0
        end
    end

end
