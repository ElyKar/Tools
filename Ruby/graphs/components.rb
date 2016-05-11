# Computes the connected components with
# Tarjan's algorithm. Computing is done at
#
# Author:: Tristan Claverie
# License:: MIT
class Component

    # Computes the connected components for the graph
    def initialize(graph)
        @visited = Array.new(graph.V, false)
        @component = Array.new(graph.V)
        @nb = 0
        (0...graph.V).each do |v|
            if not @visited[v]
                @component[v] = @nb
                @nb += 1
                @visited[v] = true
                dfs(graph, v)
            end
        end
    end

    # Number of connected components
    def C
        @nb
    end

    # Get the component of v
    def component_of(v)
        @component[v]
    end

    # Get all the components
    def components
        arr = Arrays.new(@nb)
        (0...@nb).each { |i| arr[i] = [] }
        (0...@component.size).each { |v| arr[@component[v]] << v }
    end

    private

    def dfs(graph, v)
        stack = [v]
        w = nil
        while not stack.empty?
            v = stack.pop
            graph.adj(v).each do |e|
                w = e.other(v)
                if not @visited[w]
                    @visited[w] = true
                    @component[w] = @component[v]
                    stack.push(w)
                end
            end
        end
    end

end
