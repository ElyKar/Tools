# SkipNode is the node of a skip list
# This implementation is done using a
# Linked List of arrays
#
# Author:: Tristan Claverie
# License:: MIT
class SkipNode
    # An array containing the next Node
    attr_accessor :next
    # The height of the current node, comprised between 1 and MAX_HEIGHT
    attr_accessor :height
    # The value contained in the node, must be comparable
    attr_accessor :value

    # Initialize a new skip node with provided parameters
    def initialize(v, h, n)
        @value = v
        @height = h
        @next = n
    end
end

# SkipList represents the eponym data structure
# This implementation allow for a max value between
# 1 and 32, which is more than enough in the majority
# of applications (default value is 16)
# This implementation uses a linked list of arrays
#
# Author:: Tristan Claverie
# License:: MIT
class SkipList

    # Initializes an empty skip list with given maximum height
    # 0 < MAX_HEIGHT < 33
    def initialize(max = 16)
        raise 'Invalid max height, must be between 1 and 32 inclusive' if max < 1 or max > 32
        @MAX_HEIGHT = max
        @MAX_RND = (1 << (max - 1)) - 1
        @rnd = Random.new
        @head = SkipNode.new(nil, 0, Array.new(@MAX_HEIGHT))
    end

    # Get a random height between 1 and current height + 1
    def rand_height(max)
        bits = rand(@MAX_RND)
        height = 1
        bits.upto(max) do |b|
            if b == 1 then
                height += 1
            else
                break
            end
        end
        return height < @MAX_HEIGHT ? height : @MAX_HEIGHT
    end

    # Find a value and returns the previous node
    def find(value)
        current = @head
        for i in (@head.height-1)..0
            while current.next[i] != nil && v > current.next[i].value
                current = current.next[i]
            end
        end
        return current.next[0] if current.next[0]
        return nil
    end

    def insert(value)
        current = @head
        for i in (@head.height-1)..0
            while current.next[i] != nil && v > current.next[i].value
                current = current.next[i]
            end
        end
        return current.next[0] if current.next[0]
        return nil
    end

end
