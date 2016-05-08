# A node of a left-leaning black BST
#
# Author:: Tristan Claverie
# License:: MIT
class LLRBNode
    # RED constant  for a node
    RED = true
    # BLACK constant for a node
    BLACK = false

    # Left is the left child
    # Right is the right child
    # Color is the color of the parent link of the node
    # Key is the key of this node
    # Value is the value of this node
    attr_accessor :left, :right, :color, :key, :value

    # Initializes a new node
    def initialize(key = nil, value = nil, color = RED, left = nil, right = nil)
        @key = key
        @value = value
        @left = left
        @right = right
        @color = color
    end

    # Flip the color of the node
    def flip
        @color = !@color
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
        @root.color = LLRBNode::BLACK
    end

    # Deletes the minimum key of the tree
    def del_min
        return if not @root
        @root = delete_min(@root)
        @root.color = LLRBNode::BLACK if @root
        @size -=1
    end

    # Deletes the maximum key of the tree
    def del_max
        return if not @root
        @root = delete_max(@root)
        @root.color = LLRBNode::BLACK if @root
        @size -= 1
    end

    # Delete the couple associated with key
    def delete(key)
        return if not @root
        @root = delete_h(@root, key)
        @root.color = LLRBNode::BLACK if @root
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
    def each_value
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
        x.color = LLRBNode::RED
        return y
    end

    # Left rotation
    def rotate_left(x)
        y = x.right
        x.right = y.left
        y.left = x
        y.color = x.color
        x.color = LLRBNode::RED
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
        x and x.color
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

# RBNode represents a node of a red-black bst
#
# Author:: Tristan Claverie
# License:: MIT
class RBNode
    # Childs is an arry of the two childs of the node
    # Key contained in the node
    # Value contained in the node
    # Color of the node
    attr_accessor :childs, :key, :value, :color

    # Represents the red color
    RED = true
    # Represents the black color
    BLACK = false

    # Initializes a new node
    def initialize(key = nil, value = nil, color = RED)
        @key = key
        @value = value
        @color = color
        @childs = [nil, nil]
    end

    # Changes the color of the node
    def flip
        @color = !@color
    end
end

# We define the to_i methods for booleans in order to reduce the number of lines.
# Typically, we use booleans to select the correct child in the array of childs
class FalseClass; def to_i; 0; end end
class TrueClass; def to_i; 1; end end

# RedBlackBST is a variant of the classic red-black BST for representing an ordered
# symbol table
# In a classical implementation, the insertion and deletion are
# implemented bottom-up, which needs a huge amount of code (~100-150 LOC for deletion)
# However, the usual implementation provides huge performances, because the insertion
# needs at most 2 rotations and the deletion needs at most 3
# The idea of this implementation is to be more elegant, at the cost of a little
# performances.
#
# The insertion is implemented bottom-up (way shorter than the top-down variant),
# but the deletion is implemented top-down recursively. The main function for deletion
# amounts to only 24 LOCs with only one multiple assignment(!!), and makes use of 4
# helper functions (which are 6, 3, 2 and 1 LOC long).
# This is by far the most concise implementation of delete I've ever seen
#
# It supports the usual put, get, delete, del_min, del_max, min, max, contains?,
# empty? and size methods plus iterators
#
# Author:: Tristan Claverie
# License:: MIT
class RedBlackTreeST
    # Number of elements in the table
    attr_reader :size

    # Initializes an empty table
    def initialize
        @size = 0
        @root = nil
    end

    # Put a couple key-value in the table
    def put(key, value)
        @root = insert(@root, key, value)
        @root.color = RBNode::BLACK
        @size += 1
    end

    # Delete key from the table
    def delete(key)
        @root.color = RBNode::RED if @root and not red?(@root.childs[0]) and not red?(@root.childs[1])
        @root = delete_h(@root, key)
        @root.color = RBNode::BLACK if @root
        @size -= 1
    end

    # Get value associated to key
    def get(key)
        x = search(@root, key)
        return x.value if x
        return nil
    end

    # Deletes the minimum key of the tree
    def del_min
        return if not @root
        x = min_node(@root)
        delete(@root, x.key) if x
    end

    # Deletes the maximum key of the tree
    def del_max
        return if not @root
        x = max_node(@root)
        delete(@root, x.key) if x
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

    # Helper for inserting into the tree
    def insert(node, key, value)
        return RBNode.new(key, value) if not node
        cmp = key <=> node.key
        if cmp == 0
            node.value = value
        else
            dir = (cmp > 0).to_i
            node.childs[dir] = insert(node.childs[dir], key, value)
            if red?(node.childs[dir])
                if red?(node.childs[dir^1])
                    flip_colors(node)
                else
                    node.childs[dir] = rotate_once(node.childs[dir], dir) if red?(node.childs[dir].childs[dir^1])
                    node = rotate_once(node, dir^1) if red?(node.childs[dir].childs[dir])
                end
            end
        end
        return node
    end

    # Helper for deleting the key from subtree rooted at node
    def delete_h(node, key)
        return nil if not node
        cmp = key <=> node.key
        if cmp == 0
            return blacken(node.childs[0]) if not node.childs[1]
            x = min_node(node.childs[1])
            node.key, node.value = x.key, x.value
            key = node.key
        end

        dir = (cmp >= 0).to_i
        if not red?(node.childs[dir])
            if red?(node.childs[dir^1])
                node = rotate_once(node, dir) if not red?(node)
            elsif node.childs[dir] and not red?(node.childs[dir].childs[0]) and not red?(node.childs[dir].childs[1])
                if node.childs[dir^1] and (red?(node.childs[dir^1].childs[dir^1]) or red?(node.childs[dir^1].childs[dir]))
                    node = rotate_del(node, dir)
                else
                    flip_colors(node)
                end
            end
        end

        node.childs[dir] = delete_h(node.childs[dir], key)
        return node
    end

    # Return a blackened node, or nil if no node
    def blacken(node)
        node.color = RBNode::BLACK if node
        return node
    end

    # Helper for rotations while deleting
    def rotate_del(node, dir)
        flip_colors(node)
        node.childs[dir^1] = rotate_once(node.childs[dir^1], dir^1) if red?(node.childs[dir^1].childs[dir])
        node = rotate_once(node, dir)
        flip_colors(node)
        return node
    end

    # Get the minimum node of the subtree
    def min_node(node)
        return node if not node.childs[0]
        return min_node(node.childs[0])
    end

    # Get the maximum node of the subtree
    def max_node(node)
        return node if not node.childs[1]
        return max_node(node.childs[1])
    end

    # Search key in the tree rooted at this node
    def search(node, key)
        return nil if not node
        cmp = key <=> node.key
        return node if cmp == 0
        return search(node.childs[(cmp > 0).to_i], key)
    end

    # A simple rotation of the tree
    def rotate_once(x, dir)
        y = x.childs[dir^1]
        x.childs[dir^1] = y.childs[dir]
        y.childs[dir] = x
        y.color = x.color
        x.color = RBNode::RED
        return y
    end

    # Change colors of the tree and its subtrees
    def flip_colors(x)
        x.flip
        x.childs[0].flip
        x.childs[1].flip
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

    # Is x a red node ?
    def red?(x)
        x and x.color
    end
end
