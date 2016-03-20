class BinomialNode
    attr_accessor :child, :sibling, :value, :rank

    def initialize(child, sibling, value)
        @child = child
        @sibling = sibling
        @value = value
        @rank = 0
    end
end

class BinomialHeap
    attr_reader :size

    def initialize
        @root = nil
        @size = 0
    end

    def meld_roots(new_list, list_x, list_y)
        return new_list if not list_x and not list_y
        if    not list_x then new_list.sibling = self.merge(list_y, list_x, list_y.sibling)
        elsif not list_y then new_list.sibling = self.merge(list_x, list_x.sibling, list_y)
        elsif list_x.rank < list_y.rank then new_list.sibling = self.merge(list_x, list_x.sibling, list_y)
        else new_list.sibling = self.merge(list_y, list_x, list_y.sibling) end
        return new_list
    end

    def link(root_x, root_y)
        root_x.sibling = root_y.child
        root_y.child = root_x
        root_x.order += 1
    end

    def union(other_heap)
        return if not other_heap
        @root = self.merge(BinomialNode.new(nil, nil, nil), @root, other_heap.root).sibling
        current_n = @root
        prev_n, next_n = nil, @root.sibling
        while next_n
            if current_n.rank < next_n.rank or (next_n.sibling and next_n.sibling.rank == current_n.rank)
                prev_n, current_n = curent_n, next_n
            elsif (next_n.value <=> current_n.value) > 0
                current_n.sibling = next_n.sibling
                self.link(next_n, current_n)
            else
                if not prev_n then @root = next_n
                else prev_n.sibling = next_n end
                self.link(current_n, next_n)
                current_n = next_n
            end
            next_n = current_n.sibling
        end
        return self
    end
end
