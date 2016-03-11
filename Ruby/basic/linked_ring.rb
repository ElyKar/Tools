require_relative('linked_queue')

# LinkedRing represents a cirular linked list.
#
# It supports the insertion, deletion and movement in the list.
# 
# The iteration is done in arbitrary order.
#
# Author:: Tristan Claverie
# License:: MIT
class LinkedRing
    include Enumerable

    # Size of the ring
    attr_reader :size

    # initialize an empty ring
    def initialize
        @current = nil
        @size = 0
    end

    # Add an element before the current node, does not
    # change the current element
    def insertBefore(elt)
        node = DoubleNode.new(elt, nil, nil)
        if @size == 0 then
            node.next, node.previous = node, node
            @current = node
        else
            node.next = @current
            node.previous = @current.previous
            @current.previous.next = node
            @current.previous = node
        end
        @size += 1
    end

    # Add an element after the current node, does not
    # change the current element
    def insertAfter(elt)
        node = DoubleNode.new(elt, nil, nil)
        if @size == 0 then
            node.next, node.previous = node, node
            @current = node
        else
            node.next = @current.next
            node.previous = @current
            @current.next.previous = node
            @current.next = node
        end
        @size += 1
    end

    # Delete the current element and place the current element
    # to the next node
    def delete
        raise 'No such element' if @size == 0
        elt = @current.value
        if @size == 1
            @current.next = nil
            @current.previous = nil
            @current = nil
        else
            @current.next.previous = @current.previous
            @current.previous.next = @current.next
            @current = @current.next
        end
        @size -= 1
        return elt
    end

    # Move the current element to the next
    def next
        raise 'No such element' if @size == 0
        @current = @current.next
    end

    # Move the current element to the previous
    def previous
        raise 'No such element' if @size == 0
        @current = @current.previous
    end

    # Return the value of the current node
    def val
        raise 'No such element' if @size == 0
        @current.value
    end

    # Is the ring empty ?
    def empty?
        @size == 0
    end

    # Iterates through the ring
    def each
        return if !@current
        current = @current
        loop do
            yield current.value
            current = current.next
            break if current == @current
        end
    end

end
