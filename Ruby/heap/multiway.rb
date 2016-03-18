# MultiwayMinPQ implements a min-oriented priority queue
# using a multiway heap
# It provides the usual insert and del_min operations
#
# Author:: Tristan Claverie
# License:: MIT
class MultiwayMinPQ
    # Size of  the queue
    attr_reader :size

    # Creates an empty multiway heap with given dimension
    def initialize(dim = 4)
        raise 'Invalid dimension' if dim < 2
        @dim = dim
        @order = 1
        @size = 0
        @pq = Array.new(dim+1)
    end

    # Is the heap empty
    def empty?
        @size == 0
    end

    # Insert an element into the heap
    def insert(elt)
        @pq[@size] = elt
        swim(@size)
        @size += 1
        if (@size == @pq.size)
            @order += 1
            resize(@order)
        end
    end

    # Deletes and returns the min element of the heap
    def del_min
        raise 'No such element' if @size == 0
        @size -= 1
        min_elt = @pq[0]
        @pq[0] = @pq[@size]
        sink(0)
        if @order > 1 and @size <= @pq.size/(@dim*@dim)
            @order -= 1
            resize(@order)
        end
        return min_elt
    end

    # Swim element i up the heap
    def swim(i)
        par = parent(i)
        while i > 0 and (@pq[par] <=> @pq[i]) > 0
            @pq[par], @pq[i] = @pq[i], @pq[par]
            i, par = par, parent(par)
        end
    end

    # Sink element i down the heap
    def sink(i)
        return if child(i) >= @size
        min_idx = min_child(i)
        while min_idx < @size and (@pq[i] <=> @pq[min_idx]) > 0
            @pq[i], @pq[min_idx] = @pq[min_idx], @pq[i]
            i, min_idx = min_idx, min_child(min_idx)
        end
    end

    # First child element of i
    def child(i)
        @dim*i+1
    end

    # Parent of element i
    def parent(i)
        (i-1)/@dim
    end

    # Minimum child of element i
    def min_child(i)
        min_idx = child(i)
        (min_idx+1...min_idx+@dim).each do |idx|
            break if idx >= @size
            min_idx = idx if (@pq[idx] <=> @pq[min_idx]) < 0
        end
        return min_idx
    end

    # Resize the heap, the parameter is the height of
    # the new heap
    def resize(order)
        new_size = (1 - @dim**(order + 1))/(1 - @dim)
        a = Array.new(new_size)
        (0...new_size).each do |i|
            a[i] = @pq[i]
        end
        @pq = a
    end

    private :child, :parent, :min_child, :swim, :sink, :resize
end
