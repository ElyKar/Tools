# We define the to_i methods for booleans in order to reduce the number of lines.
# Typically, we use booleans to select the correct child in the array of childs
class FalseClass; def to_i; 0 end end
class TrueClass; def to_i; 1 end end

# AVLTreeST is an ordered symbol table implemented
# using an AVL tree. Both insert and delete
# methods are implemented bottom-up.
# It supports the usual put, get, delete, del_min
# del_max, min, max, empty?, contains? and size
#
# Author:: Tristan Claverie
# License:: MIT
class AVLTreeST
    # Number of couples in the table
    attr_reader :size

    # Initializes an empty table
    def initialize
        @root = nil
        @size = 0
    end

    # Put the couple key-value in the table
    def put(key, value)
        @root = insert(@root, key, value)
        @size += 1
    end

    # Delete couple identified by key
    def delete(key)
        @root = delete_h(@root, key)
        @size -= 1
    end

    # Get the value associated with key
    def get(key)
        node = search(@root, key)
        node ? node.value : nil
    end

    # Get the min key in the tree
    def min
        return nil if not @root
        return min_node(root).key
    end

    # Get the max key in the tree
    def max
        return nil if not @root
        return max_node(@root).key
    end

    # Deletes the min couple from the table
    def del_min
        return nil if not @root
        delete(min)
    end

    # Deletes the max couple from the table
    def del_max
        return nil if not @root
        delete(max)
    end

    # Is the table empty ?
    def empty?
        @size == 0
    end

    # Does the table contains key ?
    def contains?(key)
        search(@root, key) != nil
    end

    # Get the largest key smaller of equal to key
    def floor(key)
        return floor_h(@root, key)
    end

    # Get the smallest key larger of equal to key
    def ceil(key)
        return ceil_h(@root, key)
    end

    # Iterate through the keys
    def each_key
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.key
            stack << x.childs[1] if x.childs[1]
            stack << x.childs[0] if x.childs[0]
        end
    end

    # Iterate through the values
    def each_value
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.value
            stack << x.childs[1] if x.childs[1]
            stack << x.childs[0] if x.childs[0]
        end
    end

    # Iterate through the couples
    def each
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.key, x.value
            stack << x.childs[1] if x.childs[1]
            stack << x.childs[0] if x.childs[0]
        end
    end

    private

    # Search the node containing key
    def search(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        dir = (cmp > 0).to_i
        return search(node.childs[dir], key)
    end

    # Helper for inserting in the table
    def insert(node, key, value)
        return Node.new(key, value, 0) if not node
        cmp = key <=> node.key

        if cmp == 0
            node.value = value
        else
            dir = (cmp > 0).to_i
            node.childs[dir] = insert(node.childs[dir], key, value)
            node = restore(node, dir)
            node.balance = balance(node)
        end
        return node
    end

    # Helper for deleting from the table
    def delete_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        if cmp == 0
            return node.childs[0] if not node.childs[1]
            x = min_node(node.childs[1])
            node.key, node.value = x.key, x.value
            key = node.key
        end

        dir = (cmp >= 0).to_i
        node.childs[dir] = delete_h(node.childs[dir], key)
        node.balance = balance(node)
        return restore(node, dir^1)
    end

    # Single rotation
    def rotate(x, dir)
        y = x.childs[dir^1]
        x.childs[dir^1] = y.childs[dir]
        y.childs[dir] = x
        x.balance = balance(x)
        y.balance = balance(y)
        return y
    end

    # Restore balance in the tree
    def restore(node, dir)
        return node if (size(node.childs[0]) - size(node.childs[1])).abs <= 1
        if node.childs[dir].childs[dir^1] and size(node.childs[dir].childs[dir]) < size(node.childs[dir].childs[dir^1])
            node.childs[dir] = rotate(node.childs[dir], dir)
        end
        return rotate(node, dir^1)
    end

    # Get the balance of the node
    def balance(x)
        return 0 if not x.childs[0] and not x.childs[1]
        return max(size(x.childs[0]), size(x.childs[1])) + 1
    end

    # Ceil of the key from the given subtree
    def ceil_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return ceil_h(node.childs[1], key) if cmp > 0
        t = ceil_h(node.childs[0], key)
        t ||= node
        return t.key
    end

    # Floor of the key from the given subtree
    def floor_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return floor_h(node.childs[0], key) if cmp < 0
        t = floor_h(node.childs[1], key)
        t ||= node
        return t.key
    end

    # Min node from the subtree in parameter
    def min_node(x)
        return x if not x.childs[0]
        min_node(x.childs[0])
    end

    # Max node from the subtree in parameter
    def max_node(x)
        return x if not x.childs[1]
        max_node(x.childs[1])
    end

    # Maximum between a and b
    def max(a, b)
        a > b ? a : b
    end

    # Size of the node x
    def size(x)
        return 0 if not x or (not x.childs[0] and not x.childs[1])
        return x.balance
    end

    # Node represents a node of an AVL tree
    # It contains an array of childs instead of
    # the usual left and right pointers
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Node
        # Key is the key contained in the node
        # Value contained in the node
        # Balance is the length of the maximum path to a leaf from this node
        # Childs is an array of childs
        attr_accessor :key, :value, :balance, :childs

        # Initializes a new node
        def initialize(key, value, balance)
            @key = key
            @value = value
            @balance = balance
            @childs = [nil, nil]
        end
    end

end
