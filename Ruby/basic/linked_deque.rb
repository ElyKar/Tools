# LinkedDeque represents a dequeue using a doubly-linked list.
#
# It supports the add-first, add-last, remove-first, and remove-last operations.
#
# Iteration via each is done from first element to the last.
#
# Author:: Tristan Claverie
# License:: MIT
class LinkedDeque
    include Enumerable

    # Size of the deque
    attr_reader :size

    # Initialize an empty deque
    def initialize
        @size = 0
        @head = nil
        @tail = nil
    end

    # Add an element at the head of the deque
    def add_first(elt)
        @head = Node.new(elt, @head, nil)
        if @size == 0
            @tail = @head
        else
            @head.next.previous = @head
        end
        @size += 1
    end

    # Add an element at the end of the deque
    def add_last(elt)
        @tail = Node.new(elt, nil, @tail)
        if @size == 0
            @head = @tail
        else
            @tail.previous.next = @tail
        end
        @size += 1
    end

    # Remove the node at the end of the list and returns its value
    def remove_last
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
    def remove_first
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
    def peek_first
        raise 'No such element' if @size == 0
        @head.value
    end

    # Return the last element without removing it
    def peek_last
        raise 'No such element' if @size == 0
        @tail.value
    end

    # Is the deque empty ?
    def empty?
        @size == 0
    end

    # Iterate through the elements from first to last
    def each
        current = @head
        while current != nil
            yield current.value
            current = current.next
        end
    end

    private

    # The Node class represents a doubly linked node.
    #
    # It holds one link for the previous Node and one for the next.
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node
        # Value contained in the node
        attr_accessor :value
        # Next node
        attr_accessor :next
        # Previous node
        attr_accessor :previous

        # Initialize a node with value v, previous p and next n
        def initialize(v, n, p)
            @value = v
            @next = n
            @previous = p
        end
    end

end
