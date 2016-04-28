class BSNode
    attr_accessor :key, :value, :left, :right

    def initialize(key = nil, value = nil, left = nil, right = nil)
        @key = key
        @value = value
        @left = left
        @right = right
    end
end

class BST
    @@RIGHT = 1
    @@LEFT = -1
    @@CENTER = 0
    attr_reader :size

    # Initializes an empty symbol table
    def initialize
        @size = 0
        @root = nil
    end

    # Put couple key value in the table
    def put(key, value)
        @size += 1
        if not @root
            @root = BSNode.new(key, value)
            return
        end
        x, pos = search(@root, key)
        if  pos == @@CENTER then x.value = value
        elsif pos == @@LEFT then x.left = BSNode.new(key, value)
        else                     x.right = BSNode.new(key, value)
        end
    end

    # Get value associated to key, nil
    # if not existant
    def get(key)
        return nil if not @root
        node, pos = search(@root, key)
        return node.value if pos = @@CENTER
        return nil
    end

    # Does the table contains key
    def contains?(key)
        return if not @root
        _, pos = search(@root, key)
        pos == @@CENTER
    end

    # Deletes the couple with the min key
    def del_min
        return if not @root
        @root = delete_min(@root)
        @size -= 1
    end

    # Deletes the couple with the max key
    def del_max
        return if not @root
        @root = delete_max(@root)
        @size -= 1
    end

    # Remove couple associated to key
    def remove(key)
        return if not @root
        @root = remove_h(@root, key)
        @size -= 1
        puts @root == nil
    end

    # Min key in the table
    def min
        return nil if not @root
        min_node(@root).key
    end

    # Max key in the table
    def max
        return nil if not @root
        max_node(@root).key
    end

    # Is the symbol table empty
    def empty?
        @size == 0
    end

    private

    # Helper function to get the min_node from
    # given starting point
    def min_node(node)
        return node if not node.left
        return min_node(node.left)
    end

    # Helper function to get the max_node from
    # given starting point
    def max_node(node)
        return node if not node.right
        return max_node(node.right)
    end

    # Helper funtion to delete the min node
    # from given starting point
    def delete_min(node)
        return node.right if not node.left
        node.left = delete_min(node.left)
        return node
    end

    # Helper function to delete the max node
    # from given starting point
    def delete_max(node)
        return node.left if not node.right
        node.right = delete_max(node.right)
        return node
    end

    # Helper function for removing a key
    def remove_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        if    cmp < 0 then node.left = remove_h(node.left, key)
        elsif cmp > 0 then node.right = remove_h(node.right, key)
        else
            return node.left if not node.right
            return node.right if not node.left
            t = node
            node = min_node(t.right)
            node.right = delete_min(t.right)
            node.left = t.left
        end
        return node
    end

    # Search the node containing key, or the node
    # parent node if the key does not exist
    # The second argument is used to know where
    # should the key be
    def search(node, key)
        cmp = key <=> node.key
        return node, @@CENTER if cmp == 0
        if cmp < 0
            return node, @@LEFT if not node.left
            return search(node.left, key)
        else
            return node, @@RIGHT if not node.right
            return search(node.right, key)
        end
    end
end
