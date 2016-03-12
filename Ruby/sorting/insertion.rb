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
            j = i-1
            while j >= 0 and (a[j] <=> a[i]) > 0
                a[j], a[i] = a[i], a[j]
                i, j = j, j-1
            end
        end
    end

    # Returns a sorted copy of the array in parameter
    # using insertion sort
    def self.sort(a)
        sorted = Array.new(a)
        self.sort!(sorted)
        return sorted
    end

end
