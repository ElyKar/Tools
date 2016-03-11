# Implementation of a bag using an array.
#
# It supports the usual add and each operations.
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayBag
    include Enumerable

    # Initialize an empty bag
    def initialize
        @elements = []
    end

    # Size of the bag
    def size
        @elements.length
    end

    # Is the bag empty ?
    def empty?
        @elements.empty?
    end

    # Add an element
    def add(element)
        @elements << element
    end

    # Iterate through the elements
    def each(&block)
        @elements.each(&block)
    end
end
