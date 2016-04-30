# A node of a left-leaning black BST
#
# Author:: Tristan Claverie
# License:: MIT
class LLRBNode
    # RED constant  for a node
    @@RED = 1
    # BLACK constant for a node
    @@BLACK = 0

    # Left is the left child
    # Right is the right child
    # Color is the color of the parent link of the node
    # Key is the key of this node
    # Value is the value of this node
    attr_accessor :left, :right, :color, :key, :value

    # Initializes a new node
    def initialize(key = nil, value = nil, color = @@RED, left = nil, right = nil)
        @key = key
        @value = value
        @left = left
        @right = right
        @color = color
    end

    # Get the black constant
    def self.black
        @@BLACK
    end

    # Get the red constant
    def self.red
        @@RED
    end

    # Flip the color of the node
    def flip
        @color ^= 1
    end
end

# Represents a left-leaning red-black BST
# This is a variation of the classical red-black
# BST introduced by Sedgewick in 2008. Its aim is to
# reduce the length of the core methods of a red-black BST
# by making heavy use of recursion and reshaping of the traverse
#
# It supports the usual put, get, delete, del_min,
# del_max, min, max, ceil, floor, contains?, empty?, size
#
# Author:: Tristan Claverie
# License:: MIT
class LeftLeaningRedBlackTreeST
    # Number of elements in the table
    attr_reader :size

    # Creates an empty table
    def initialize
        @root = nil
        @size = 0
    end

    # Get the value associated to key
    def get(key)
        return nil if not @root
        node = search(@root, key)
        node ? node.value : nil
    end

    # Put a couple key-value in the table
    def put(key, value)
        @size += 1
        @root = insert(@root, key, value)
        @root.color = LLRBNode.black
    end

    # Deletes the minimum key of the tree
    def del_min
        return if not @root
        @root = delete_min(@root)
        @root.color = LLRBNode.black if @root
        @size -=1
    end

    # Deletes the maximum key of the tree
    def del_max
        return if not @root
        @root = delete_max(@root)
        @root.color = LLRBNode.black if @root
        @size -= 1
    end

    # Delete the couple associated with key
    def delete(key)
        return if not @root
        @root = delete_h(@root, key)
        @root.color = LLRBNode.black if @root
        @size -= 1
    end

    # Get the minimum key
    def min
        return nil if not @root
        return min_node(@root).key
    end

    # Get the maximum key
    def max
        return nil if not @root
        return max_node(@root).key
    end

    # Get the largest key smaller of equal to key
    def floor(key)
        return floor_h(@root, key)
    end

    # Get the smallest key larger of equal to key
    def ceil(key)
        return ceil_h(@root, key)
    end

    # Is the table empty ?
    def empty?
        @size == 0
    end

    # Does the table contains key ?
    def contains?(key)
        search(@root, key) != nil
    end

    # Iterate through the keys
    def each_key
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.key
            stack << x.right if x.right
            stack << x.left if x.left
        end
    end

    # Iterate through the values
    def each_key
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.value
            stack << x.right if x.right
            stack << x.left if x.left
        end
    end

    # Iterate through the couples
    def each
        return if not @root
        stack, x = [@root], nil
        while not stack.empty?
            x = stack.pop
            yield x.key, x.value
            stack << x.right if x.right
            stack << x.left if x.left
        end
    end

    private

    # Helper for searching the node containing key
    def search(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return search(node.left, key) if cmp < 0
        return search(node.right, key) if cmp > 0
    end

    # Helper for inserting a couple in the tree
    def insert(node, key, value)
        return LLRBNode.new(key, value) if not node

        cmp = key <=> node.key
        node.value = value if cmp == 0
        node.left = insert(node.left, key, value) if cmp < 0
        node.right = insert(node.right, key, value) if cmp > 0

        return restore(node)
    end

    # Helper for deleting the minimum key of the tree rooted at this node
    def delete_min(node)
        return nil if not node.left

        if (not red?(node.left)) and (not red?(node.left.left))
            node = move_red_left(node)
        end

        node.left = delete_min(node.left)
        return restore(node)
    end

    # Helper for deleting the maximum key of the tree rooted at this node
    def delete_max(node)
        if red?(node.left)
            node = rotate_right(node)
        end

        return nil if not node.right

        if not red?(node.right) and not red?(node.right.left)
            node = move_red_right(node)
        end

        node.right = delete_max(node.right)
        return restore(node)
    end

    # Helper for deleting a couple from the key rooted at this node
    def delete_h(node, key)
        cmp = key <=> node.key
        return node if not node.left and not node.right and cmp != 0
        if cmp < 0
            if not red?(node.left) and not red?(node.left.left)
                node = move_red_left(node)
            end
            node.left = delete_h(node.left, key)
        else
            node = rotate_right(node) if red?(node.left)
            return nil if (not node.right) and (key <=> node.key) == 0
            node = move_red_right(node) if not red?(node.right) and not red?(node.right.left)
            if (key <=> node.key) == 0
                x = min_node(node.right)
                node.key = x.key
                node.value = x.value
                node.right = delete_min(node.right)
            else node.right = delete_h(node.right, key)
            end
        end
        return restore(node)
    end

    # Get the node containing the minimum key from this node
    def min_node(node)
        return nil if not node
        return node if not node.left
        return min_node(node.left)
    end

    # Get the node containing the maximum key from this node
    def max_node(node)
        return nil if not node
        return node if not node.right
        return max_node(node.left)
    end

    # Reshapes the tree to make the left link a red one
    def move_red_left(node)
        flip_colors(node)
        if red?(node.right.left)
            node.right = rotate_right(node.right)
            node = rotate_left(node)
            flip_colors(node)
        end
        return node
    end

    # Reshapes the tree to make the right link a left one
    def move_red_right(node)
        flip_colors(node)
        if red?(node.left.left)
            node = rotate_right(node)
            flip_colors(node)
        end
        return node
    end

    # Right rotation
    def rotate_right(x)
        y = x.left
        x.left = y.right
        y.right = x
        y.color = x.color
        x.color = LLRBNode.red
        return y
    end

    # Left rotation
    def rotate_left(x)
        y = x.right
        x.right = y.left
        y.left = x
        y.color = x.color
        x.color = LLRBNode.red
        return y
    end

    # Flip the colors of the node and its childs
    def flip_colors(x)
        x.right.flip
        x.left.flip
        x.flip
    end

    # Reshapes the tree to respect the rules
    def restore(node)
        node = rotate_left(node) if red?(node.right)
        node = rotate_right(node) if red?(node.left) and red?(node.left.left)
        flip_colors(node) if red?(node.right) and red?(node.left)
        return node
    end

    # Is this node a red one ?
    def red?(x)
        x and x.color == LLRBNode.red
    end

    # Ceil of the key from the given subtree
    def ceil_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return ceil_h(node.right, key) if cmp > 0
        t = ceil_h(node.left, key)
        t ||= node
        return t.key
    end

    # Floor of the key from the given subtree
    def floor_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return floor_h(node.left, key) if cmp < 0
        t = floor_h(node.right, key)
        t ||= node
        return t.key
    end
end
