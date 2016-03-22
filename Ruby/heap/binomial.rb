# BinomialNode holds information about
# a node in a binomial heap
# It uses the usual left-child right-sibling representation
#
# Author:: Tristan Claverie
# License:: MIT
class BinomialNode
    # child is the child of self, the head of self's child list
    # sibling is the next element in self's list
    # value is the value stored in the node
    # rank is the rank of the binomial tree starting at this node
    attr_accessor :child, :sibling, :value, :rank

    # Initializes a node
    def initialize(child = nil, sibling = nil, value = nil)
        @child = child
        @sibling = sibling
        @value = value
        @rank = 0
    end
end

# BinomialHeap implements a min-oriented priority queue using
# a binomial heap. It provides the usual insert and del_min
# methods, plus a union one to merge (destructively !!) two heaps.
#
# Implementing it can be tricky, one must be careful because the root
# list's first element points to the lowest ranked, whereas a child pointer
# points to the highest ranked child.
#
# Author:: Tristan Claverie
# License:: MIT
class BinomialHeap
    # Root of the root list
    attr_accessor :root

    # Initializes and empty heap
    def initialize
        @root = nil
    end

    # Insert a new element in the heap
    def insert(elt)
        node = BinomialNode.new(nil, nil, elt)
        heap = BinomialHeap.new
        heap.root = node
        @root = union(heap).root
    end

    # Deletes and returns the min element in the heap
    # Algorithm is as follow :
    # - Remove the min element from the root list (taking all the tree with it)
    # - Cut the root of the extracted tree
    # - Merge the root list with the child list of the extracted tree
    def del_min
        min = erase_and_return_min
        x = min.child == nil ? min : min.child
        if min.child
            # Reverse the child list to have increasing ranks instead of
            # decreasing ones
            min.child = nil
            prev_x, next_x = nil, x.sibling
            while next_x
                x.sibling = prev_x
                prev_x = x
                x = next_x
                next_x = next_x.sibling
            end
            # Merge back the child list into the root list
            x.sibling = prev_x
            heap = BinomialHeap.new
            heap.root = x
            @root = union(heap).root
        end
        return min.value
    end

    # Merges another binomial heap into self
    # BE CAREFUL, both heaps will be destroyed at the end
    def union(other_heap)
        return if not other_heap
        # Create a new root list containing duplicate ranks
        @root = meld_roots(BinomialNode.new(nil, nil, nil), @root, other_heap.root).sibling
        # Consolidate the root list to re-create a binomial heap
        # Algorithm used is basically the binary addition
        current_n = @root
        prev_n, next_n = nil, @root.sibling
        while next_n
            if current_n.rank < next_n.rank or (next_n.sibling and next_n.sibling.rank == current_n.rank)
                prev_n, current_n = current_n, next_n
            elsif (next_n.value <=> current_n.value) > 0
                current_n.sibling = next_n.sibling
                link(next_n, current_n)
            else
                if not prev_n then @root = next_n
                else prev_n.sibling = next_n end
                link(current_n, next_n)
                current_n = next_n
            end
            next_n = current_n.sibling
        end
        return self
    end

    # Get the number of elements in the heap
    def size
        current = @root
        size = 0
        while current
            size += 1 << current.rank
            current = current.sibling
        end
        return size
    end

    # Is the heap empty
    def empty?
        @root == nil
    end

    private

    # Finds the min root in the root list and deletes then returns it
    def erase_and_return_min
        min = @root
        prev = BinomialNode.new(nil, nil, nil)
        current = @root
        while current.sibling
            if (min.value <=> current.sibling.value) > 0
                prev = current
                min = current.sibling
            end
            current = current.sibling
        end
        prev.sibling = min.sibling
        if min == @root then @root = min.sibling end
        return min
    end

    # Re-order two root lists into the new list. new_list cannot be nil,
    # Thus a way to use if is to create a dummy node. All the roots will go
    # after this dummy node, so all there is left to do is to take the sibling
    # of the dummy node, which is the head of the new root list
    # At the end of this procedure, the new list may contain
    # nodes with duplicate ranks, agregation is needed after using this method
    def meld_roots(new_list, list_x, list_y)
        return new_list if not list_x and not list_y
        if    not list_x then new_list.sibling = meld_roots(list_y, list_x, list_y.sibling)
        elsif not list_y then new_list.sibling = meld_roots(list_x, list_x.sibling, list_y)
        elsif list_x.rank < list_y.rank then new_list.sibling = meld_roots(list_x, list_x.sibling, list_y)
        else new_list.sibling = meld_roots(list_y, list_x, list_y.sibling) end
        return new_list
    end

    # Assuming root_x holds a greater key than root_y,
    # links root_x to root_y
    def link(root_x, root_y)
        root_x.sibling = root_y.child
        root_y.child = root_x
        root_y.rank += 1
    end

end
