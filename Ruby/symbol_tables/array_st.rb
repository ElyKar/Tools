# Array ST implements an ordered symbol
# table using an Array.
# It supports the usual put, get, delete,
# del_min, del_max, min, max, ceil, floor,
# contains?, empty? and size operations
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

    # Is the table empty ?
    def empty?
        size == 0
    end

    # Get value associated to key
    def get(key)
        position = search(key)
        return nil if (key <=> @keys[position]) != 0
        @values[position]
    end

    # Remove couple containing key from the table
    def delete(key)
        position = search(key)
        return if (key <=> @keys[position]) != 0
        @keys.delete_at(position)
        @values.delete_at(position)
    end

    # Min key in the table
    def min
        @keys[0]
    end

    # Max key in the table
    def max
        @keys[@keys.size-1]
    end

    # Delete the minimum key of the table
    def del_min
        return if @keys.size == 0
        @keys.delete_at(0)
        @values.delete_at(0)
    end

    # Delete the maximum key of the table
    def del_max
        return if @keys.size == 0
        @key.delete_at(@keys.size-1)
        @values.delete_at(@keys.size-1)
    end

    # Get the largest key smaller of equal to key
    def floor(key)
        position = search(key)
        return key if key == @keys[position]
        return nil if position == 0
        return @keys[position-1]
    end

    # Get the smallest key larger of equal to key
    def ceil(key)
        position = search(key)
        return key if key == @keys[position]
        return nil if position == @keys.size
        return @keys[position]
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
