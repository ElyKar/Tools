# Shell handles shell sort in ascendant order.
# It uses the Incerpi-Sedgewick gap sequence found in 1985.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Shell
    @@gap = [1391376,463792,198768,86961,33936,13776,4592,1968,861,336,112,48,21,7,3,1]

    # Sort the given array in parameter using
    # shell sort
    def self.sort!(a)
        @@gap.each do |h|
            (h...a.size).each do |i|
                while i-h >= 0 and (a[i-h] <=> a[i]) > 0
                    a[i-h], a[i] = a[i], a[i-h]
                    i -= h
                end
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

# ShellHalf handles shell sort in ascendant order with half exchanges.
# It uses the Incerpi-Sedgewick gap sequence found in 1985.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class ShellHalf
    @@gap = [1391376,463792,198768,86961,33936,13776,4592,1968,861,336,112,48,21,7,3,1]

    # Sort the given array in parameter using
    # shell sort
    def self.sort!(a)
        @@gap.each do |h|
            (h...a.size).each do |i|
                current = a[i]
                while i-h >= 0 and (a[i-h] <=> current) > 0
                    a[i] = a[i-h]
                    i -= h
                end
                a[i] = current
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
