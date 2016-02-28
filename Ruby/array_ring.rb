# ArrayRing represents a cirular list using an array.
#
# It supports the insertion, deletion and movement in the list.
#
# The iteration is done in arbitrary order.
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayRing
    include Enumerable

    # initialize an empty ring
    def initialize
        @elements = []
        @current = nil
    end

    # Add an element before the current element
    def insertBefore(elt)
        if ! @current then
            @elements << elt
            @current = 0
        else
            @elements.insert(@current, elt)
        end
    end

    # Add an element after the current element
    def insertAfter(elt)
        if ! @current then
            @elements << elt
            @current = 0
        else
            @elements.insert(@current + 1, elt)
        end
    end

    # Delete the current element and place the current element
    # to the next
    def delete
        raise 'No such element' if @elements.length == 0
        elt = @elements.slice!(@current)
        if @elements.length == 0 then
            @current = nil
        else
            @current = @current % @elements.length
        end
        return elt
    end

    # Move the current element to the next
    def next
        raise 'No such element' if @elements.length == 0
        @current = (@current + 1) % @elements.length
        return self
    end

    # Move the current element to the previous
    def previous
        raise 'No such element' if @elements.length == 0
        @current = (@current - 1) % @elements.length
        return self
    end

    # Return the value of the current node
    def val
        raise 'No such element' if @elements.length == 0
        @elements[@current]
    end

    # Is the ring empty ?
    def empty?
        @elements.empty?
    end

    # Size of the ring
    def size
        @elements.length
    end

    # Iterates through the ring
    def each(&block)
        return if !@current
        current = @current
        loop do
            yield @elements[current]
            current = (current + 1) % @elements.length
            break if current == @current
        end
    end

end
