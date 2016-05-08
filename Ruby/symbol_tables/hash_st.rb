# Implementation of a hash table using
# separate chaining method
# It supports the usual put, get, delete,
# contains, size and empty methods, along
# with methods for iteration
#
# This is a PURELY educative implementation
# You should NOT use this in any real implementation
#
# Author:: Tristan Claverie
# License:: MIT
class SeparateChainingHashing

    # Initial capacity of the table
    INIT_CAPACITY = 4
    # Load factor of the table
    LOAD_FACTOR = 0.75

    # Inner couple class
    class Couple
        # Key is the key of the couple
        # Value is the value contained
        # n is a reference to the next element
        attr_accessor :key, :value, :n

        # Initializes a new couple
        def initialize(key, value, n)
            @key = key
            @value = value
            @n = n
        end
    end

    # Initializes an empty table
    def initialize(cap = INIT_CAPACITY)
        @M = cap
        @N = 0
        @table = Array.new(cap)
        @threshold = LOAD_FACTOR*cap
    end

    # Get value associated with key, nil else
    def get(key)
        index = key.hash % @M
        current = @table[index]
        while current and current.key != key
            current = current.n
        end
        return current ? current.value : nil
    end

    # Put a new couple in the table, replace old
    # value if the key is already present
    def put(key, value)
        index = key.hash % @M
        current = @table[index]
        while current and current.key != key
            current = current.n
        end
        if current
            current.value = value
            return
        end
        @table[index] = Couple.new(key, value, @table[index])
        @N += 1
        resize(@M*2) if @N > @threshold
    end

    # Delete couple containing this key from the table
    def delete(key)
        index = key.hash % @M
        current = @table[index]
        return if not current
        if current.key == key
            @table[index] = current.n
        else
            while current.n and current.n.key != key
                current = current.n
            end
            return if not current.n
            current.n = current.n.n
        end
        @N -= 1
    end

    # Iterate through the keys
    def each_key
        @table.each do |x|
            while x
                yield x.key
                x = x.n
            end
        end
    end

    # iterate through the values
    def each_value
        @table.each do |x|
            while x
                yield x.value
                x = x.n
            end
        end
    end

    # Iteration
    def each
        @table.each do |x|
            while x
                yield x.key, x.value
                x = x.n
            end
        end
    end

    # Does the table contain key ?
    def contains?(key)
        index = key.hash % @M
        current = @table[index]
        while current
            return true if key == current.key
            current = current.n
        end
        return false
    end

    # Is the table empty ?
    def empty?
        @N == 0
    end

    # Number of couples stored in the table
    def size
        @N
    end

    private

    # Helper method for growing the table
    def resize(size)
        @threshold = size * LOAD_FACTOR
        new_a = Array.new(size)
        @table.each do |x|
            while x
                idx = x.key.hash % size
                new_a[idx] = Couple.new(x.key, x.value, new_a[idx])
                x = x.n
            end
        end
        @M = size
        @table = new_a
    end
end
