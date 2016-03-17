require_relative 'insertion'

# Merge handles mergesort in ascendant order.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class Merge

    # Destructively sort the array in parameter
    def self.sort!(a)
        aux = Array.new(a.size)
        recurse(a, aux, 0, a.size-1)
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        (1...sorted.size).each do |i|
            raise 'Not sorted' if (sorted[i-1] <=> sorted[i]) > 0
        end
        return sorted
    end

    # Handles the recursion of mergesort
    def self.recurse(a, aux, first, last)
        return if last <= first
        mid = first + (last - first) / 2
        # Sort the right and left subarrays
        recurse(a, aux, first, mid)
        recurse(a, aux, mid+1, last)
        # Merge the two subarrays into one
        merge(a, aux, first, mid, last)
    end

    # Merge two sorted subarrays into one sorted subarray
    def self.merge(a, aux, first, mid, last)
        # Copy the two halves into the temporary array aux
        (first..last).each do |i|
            aux[i] = a[i]
        end

        # aux[first..last] = a[first..last]

        # Merge the aux[first..last] into a
        i, j, k = first, mid + 1, first
        while i <= mid or j <= last
            if j > last
                a[k] = aux[i]
                i += 1
            elsif i > mid
                a[k] = aux[j]
                j += 1
            elsif (aux[i] <=> aux[j]) < 0
                a[k] = aux[i]
                i += 1
            else
                a[k] = aux[j]
                j += 1
            end
            k += 1
        end
    end

    private_class_method :recurse, :merge

end

# MergeBU handles bottom-up mergesort in ascendant order.
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class MergeBU

    # Destructively sort the array in parameter
    def self.sort!(a)
        aux = Array.new(a.size)
        n = 1
        while n < a.size
            i = 0
            while i < a.size - n
                l = i
                m = i + n - 1
                h = a.size - 1 < i+2*n-1 ? a.size-1 : i + 2*n - 1
                merge(a, aux, l, m, h)
                i += 2*n
            end
            n += n
        end
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        (1...sorted.size).each do |i|
            raise 'Not sorted' if (sorted[i-1] <=> sorted[i]) > 0
        end
        return sorted
    end

    # Merge two sorted subarrays into one sorted subarray
    def self.merge(a, aux, first, mid, last)
        # Copy the two halves into the temporary array aux
        (first..last).each do |i|
            aux[i] = a[i]
        end

        # aux[first..last] = a[first..last]

        # Merge the aux[first..last] into a
        i, j, k = first, mid + 1, first
        while i <= mid or j <= last
            if j > last
                a[k] = aux[i]
                i += 1
            elsif i > mid
                a[k] = aux[j]
                j += 1
            elsif (aux[i] <=> aux[j]) < 0
                a[k] = aux[i]
                i += 1
            else
                a[k] = aux[j]
                j += 1
            end
            k += 1
        end
    end

    private_class_method :merge

end

# MergeOpti handles an optimized mergesort in ascendant order.
# Here are the optimizations made :
# - When the subarray is small enough, an insertion sort is performed
# - Do not merge two subarrays if they are already if the a[mid] < a[mid+1]
# - No need to copy the content systematically. To do this, alternate between
# a and aux each time
# It provides two methods, one for sorting the array in parameter and
# the other to return a sorted copy of the array
# The items of the array must support the <=> operator
#
# Author:: Tristan Claverie
# License:: MIT
class MergeOpti

    # Destructively sort the array in parameter
    def self.sort!(a)
        aux = a.dup
        recurse(aux, a, 0, a.size-1)
    end

    # Return a sorted copy of the array
    # in parameter
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        (1...sorted.size).each do |i|
            raise 'Not sorted' if (sorted[i-1] <=> sorted[i]) > 0
        end
        return sorted
    end

    # Handles the recursion of mergesort
    def self.recurse(a, aux, first, last)
        if (last - first) < 20
            InsertionHalf.sort!(aux, first, last)
            return
        end
        mid = first + (last - first) / 2
        # Sort the right and left subarrays
        recurse(aux, a, first, mid)
        recurse(aux, a, mid+1, last)
        if (a[mid] <=> a[mid+1]) < 0
            (first..last).each do |i|
                aux[i] = a[i]
            end
        else
            merge(a, aux, first, mid, last)
        end
    end

    # Merge two sorted subarrays into one sorted subarray
    def self.merge(a, aux, first, mid, last)
        i, j, k = first, mid + 1, first
        while i <= mid or j <= last
            if j > last
                aux[k] = a[i]
                i += 1
            elsif i > mid
                aux[k] = a[j]
                j += 1
            elsif (a[i] <=> a[j]) < 0
                aux[k] = a[i]
                i += 1
            else
                aux[k] = a[j]
                j += 1
            end
            k += 1
        end
    end

    private_class_method :recurse, :merge

end
