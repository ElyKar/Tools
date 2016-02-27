# The SingleNode is the Node for the SingleLinkedList
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

# The SingleLinkedList represents a one-way linked list.
# It supports the usual add, remove and each operation
#
# Author:: Tristan Claverie
# License:: MIT License
class SingleLinkedList

    # Initialize an empty list
    def initialize
        @size = 0
        @root = nil
    end

    # Is the list empty ?
    def empty?
        return @size == 0
    end

    # Number of elements in the list
    def size?
        return @size
    end

    # Add value to the list
    def add(value)
        @root = SingleNode.new(value, @root)
        @size += 1
    end

    # Remove element from the list and returns it
    def remove
        raise 'No such element' if self.empty?
        v = @root.value
        @root = @root.next
        @size -= 1
        return v
    end

    # Make the list Enumerable
    def each
        node = @root
        while node != nil
            yield node.value
            node = node.next
        end
    end

    # Get the i element of the list
    def get(i)
        raise 'No such element' unless @size > i
        node = @root
        while i != 0
            i -= 1
            node = node.next
        end
        return node.value
    end
end
