# Insertion handles insertion sort in ascendant order.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Insertion

    # Sort the given array in parameter using
    # insertion sort
    def self.sort!(a)
        (1..a.size-1).each do |i|
            while i-1 >= 0 and (a[i-1] <=> a[i]) > 0
                a[i-1], a[i] = a[i], a[i-1]
                i -= 1
            end
        end
    end

    # Returns a sorted copy of the array in parameter
    # using insertion sort
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

end

# InsertionHalf handles insertion sort in ascendant order using half exchanges.
# It allows to reduce the number of exchanges and represent a good optimization.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operators
#
# Author:: Tristan Claverie
# License:: MIT
class InsertionHalf

    # Sort the given array in parameter using
    # insertion sort
    def self.sort!(a)
        (1..a.size-1).each do |i|
            current = a[i]
            while i-1 >= 0 and (a[i-1] <=> current) > 0
                a[i] = a[i-1]
                i -= 1
            end
            a[i] = current
        end
    end

    # Returns a sorted copy of the array in parameter
    # using insertion sort
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

end

# InsertionBinary handles insertion sort in ascendant order using binary search
# to find the right position and half exchanges.
# It allows to reduce the number of exchanges and comparisons and represent a good optimization.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operators
#
# Author:: Tristan Claverie
# License:: MIT
class InsertionBinary

    # Sort the given array in parameter using
    # insertion sort
    def self.sort!(a)
        (1..a.size-1).each do |i|
            current = a[i]
            lo, hi = 0, i
            while lo < hi
                mid = lo + (hi - lo) / 2
                if (current <=> a[mid]) < 0
                    hi = mid
                else
                    lo = mid + 1
                end
            end

            while i > lo
                a[i] = a[i-1]
                i -= 1
            end
            a[i] = current
        end
    end

    # Returns a sorted copy of the array in parameter
    # using insertion sort
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

end
