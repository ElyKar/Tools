# Implements a stack using an array.
#
# It supports the usual push and pop operations.
#
# The iteration is done in lifo order : last inserted is the first retrieved.
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayStack
    include Enumerable

    # Initializes an empty stack
    def initialize
        @elements = []
    end

    # Sive of the stack
    def size
        @elements.length
    end

    # Is the stack empty ?
    def empty?
        @elements.empty?
    end

    # Add an element at the top of the stack
    def push(elt)
        @elements << elt
    end

    # Remove and return the top element
    def pop
        raise 'No such element' if @elements.length == 0
        @elements.slice!(-1)
    end

    # Return the top element without removing it
    def peek
        raise 'No such element' if @elements.length == 0
        @elements[-1]
    end

    # Make the stack iterable in lifo order
    def each(&block)
        i = @elements.length - 1
        while i >= 0
            yield @elements[i]
            i -= 1
        end
    end
end
