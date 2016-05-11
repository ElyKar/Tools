# Use depth-first search to perform graph traversal from a given source
# One initialized, query it for getting data from the graph suh has paths
# The dfs method is beautiful, but should not be used for a real
# application because it is easy to find a graph which would explode the call stack
#
# Author:: Tristan Claverie
# License:: MIT
class DepthFirstSearch

    # Perform dfs on the graph from given source
    def initialize(graph, s)
        @visited = Array.new(graph.V, false)
        @path = Array.new(graph.V)
        @s = s
        dfs(graph, s)
    end

    # Source for DFS
    def S
        @s
    end

    # Has the source a path to v ?
    def has_path?(v)
        @visited[v]
    end

    # Path from the source to v, the path is rendered
    # as an array containing the source and the destination
    # Example:
    # Graph is 0 -- 1 -- 2 -- 3 -- 4
    # DFS is called with source = 0
    # path_to(4) returns [0,1,2,3,4]
    def path_to(v)
        return nil if not @visited[v]
        path = [v]
        while @path[v]
            path << @path[v]
            v = @path[v]
        end
        return path.reverse
    end

    private

    # Inner function performing the actual dfs
    def dfs(graph, v)
        @visited[v] = true
        w = nil
        graph.adj(v).each do |edge|
            w = edge.other(v)
            if not @visited[edge.other(v)]
                @path[w] = v
                dfs(graph, edge.other(v))
            end
        end
    end

end

# Use depth-first search to perform graph traversal from a given source
# One initialized, query it for getting data from the graph suh has paths
# This implementation is non-recursive
#
# Author:: Tristan Claverie
# License:: MIT
class NRDepthFirstSearch

    # Perform dfs on the graph from given source
    def initialize(graph, s)
        @visited = Array.new(graph.V, false)
        @path = Array.new(graph.V)
        @s = s
        dfs(graph, s)
    end

    # Source for DFS
    def S
        @s
    end

    # Has the source a path to v ?
    def has_path?(v)
        @visited[v]
    end

    # Path from the source to v, the path is rendered
    # as an array containing the source and the destination
    # Example:
    # Graph is 0 -- 1 -- 2 -- 3 -- 4
    # DFS is called with source = 0
    # path_to(4) returns [0,1,2,3,4]
    def path_to(v)
        return nil if not @visited[v]
        path = [v]
        while @path[v]
            path << @path[v]
            v = @path[v]
        end
        return path.reverse
    end

    private

    # Inner function performing the actual dfs
    def dfs(graph, s)
        stack = [s]
        @visited[s] = true
        w = nil
        while not stack.empty?
            v = stack.pop
            graph.adj(v).each do |edge|
                w = edge.other(v)
                if not @visited[edge.other(v)]
                    @path[w] = v
                    @visited[w] = true
                    stack.push(edge.other(v))
                end
            end
        end
    end

end
