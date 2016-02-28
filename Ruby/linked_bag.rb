# The SingleNode is the Node for several Linked structures
#
# Author:: Tristan Claverie
# License:: MIT License
class SingleNode
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

# The LinkedBag represents a one-way linked list.
# It supports the usual add and each operation
#
# Author:: Tristan Claverie
# License:: MIT License
class LinkedBag
    include Enumerable

    # Size of the bag
    attr_reader :size

    # Initialize an empty bag
    def initialize
        @size = 0
        @root = nil
    end

    # Is the bag empty ?
    def empty?
        @size == 0
    end

    # Add value to the bag
    def add(value)
        @root = SingleNode.new(value, @root)
        @size += 1
    end

    # Make the bag Enumerable
    def each
        node = @root
        while node != nil
            yield node.value
            node = node.next
        end
    end

end
