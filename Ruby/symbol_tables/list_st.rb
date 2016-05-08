# A symbol table represented using a list
# This implementation is highly inefficient,
# and therefore should not be used in any
# real application. Its aim is PURELY educative
#
# It supports the put, get, remove, contains and size
# operations
#
# Author:: Tristan Claverie
# License:: MIT
class ListST
    # Size is the number of elements in the list
    attr_reader :size

    # Initializes an empty symbol table
    def initialize
        @size = 0
        @head = nil
        @tail = nil
    end

    # Put a couple key-value inside the table
    def put(key, value)
        node = Node.new(key, value)
        if !@head
            @head, @tail = node, node
        elsif (@head.key <=> key) > 0
            @head.left = node
            node.right = @head
            @head = node
        elsif (@tail.key <=> key) < 0
            @tail.right = node
            node.left = @tail
            @tail = node
        else
            left = search(key)
            if (left.key <=> key) == 0
                left.value = value
            else
                left.right.left = node if left.right
                node.right = left.right
                node.left = left
                left.right = node
            end
        end
        @size += 1
    end

    # Deletes entry associated to key
    def delete(key)
        return if !@head
        node = search(key)
        return if (node.key <=> key) != 0
        node.right.left = node.left if node.right
        node.left.right = node.right if node.left
        @head = node.right if @head == node
        @tail = node.left if @tail == node
        @size -= 1
    end

    # contains? the value associated with key, nil
    # if it does not exist
    def get(key)
        return nil if !@head
        node = search(key)
        ((node.key <=> key) == 0) ? node.value : nil
    end

    # Get the largest key in the table
    def max
        return nil if not @tail
        return @tail.key
    end

    # Get the lowest key in the table
    def min
        return nil if not @head
        return @head.key
    end

    # Deletes the smallest key
    def del_min
        return if not @head
        @tail = nil if @tail == @head
        @head = @head.right
        @head.left = nil if @head
        @size -= 1
    end

    # Deletes the largest key
    def del_max
        return if not @tail
        @head = nil if @tail == @head
        @tail = @tail.left
        @tail.right = nil if @tail
        @size -= 1
    end

    # Get the largest key smaller or equal to the given key
    def floor(key)
        return nil if not @head or (key <=> @head.key) < 0
        return search(key)
    end

    # Get the smallest key larger or equal to the given key
    def ceil(key)
        return nil if not @head or (key <=> @head.key) > 0
        node = search(key)
        return node if (node.key <=> key) == 0
        return node.right
    end

    # Does the symbol table contains this key ?
    def contains?(key)
        return false if !@head
        (search(key).key <=> key) == 0
    end

    # Is the table empty
    def empty?
        @size == 0
    end

    # Iterate through the keys
    def each_key
        current = @head
        while current
            yield current.key
            current = current.right
        end
    end

    # Iterate through the values
    def each_value
        current = @head
        while current
            yield current.value
            current = current.right
        end
    end

    # Iterate through the couples
    def each
        current = @head
        while current
            yield current.key, current.value
            current = current.right
        end
    end

    private

    # Search returns the node containing specified key
    # If not found, returns the last node inferior to it instead
    # (the left node that is)
    def search(key)
        current = @head
        while current.right and (current.right.key <=> key) <= 0
            current = current.right
        end
        return current
    end

    # Node represents a Node of the symbol
    # table
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node
        # Left is the left neighbor of this Node
        # Right is the right neighbor of this node
        # Key is the key of this Node
        # Value is the value contained in this Node
        attr_accessor :left, :right, :key, :value

        # Initialize a new node
        def initialize(key = nil, value = nil, left = nil, right = nil)
            @key = key
            @value = value
            @left = left
            @right = right
        end
    end

end

