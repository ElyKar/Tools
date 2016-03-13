# Heap sorts an array using heapsort.
# It uses the standard heapify operation before sorting.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array.
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Heap

    # Sink the item in position k up to position n
    def self.sink(a, k, n)
        while k*2 + 1 <= n
            child = k*2 + 1
            if child + 1 <= n and (a[child] <=> a[child + 1]) < 0 then
                child += 1
            end
            break if not (a[k] <=> a[child]) < 0
            a[k], a[child] = a[child], a[k]
            k = child
        end
    end
    private_class_method :sink

    # Sort the given array in parameter using
    # heapsort
    def self.sort!(a)
        n = a.size
        # Heapify the array
        ((n-2)/2).downto(0) do |k|
            sink(a, k, n-1)
        end
        # Sort the array
        (n - 1).downto(1) do |last|
            a[0], a[last] = a[last], a[0]
            sink(a, 0, last - 1)
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

# HeapHalf sorts an array using heapsort with half exchanges.
# It uses the standard heapify operation before sorting.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array.
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class HeapHalf

    # Sink the item in position k up to position n
    def self.sink(a, k, n)
        current = a[k]
        while k*2 + 1 <= n
            child = k*2 + 1
            if child + 1 <= n and (a[child] <=> a[child + 1]) < 0 then
                child += 1
            end
            break if not (current <=> a[child]) < 0
            a[k] = a[child]
            k = child
        end
        a[k] = current
    end
    private_class_method :sink

    # Sort the given array in parameter using
    # heapsort
    def self.sort!(a)
        n = a.size
        # Heapify the array
        ((n-2)/2).downto(0) do |k|
            sink(a, k, n-1)
        end
        # Sort the array
        (n - 1).downto(1) do |last|
            a[0], a[last] = a[last], a[0]
            sink(a, 0, last - 1)
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
