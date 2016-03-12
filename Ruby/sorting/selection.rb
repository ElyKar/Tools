# Selection handles selection sort in ascendant order.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the < operator
#
# Author:: Tristan Claverie
# License:: MIT
class Selection

    # Returns a sorted copy of the array in parameter
    def self.sort(a)
        sorted = Array.new(a)
        self.sort!(sorted)
        return sorted
    end

    # Sort the array by modifying it
    def self.sort!(a)
        for i in 0..a.size-1
            min_idx = i
            min_elt = a[i]
            for j in (i+1)..a.size-1
                puts i.to_s + "  " + j.to_s
                if a[j] < min_elt
                    min_elt = a[j]
                    min_idx = j
                end
            end
            a[i], a[min_idx] = a[min_idx], a[i]
        end
    end

end
