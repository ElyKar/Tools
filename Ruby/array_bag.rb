# Implementation of a bag using an array
# It supports the usual add and each operation
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayBag
    include Enumerable

    def each(&block)

    end

    # Initialize an empty bag
    def initialize
        @elements = []
    end

    # Size of the bag
    def size?
        @elements.size
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