# ListSTX is another implementation of a symbol
# table using a list.
# This implementation is highly inefficient,
# and therefore should not be used in any
# real application. Its aim is PURELY educative
#
# It supports the put, get, remove, contains
# and size operations
#
# Author:: Tristan Claverie
# License:: MIT
class ListSTX
    # Size is the number of elements contained in the symbol table
    attr_reader :size

    # Initializes an empty symbol table
    def initialize
        @head = Node.min_node
        @tail = Node.max_node
        @head.right = @tail
        @tail.left = @head
        @size = 0
    end

    # Put a key-value couple in the symbol table
    def put(key, value)
        node = Node.new(key, value)
        left = search(node)
        if (left <=> node) == 0
            left.value = value
        else
            node.right, node.left = left.right, left
            left.right.left = node
            left.right = node
        end
        @size += 1
    end

    # Get value associated to key
    def get(key)
        node = search(Node.new(key))
        (!node.left or !node.right) ? nil : node.value
    end

    # Deletes entry associated to key
    def delete(key)
        node = search(Node.new(key))
        return if (key <=> node.key) != 0
        node.right.left = node.left
        node.left.right = node.right
        @size -= 1
    end

    # Get the smallest key
    def max
        @tail.left != @head ? @tail.left.key : nil
    end

    # Get the largest key
    def min
        @head.right != @tail ? @head.right.key : nil
    end

    # Deletes the minimum key in the table
    def del_min
        return if @tail.left == @head
        @tail.left.left.right = @tail
        @tail.left = @tail.left.left
        @size -= 1
    end

    # Deletes the largest key in the table
    def del_max
        return if @head.right == @tail
        @head.right.right.left = @head
        @head.right = @head.right.right
        @size -= 1
    end

    # Get the largest key smaller or equal to the given key
    def floor(key)
        return search(Node.new(key)).key
    end

    # Get the smallest key larger or equal to the given key
    def ceil(key)
        node = search(Node.new(key))
        (node.key <=> key) == 0 ? key : node.right.key
    end

    # Does the symbol table contains key
    def contains?(key)
        (key <=> search(Node.new(key))) == 0
    end

    # Is the table empty
    def empty?
        @size == 0
    end

    # Iterates through the keys
    def each_key
        current = @head.right
        while current != @tail
            yield current.key
            current = current.right
        end
    end

    # Iterates through the values
    def each_value
        current = @head.right
        while current != @tail
            yield current.value
            current = current.right
        end
    end

    # Iterates through the couples
    def each_key
        current = @head.right
        while current != @tail
            yield current.key, current.value
            current = current.right
        end
    end

    private

    # Search returns the node containing specified key
    # If not found, returns the last node inferior to it instead
    # (the left node that is)
    def search(node)
        current = @head
        while (current.right <=> node) <= 0
            current = current.right
        end
        current
    end

    protected

    # Node extends the basic node to allow
    # direct comparison between nodes instead of
    # comparing the keys
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node

        # Represents min_infinity, the smallest possible value
        @@MIN_INFINITY = Node.new
        # Represents max_infinity, the largest possible value
        @@MAX_INFINITY = Node.new

        # Left is the left neighbor of this Node
        # Right is the right neighbor of this node
        # Key is the key of this Node
        # Value is the value contained in this Node
        attr_accessor :left, :right, :key, :value

        # Initialize a new node
        def initialize(key = nil, value = nil, left = nil, right = nil)
            @key = key
            @value = value
            @left = left
            @right = right
        end

        # Access the max infinity node
        def self.max_node
            @@MAX_INFINITY
        end

        # Access the min infinity node
        def self.min_node
            @@MIN_INFINITY
        end

        # Define a comparison operator for
        # handling +inf and -inf
        def <=>(other)
            return -1 if self == @@MIN_INFINITY
            return 1 if other == @@MIN_INFINITY
            return 1 if self == @@MAX_INFINITY
            return -1 if other == @@MAX_INFINITY
            return self.key <=> other.key
        end
    end

end

# ListSTFinger is another implementation of a symbol
# table using a list and finger search
# This implementation is highly inefficient,
# and therefore should not be used in any
# real application. Its aim is PURELY educative
#
# It supports the put, get, remove, contains
# and size operations
#
# Author:: Tristan Claverie
# License:: MIT
class ListSTFinger < ListSTX
    # Size is the number of elements contained in the symbol table
    attr_reader :size

    # Initializes an empty symbol table
    def initialize
        @head = Node.min_node
        @head.right = Node.max_node
        @head.right.left = @head
        @finger = @head
        @size = 0
    end

    # Deletes entry associated to key
    def delete(key)
        node = search(Node.new(key))
        return if (key <=> node.key) != 0
        node.right.left = node.left
        node.left.right = node.right
        @finger = node.left
        @size -= 1
    end

    private

    # Search returns the node containing specified key
    # If not found, returns the last node inferior to it instead
    # (the left node that is)
    # Implemented using finger search
    def search(node)
        if (@finger.right <=> node) <= 0
            while (@finger.right <=> node) <= 0
                @finger = @finger.right
            end
        else
            while (@finger <=> node) > 0
                @finger = @finger.left
            end
        end
        @finger
    end
end
