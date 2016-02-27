require_relative('linked_queue')

# LinkedDeque represents a dequeue using a doubly-linked list
# it supports the addFirst, addLast, removeFirst, and removeLast operations
# Iteration via each is done from first element to the last
#
# Author:: Tristan Claverie
# License:: MIT
class LinkedDeque
    include Enumerable

    # Initialize an empty deque
    def initialize
        @size = 0
        @head = nil
        @tail = nil
    end

    # Add an element at the head of the deque
    def addFirst(elt)
        @head = DoubleNode.new(elt, @head, nil)
        if @size == 0
            @tail = @head
        else
            @head.next.previous = @head
        end
        @size += 1
    end

    # Add an element at the end of the deque
    def addLast(elt)
        @tail = DoubleNode.new(elt, nil, @tail)
        if @size == 0
            @head = @tail
        else
            @tail.previous.next = @tail
        end
        @size += 1
    end

    # Remove the node at the end of the list and returns its value
    def removeLast
        raise 'No such element' if @size == 0
        elt = @tail.value
        if @size == 1
            @head = nil
            @tail = nil
        else
            @tail = @tail.previous
            @tail.next.previous = nil
            @tail.next = nil
        end
        @size -= 1
        return elt
    end

    # Remove the node at the head of the list and returns its value
    def removeFirst
        raise 'No such element' if @size == 0
        elt = @head.value
        if @size == 1
            @head = nil
            @tail = nil
        else
            @head = @head.next
            @head.previous.next = nil
            @head.previous = nil
        end
        @size -= 1
        return elt
    end

    # Return the first element without removing it
    def peekFirst
        raise 'No such element' if @size == 0
        @head.value
    end

    # Return the last element without removing it
    def peekLast
        raise 'No such element' if @size == 0
        @tail.value
    end

    # Is the deque empty ?
    def empty?
        @size == 0
    end

    # Size of the deque
    def size?
        @size
    end

    # Iterate through the elements from first to last
    def each
        current = @head
        while current != nil
            yield current.value
            current = current.next
        end
    end

end
