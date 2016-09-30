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
        arr = Arrays.new(@nb) { [] }
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

# Finds the strong components in a graph using kosaraju sharir algorithm.
# It relies on the fact that strong components are the same between a digraph and its
# reversed digraph (invert all edges)
# Principle is as follow:
# - Do a first dfs storing traversed the nodes in a stack by order of visit on the reversed digraph
# - Iterate through the stack in reverse order (first inserted is first retrieved)
#   and perform a DFS on the graph to find the component
# - All done !
# Some functions are provided to query about the structure of the digraph
#
# Author:: Tristan Claverie
# License:: MIT
class KosarajuSharirSC

    # Computes the strong components of the given graph
    def initialize(graph)
        @nb = 0
        @component = Array.new(graph.V)
        @visited = Array.new(graph.V, false)
        @stack = []
        reverse = graph.reverse
        (0...graph.V).each { |v| dfs_stack(reverse, v) if not @visited[v] }
        @visited.fill(false) # Reset the array
        (0...graph.V).each do |v|
            if not @visited[v]
                dfs(graph, v)
                @nb += 1
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
        arr = Arrays.new(@nb) { [] }
        (0...@component.size).each { |v| arr[@component[v]] << v }
    end

    private

    # First dfs, stores the nodes traversed in a stack
    def dfs_stack(graph, v)
        @visited[v] = true
        w = nil
        @stack.push(v)
        graph.adj(v).each do |e|
            w = e.to
            dfs_stack(graph, w) if not @visited[w]
        end
    end

    # Fill the components array
    def dfs(graph, v)
        @visited[v] = true
        w = nil
        @component[v] = @nb
        graph.adj(v).each do |e|
            w = e.to
            dfs(graph, w) if not @visited[w]
        end
    end

end

