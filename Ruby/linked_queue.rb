# The DoubleNode class represents a doubly linked node.
#
# It holds one link for the previous Node and one for the next.
#
# Author:: Tristan Claverie
# License:: MIT
class DoubleNode
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

# The LinkedQueue class represents a Queue using a Linked List.
#
# It supports the enqueue and dequeue operations.
# 
# Iteration is done in fifo order : first inserted is the first retrieved.
#
# Author:: Tristan Claverie
# License:: MIT
class LinkedQueue
    include Enumerable

    # Size of queue
    attr_reader :size

    # Initialize an empty queue
    def initialize
        @head = nil
        @tail = nil
        @size = 0
    end

    # Insert a node at the top of the list
    def enqueue(elt)
        @head = DoubleNode.new(elt, @head, nil)
        if @size == 0
            @tail = @head
        else
            @head.next.previous = @head
        end
        @size += 1
    end

    # Remove the node at the end of the list and returns its value
    def dequeue
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

    # Peek at the end of the list
    def peek
        raise 'No such element' if @size == 0
        return @tail.value
    end

    # Iterates in the list in lifo order :
    # start with the tail (first inserted) and
    # move backward
    def each
        current = @tail
        while current
            yield current.value
            current = current.previous
        end
    end

    # Is the queue empty ?
    def empty?
        @size == 0
    end
end
