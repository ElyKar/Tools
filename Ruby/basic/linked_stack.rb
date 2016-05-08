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
        @head = Node.new(elt, @head)
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

    private

    # The Node for the LinkedStack structure
    #
    # Author:: Tristan Claverie
    # License:: MIT License
    class Node
        # Value contained in the Node
        attr_reader :value
        # Next Node
        attr_reader :next

        # Create a Node with value and next Node n
        def initialize(value, n)
            @value = value
            @next = n
        end
    end

end
