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

class HeapShell

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
        Shell.sort!(a)
    end

    # Returns a sorted copy of the array in parameter
    # using insertion sort
    def self.sort(a)
        sorted = a.dup
        self.sort!(sorted)
        return sorted
    end

end

require 'benchmark'
require_relative 'shell'

N = 10000000
sorted_array = []
reverse_array = []
rnd_array = (0..N).map { rand }
(0..N).each do |i|
    sorted_array << i
    reverse_array << N - i
end

Benchmark.bm do |x|
    x.report("Shell sorted") { Shell.sort(sorted_array) }
    x.report("Heap sorted") { Heap.sort(sorted_array) }
    x.report("HeapShell sorted") { HeapShell.sort(sorted_array) }
    x.report("Shell reverse") { Shell.sort(reverse_array) }
    x.report("Heap reverse") { Heap.sort(reverse_array) }
    x.report("HeapShell reverse") { HeapShell.sort(reverse_array) }
    x.report("Shell random") { Shell.sort(rnd_array) }
    x.report("Heap random") { Heap.sort(rnd_array) }
    x.report("HeapShell random") { HeapShell.sort(rnd_array) }
end
