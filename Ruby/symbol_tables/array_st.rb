# Array ST implements a simple symbol
# table using an Array.
# It supports the usual put, get, remove,
# contains and size operations
#
# Author:: Tristan Claverie
# License:: MIT
class ArrayST

    # Initializes an empty symbol table
    def initialize
        @keys = []
        @values = []
    end

    # Number of elements in the table
    def size
        @keys.size
    end

    # Put couple key, value in the table
    # If key is already present, replace
    # the old value with the new one
    def put(key, value)
        position = search(key)
        if (key <=> @keys[position]) == 0
            @values[position] = value
        else
            @keys.insert(position, key)
            @values.insert(position, value)
        end
    end

    # Does the symbol table contains key
    def contains?(key)
        position = search(key)
        (key <=> @keys[position]) == 0
    end

    # Get value associated to key
    def get(key)
        position = search(key)
        return nil if (key <=> @keys[position]) != 0
        @values[position]
    end

    # Remove couple containing key from the table
    def remove(key)
        position = search(key)
        return if (key <=> @keys[position]) != 0
        @keys.delete_at(position)
        @values.delete_at(position)
    end

    # Is the table empty
    def empty?
        @keys.empty?
    end

    private

    # Returns the position at which key is
    # stored in the table. If the key is not
    # present, return the position at which insert it
    def search(key)
        return binary(0, @keys.size-1, key)
    end

    # Search for the position between lo and hi of key
    # using binary search
    def binary(lo, hi, key)
        return lo if lo > hi
        mid = lo + (hi - lo)/2
        cmp = key <=> @keys[mid]
        return binary(lo, mid-1, key) if cmp < 0
        return binary(mid+1, hi, key) if cmp > 0
        return mid
    end
end
