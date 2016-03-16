require_relative 'insertion'

# Quick handles quicksort in ascendant order.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Quick

    # Sort the given array in parameter using
    def self.sort!(a)
        # Shuffling the array beforehand ensures with very high
        # probability that the algorithm will perform average on
        # a sorted or nearly array
        # quicksort
        a.shuffle!
        quick(a, 0, a.size-1)
    end

    # Recursively sort the array a between indices
    # first and last
    def self.quick(a, first, last)
        if first < last
            mid = partition(a, first, last)
            quick(a, first, mid-1)
            quick(a, mid+1, last)
        end
    end

    # Use Sedgewick partitioning between first and last indices
    def self.partition(a, first, last)
        pivot = a[first]
        i, j = first, last + 1
        loop do
            loop do
                i += 1
                break if i == last
                break if (a[i] <=> pivot) > 0
            end

            loop do
                j -= 1
                break if j == first
                break if (pivot <=> a[j]) > 0
            end

            break if i >= j

            a[i], a[j] = a[j], a[i]
        end

        a[first], a[j] = a[j], pivot
        return j
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

    private_class_method :quick, :partition

end

# Quick3Dijkstra handles quicksort in ascendant order using Dijkstra's
# 3-way partitioning.
# The implementation is even simpler than the classic one, and performs better on
# arrays containing few elements with many duplicates.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Quick3Dijkstra

    # Sort the given array in parameter using
    # quicksort
    def self.sort!(a)
        # Shuffling the array beforehand ensures with very high
        # probability that the algorithm will perform average on
        # a sorted or nearly array
        a.shuffle!
        quick(a, 0, a.size-1)
    end

    # Recursively sort the array a between indices
    # first and last
    def self.quick(a, first, last)
        return if first >= last
        lt, gt = first, last
        i = lt
        pivot = a[lt]
        while i <= gt
            cmp = a[i] <=> pivot
            if cmp < 0 then
                a[lt], a[i] = a[i], a[lt]
                lt, i = lt+1, i+1
            elsif cmp > 0
                a[i], a[gt] = a[gt], a[i]
                gt -= 1
            else
                i += 1
            end
        end
        quick(a, first, lt-1)
        quick(a, gt+1, last)
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

    private_class_method :quick

end

# Quick3BM handles quicksort in ascendant order using
# Bentley-McIlroy's 3-way partitioning, insertion sort on small subarrays
# And Tukey's ninther
# The implementation is more difficult than the classic one however it
# way more efficient when the array to sort contains many duplicate elements
# plus, it performs better in the average case.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Quick3BM

    # Sort the given array in parameter using
    # quicksort
    def self.sort!(a)
        quick(a, 0, a.size-1)
    end

    # Recursively sort the array a between indices
    # first and last
    def self.quick(a, first, last)
        return if first >= last
        if (last - first) < 20
            InsertionHalf.sort!(a, first, last)
            return
        end
        p, q = first+1, last
        i, j = p - 1, q + 1
        ninther(a, first, last)
        pivot = a[first]
        # partition the array using Bentley-McIlroy scheme
        loop do
            i += 1
            while (a[i] <=> pivot) < 0
                break if i == last
                i += 1
            end

            j -= 1
            while (pivot <=> a[j]) < 0
                break if j == first
                j -= 1
            end

            if (i == j and a[i] <=> pivot) == 0
                a[p], a[i] = a[i], a[p]
                p += 1
            end
            break if i >= j

            a[i], a[j] = a[j], a[i]

            if (a[i] <=> pivot) == 0
                a[p], a[i] = a[i], a[p]
                p += 1
            end
            if (a[j] <=> pivot) == 0
                a[q], a[j] = a[j], a[q]
                q -= 1
            end

        end

        i = j+1
        (first).upto(p - 1) do |x|
            a[j], a[x] = a[x], a[j]
            j -= 1
        end

        (last).downto(q+1) do |y|
            a[i], a[y] = a[y], a[i]
            i += 1
        end

        quick(a, first, j)
        quick(a, i, last)
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

    # Get the median of the 3 indices
    def self.median3(a, i, j, k)
        (a[i] <=> a[j]) < 0 ?
        (a[j] <=> a[k]) < 0 ? j : (a[i] <=> a[k]) ? k : i :
        (a[k] <=> a[j]) < 0 ? j : (a[k] <=> a[i]) ? k : i
    end

    # Swap tukey's ninther with the first element to use it as pivot.
    def self.ninther(a, first, last)
        delta = (last-first)/8
        m1 = median3(a, first, first+delta, first+delta*2)
        m2 = median3(a, first+delta*3, first+delta*4, first+delta*5)
        m3 = median3(a, last-delta*2, last-delta, last)
        med = median3(a, m1, m2, m3)
        a[first], a[med] = a[med], a[first]
    end

    private_class_method :quick, :median3, :ninther

end

# QuickDualPivot handles quicksort in ascendant order using
# Yaroslvskiy's dual pivot, the thirds to get the pivots and
# Insertion sort for small subarrays
# The implementation is even simpler than the classic one, and performs way better on
# average case
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class QuickDualPivot

    # Sort the array given in parameter
    def self.sort!(a)
        quick(a, 0, a.size-1)
    end

    # Returns a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

    # Performs the dual pivot quicksort
    def self.quick(a, first, last)
        # Use Insertion sort on small subarrays
        if (last - first) < 20
            InsertionHalf.sort!(a, first, last)
            return
        end

        # Swap the pivots with the first and last element
        pivots(a, first, last)

        p1, p2 = a[first], a[last]
        l, k, g = first + 1, first + 1, last - 1

        loop do
            cmp = a[k]
            if (cmp <=> p1) < 0
                if l != k
                    a[l], a[k] = cmp, a[l]
                end
                l, k = l+1, k+1
            elsif (cmp <=> p2) > 0
                while k < g and (a[g] <=> p2) > 0
                    g -= 1
                end
                a[g], a[k] = cmp, a[g]
                g -= 1
            else
                k += 1
            end

            break if k > g
        end
        a[first], a[l-1] = a[l-1], p1
        a[last], a[g+1] = a[g+1], p2

        quick(a, first, l-2)
        quick(a, g+2, last)
        quick(a, l, g) if (p1 <=> p2) != 0
    end

    # Changes the first and last elements with the chosen
    # pivots
    def self.pivots(a, first, last)
        third = (last - first)/3
        p1, p2 = first + third, last - third
        if (a[p1] <=> a[p2]) < 0
            a[first], a[p1] = a[p1], a[first]
            a[last], a[p2] = a[p2], a[last]
        else
            a[first], a[p2] = a[p2], a[first]
            a[last], a[p1] = a[p1], a[last]
        end
    end

    private_class_method :pivots, :quick
end
