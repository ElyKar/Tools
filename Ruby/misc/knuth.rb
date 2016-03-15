# Knuth class provides a method for shuffling an array using Knuth's shuffle
# This is done under the assumption that the rand(i) method of ruby is a good
# pseudo-random generator, that is the results are independant and uniformly distributed
# between 0 and i
#
# Author:: Tristan Claverie
# License:: MIT
class Knuth

    # Destructive shuffle of the array given in parameter
    def self.shuffle!(a)
        0.upto(a.size-1).each do |i|
            swp = i + rand(a.size - i)
            a[swp], a[i] = a[i], a[swp]
        end
    end

    # Returns a shuffled copy of the array in parameter
    def self.shuffle(a)
        shuffled = a.dup
        shuffle!(shuffled)
        return shuffled
    end
end
