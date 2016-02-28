# The ArrayQueue class represents a Queue using an array.
#
# It supports the enqueue and dequeue operations.
# 
# Iteration is done in fifo order : first inserted is the first retrieved.
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayQueue
    include Enumerable

    # Initialize an empty queue
    def initialize
        @elements = []
    end

    # Insert an element at the end of the array
    def enqueue(elt)
        @elements << elt
    end

    # Remove the first element of the array
    def dequeue
        raise 'No such element' if @size == 0
        @elements.slice!(0)
    end

    # Peek at the first element
    def peek
        raise 'No such element' if @size == 0
        @elements[0]
    end

    # Iterates in the array in lifo order :
    # start with the first and move to the last
    def each(&block)
        @elements.each(&block)
    end

    # Is the queue empty ?
    def empty?
        @elements.empty?
    end

    # Size of the queue
    def size
        @elements.length
    end
end
