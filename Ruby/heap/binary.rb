# BinaryMinPQ implements a min-oriented priority queue
# using a binary heap
# It provides the usual insert and delMin operations
#
# Author:: Tristan Claverie
# License:: MIT
class BinaryMinPQ
    # Current size of the heap
    attr_reader :size

    # Initializes an empty priority queue
    def initialize
        @pq = Array.new(2)
        @size = 0
    end

    # Insert an element in the priority queue
    def insert(elt)
        resize(@size*2) if @size == (@pq.length - 1)
        @size += 1
        @pq[@size] = elt
        swim(@size)
    end

    # Is the queue empty
    def empty?
        @size == 0
    end

    # Deletes and returns the min element of the heap
    def delMin
        raise 'No such element' if @size < 1
        min = @pq[1]
        @pq[@size], @pq[1] = @pq[1], @pq[@size]
        @size -= 1
        sink(1)
        resize(@size*2) if @size <= @pq.size/4
        return min
    end

    # Sink the item in position k to a lower level to restore the heap invariant
    def sink(k)
        while k*2 <= @size
            child = k*2
            if child < @size and (@pq[child] <=> @pq[child + 1]) > 0 then
                child += 1
            end
            break if not (@pq[k] <=> @pq[child]) > 0
            @pq[k], @pq[child] = @pq[child], @pq[k]
            k = child
        end
    end

    # Swim the item in position k to a higher level to restore the heap innvariant
    def swim(k)
        while k/2 >= 1 and (@pq[k/2] <=> @pq[k]) > 0
            @pq[k], @pq[k/2] = @pq[k/2], @pq[k]
            k = k/2
        end
    end

    # Resize the priority queue
    def resize(n)
        a = Array.new(n+1)
        1.upto(n+1) do |i|
            a[i] = @pq[i]
        end
        @pq = a
    end

    private :resize, :sink, :swim
end

# BinaryMinPQOpti implements a min-oriented priority queue
# using an optimized binary heap
# The improvements are the following :
# - Moving up and down through the sink and swim operrations
# is done using half exchanges
# - When deleting the minimum key, the min element is swapped
# with a leaf, i.e. one of the lowest elements. The amelioration
# consists in sinking the root all the way to a leaf (1 compare/level),
# then swim it up (1 compare/level), instead of doing a classical swim
# (2 compare/level), because it is likely to end up in one of the lower layers.
#
# Author:: Tristan Claverie
# License:: MIT
class BinaryMinPQOpti
    # Size of the heap
    attr_reader :size

    # Initializes an empty priority queue
    def initialize
        @pq = Array.new(2)
        @size = 0
    end

    # Insert an element into the heap
    def insert(elt)
        resize(@size*2) if @size == (@pq.length - 1)
        @size += 1
        @pq[@size] = elt
        swim(@size)
    end

    # Is the heap empty
    def empty?
        @size == 0
    end

    # Deletes and returns the min element
    def delMin
        raise 'No such element' if @size < 1
        min = @pq[1]
        @pq[@size], @pq[1] = @pq[1], @pq[@size]
        @size -= 1
        leaf = sink(1)
        swim(leaf)
        resize(@size*2) if @size <= @pq.size/4
        return min
    end


    # Sink the item in position k all the way to a leaf, return the
    # index of the leaf. It MUST be followed by a swim operation on the
    # leaf to restore the heap invariant.
    def sink(k)
        current = @pq[k]
        while k*2 <= @size
            child = k*2
            if child < @size and (@pq[child] <=> @pq[child + 1]) > 0 then
                child += 1
            end
            @pq[k] = @pq[child]
            k = child
        end
        @pq[k] = current
        return k
    end

    # Swim the item in position k to a higher level to restore the heap invariant
    def swim(k)
        current = @pq[k]
        while k/2 >= 1 and (@pq[k/2] <=> current) > 0
            @pq[k] = @pq[k/2]
            k = k/2
        end
        @pq[k] = current
    end

    # Resize the heap
    def resize(n)
        a = Array.new(n+1)
        1.upto(n+1) do |i|
            a[i] = @pq[i]
        end
        @pq = a
    end

    private :resize, :sink, :swim
end
