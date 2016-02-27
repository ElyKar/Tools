# ArrayDeque represents a dequeue using an array
# it supports the addFirst, addLast, removeFirst, and removeLast operations
# Iteration via each is done from first element to the last
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayDeque
    include Enumerable

    # Initialize an empty deque
    def initialize
        @elements = []
    end

    # Add an element at the head of the deque
    def addFirst(elt)
        @elements.insert(0, elt)
    end

    # Add an element at the end of the deque
    def addLast(elt)
        @elements << elt
    end

    # Remove the last element and returns its value
    def removeLast
        raise 'No such element' if @size == 0
        @elements.slice!(-1)
    end

    # Remove the first element and returns its value
    def removeFirst
        raise 'No such element' if @size == 0
        @elements.slice!(0)
    end

    # Return the first element without removing it
    def peekFirst
        raise 'No such element' if @size == 0
        @elements[0]
    end

    # Return the last element without removing it
    def peekLast
        raise 'No such element' if @size == 0
        @elements[-1]
    end

    # Is the deque empty ?
    def empty?
        @elements.empty?
    end

    # Size of the deque
    def size?
        @size
    end

    # Iterate through the elements from first to last
    def each(&block)
        @elements.each(&block)
    end

end
