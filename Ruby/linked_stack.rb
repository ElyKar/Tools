require_relative('linked_bag')

# The LinkedStack represents a simple stack using a Linked List.
#
# It supports the push and pop operations.
# 
# The iteration is done in lifo order : last inserted is the first retrieved.
#
# Author:: Tristan Claverie
# License:: MIT
class LinkedStack
    include Enumerable

    # Size of the stack
    attr_reader :size

    # Initialize an empty stack
    def initialize
        @size = 0
        @head = nil
    end

    # Push an element at the top of the stack
    def push(elt)
        @head = SingleNode.new(elt, @head)
        @size += 1
    end

    # Remove the top element and retrieve it
    def pop
        raise 'No such element' if @size == 0
        elt = @head.value
        @head = @head.next
        @size -= 1
        return elt
    end

    # Return the top element without removing it
    def peek
        raise 'No such element' if @size == 0
        return @head.value
    end

    # Is the stack empty ?
    def empty?
        @size == 0
    end

    # Make the stack iterable in lifo order
    def each
        current = @head
        while current != nil
            yield current.value
            current = current.next
        end
    end

end
